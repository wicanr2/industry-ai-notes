# VLA-Tug：校準早期警報，不等於保證救得回來

> **問題**：VLA 的內部表徵能否在錯誤發生前發出有用警報，而不只是辨認已經失敗的畫面？
> **方法**：保留失敗前的監督、以循環探針累積表徵，再共同校準誤報與早期漏報；另外輸出失敗類別。
> **判讀**：方法最有價值的是把「預測、校準、介入」分帳；跨分布只有實測穩健性，修正動作仍是示例，不能升格為安全或救援保證。

## 原件與實際閱讀範圍

- **原題**：Failure Prediction and Classification in Vision-Language-Action Models Via Calibrated Latent Probing。
- **作者**：Michal P. Podolinsky、Yunhao Yang、Daniel Little、Hong Lu、Rohan Siva、Olin Goudey、Neel P. Bhatt、Matthias Scheutz、Ufuk Topcu。
- **版本與日期**：arXiv:2611.08425v1；2026-11-05 18:21:07 UTC 提交；擷取／閱讀日期為 **2026-11-09（Asia/Taipei，10:56 後）**。這是今日執行取得的材料，不冒充 09:00 已完成。
- **可點原文**：[版本摘要](https://arxiv.org/abs/2611.08425v1)｜[PDF](https://arxiv.org/pdf/2611.08425v1)｜[HTML](https://arxiv.org/html/2611.08425v1)｜[作者專案／資料與程式入口](https://vla-tug.github.io/)。專案內容未另行審查。
- **實讀**：27 頁 PDF 的摘要、§1–2、§3 任務、§4 方法、§5 資料、§6.1–6.5 實驗、§7 限制；附錄 A.1–A.3、B.1–B.3、C.1–C.3、D.1–D.4 與 Tables 3、6–11，E.3 介入示例的前段文字。以 `pdftotext -layout` 抽取，HTML 核對公式與章節。
- **未讀／未做**：未完整閱讀 E 的視覺化圖組及 E.3 後段；沒有逐圖核對影像、讀實作、看影片、下載資料或重跑。以下是原文方法及表格閱讀，不是獨立實驗重現。此前只有候選索引提到此文，未改寫舊閱讀歷史。
- **撤稿檢查**：當日無版本摘要頁只列 v1，未見 withdrawn／retracted 標記；這是擷取當下的狀態。

## 1. 真正缺口：辨識失敗，不代表留下介入時間

既有 detector 可以用表徵、動作一致性或距離產生風險分數，但若訓練正例包含大量失敗後片段，模型可能只是學會認出已落地的錯誤。整條失敗軌跡都貼正標籤，也會混入很早、未必已有因果線索的片段。

本文把問題改成三件事：警報是否在標註的失敗時點之前、低誤報能否同時伴隨可接受的早期檢出率，以及警報是否提供選擇介入的類別。這不同於直接讓大模型重新規劃，也沒有提出完整的安全控制器。

## 2. 任務、輸入輸出與部署迴圈

VLA 每次讀兩個 RGB 視角及自然語言指令，輸出一段控制動作。探針不額外生成候選動作，也不改 backbone；它讀取既有內部特徵：π0.5 的第 18 層（normalization 後），或 GR00T-N1.7 的第 16 層。

每個 policy step 對主相機、腕部相機與非 padding 指令 tokens 分別平均，各得 2,048 維，串成 6,144 維向量。單層 256 hidden-unit LSTM 讀取這些向量的歷史；三個單隱藏層 MLP 各輸出失敗分數、十類失敗分布、語意對齊向量。總參數 6.6M。平均 pooling 是有損壓縮；本文沒有系統性比較不同來源層，不能推稱這是最好的可觀測狀態。

部署可整理為：**VLA 產生 chunk／特徵 → LSTM 更新狀態 → 分數與門檻比較 → 若越界則輸出警報及類別 → 外部流程決定是否暫停、介入、重查 VLA**。探針每次 VLA call 更新，不是每個底層馬達控制 tick 更新。沒有警報也不代表動作經過物理安全驗證。

警報時間定義為

$$
t_{\mathrm{det}}(h)=\min\{t:s_t\ge h\},\qquad
\mathrm{TPR}_{\mathrm{early}}(h)=P(t_{\mathrm{det}}\le t_{\mathrm{fail}}\mid Y=1).
$$

其中 $t$ 是 policy step、$s_t$ 是探針分數、$h$ 是固定門檻；$Y=1$ 表示該 episode 最終失敗，$t_{\mathrm{fail}}$ 是標註的錯誤首次明顯或人類應接管時刻。沒有越界便沒有檢出。這裡容許等號，所以「early」未要求嚴格正的救援提前量；分數用 sigmoid 產生，也未因此被證明是準確的失敗機率。

## 3. 訓練真正改了什麼：不是換大模型，而是正例與損失的時間位置

### 3.1 四種監督的差異

成功軌跡所有步驟都為負例；失敗軌跡另比四種配方：

- **Pre-onset（主方法）**：失敗時刻及以前全部為正例，之後不進 loss。
- **Onset**：僅失敗前的短窗為正例，更早為負例，失敗後排除。
- **Post-onset**：短窗開始至失敗後均為正例，更早為負例。
- **Trajectory**：整條失敗軌跡都為正例，是文中 SAFE 使用的標籤形式。

短窗約 2.4 秒，π0.5 對應 2.5 秒。主方法不是只抓「即將失敗的最後幾步」：它把最初尚可能正常的失敗軌跡前段也貼正。**本筆記判讀**：排除事後捷徑有實驗支持，但這種監督仍預測離線軌跡結果，不等於辨認每一步的可避免危險，也沒有標出某次介入的因果收益。

### 3.2 損失、語意資料與訓練

$$
\mathcal L=\mathcal L_{\mathrm{score}}+
\lambda_m\mathcal L_{\mathrm{mode}}+
\lambda_c\mathcal L_{\mathrm{CLIP}},\qquad \lambda_m=\lambda_c=1.
$$

$\mathcal L_{\mathrm{score}}$ 是未被排除步驟的加權二元交叉熵；$\mathcal L_{\mathrm{mode}}$ 是失敗正例步驟上的類別加權交叉熵；$\mathcal L_{\mathrm{CLIP}}$ 讓第三個 head 對齊該步動作描述。$\lambda_m,\lambda_c$ 是兩個輔助目標的權重，不是風險保證係數。

動作描述每三秒一個短詞組；CLIP 文字 embedding 以僅在訓練集擬合的 PCA 壓至 64 維，再用溫度 0.07 的 InfoNCE 對齊；目標不在訓練詞組集合的步驟不計這一項。推論不需跑 CLIP encoder。Adam learning rate 為 0.0003、batch 為 32 條 rollout、最多 100 epochs，按 validation 的分數 loss early stop，patience 15。這裡訓練的是 probe，不是以這套 loss 微調整個 VLA。

**真正增量**是失敗前監督、模式 head 與共同校準的組合，而非 LSTM 本身的新穎性。消融也沒有支持「加 CLIP 就會更會預警」的強說法。

## 4. 校準承諾到哪裡：可拒絕認證，不替未知分布背書

FPR（false-positive rate）在本文是**一條成功 episode 曾否出現任一警報**的機率，不是每秒誤報率；早期漏報則是失敗 episode 沒有及時被抓到的機率。作者用 Learn-then-Test（LTT）找出同時符合兩個目標的門檻：

$$
P_{D_{\mathrm{cal}}}\!\left(
\forall h\in\widehat\Lambda:\quad
\mathrm{FPR}(h)\le\alpha,\quad
\mathrm{TPR}_{\mathrm{early}}(h)\ge\beta
\right)\ge1-\delta.
$$

$D_{\mathrm{cal}}$ 是校準 episodes、$\widehat\Lambda$ 是通過檢定的門檻集合；$\alpha$ 是可接受誤報上限、$\beta$ 是早期檢出下限、$\delta$ 是校準程序的失敗機率，本文設 0.1。外層機率是對校準資料抽樣而言，**不是每次抓取都有 90% 安全性**；需要測試 episodes 與校準 episodes 可交換。

實作在 181 個 sigmoid 門檻上測試誤報及漏報的精確二項尾機率，取兩者較大的 p-value，配合 40 個起點的 fixed-sequence testing 控制多重選擇；選通過集合中校準早期檢出最高的門檻，空集合便 abstain（拒絕認證）。拒絕認證不是自動安全停止，營運如何回退仍由外部系統決定。

### 4.1 PPV 要知道基準失敗率

$$
\mathrm{PPV}=P(Y=1\mid\mathrm{alarm})
\ge\frac{\pi\beta}{\pi\beta+(1-\pi)\alpha}.
$$

PPV 是收到警報後該 episode 真的失敗的機率；$\pi=P(Y=1)$ 是基準失敗率。這個下界承接前述風險成立的條件，並需可信的 $\pi$ 或其下界。附錄以校準集估計 $\pi$；未知任務會改變失敗盛行率，不能把估計值當永遠有效的常數。**本筆記推論**：介入真的改變結果時，原來無介入 rollout 的 PPV 也不能直接當「介入後仍失敗」的機率。

### 4.2 「86%」不能照摘要讀成共同安全保證

Table 7 分開列 FPR holds 與 TPR holds，且 LTT 百分比的分母只限通過認證的 runs。以 FPR 15%、早期 TPR 15% 為例，只有 **7/14 runs** 通過；未知任務的 FPR holds 為 **86%**、TPR holds 為 **71%**，並未給兩者同時成立的交集比例。因此摘要「up to 86%」不宜翻成「86% 新任務同時受兩個界保護」。

FPR 20%、早期 TPR 35% 時，也只有 7/14 runs 通過；未知任務兩欄分別 71% 與 57%。FPR 10% 時沒有任何 run 通過。這顯示資料和訊號不足會實際阻止認證，不能只報通過後的好數字。

還有**比較口徑**：附錄的 max-conformal（MC）是在新成功 episode 與校準資料可交換時的 marginal false-alarm 控制；LTT 是對固定校準結果取得高機率風險上界，允許棄權。單次有限測試集的 empirical FPR 超標，與 marginal 定理被推翻不是同一件事。不能僅用 holds 比例宣稱所有 conformal 方法「不可靠」。

## 5. 實驗究竟測了什麼

### 5.1 資料與切分

- **模擬**：π0.5 與 GR00T 各 500 條 LIBERO-10／LIBERO-Occ 混合 episodes；GR00T 的 LIBERO-X 218 任務共 2,180 條。合計公開模擬資料為 3,180 episodes。
- **真機另外計**：Kinova Gen3、8 個桌面任務，510 條 demonstrations 微調 GR00T；評估 399 條 rollouts，其中 254 失敗。不要把這 399 條也說成已含在公開 3,180 條裡。
- **標註**：Gemini（gemini-3.5-flash）從影片做粗定位、慢速片段細化到 frame、再寫動作時間線。已讀章節沒有提供系統性人工 onset 誤差／標註者一致性稽核。失敗時點首先是操作性標註，不是由接觸力或不可恢復集合定義的物理真值。
- **泛化軸**：NEW-TASK 留任務但可共享技能／signature；NEW-SIGNATURE 留技能與物件關係組合；NEW-SKILL 整類技能未見。Seen 任務 episodes 按 65/15/10/10 分為 train／validation／calibration／held-out seen。
- **統計限制**：NEW-TASK 與 NEW-SIGNATURE 各三個 seeds 使用相同 unseen 任務，只改 shuffle／初始化；八個 NEW-SKILL folds 才有不同保留技能。14 runs 不是 14 份獨立新場域。真機 8 任務 × 5 seeds 為 40 splits，單次校準成功樣本只有 12–14 條。

### 5.2 指標、baseline 與主表

主指標是早期 TPR 對 FPR 曲線在 FPR 0 至 0.4 區間的面積，再除以 0.4 並以百分數呈現；以下稱「早期面積」。不是完整 AUROC，更不是任務成功率。基線包含 SAFE-LSTM／MLP、STAC、ActProbe、FailureSpot、Mahalanobis／Euclidean／PCA-KMeans。

Table 3／6 的 unseen 早期面積：

- NEW-SKILL：VLA-Tug **39.0 ± 7.0**，SAFE-LSTM **30.1 ± 8.5**。
- NEW-SIGNATURE：**47.0 ± 0.6** 對 **41.2 ± 7.1**。
- NEW-TASK：**40.2 ± 1.2** 對 **40.4 ± 2.3**，沒有全面超越。
- LIBERO-10／GR00T：**47.4 ± 13.5** 對 **51.2 ± 8.4**，VLA-Tug 較低。
- 真機：**25.8 ± 11.6** 對 **25.1 ± 18.8**，差距小且跨 split 變異大，不宣稱顯著。

「最高約 30%」是作者對 NEW-SKILL 相對早期面積改善的說法，不是所有任務提高 30 個百分點、也不是 30% 更多機器人被救回。主表的 VLA-Tug 採 **MC** 校準；§6.2／Table 7 才另測 **LTT**，不能把主表全部結果歸因於共同校準。

比較也非完全原封使用各基線：FailureSpot 由作者按論文重作，SAFE 修改 early stopping 並選 validation checkpoint，基線有 grid 搜尋；真機部分動作型方法因未保存所需 action chunks 而缺列。這些都限制「全面優於現有方法」的外推。

### 5.3 消融與失效反例

Table 9 支持 LIBERO-X 的 pre-onset 優勢：固定其他 heads，NEW-SKILL unseen 從主方法 39.0 變成 trajectory 21.6、onset 25.5、post-onset 17.0。但它不是所有 benchmark 最優；LIBERO-10／π0.5 的 trajectory unseen 52.0 高於主方法 47.9。

移除 modes 與 CLIP 兩個輔助 head，NEW-SKILL unseen 反而到 43.6。作者亦承認輔助目標對 detection 沒有一致收益；模式 head 的價值應另以分類／介入效用評估。Table 8 的模式 accuracy 有小類別合併，且 own-alarm 只評有發警報的失敗 episodes；不是原始十類所有失敗的端到端準確率，不能用它填補漏報。

Table 11 將標註 failure time 往後移 1、2 秒、固定預測與門檻重算：LIBERO-X 優勢仍在，但真機往後 1 秒 SAFE-LSTM 就超過 VLA-Tug。**本筆記判讀**：這是 metric 對時點定義的敏感度，不是模擬真實通訊延遲，也沒有測把 onset 提早時能否保留足夠煞停餘裕。

### 5.4 效率與介入，不可偷換分母

RTX 4090 的 probe scoring median 為每 policy step 0.12 ms，四 CPU threads 約 0.94 ms；GR00T policy call 約 54 ms。LIBERO-X 每 chunk 8 個動作、20 Hz，policy step 為 400 ms；真機 6 個動作、50 Hz，step 為 120 ms。這支持探針本身便宜，不提供系統尾延遲、網路、介入等待或物理停止時間保證。

§6.5／E.3 用錯放時向目的地微移、抓取失敗時側向調整、其他情況重規劃等 heuristic 示範；真機有蘑菇抓取示例。**作者明說 steering 不在本次系統性評估範圍**；圖示的個別成功不能代替跨任務、對照與介入成本統計。論文沒有證明從任意 failure mode 自動合成正確修正，也沒有證明提前警報一定能恢復任務。

## 6. 第一性原理：最小狀態、限制與有效條件

**最小必要狀態**不只是一個當下分數：至少需要特徵歷史／LSTM state、episode 邊界、已校準門檻、資料適用域、首次警報時間及模式。若要把警報接到硬體，還須知道已承諾的 chunk、可撤銷範圍、當下幾何／接觸狀態及介入耗時；後幾項不是此 probe 已建模的內容。

**為何可能有效**：失敗前訊號已存在於 backbone 時，排除失敗後 loss 可減少辨認後果的捷徑；LSTM 把單步模糊線索累積起來；共同校準則排除只會低誤報卻從不抓失敗的門檻。成立條件是訊號在發生前可觀測、標註與部署的失敗定義一致，且 calibration 資料足以支持目標。

**可能失效**：新危險不在表徵內、模型換版、相機改變、未知技能造成失敗分布／基準率漂移，或失敗突然到來而整個 action chunk 已不可撤回。pre-onset 全段正例也可能學到任務難度／episode 身分等先驗，而不是可修正錯誤的前兆；本文沒有用匹配成功／失敗初始狀態的介入實驗排除所有替代解釋。

可複用模型是：**前兆可辨識 → 風險可認證 → 還有時間 → 介入可執行 → 整段任務收益**。每一箭頭都須另有證據；低成本 probe 僅完成其中一些接口。

## 7. 與庫內研究對讀及後續驗證

與 [OopsieRecover](../2026-11-08/01-oopsierecover-修正意圖一致不等於通過安全驗證.md) 對讀：前者問修正意圖如何變成程式，本文問何時值得觸發介入；兩篇沒有共同驗證的整合系統。與 [VLALagBench](../2026-11-05/01-vlalagbench-非同步要分開觀測年齡停頓與請求預算.md) 對讀：probe 夠快不等於控制資訊夠新，也不等於剩餘 chunk 可取消。不改兩篇既有閱讀範圍。

1. **把 early 改成可行介入期限**：依停止／重規劃耗時要求正提前量，固定警報預算，重報完整成功、損害及人工接管；同時測 chunk 取消，而非只往後移標註時點。
2. **檢查資料與語意捷徑**：配對相同任務／初始狀態的成功與失敗，人工稽核 onset，並做新場景、模型換版及獨立校準集測試；同報不認證率、未認證的 fallback 成本及所有 episodes 的模式表現。
3. **把救援價值與辨識率分離**：固定 probe 比隨機介入／固定規則／oracle mode，做有無類別與有無介入的因子對照，分報救回、誤傷與額外秒數；否則無法判斷十類語意是否真的提高淨收益。

---

[當日候選與索引](./README.md)｜[年度索引](../README.md)
