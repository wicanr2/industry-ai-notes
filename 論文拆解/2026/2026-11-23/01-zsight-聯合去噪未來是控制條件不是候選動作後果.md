# Z-sight：聯合去噪的未來是控制條件，不是候選動作後果

> **問題**：不生成影片，能否讓控制策略在部署時持續使用預測的未來，而且知道何時不該相信它？
> **方法**：在 VLM 自身持續更新的視覺空間中，讓 foresight expert 與 action expert 同步去噪；以 EMA 教師提供未來監督，並讓動作端在訓練中接觸不同噪聲程度的預測。
> **判讀**：換內容與換噪聲標籤的閉迴路介入，支持策略依賴場景特定預測及其噪聲條件；但未來流不讀候選動作，不能稱作逐候選後果模擬，也未驗證不確定性校準或安全保證。

## 原文與實際閱讀範圍

- **論文**：$Z$-sight: Unifying Vision-Language-Action and Latent World Modeling。
- **作者**：Junjie Ye、Yiqi Zhao、Muchen Xu、Celina Shiyu Wang、Hao Dong、Ruohai Ge、Rong Xue、Benjamin J Kolligs、Aditya Dutt、Sasanka Nagavalli、Nassim A. Samad、Gaurav S. Sukhatme、Jyotirmoy V. Deshmukh、Yue Wang、Yuliang Guo；Maven Robotics／University of Southern California。
- **版本與日期**：`2611.24940v1`；2026-11-18 18:59:38 UTC 提交。2026-11-23（Asia/Taipei）11:39 後擷取；這是本次實際執行時間，不冒充 09:00 已取得。官方無版本摘要頁僅列 v1，未見撤稿／withdrawn 註記；只是當時狀態，不是同儕審查或未來不撤稿的保證。
- **來源**：[版本摘要](https://arxiv.org/abs/2611.24940v1)｜[目前摘要與版本歷史](https://arxiv.org/abs/2611.24940)｜[官方 HTML](https://arxiv.org/html/2611.24940v1)｜[PDF](https://arxiv.org/pdf/2611.24940v1)｜[作者專案頁](https://junjieye.com/Z-sight/)（本次未另審專案頁、程式或影片）。下述章節與表號均指 v1。
- **實讀**：官方 HTML 摘要、§1–5（含 Limitations）、附錄 A.1–A.3、B.1、C.1–C.2、D.1–D.2、E.1 的評估協定與 Table E.1、E.2、F.1–F.2、G；主文 Tables 1–8、Figures 1–7 圖說。另取得 PDF，以 `pdftotext -layout` 核對首頁作者與 Tables 3–8 的相關文字／表號；未逐頁讀完 PDF、未逐像素讀圖、未完整讀 B.2 與 Table E.2 逐任務列、未審碼或重跑實驗。PDF 抽取有字型警告，公式主要依 HTML 的 LaTeX alttext 核對。
- **與庫內關係**：11-20 至 11-22 只有摘要候選，本次首次新增方法筆記，不回寫舊索引為已讀。所有效能皆為作者報告，不是本筆記重現。

## 一、先問預測在哪裡，以及誰能讀誰

既有路徑有三種不同成本：影片生成保留豐富外觀但推論重；輔助 feature loss 可以只在訓練生效；外接凍結 encoder 的未來特徵則可能與持續微調的感知空間分離。本文把預測放在 VLM 原生的空間 tokens 中，省去 pixel decoder，但保留部署時的生成流。

這不是「沒有影片生成，所以沒有未來生成」。每次動作 chunk 都要生成 latent future；新增的計算與錯誤傳播都還在。也不是 LLM 先寫自然語言計畫：語言指令作條件，實際控制由連續動作 expert 產生。

更關鍵的是 attention 方向（§3.1、Figure 3）：

1. VLM prefix 讀指令、觀測、本體狀態，不看兩個 experts。
2. foresight 讀 prefix 和自己，**不讀 action stream**。
3. action 讀 prefix、foresight 和自己。

因此「聯合去噪」是共用去噪進度、每步同時更新，並非動作與未來雙向互相條件化。作者也在 Limitations 明說，讓 future 以候選動作為條件是未來工作。這個資訊拓樸比模型被叫作 world model 更能界定它目前會做什麼。

## 二、任務與方法：原生空間也需要處理漂移

### 輸入、輸出與最小時間單位

在時間 $t$，輸入語言指令 $\ell$、本體狀態 $s_t$ 與多相機歷史影像 $O_t$，輸出

$$
A_t=(a_t,\ldots,a_{t+H-1}).
$$

$A_t$ 是動作 chunk，$a_t$ 是單步動作，$H$ 為規劃步數；這不是保證所有動作都能安全執行的軌跡。訓練另有未來影像 $O_t^+$，部署時不可取得。G1 的 $H=30$，LIBERO 為 16，RoboTwin 為 50；不同實驗不能共用一個 chunk 時間口徑。

架構是 Qwen3.5-2B VLM 加上各 0.48B 的 foresight／action expert，合計 3.18B。因果 video encoder 重用 vision encoder 的權重，每第四個 ViT block 加入因果時間混合與空間 attention，只將最後影格的空間 tokens 交給 VLM；不增加這部分的模型參數，不代表讀歷史沒有計算成本。多相機分別編碼並加入 view-role embeddings。

### EMA 教師不是外部 encoder，也不是完全同步的自己

核心目標（原文 Eqs. 1–2）可縮寫為：

$$
\bar\phi\leftarrow\mu\bar\phi+(1-\mu)\phi,\qquad
z_t^+=\operatorname{LN}\!\left(\operatorname{sg}[V_{\bar\phi}(O_t^+)]\right).
$$

$\phi$ 是在線視覺 encoder 參數，$\bar\phi$ 是指數移動平均（EMA）教師參數；$\mu\in[0,1)$ 控制追蹤速度。$V$ 是因果 video encoder，$z_t^+$ 是未來片段最後影格的空間特徵目標；$\operatorname{sg}$ 表示不沿目標反傳梯度，$\operatorname{LN}$ 是逐 token 的通道正規化。它對齊的是同一家族中緩慢追蹤的特徵空間，不是每個更新步都完全相同的座標，更不直接等於物體位姿、接觸力或物理充分狀態。

foresight 從混有高斯噪聲的目標還原乾淨特徵，其 loss（Eq. 5）為：

$$
\mathcal L_{\mathrm{view}}
=\mathbb E\left[\left\|\frac{z_t^+-\hat z_t^+}{\max(\sigma,\sigma_{\min})}\right\|^2\right].
$$

$\hat z_t^+$ 是預測特徵，$\sigma\in[0,1]$ 是視覺流噪聲程度，$\sigma_{\min}=0.05$ 限制小噪聲時的權重放大；期望對訓練樣本與噪聲取平均。這是特徵生成的訓練誤差，不是任務成功機率，也沒有把 latent 的小誤差換成物理安全界限。

action expert 則做條件 flow matching：把真值 chunk 與高斯噪聲依動作噪聲程度 $\tau\in[0,1]$ 混合，學習由資料指向噪聲的速度場，推論再逆向積分。訓練以 $\sigma=\max(\tau,u)$ 讓視覺流可能比動作流更吵，$u$ 是隨機噪聲下限；推論兩者共用 $\sigma=\tau$ 的 10 個 Euler steps。**這裡的噪聲時間不是牆鐘時間，指定噪聲量也不是對真實場景未知程度的校準分數。**

### 三階段訓練：要把「誰教誰」寫清楚

- **預訓練**：1,977.1 小時 EgoDex／EgoVerse 人類第一視角影片，只訓練 VLM 預測離散 FAST 動作 tokens。手部追蹤低信心通道遮罩，軌跡轉相對座標並平滑；本次未完整讀 B.2 的平滑消融，不對最佳核寬下結論。
- **中期訓練**：約 2,753 小時 AgiBot World／Humanoid Everyday 機器人資料，另以 20% 抽樣權重 replay 人類資料，並非額外新增 20% 的錄影時數。聯合使用 FAST、action flow 及權重 0.1 的 view loss。對新 expert 的 VLM keys／values 使用 stop-gradient，VLM 由 FAST loss 更新；view loss 不回傳 VLM。中期 EMA decay 為 0.99。
- **目標域適應**：不再使用 FAST loss，保留 action flow 加 0.1 view loss。action 梯度可更新 VLM 與 experts；view loss 仍隔離於 VLM 外，只更新 foresight。EMA decay 為 0.999。不能把「隔離 view 梯度」說成「凍結整個視覺 backbone」。

不同本體以相對動作、補齊維度與有效通道遮罩統一。G1 另收 557 段 demonstrations，其中 355 段來自六個評估任務，202 段來自另四種家務技能；按 episode 切出 nominal 10% validation。相同目標域 demonstrations 不表示各基線的預訓練知識相同。

## 三、部署：模型的 110 毫秒，不是感測到動作的新鮮度

每個 chunk 先算一次 VLM prefix 並 cache keys／values，從兩組噪聲啟動 future／action experts，在十次共同前向計算中逐步更新。部署省略 FAST tokens，且 expert 不能偷看訓練時的真值 FAST tokens。這是生成與控制耦合，不是搜尋多個候選並按預測後果選最佳。

真機使用 Unitree G1、兩隻 Dex3-1 手與頭部相機；桌面任務用 RealSense，移動任務用 ZED，相機在每個任務的收集／評估保持一致。輸出為 **78 維 SONIC motion token 加手部目標**的組合動作，並非裸全身關節控制；SONIC 在 50 Hz 維持底層追蹤／平衡。上層以同步閉迴路、10 Hz 串流完整 30-step chunks；3 秒規劃跨度不能讀成每 0.1 秒重做一次 VLM 決策。

Table 8 的 RTX 4090 中位數為 109.5 ms／chunk：100 次 warm-up、100 次 CUDA 同步計時，**只包含行程內模型計算**，排除影像擷取、網路與低階控制。GR00T N1.7 的 60.0 ms 更快，但用四個去噪 steps；其餘列用十步。關掉 foresight 約省 45 ms，也說明 latent 預測不是免費。

Table 7 的 joint 114.8 ms、sequential 208.0 ms 是另一套 SIMPLE 歷史片段設定；不可和 109.5 ms 混成同一次量測。同權重 sequential 先做十步 future、再十步 action，SIMPLE Hard 由 73.1% 降至 64.2%，但 RoboTwin C2C 從 82.4% 到 82.6%，因此不能逐格說 joint 都更準。這也是同權重推論排程比較，未等總 FLOPs 或分別重新訓練。

## 四、實驗：主榜、機制與分母各自回答什麼？

### 完整成功與局部進度分開

- **SIMPLE**：主文的 81.9% 是 12 個 Teleop 任務、三種難度的平均，三次 evaluation passes 共 1,080 episodes，**是同一 checkpoint 的評估變動，不是三個訓練 seeds**。GR00T 官方配方為 72.3%；開放 VLM 全量訓練控制為 73.9%。附錄 E.1 加入五個 motion-planned 任務後，Z-sight 全 17 任務平均是 73.1%，MP 子集只有 52.0%；不能把 81.9% 當整套 benchmark 覆蓋。
- **真機六任務**：每任務十次，44/60 完整成功，即 73.3%；進度 81.7% 另計。最強基線 Fast-WAM 53.3% 成功、63.8% 進度；兩階段任務每階段半分，四階段每階段四分之一。Book 僅 6/10 完整完成，Puffs 也是 6/10；成功平均不能替代跨物體、跨日或安全驗收。
- **LIBERO**：四 suites、40 任務、每任務 50 次，共 2,000 episodes，平均 97.7%，與 Motus 持平。不是所有列都勝出，例如 Spatial 97.2% 低於部分基線；已接近飽和的平均不能單獨支持大幅泛化。
- **RoboTwin 2.0**：50 任務、每任務 50 段 clean demos；主榜每條件 5,000 episodes。C2C 82.44%、C2R 39.00%，C2R 低於 π0.5 的 46.00%。受控消融／介入為每條件 1,000 episodes，其完整模型 C2R 是 40.10%；這與 39.00% 是不同評估分母，不是悄悄挑選較好數字。

基線涵蓋 π0.5、GR00T N1.7、Ψ0、Fast-WAM 等。D.1 對目標域資料與控制介面有對齊，但預訓練與適應資源未完全同質：例如 Fast-WAM 為匹配 GPU-hours 而減少 sample presentations，G1 1.44M 次對 Z-sight 2.56M 次；Ψ0 則 5.12M 次。作者解釋 video backbone 每樣本訓練較貴；這是成本口徑選擇，不等於所有公平性問題都消失。

### 訓練消融：有未來 loss 比只保留分支好，但還沒拆完原生空間

Table 3 從相同 mid-trained 初始化做適應，比 demonstrations 與 schedules：

- 完整模型／去掉 view loss／去掉整個 foresight branch：SIMPLE Hard 為 **73.1／25.0／68.3%**。
- G1 Dog 為 **90／30／40%**，但僅單任務十次。
- RoboTwin C2R 為 **40.1／11.6／22.0%**。

去掉 loss 卻留下分支更差，支持「沒有持續預測監督的串流會成為壞條件」，不只多參數帶來收益；但也提醒不能把 full 對 no-loss 的全部差值稱為超越良好 action-only 模型的純增益。移除 branch 與保留無監督 branch 是不同反事實。

Table 4 的 FLARE-style／凍結 DINOv2-B target／完整模型，在 RoboTwin C2R 為 20.9／26.6／40.1%。這支持目前整組原生 EMA 設計，卻同時混合**encoder 身分、是否原生、是否凍結／追蹤**等因素；缺少「凍結自己的 encoder」及「外部 encoder 也追蹤」等交叉控制，不能獨立歸因全部差距於 EMA 或 native 其中一項。

### 內容與噪聲標籤的介入，是本文比排行榜更有用的地方

Table 6 固定權重，在 SIMPLE Hard：

- 原模型預測：73.1%。
- 高斯噪聲並標為高噪聲（$\sigma=1$）：61.7%。
- 同樣是高斯噪聲，但標為正常共同去噪進度（$\sigma=\tau$）：16.7%。
- 另一 episode 的預測、保持共同噪聲進度：11.7%。
- 複製現在當未來：5.8%；阻斷 action 讀取 future 的 attention：7.5%。

作者據此認為策略依賴場景特定內容，也能在「被告知不可靠」時退回目前觀測。本筆記接受這比 attention 熱圖或 feature similarity 更強：同一個壞內容配不同噪聲條件，結果會不同；單有分支的統計外形也不夠。

但保留三個限制。第一，噪聲程度是人工指定的生成條件，不是模型在線偵測真實預測錯誤；沒有校準曲線、未知物理事件的自動棄權或校準失效研究。第二，跨 episode swap 連同任務／場景相關內容一起換掉，沒有只改某一個後果事實的最小介入；拒絕不相容條件也會導致差異。第三，嚴重破壞或遮斷會造成分布外輸入，不能從掉分直接斷言已辨識唯一必要的物理推理機制。

附錄 F.2 真機介入只測 Dog：原模型 90%、宣告高噪聲的高斯流 60%、copy 0%；未提供真機六任務的完整介入矩陣。不能把模擬的內容交換結論視作所有真機任務已驗證。

### 更準的未來與更好的動作，還隔一層

Table 5／F.1 在 11,676 個 held-out G1 windows 比預測、現在與無關未來：對真值未來的 cosine 分別 0.955、0.921、0.850。背景與特徵共同成分本來就很像，不能把 0.955 稱為 95.5% 的物理預測正確率；變化向量 cosine 0.646 比較接近是否捕捉改變，仍包含頭部相機運動。

固定初始動作噪聲，把模型預測換成**真值未來特徵，並加噪至相同進度**，demonstration chunk 的 normalized MSE 由 0.0495 到 0.0436，作者報改善 11.9%。這是事後有 oracle 的開迴路誤差，不是部署可得輸入，不是完整成功提升 11.9%，也不證明更靠近 demonstration 的動作在所有場景都更安全。窗口按 episode 留出比逐幀混分可靠，但相鄰窗口仍不能當 11,676 次獨立真機部署。

## 五、第一性原理：預測應帶什麼資訊，才值得付出計算？

**最小必要狀態**不是「整張未來的相似度」，而是足以決定下一段動作的物體／手／身體關係、速度與階段條件。短歷史與空間 tokens 可增加可用線索，卻沒有新增接觸力感測；同一外觀下若接觸狀態不同，視覺預測仍可能欠定。這是本筆記對可觀測性的推論，不是作者已做的力學測試。

**資料與技術限制**是 teacher 的目標跟著控制學習移動：原生空間可能減少接口不一致，卻也可能放棄某些通用知識。EMA 與梯度隔離是抑制塌縮／遺忘的設計，文中未提供足以保證一般 VLM 能力全部保留的評估。前瞻來自 demonstrations 下的未來分布，不能無條件外推到未見干預。

**物理限制**在控制鏈下游：SONIC 的平衡／追蹤能力是完整系統的一部分；上層 chunk 內若物體滑落或人進入場景，110 ms 純計算不是停止延遲，也沒有獨立安全 barrier 或取消承諾動作的驗證。

**有效條件**是未來 token 的內容與當前觀測相容，並且其噪聲條件落在訓練覆蓋內；它可以提供控制條件，但錯誤且被當作乾淨的未來可能比不提供更傷。RoboTwin 的隨機條件落後、SIMPLE MP 子集掉分與 no-view-loss 變體，都是不宜省略的反例。

可複用的研究模型為：**預測空間 → 梯度路徑 → 讀取方向 → 可信程度的來源 → 內容介入 → 完整閉迴路結果**。特別把「生成的未來影響動作」與「對候選動作預測後果」分成兩個問題，避免從聯合生成跳到反事實規劃。

## 六、下一步只問三件事

1. **不確定性從哪裡來？** 固定場景與錯誤內容，掃描噪聲條件；再測未知遮擋／接觸改變下是否能自行偵測失準，報校準、完整成功及誤棄權成本，而不只手工給 $\sigma=1$。
2. **原生與持續追蹤誰有效？** 固定容量、資料、適應更新與噪聲 schedule，交叉比較 native／external、frozen／EMA；再加入凍結／交換視覺 backbone，分離被讀的表徵與讀取器的收益。
3. **如果改成候選動作條件化呢？** 先選具有不同後果的可執行動作，逐候選預測並檢驗排序對真實 rollout 的校準；在相同總延遲／算力下比較目前共生成，分報完整成功、人工救援與物理安全。這是提案，本文未完成。

## 與既有筆記對讀

- [RelayWAM：可解碼、動作使用與有益使用](../2026-11-20/01-relaywam-可解碼未來不等於動作使用而使用也不等於有益.md)：部署不生成 future，透過當前視覺表徵讀取訓練得來的預測資訊；本文則部署直接生成 latent future，並提供閉迴路內容介入。不同資料／任務，不能用兩文平均分直接排名。
- [CoRAct：離線後果對齊與部署噪聲偏好](../2026-11-02/01-coract-對齊預測後果不等於實測執行正確.md)：對照「候選後果在哪個階段被評估」；不主張兩者已有整合或任何一方完成實機安全證明。
- [研究導覽：表徵如何被使用](../../../研究導覽.md)：今天新增的是噪聲條件與單向共生成的證據邊界，不改寫舊文的實際閱讀範圍。
