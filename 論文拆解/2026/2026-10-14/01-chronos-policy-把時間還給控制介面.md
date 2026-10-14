# Chronos Policy：把時間還給控制介面

> **問題**：相同的兩張影像，若間隔與動作真正執行的時間不同，還能用同一段序列表示同一個控制問題嗎？
> **方法**：讓感測的擷取時間與動作的預定執行時間進入 attention，配合時間隨機化訓練，而不是只把推論變快。
> **判讀**：證據支持時間標記與訓練覆蓋的互補性；沒有證明能吸收任意延遲，也不等於時鐘同步、排程或安全保證。

## 來源與實際閱讀範圍

- 原題：*Chronos Policy: Learning Robot Policies on Physical Time*。
- 作者：Changhao Wang、Jaden Clark、Shuran Song；Stanford University。
- 版本：**arXiv:2610.13929v1**；首次提交 2026-10-09 17:55:20 UTC。2026-10-14 查閱版本頁時最新列示為 v1，未見 withdrawn／retracted 標記；這是查閱當下狀態。
- [版本頁](https://arxiv.org/abs/2610.13929v1)｜[官方 PDF](https://arxiv.org/pdf/2610.13929v1)｜[官方 HTML](https://arxiv.org/html/2610.13929v1)｜[作者專案入口](https://changhaowang.github.io/chronospolicy/)。專案入口僅保留 provenance，本次未驗證程式碼與資料下載內容。
- 擷取／閱讀日：**2026-10-14（Asia/Taipei）**。
- **實讀範圍**：以官方 PDF 的 `pdftotext -layout` 抽取為主，讀摘要、§1 導論、§2 相關工作、§3.1–3.4 完整方法、§4.1–4.5 實驗、§5 結論／未來工作，以及附錄 A 架構／訓練、B 評估與消融、C 真機資料／計分／結果。PDF 共 18 頁；未逐條查證參考文獻，未重跑實驗。
- 抽取限制：PDF 有字型型態 warning，部分公式排版與 query/key 的上標在文字層錯位；以下按公式前後說明整理。圖 3–5 的視覺長條未逐點讀值，數字依內文及附錄表 3–9，不以圖形目測補數字。已取得 HTML，未把「下載成功」當作全部 HTML 逐節閱讀。
- 昨日日期索引只將這篇列為未讀方法候選；**今日才建立方法筆記**，沒有回改昨日閱讀範圍。

## 一、缺口不是少了一個 timestamp，而是控制狀態不可辨識

固定頻率 observation–action sequence 通常讓第幾個 token 代替經過多久。這在錄製與部署時序相同時可以工作，卻把三種不同關係混在一起：影像間隔決定能否辨識速度；不同感測器的相對時間決定能否辨識接觸狀態；觀測到動作執行的間隔決定應預測多遠的未來。

論文用移動輸送帶抓取說明：相同位移若發生在不同時間間隔，對應不同速度。降低推論延遲可以縮小誤差，卻沒有讓 policy 知道這次影像有多舊、這次動作何時才會生效。RTC 類方法著重讓新舊 chunk 銜接，並不自動提供感測擷取時間。Chronos 改的是**模型接收的問題定義**，不只是 chunk 執行器。

本筆記判讀：這是 Physical AI 的時間介面研究，**不是語言條件 VLA／LLM 研究**。把它接到 LLM 機器人系統時，受益的應是低階感測—控制契約；本文未測語言推理或 LLM 整合。

## 二、任務、輸入與輸出：查詢一段有預定時刻的動作

依 §3.1，用緊湊記法表示：

$$
A_{\mathbf t_a}\sim\pi_\theta(\cdot\mid O_{\mathbf t_o},\mathbf t_o,\mathbf t_a),\qquad
 t_{a,j}=t+d_t+j\Delta t_a,\quad j=0,\ldots,H-1.
$$

- $\pi_\theta$ 是參數為 $\theta$ 的策略；$O_{\mathbf t_o}$ 是一批帶擷取時間的影像、本體感覺及選用的力／力矩觀測；$\mathbf t_o$ 是這些擷取時間。
- $A_{\mathbf t_a}$ 是動作 chunk；$\mathbf t_a$ 是各動作的**預定**執行時刻，不是事後量得的實際生效時刻。
- $t$ 是發出策略請求的時間；$d_t$ 是第一個查詢動作距請求的延遲；$\Delta t_a$ 是動作間隔；$H$ 是預測動作數；$j$ 是從零起算的動作索引。

白話：模型不是只回答「下一段要做什麼」，而是回答「從指定的未來時間開始，各時刻要做什麼」。感測器保留各自原生時間，不必先硬對齊成共同網格。實驗仍固定預測 16 個動作、20 Hz；可輸入時間的形式化，不代表本文已驗證任意可變控制頻率。

## 三、真正改動：content 不變，把物理時間放進 attention

### 1. 相同 backbone 與不同時間表示

附錄 A 使用同樣的 16 層、寬度 512、8 個 attention heads 的 diffusion transformer 比較 DP 與 Chronos。SigLIP2 base 產生影像 patch 特徵；非影像 token 間有 self-attention，再 cross-attend 到影像 patch。力／力矩任務加相應 token。Pivoting 使用同樣的 adaptive-compliance controller 與動作表示，各方法不是換控制器比輸贏。

Chronos 為每個 token 指定物理時間：同一 frame 的 patches 共用擷取時刻，姿態與力／力矩用測量時刻，noisy action tokens 用要求的執行時刻。modality／spatial embeddings 保留內容；時間另外進 RoPE。

### 2. time-aware RoPE 的關係與邊界

依 §3.2，設 $\tilde t_i=t_i-t$，用旋轉矩陣 $R$ 改寫 query／key：

$$
\tilde q_i=R(\tilde t_i)q_i,\qquad
\tilde k_j=R(\tilde t_j)k_j,\qquad
\tilde q_i^\top\tilde k_j=q_i^\top R(t_j-t_i)k_j.
$$

$q_i$、$k_j$ 是 token $i$、$j$ 的 attention query／key；$\top$ 是轉置；$R(\tau)$ 是以時間差 $\tau$ 決定角度的成對座標旋轉。模型因此能區分不同的經過時間，而不是只看序列索引。一起平移時鐘原點不改變差值，**但感測器間時鐘偏差不會因而消失**。

附錄 A.2 用秒為座標，旋轉 16 組 query–key 座標對，週期在 0.1–2 秒間以對數間距安排。這不是物理方程式或防碰撞約束；旋轉表示會受尺度與週期性限制，本文也沒有證明長時間跨度的外推能力。

對照的 AddTime 用 Fourier features 加 MLP，直接把同樣時間加到 token embeddings。兩者共用資料、token 配置與時間隨機化，這個比較較能隔離「時間如何進入模型」；作者提出 content／time 分離可能更有效，**那是機制解釋，不是已證明的唯一原因**。

### 3. 時間隨機化不是任意捏造軌跡

§3.3 對錄製示範隨機抽 observation rate、delivery delay 及 action chunk 起始延遲；只選該請求時點已可取得的 measurements，保留原始擷取時刻。原本固定降採樣會丟掉的 measurements 得以進不同訓練樣本。沒有將未來觀測偷偷當現有輸入，也不是重演所有新時序下的物理軌跡。

訓練仍是模仿學習的 diffusion clean-action prediction，不是新增語言 reward 或 RL。依 §3.3 的目標，整理為：

$$
A^{(k)}=\alpha_k A^*_{\mathbf t_a}+\sigma_k\epsilon,\quad
\epsilon\sim\mathcal N(0,I),\qquad
\mathcal L(\theta)=\mathbb E\left[\left\|D_\theta(A^{(k)},k,O_{\mathbf t_o},\mathbf t_o,\mathbf t_a)-A^*_{\mathbf t_a}\right\|_1\right].
$$

$A^*_{\mathbf t_a}$ 是示範中對應查詢時刻的目標動作；$k$ 是擴散步；$\alpha_k$、$\sigma_k$ 控制原動作與噪聲比例；$\epsilon$ 為單位協方差高斯噪聲，$I$ 是單位矩陣；$D_\theta$ 是去噪模型；$\mathbb E$ 對訓練樣本及噪聲取期望；$\|\cdot\|_1$ 是各維絕對誤差總和。目標是還原示範動作，不保證新狀態下的最優或安全控制。

模擬以 100 Hz 原始資料抽取，影像／姿態訓練速率 12.5–33.33 Hz、delivery delay 0–50 ms；Pivoting 的 force/torque 1–100 Hz、delay 0–100 ms。action 起始延遲一半為零，其餘最多 100 ms。所有 policy 訓練 50 epochs；模擬 DDIM 24／8 training／inference steps，真機 50／16。不是以無限隨機化覆蓋所有可能延遲。

## 四、部署迴圈：預測執行時間，也要丟掉過期動作

依 §3.4：

1. 收集目前已交付觀測，保留 capture time，不以收到資料的時間取代它。
2. 決定新的 action query times；模擬用注入推論延遲，真機用已完成請求估計下一次的 $d_t$。
3. 去噪生成新 chunk；生成期間繼續執行舊 chunk。
4. 新預測到達後，丟掉查詢執行時刻已過的動作，依剩餘時刻排程。

這個迴圈處理了「模型輸出已過期」問題，但下一次推論時間仍未知。本次所讀沒有提供尾延遲預測保證、任意超時的安全備援，或讓實際馬達響應與查詢時刻完全一致的證明。排程／控制器抖動與感測時鐘校準仍是外部責任。

## 五、實驗究竟支持哪個機制？

以下為**作者報告**，本筆記沒有獨立重現。

### 資料、任務、比較與評估口徑

- 模擬：Conveyor 動態取放、Pivoting 多感測接觸任務，以及 DexMimicGen 的 Threading、Assembly、Transport、Coffee、Drawer Cleanup、Pouring 六項準靜態任務。本文提供錄製／降採樣設定；本次所讀附錄未找到每一模擬任務的示範筆數，不自行補齊。
- 基線／消融：DP、DP + temporal randomization、RoPE without randomization、AddTime、完整 RoPE。真機另比較經 DDIM sampler 適配的 DP + RTC；這不是所有可能的 delay-aware policy 的完整排名。
- 模擬指標是成功率。Conveyor／Pivoting 消融每個方法／條件 450 episodes，先平均每 training seed 的三個 evaluation seeds，再報三個 training seeds 的均值與 sample SD。標準任務每 seed／條件 50 episodes。checkpoint 由 nominal validation success 每五 epochs 選一次。
- 真機：Dynamic Cup 的 train／validation demos 為 252／13，Peg Insertion 220／11，Pivoting 322／17。前兩任務每 policy／timing condition 各 10 trials，Pivoting 20 trials；力／力矩原始約 360 Hz，以 stride four 形成約 90 Hz history。
- 真機不是單純二元成功率。依附錄 C，task score 為 $100(F+0.5P)/N$：$F$ 是完全成功數，$P$ 是部分成功數，$N$ 是試驗總數。側倒但在 saucer 上、超過 30 秒才插入、物件先直立再倒下，分別算各任務的部分成功；不能把 score 寫成完整成功率。

### 1. 時間隨機化與時間標記互補，不是所有 augmentation 都有益

附錄表 3：Pivoting nominal success，DP 是 61.6%，DP + randomization 變成 29.8%。同樣隨機化若不告訴模型跨感測器相對時刻，可以讓資料更多卻更歧義。

在 Pivoting combined perturbation，RoPE without randomization 為 4.2%，AddTime 為 16.7%，完整 RoPE 為 38.4%；Conveyor 同條件分別 10.7%、7.8%、32.7%。這支持「時間資訊讓變動可辨識，隨機化讓模型看過足夠變動」的配對，不支持只加 timestamp 就能抵抗全部 sensing shift。

### 2. 延遲下的改善很大，但重度混合擾動仍有明顯失敗

Conveyor 的 0–200 ms inference-delay condition，DP 為 1.8%，Chronos 為 76.4%；combined 則為 0% 對 32.7%。combined 同時採用 wide sensing 與大 inference delay，影像／姿態可降到 1 Hz。後者離可靠部署仍遠，不能把前者的大差距宣傳成「延遲問題已解」。

準靜態任務整體有利，不代表每個 cell 都有利。附錄表 4 的 Threading combined 是 DP 77.3% 對 Chronos 63.3%；Assembly nominal 是 75.3% 對 68.7%。本文所稱「preserves nominal performance」應讀成整體表現相近，而非每個任務、條件皆無退步。

### 3. 真機 score 與小樣本要一起讀

附錄表 7：Dynamic Cup combined，DP／RTC／Chronos 的 task score 為 30%／25%／55%；Chronos 實際是 **5 full、1 partial、4 failure／10 trials**。表 8 的 Peg Insertion combined，Chronos score 65%，但 full 為 6／10。表 9 的 Pivoting combined，score 75%，full 為 14／20。

作者總結 Chronos 在每個真機 condition 的 aggregate score 都最高；樣本數與上述計分不支援直接把結論擴成工業可靠性。Pivoting 的 OOD sideways／inference condition，Chronos 為 0 full、3 partial、2 failures，score 30%；總平均仍會掩蓋這種失效子群。

### 公平比較與尚未隔離之處

shared backbone／controller，以及 AddTime 對 RoPE 的同資料比較，增加架構差異的可解釋性；DP + randomization 也讓資料增廣效應不致完全混進「時間表示」成效。但本文沒有測大規模跨 embodiment、未提供感測時鐘誤差 sweep，亦未把 timestamp noise、尾延遲估計、實際執行 jitter 各自單獨隔離。seed SD 不是信賴區間，真機表未提供大量重複試驗的可靠性區間。

## 六、第一性原理：最小狀態要包含資料年齡與行動生效時刻

**最小必要狀態**不是所有歷史都保留，而是足以辨識局部運動／接觸的 observations，加上各自 capture time 與動作 query time。只增加圖像數量而不增加時間關係，仍可能無法辨識速度或接觸前後。

**有效條件**：時間標記可信且可比較；示範含有支持動態估計的訊號；訓練覆蓋實際時序變動；執行器能大致按查詢時刻生效；所需預測距離仍在可學習範圍。這些是本筆記由介面與實驗推得的工程條件，不是作者提出的充要定理。

**不能被表示法消除的限制**：低取樣已丟失的事件、遮蔽中的未知擾動、超過制動／接觸反應時間的延遲、飽和力矩，以及失準時鐘。觀測更舊的時候，知道它更舊仍比不知道好；但知道資料年齡不會生出缺失資訊。

**可複用思考模型**：先問系統中哪個變量被序列格式偷偷固定，再分開驗證「把它顯式化」與「讓訓練分布覆蓋它」。不要把資料增廣、模型介面、推論速度及排程保障的收益合成一個模型能力分數。

## 七、與既有筆記串接，以及後續驗證

[BT-Agent 的固定技能與本地 guard](../2026-10-13/01-bt-agent-固定技能與反應式護欄.md)關注誰能在模型之外中斷；[RESCUE 的介入價值](../2026-10-13/02-rescue-警報的介入價值.md)關注何時恢復值得。本篇補上第三個問題：**資訊與行動在哪個物理時間上才有效？** 三者不能相互代替：時間條件策略不等於強制停止，亦不直接證明恢復值得。

1. **timestamp correctness**：分開注入跨感測器 clock offset、drift 與 capture-time noise，保持 delivery delay 不變；多少誤差開始抵銷 RoPE 的優勢？這比再加更多隨機延遲更能測介面依賴。
2. **actual execution contract**：在真機量 queried time 對實際 command／接觸生效時間的偏差，加入非平穩尾延遲。比較目前的 previous-request estimate 與其他估計／備援，報過期動作比例、full success、接觸峰值，不能只報平均 latency。
3. **where time helps**：固定資料量與模型容量，分開測動態、接觸、準靜態任務，保留完整成功與部分成功及子群結果；確認收益來自時間可辨識性，而非只有採樣多樣性。若接入 VLA，再另測語言條件是否保持，不從本文推定。
