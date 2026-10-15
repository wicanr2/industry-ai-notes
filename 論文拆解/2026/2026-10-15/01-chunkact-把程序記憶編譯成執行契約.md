# ChunkAct：把程序記憶編譯成執行契約

> **問題**：機器人已知道某類子任務的固定流程，為何每一步仍要重新問 LLM？
> **方法**：把記憶中的程序離線轉為可執行 chunk，現場重估幾何、逐階段驗證；只在需要決策或交接時回到 planner。
> **判讀**：這是執行介面與記憶消費方式的改造，不是新的 VLA 訓練法；模擬結果支持整套介面有效，尚不能把收益全歸因於單一「記憶內化」因素。

## 來源、版本與實際閱讀邊界

- 原文：**ChunkAct: Action Chunking for Agentic Robotics**。
- 作者：Bingxin Xu、Wenrui Bao、Xinxin Liu、Jiawei Zhou、Yuzhang Shang、Emilio Ferrara。
- 版本：[arXiv:2610.18874v1](https://arxiv.org/abs/2610.18874v1)；首次提交 **2026-10-13 17:59:57 UTC**。cs.RO recent 將它列於 2026-10-14 公告批次，公告日不是提交日。
- [官方 PDF](https://arxiv.org/pdf/2610.18874v1)｜[官方 HTML](https://arxiv.org/html/2610.18874v1)；擷取及閱讀日期 **2026-10-15（Asia/Taipei）**。查閱未帶版本的最新頁，當時僅列 v1，未見 withdrawn／retracted 標記；不是永久無撤稿保證。
- **實讀**：PDF 摘要、§1 導論、§2 相關工作、§3.1–3.4 全部方法、§4.1–4.5 實驗、§5 結論，以及附錄 A typed exits／Table 4、B primitive library／Table 5。另用 HTML 核對 Tables 1–3、評估設計及正文數字矛盾。本文沒有獨立 limitations 章；下列限制由實驗範圍與方法條件辨認。
- 未重跑程式，未逐篇核對參考文獻，未查證導論引用的其他模型排行榜與 API 價格，不將它們當本文實驗證據。PDF 用現有 `pdftotext -layout` 抽取，出現字型 mismatch warning；重要數字另核 HTML，不從抽取缺字補公式。

## 1. 真正要解決的是「程序執行被誤當成決策」

作者觀察原有 Harness VLA 的工具呼叫：動作 primitive 約占 20.5%，記憶讀取 31.7%，感知 44.3%（§3.1／Figure 2）。重點不在感知本身浪費，而是每次工具選擇都經 LLM、工具結果又被放進後續 context。當「抓起 A、搬到 B」已選定，hover、grasp、check、carry、release 的大部分順序不是新問題。

因此缺口有兩層：一是把固定控制流程反覆交給 planner；二是把已知程序當文件反覆檢索、解釋。只快取一個舊場景計畫未必有效，因為物體位置每次都可能變；只減少記憶讀取，也仍可能逐 primitive 問模型。ChunkAct 試圖同時改掉兩者。

原文 §3.1 的成本機制可寫成以下等價簡式：

$$
N_{\mathrm{in}}=T|c_0|+\sum_{s=0}^{T-2}(T-1-s)\ell_s.
$$

這裡 $N_{\mathrm{in}}$ 是整個 episode 累計輸入 token；$T$ 是 planner 呼叫次數；$c_0$ 是初始任務 context，$|c_0|$ 是其 token 數；$s$ 是從 0 開始的步次；$\ell_s$ 是該步工具呼叫與回傳共同增加的 token 數。越早加進去的內容，後面越常再讀。只有在**保留完整歷史、每步增量大致不縮減**的條件下，才得到隨 $T$ 近似二次成長的帳面輸入量；這不是所有 agent 的必然律，也不等於有 cache、摘要或折扣後的實付費用。

## 2. 任務、輸入輸出與控制迴圈

### 離線：把知識轉為可執行程序，而非更新模型權重

§3.2 把子任務分成少量類型；桌面操作的例子是 **transport**（搬移到容器上／內）與 **fixture**（操作抽屜等關節構件）。將同類型的全域規則、任務紀錄整合成 chunk，保存：

- 階段順序及每階段呼叫哪個 primitive。
- 依物件類別選擇的參數、失敗時 fallback、階段驗證條件。
- 接觸密集階段交給既有 VLA，其餘交給解析控制的分工。

刻意不保留舊座標與部署時不可取得的 simulator privileged state；幾何量在現場重新量。chunk library 編好後凍結，不在每個測試 episode 在線增長。

**資料與目標的邊界**：輸入知識包含 LIBERO-Pro 的 task-specific 與 global memory；作者稱與 Harness VLA 使用相同記憶。本文沒有為 ChunkAct 設計新的梯度訓練 loss，也沒有重新訓練 planner／VLA。這裡的「compile」不能自動理解為已公開、全自動且有正確性證明的編譯器：§3.2 說明保留什麼知識，卻沒有給出足以重現整個編譯過程的生成演算法、人工修改量或離線成本帳。既有記憶如何取得、是否與評估初始狀態完全隔離，也需進一步稽核。

### 在線：一個呼叫可以含多個觀測與控制步驟

**輸入**是任務指令、當前場景影像與 robot state、待操作目標及 chunk 參數；**輸出**不是單一 motor token，而是 chunk 的物理執行結果，或帶失敗階段／原因的結構化交接。

1. Planner 理解指令與當前場景，形成有序 typed sub-goals，ground 第一個目標並呼叫新增的 `approach` 工具。
2. chunk 自行完成 locate、hover、VLA grasp、check、carry、locate receptacle、descend、release 等階段；fixture 走對應程序。每階段驗證後才推進，覆蓋範圍內也可接續下一個子目標。
3. 正常中間步驟不回 LLM、不讀外部記憶文件，也不把每個內部工具回傳塞進 planner context。
4. 無法完成時回傳 typed exit、log、robot state 與新觀測；planner 重新 ground、重做未驗證子目標，或退回原始 primitives。環境成功則終止。

附錄 B 指定 motion primitives 由解析 controller **閉迴路**達成 pose／gripper 目標；VLA 接觸 primitive 使用凍結的既有 policy。因此「一個 LLM 呼叫跑一長段」**不等於機器人閉眼開迴路執行**，也不等於完全沒有感知或運算。

附錄 A 的例子包括 `need_pixels`、`wrong_object_under_gripper`、`grasp_failed`、`lost_in_carry`、`subgoal_unverified`、`not_covered`。有的 exit 是要求新 grounding，有的是抓取失敗，有的是能力不覆蓋；不能把它們全當作同一個可盲目 retry 的錯誤。Table 4 亦列成功／內部狀態，所以「只在失敗交接」是主要設計概述，不是所有 return code 都代表失敗。

## 3. 相對基線到底改了什麼？

最接近的 Harness VLA 對照，共用 planner、感知、VLA primitive 與記憶，原本逐工具讀記憶、選 primitive；ChunkAct 增加執行 chunk 介面，讓程序／部分感知／參數決定移到 chunk 內。§4.1 的 planner 是 GPT-5.6-sol high reasoning、在 Codex 中運行，每 episode 最多 100 次 LLM 呼叫；分割使用 SAM 3，接觸 primitive 是 RLinf 微調過的既有 VLA checkpoint。

因此真正的 treatment 是**程序內化＋呼叫粒度＋context 過濾＋局部驗證／fallback 的整套組合**。作者 §4.2 認為比較隔離了記憶內化效益；本筆記較保守：即使所有底層模型相同，仍缺「只移除記憶讀取、不 chunk」和「chunk 但保留同樣記憶流程」等因子對照，不能把整個差額獨立歸給 memory internalization。

附錄工具名保留 `pi0_pick`／`pi0_doubled`，不能據此猜測它們是新訓練的模型；本文設定以 §4.1 的 checkpoint 說明為準。

## 4. 實驗證據：整體收益與沒被測到的事

### LIBERO-Pro：同系統比較最有解釋力

來源為 §4.1–4.3、Tables 1–2。四個 suite 各測 instruction redirection（T）與 position swap（S）；指標 TSR 是**環境 termination signal 判定的成功率**。表列 baseline 包括 OpenVLA、π0、π0.5、MolmoAct、NORA、X-VLA、AtomVLA、πRLinf、CaP-X 與 Harness VLA。前面的非 Harness 結果取自既有報告；Harness VLA 與 ChunkAct 是作者本次執行，不是所有系統統一重跑。

- High reasoning：Harness VLA **78.8% → ChunkAct 83.8%**，增加 **5.0 個百分點**。
- 每 episode 平均 LLM calls：**24.2 → 8.3**；輸入 token：**2.2M → 0.5M**；輸出 token：**8.5k → 3.7k**。約 2.9／4.4／2.3 倍是表列 token／calls 分母比，不是全系統 wall-clock 加速或含離線編譯的成本比。
- 子群不是全面改善：Spatial-T **100.0% → 94.0%**；L10-T 維持 **60.0%**。平均提升不表示每種任務都變可靠。
- 關閉 reasoning：Harness **56.0%**，ChunkAct **80.0%**；不用 planner、只用 scripted driver 跑 chunks 為 **57.5%**。作者將 80.0% 與 57.5% 的 **22.5 個百分點**差額解釋成 recovery 貢獻；本筆記認為這支持 planner 仍有價值，但移除 planner 也可能改變初始 grounding／指令處理，尚非純粹 recovery 的配對因果估計。

**兩個不可直接照抄的原文矛盾**（PDF 與 HTML 均有）：

1. §4.1 寫八個組合、每組 10 tasks、每 task 10 seeds，卻說「每組」800 episodes。按所列設計計算應是**每組 100、八組合計 800**；這是筆記依文字重算，不是取得作者更正或 rollout manifest。實際執行總量待核。
2. §4.2 說 πRLinf 落後 ChunkAct 43.8 點，但 Table 1 給 **50.0% 與 83.8%**，差是 **33.8 點**。筆記保留表值與衝突，不替作者猜另有 40.0% 基準。

這些矛盾不直接否定整套方法，但降低對報告口徑的信心；表中也未附足以判斷 5 點差異穩定性的 confidence interval 或配對檢定。

### LIBERO-Plus：未改 chunk 的擾動轉移，不是全新任務世界

§4.4／Table 3 沿用 LIBERO-Pro 編好的 library 與 prompt，測 camera、robot initial state、language、light、background、noise、layout 七軸；作者說每 task／軸用一個 seed，**並非完整跑完所有 10,030 variants**，本文未提供可直接稽核的完整採樣清單。

ChunkAct overall **83.9%**，表內最好的既有 overall（OpenVLA-OFT）為 **72.9%**，差 **11.0 個百分點**；background **82.5%** 並不是該欄最佳。基線數字來自其他文獻，且這些任務仍屬 LIBERO 家族；比較可支持對列出擾動的轉移，不能當成跨任意新任務、真機或新 embodiment 的泛化證明。也沒有同頁統一重跑的 Harness VLA transfer 對照。

### 失敗怎樣進入研究，而不是只展示成功？

Figure 4 是物體搬運途中滑落、回傳 `lost_in_carry`、重定位再抓取的**一個成功恢復案例**；它說明交接格式，沒有給出所有滑落事件的恢復率。Table 4 描述可偵測的抓取／掉落／不可達／驗證失敗，也不表示這些偵測器有經過漏報、誤報和危險接觸測試。

本文未提供真機實驗、碰撞／傷害率、安全停機時延、程序編譯成本攤提與整體 wall-clock 分布；不能用 token 節省替代安全證明。

## 5. 第一性原理：什麼可以編譯，什麼必須留下？

以下是**本筆記判讀**，不是新增實驗結果。

- **最小必要狀態**：目前是哪個子目標／階段、目標與容器的即時 grounding、機器人及夾爪狀態、物體是否仍被持有、階段驗證結果、失敗原因，以及最新觀測的有效性。只留下文字「搬運中」不足以安全恢復。
- **技術限制**：程序能否重用，取決於 type 與 object class 是否涵蓋現場、perception 是否能辨認、typed exit 是否表達足夠的原因。錯誤分類若掩蓋感知錯誤，planner 可能精確地重試錯事。
- **資料限制**：task-specific memory 可能編入任務分布的知識；移除舊座標只能消除一類幾何捷徑，不代表沒有程序層級洩漏。需要 held-out task type 與 memory provenance 才能界定泛化。
- **物理限制**：固定順序不能消除摩擦、順應性、可達範圍、遮擋與外界移動；chunk 內部必須持續驗證必要條件。降低 LLM 參與頻率，不等於可以降低安全監測頻率。
- **有效條件**：程序大致穩定、幾何可在線重估、失敗可被局部觀測及時識別，而且 re-grounding 能修復偏差。若每一步都改變接下來的策略、目標被人移走、接觸狀態無法觀測或舊 memory 不再適用，編譯後的程序可能把錯誤更有效率地執行下去。

可複用模型是：**把穩定程序編入執行器，把不可預先決定的分歧留給 planner；節省的是重複解釋，不能省掉狀態驗證。**

這與 [BT-Agent 的固定技能／本地護欄](../2026-10-13/01-bt-agent-固定技能與反應式護欄.md)相接，但 ChunkAct 的 typed exit 不是相同的強制安全 guard；與 [RESCUE 的介入價值](../2026-10-13/02-rescue-警報的介入價值.md)相接，但呼叫減少不直接證明介入時機最優；與 [Chronos Policy 的時間介面](../2026-10-14/01-chronos-policy-把時間還給控制介面.md)相接，但本文沒有證明交接觀測在真實延遲下仍及時。三者不能互相代替驗證。

## 6. 後續最值得驗證的三個問題

1. **收益從哪裡來？** 固定 perception／VLA／記憶來源，以「記憶內化、有無 chunk」做因子消融，再配對重跑相同 seeds；同時公布 rollout manifest，釐清樣本數與 Table 1 差額矛盾。
2. **錯誤何時該交接？** 注入漏檢滑落、錯誤 target、動態移物與過期影像，比較本地偵測時延、錯誤重試、恢復率及強制停止，檢查 typed exit 是否真能支撐安全重新規劃。
3. **編譯何時值得？** 在未見 task type／真機上計入人工編輯、離線生成、更新維護、感知與控制、token 及失敗損失；與 rolling-context／cache 基線比較每個成功任務的總成本，而非只比 LLM 呼叫數。
