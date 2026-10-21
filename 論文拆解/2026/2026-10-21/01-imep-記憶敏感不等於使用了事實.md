# IMEP：記憶敏感，不等於使用了事實

> **問題**：拔掉記憶後成功率下降，足以證明機器人使用了記憶裡的關鍵事實嗎？
> **方法**：在同一檢索介面配對比較「換事實／保留事實／微小數值擾動／完全重複」，再把決策與馬達執行分開量測。
> **判斷**：這是可重用的歸因框架，不是記憶無用的結論；正向 ChainBench 結果也只驗證整理過的記錄與特定讀取器，不能冒充完整 agent 記憶管線。

## 來源、版本與實際閱讀邊界

- 原題：*Beyond Success Rate: Interventional Evaluation of Memory in Vision–Language–Action Systems*。
- 作者：Keyuan Luo、Yi Xie、Wanyun Ling、Yuanzhe Li、Ziyue Li、Zhuoqi Zeng。
- 版本：[arXiv:2610.23372v1](https://arxiv.org/abs/2610.23372v1)；首次提交 **2026-10-16 12:23:56 UTC**。[目前版本頁](https://arxiv.org/abs/2610.23372)於本次擷取僅列 v1，未見整篇 withdrawn／retracted 標記。文中另有**作者撤回的個別實驗證據**，不是整篇撤稿。
- 原文：[官方 PDF](https://arxiv.org/pdf/2610.23372v1)／[HTML](https://arxiv.org/html/2610.23372v1)。擷取與閱讀日期 **2026-10-21（Asia/Taipei）**，本次上午排程執行期間。
- **實讀範圍**：41 頁官方 PDF，以既有 `pdftotext -layout` 抽取；摘要、§1–5、AI／倫理／可重現聲明，附錄 A.3 的 checkpoint／實作綁定段落與表 5、B.2–B.5、C.1、E.2、F.1、F.4、G.1–G.3（表 19／20 讀到相關部分）及 H.1–H.2 開頭。重點讀主表 1／2、表 10／13／14／17／18，以及檢索與統計解釋。
- **未讀／未做**：不是逐頁完整讀完所有附錄；未完整讀 D 的 survival 審計、E.1 的 blackout 實作、H.3／I–K，未視覺逐圖核對、未追讀所有引用文獻、未審程式碼或重跑實驗。抽取有字型警告但文字可讀，未由模糊圖像猜數字。
- [作者列出的匿名 artifact](https://anonymous.4open.science/r/IMEP-ChainBench-DC83/)本次未下載審核；「兩個實作一致／checksum 通過」均為作者報告，不是本筆記獨立重現。

## 1. 缺口不是記憶容量，而是歸因單位

接續 [REKI](../2026-10-19/01-reki-記憶要保存分辨動作所需的過去.md)與 [Mem4Act](../2026-10-20/01-mem4act-記憶要分開覆蓋內容與使用.md)，可以把三種問題分開：需要過去嗎？模型確實消費過去嗎？消費的是**那個決策所需的事實**嗎？

關掉 memory read 同時改了資訊與計算路徑；交換整段歷史又同時換了外觀、姿態與動作分布。即使任務結果變了，也可能是安裝操作、數值變化或非目標內容造成。相反地，總成功率不變，也可能是原本成功的變失敗、原本失敗的變成功，互相抵銷。

**作者提出的四問**是淨收益、有效條件、結果敏感性與事實特異性。本筆記認為這比「有／無記憶」二分更有研究價值：它要求研究者說清楚自己究竟證明哪一層，而不是靠成功率替全部機制背書。這不直接否定前兩篇方法；本篇沒有在 REKI／Mem4Act 上實作同一套介入。

## 2. IMEP 如何操作：固定介面，不只固定 seed

### 任務、輸入與輸出

輸入是固定任務與 seed 的 episode 對，或跨 episode 的 chain；還要指定記憶介面、替換時刻、被控制的欄位，以及執行隨機性。輸出不是新動作策略，而是每個條件的任務成功、配對翻轉方向、可觀察時的決策正確率、替換送達檢查與區間估計。

介入分工如下（§3.2）：

- **A：reference**，保留原記憶；**N：no access**，阻斷讀取或清空；**O：oracle**，給正確事實或決策。
- **C：exact repeat**，原樣重複，量測重現底噪。
- **U：one-ULP control**，將數值移動一個該資料型別可表示的末位單位（unit in the last place），不是任意固定的小實數。
- **S：same-fact swap**，換成同目標事實的另一份記錄；**T：different-fact swap**，改成不同目標事實。

S 不保證非目標語意完全相同。跨 episode learned bank 的 U／S／T 共用安裝程序，但 C **不經過安裝**；所以 U 對 C 的差異是「微擾加安裝流程」，不能歸因成單獨一個浮點位元造成災難。

### 成功率與翻轉率必須分帳

依主文式 (1)，令 $Y_i^A,Y_i^X\in\{0,1\}$ 是第 $i$ 個配對在 reference 與介入 $X$ 下的任務成功，$n$ 是配對數：

$$
D_X=\frac{1}{n}\sum_{i=1}^n(Y_i^A-Y_i^X)=\frac{b_X-c_X}{n},\qquad
\rho_X=\frac{1}{n}\sum_{i=1}^n\mathbf{1}[Y_i^A\ne Y_i^X]=\frac{b_X+c_X}{n}.
$$

$b_X$ 是 reference 成功、介入失敗的次數；$c_X$ 是反方向；$\mathbf{1}$ 是條件成立記為 1 的指示函數。$D_X$ 問淨得失，$\rho_X$ 問有多少結果被改動；兩者不可互代。決策翻轉與馬達結果翻轉亦不得混合。

事實特異性用 $\theta=\rho_T-\rho_S$；另用 $\bar\theta$ 表示各任務差值等權平均。白話是「改變目標事實，比保留事實的替換多改變多少結果」。若非目標內容沒控制好，或替換沒送達 reader，這個差值仍不是純粹的事實因果效果。

文中回溯性規則要求事實特異性差值的下界超過零，且超過 U 翻轉率的上界；但**整套四問框架是在實驗結束後形成**，不可把它與個別 campaign 事前凍結的規則合稱完整前瞻預註冊。

### 三項前提檢查

1. **資訊需求**：目前觀測不能直接洩漏答案，且不能靠輪流試所有選項過關。
2. **送達**：原記憶真的被讀、N 真的空讀、替換在決策時仍被選中。作者的 coverage 是每個單位的每次決策 query 都取到至少一筆未被改寫的替換記錄之比例；coverage 為一也只證明操作送達，不證明使用了事實。
3. **有效期**：資料仍是目前正確事實嗎？要固定其餘條件測 persistence；換整套系統不能單獨歸因 stale memory。

## 3. 實際被測的系統：不要把協定誤讀成新訓練演算法

IMEP 本身沒有新的統一訓練目標；主要是在既有模型推論時做介入。

- **Learned bank**：MIKASA-Robo 使用 MemoryVLA-compatible 社群 checkpoint，不是官方 release。A.3 記錄的相鄰設定為 OpenVLA-7B 初始化、五任務 1,250 條示範／90,000 transitions、最多 20,000 steps、16 slots、ToMe consolidation、檢索聚合與 gated fusion；但缺完整 optimizer 與 checkpoint-selection 歷史，不能補推完整重訓配方。SimplerEnv-Fractal／Bridge 又是不同權重、機器人介面與實作譜系，不是跨資料集單一相同模型。
- **Remember Color 的固定初始檢索路徑替換**：第二次 attempt 開始、第一次 query 前，只換 payload，保留 key、state signature、slot、timestamp、version 等欄位。selector 依 cognitive／perceptual key 與目前 tokens 的相似度排序，以 state similarity 門檻決定是否接受，最多回傳四筆。之後 merge 可能改寫部分 payload，故安裝時固定路徑不代表整場決策都固定或替換完整存活。
- **ChainBench**：先有 write episode 顯示物體在哪個抽屜，再加同場景 distractor writes；query 時抽屜關閉，觀測跨答案相同，必須先承諾選一個，再由凍結的 $\pi_{0.5}$ 動作策略執行。這裡 $\pi_{0.5}$ 是模型名稱，不是成功機率或門檻。

202-chain 主實驗的 full memory 是指定保留 latest write 的集合、校準過的 presence gate、兩階段檢索與 leave-one-chain-out nearest-centroid readout；query chain 的事件不進自身 centroid。它沒有決策當下的 LLM call，也沒評估 eviction policy。另有 live harness 使用封閉權重 planner，但**不能把 live harness、封存決策重播與腳本 reader 的證據混為一談**。

## 4. 哪些實驗支持哪些結論？

所有實驗都在 **MIKASA-Robo、SimplerEnv、LIBERO 模擬**；沒有真機安全或部署驗證（倫理聲明）。以下是作者結果，本筆記沒有重跑。

### A. Learned bank：看得到敏感，尚未識別事實特異性

- Shell Game blackout 的 200 配對中，讀記憶成功率 **73.5%**、阻斷讀取 **69.5%**；作者報告可檢出的差異，但單側上界 **7.70 個百分點**仍低於該 campaign 的 **10 個百分點**實質收益標準。這不是「完全無效」。相機可見時則為 **94.0%／93.5%**。此外任務只要碰過正確杯即成功，可能先選錯再補救；成功率不是單次記憶決策正確率。
- Remember Color 3／5 的共同 donor-eligible cohort **388 對**：C 翻轉 **0/388**，U **46/388（11.9%）**，S **51/388（13.1%）**，T **55/388（14.2%）**。T 比 S 的任務等權增量為 **+1.03 個百分點**，90% paired-bootstrap 區間 **[−2.34, +4.41] 個百分點**，落在事先規劃的 **±7.5 個百分點**等效帶。
- 這個區間表示「實際送達的替換」在該寬度內等效，不代表完全沒有小效應；U 與 S／T 未檢出差異則**沒有**做成等效證明。coverage 僅 **0.70–0.83**，且 attempt 2 會再次露出 cue，因此不能斷言所有真正需要歷史的記憶模型都不使用事實。

**區間怎麼讀**：90% confidence interval 是特定重複抽樣程序的覆蓋性質，不是這一個固定區間有 90% 機率裝著真值；預設等效界限則是研究問題容許忽略的效果尺度，不是自然常數。B.4 指出實現的 sham floor 高於原先 power simulation 的假設，小效應的解析度不足。

### B. ChainBench：正確記錄有用，但上限與管線要拆開

LIBERO 的主研究用 **202 chains、每題兩個選項**。無記憶的決策正確率 **53.0%**、任務成功率 **39.1%**；full memory 分別 **100%／74.3%**，oracle 也是 **100%／74.3%**。initial-fact baseline 忽略更新，決策 **52.0%**、任務成功 **39.1%**；打亂記錄則 **51.5%／38.6%**（表 2）。相同成功率沒有做等效檢定。

**真正的比較單位**：每條 chain 只有兩個錄好的物理執行供所有條件查表；相同決策共用同一個執行結果。因此 full memory 與 oracle 都答對時，任務成功率相等是配對構造的結果，不能說成兩套 agent 獨立反覆跑真機後同樣可靠。100% 決策正確本身仍是待解釋的觀測結果，不是由共用執行直接強迫出來。

另外 **401 chains** 的 C／U／S／T 測試只換整理過的 event feature，固定 nearest-centroid 腳本 reader：U／S 各 **0/401** 決策翻轉，T **401/401**。這支持**該 reader、該記錄集合**的事實特異性；不測 live writing／retrieval，也不是另一份獨立正向控制證據。其 bootstrap 區間退化成同一值，不意味母體無不確定性（B.2）。

馬達端另做相同指令重播時，約 **27%** 結果會翻轉（B.5）；所以主研究把決策與馬達分開是必要辨識設計，而不是端到端穩定性證明。另一個 143-chain 支持研究有不同 executor、三選一與 manifest 重建的選擇偏誤疑慮，不能與 202-chain 合併或當獨立同條件複現。

### C. 訓練目標變好不保證閉迴路變好

F.4 另訓練 retrieval／fusion 與零初始化 execution adapter，凍結 7B backbone，約 **427.7M** 可訓練參數。held-out diffusion loss 能分開 true／empty／mismatched memory，但新的 **500 配對／條件** factorial 中，trained+bank 任務成功率 **10.2%**，trained+empty **18.4%**。作者假說是短示範對長 rollout，以及 expert memory 對自身 rollout memory 的分布轉移；並未識別唯一原因。完整 loss 式與全部訓練細節本次未讀，不代填。

這個例子提醒我們：offline content sensitivity 不能直接外推到閉迴路任務效益。但該 plugin 部分執行實作版本無法綁定，仍須保留可重現性折扣，不能拿來對 MemoryVLA 全家族下定論。

## 5. 失效、撤回證據與可重現性折扣

- **介入有效性**：S 仍可能換掉很多非目標內容；U 與 C 走不同安裝程序。本文有控制混雜的意識，但不代表所有混雜已消失。
- **資訊與讀取瓶頸**：目前畫面重新洩漏 cue、允許多次試錯、替換被 merge 或 reader 沒取到，都會讓陰性結果難以解釋。
- **證據撤回**：Shell Game full-vision content ladder 被作者撤出 Q3／Q4 證據，理由包括事前未設 survival gate、送達不足與 any-touch 指標；不引用那個陰性數字當事實特異性結論。
- **前瞻／回溯分界**：部分 campaign 有事前凍結 protocol，但無第三方時間戳；IMEP 四問、部分送達審計與判準是 post hoc。不能把公開論文的整體整理稱為完全預註冊。
- **譜系缺口**：community checkpoint、不同 overlay 的行為等價性未建立；ChainBench 歷史 decision evaluator 原始版本未留下 digest。artifact 可做 offline verification 也不等於全部重跑，封閉 planner 無法 bit-for-bit 再生。

## 6. 第一性原理：記憶是可追蹤的資訊通道，不是多一個模組名稱

**本筆記的可重用模型**：把主張依序拆成「資訊是否必要 → 事實是否被保留 → 是否送達 → 是否被正確解讀 → 決策是否改變 → 改變是否值得 → 馬達能否可靠實現」。一個成功率只觀測最後結果，無法自動定位前面哪一段有效。

最小必要狀態不是整段影片，而是足以改變當前選擇的事實、適用對象與有效時間；但是否足夠必須在觀測混淆的任務上測。資料限制是 expert trace 與自身 rollout 的分布可能不同；計算限制是記憶路徑同時改變額外計算；物理／控制限制是正確指令仍可能執行失敗。只有把這些通道分開量測，才能知道下一筆研發成本應花在 writer、retriever、reader 還是 executor。

這補強 Mem4Act 的「歷史依賴尚非事實特異性」，不是回頭改稱舊筆記已做過 IMEP。也接續 [RESCUE](../2026-10-13/02-rescue-警報的介入價值.md)：警報可辨識、記憶可敏感，都不是介入淨效益本身；本文則再往內追問效益是否真的由目標內容造成。

## 7. 後續驗證問題

1. 在 Mem4Act／REKI 上，能否設計非目標外觀相近、只改關鍵階段事實的 S／T，另加**原 payload 經同一安裝程序**的控制，把安裝與 ULP 分開？事前登錄送達檢查及最小有意義效應。
2. 用閉抽屜、單次承諾、不可試錯的任務，逐步追蹤 writer → bank → retrieved record → reader；把「記錄已存在但未取到」與「取到卻未使用」分成兩種失敗率，是否仍能看到事實特異性？
3. 在獨立重跑而非共用查表執行下，決策改善的收益是否超過 executor 隨機性與記憶成本？同時保留配對／信賴區間，不把 100% curated decision accuracy 外推成部署可靠性。

---

**回到索引**：[今日候選與取捨](./README.md)｜[2026 年](../README.md)｜[研究導覽](../../../研究導覽.md)
