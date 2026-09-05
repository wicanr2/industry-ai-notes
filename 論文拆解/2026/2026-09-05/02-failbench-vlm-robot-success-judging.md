# FailBench: How Reliable are VLMs at Judging Robot Task Success?

## 原文資訊
- 論文：FailBench: How Reliable are VLMs at Judging Robot Task Success?
- 作者：Zaruhi Navasardyan、Tatul Danielyan、Hrant Davtyan
- arXiv ID：2609.03611v1
- 分類：cs.RO、cs.AI
- 發表 / 更新：2026-09-03 / 2026-09-03（v1）
- 連結：[abs](https://arxiv.org/abs/2609.03611v1) / [pdf](https://arxiv.org/pdf/2609.03611v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Methods、Experiments、Results 與附錄
- 擷取日期：2026-09-05

## 為什麼選這篇

機器人學習一次會產生大量 rollouts，人工逐段判斷成功或失敗很昂貴，因此 VLM 開始被拿來當 evaluator、資料過濾器、reward 或 recovery signal。真正危險之處不是單一分類錯誤，而是錯誤標籤會進入下一輪訓練與評估，形成「模型替模型製造 ground truth」的閉環。

FailBench 值得收錄，因為它沒有只比較某一套 failure detector 在自己的資料上表現，而是把問題改成跨來源泛化，並進一步問：成功判定需要什麼視覺證據？摘要與 Introduction 對比了可由物體位移辨認的結果，以及必須看清是否真正接觸／插入的 assembly 結果。這讓 benchmark 不只是排行榜，而是在定位 VLM 作為 Physical AI judge 的感知邊界。

## 一句話理解

FailBench 檢查 VLM 能否跨資料來源可靠判斷機器人執行成敗，並指出「看見物體動了」與「確認物理接觸成立」是兩種難度不同的證據問題。

## Summary / Abstract 說了什麼

FailBench 收集 2,197 次 robot manipulation attempts，來自 14 個公開來源，其中 12 個是真實世界、2 個是模擬；每筆資料包含指令、視覺觀察與二元結果。摘要表示 75% 的 failures 是自然發生，六個真實來源原本也不是為 failure detection 建立，意在減少只辨認人工失敗生成程序的捷徑。

作者評估 13 個 VLM-based detectors。摘要自稱最佳模型的 mean balanced accuracy 只有 0.77；failure-detection fine-tuned models 反而持續落後 general-purpose VLMs 與各自 pretrained baselines。當結果可由明顯物體移動判斷時，模型接近飽和；接觸密集的 assembly tasks 則接近隨機，balanced accuracy 低於 0.60，且模糊證據下有偏向預測成功的傾向。

Balanced accuracy 用來平均看待正、負類別的辨識能力：

$$
\text{BA}=\frac{1}{2}\left(\frac{TP}{TP+FN}+\frac{TN}{TN+FP}\right)
$$

其中 $TP/(TP+FN)$ 是成功類別的召回率，$TN/(TN+FP)$ 是失敗類別的召回率。若兩類都接近亂猜，BA 約為 0.5；因此「低於 0.60」表示 contact-rich 判斷只略高於 chance，而不是可直接當可靠 reward。

摘要另稱，先定位並裁切 outcome-relevant region，可在不額外訓練下讓最佳 detector 增加 2.4 個百分點。Introduction 寫的是 +2.3 points，兩處有 0.1-point 的文字差異；本筆記保留此 provenance 差異，不自行選定哪一個才是最終數字。

## Introduction 的問題設定

Introduction 從運作鏈切入：VLM 的成敗判斷可能被當成 evaluation label、data filter、reward 或 recovery signal，實務上常被視為 ground truth，但跨資料來源可靠性仍不清楚。

作者區分兩類 detector。**Policy-dependent monitor** 讀取政策內部表示、action statistics 或 predicted trajectories，資訊較貼近政策，但綁定特定架構；**policy-agnostic detector** 只看完成後的錄影與指令，原則上可跨政策與 robot platform 使用，但 transfer failure 會直接變成 noisy reward、錯誤評估或保留下來的失敗資料。

既有 benchmark 多來自單一 collection effort，也常刻意製造失敗，例如擾動成功軌跡或替未變動影片換一條不相符指令。這有助受控測試，卻可能讓 detector 學會辨識資料生成程序，而非真實世界中不明顯的失敗，例如 peg 差一點才插入、gripper 看似閉合卻沒有建立接觸、物件過早被放開。

FailBench 把範圍刻意限縮在 **execution failures**：動作執行後沒有產生預期結果，而且可從錄影判斷。它不涵蓋執行前意圖就不合理的 planning failures，也不評估中途 progress。這個限制反而讓共同問題較清楚：給定指令與視覺記錄，任務究竟有沒有成功？

## 研究的第一性問題

- **基本問題**：當自動 evaluator 成為訓練閉環的一部分時，它是否真的看得到決定成敗的物理證據？
- **約束**：資料來自不同相機、robot、任務與 failure distribution；二元標籤會壓縮過程資訊；接觸狀態可能只佔少數 pixels 或根本被遮擋。
- **既有方法卡點**：同來源測試容易高估泛化；人工合成 failures 可能引入捷徑；更多 reasoning 不能補回輸入中缺失或未定位的證據。
- **作者試圖移動的邊界**：從「哪個 VLM 分數最高」移到「哪些 outcome evidence 可被 VLM 可靠辨識、哪些仍接近 chance」。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 建立含 2,197 次執行、14 個來源的共通 benchmark schema，涵蓋 policy rollout、human teleoperation、constructed failures，以及單／多視角觀察。
- 按各 detector 原本設定進行 13 個模型的 cross-source evaluation。
- 將錯誤連到 outcome 所需證據，特別是 coarse object motion 與 physical contact 的差異。
- 提出 evidence-localization cropping，不重訓也能改善最佳 detector。

### 我的保守判讀

- 這篇最有價值的可能不是 0.77，而是把 evaluator error 拆成 **資料來源轉移** 與 **證據可觀測性**。前者可透過資料設計改善，後者可能需要觸覺、力覺、音訊或更好的相機，而非更大 VLM。
- Specialist 落後 base model 是重要警訊，但 Introduction 尚不足以排除 prompt、input sampling、resolution、fine-tuning data size 或 domain imbalance 的影響。
- 原始提供者標籤被當成參考答案；不同資料集對「成功」的操作定義是否一致，仍需讀 methods 與 annotation protocol。
- Cropping 的改善幅度有限，而且摘要／Introduction 的數字略有差異。它支持「先找證據」的方向，不足以證明 localization 已解決 contact reasoning。
- Benchmark 不處理 planning failure 與 intermediate progress，所以不能直接代表完整 robot evaluator 的可靠度。

## 可放進資料庫的筆記

1. **Evaluator 不是旁觀者。** 一旦判斷被當成 reward、filter 或 recovery trigger，它就是控制與資料閉環的一部分。
2. **跨來源測試是 robot judge 的最低門檻。** 同資料源高分可能只是辨認相機、任務或失敗生成方式。
3. **把「看懂任務」與「看見證據」分開。** 語義理解強，不代表能從 pixels 確認接觸、受力或插入深度。
4. **更多推理不能補回不可觀測資訊。** 若關鍵區域太小、被遮擋或缺少模態，延長 chain-of-thought 未必有用。
5. **先做 evidence localization，再做 outcome reasoning。** 感知介面設計可能比盲目擴大 judge 更有效。
6. **二元 success label 會隱藏失敗機制。** 部署時可能還需要 confidence、failure type 與可觀測性標記。
7. **安全相關指標要看失敗類別召回。** 即使 balanced accuracy 尚可，偏向 success 的錯誤仍可能讓危險失敗通過。
8. **Benchmark scope 要保持誠實。** Execution success、planning correctness 與 progress estimation 是不同問題。

## 後續想追的問題

1. 十四個來源的標籤定義與品質如何校準？是否有跨標註者一致性檢查？
2. 模型偏向 success 時，failure recall、false-success rate 與 calibration 各是多少？
3. 單視角與多視角差多少？加入 force／tactile／audio 後，contact-rich assembly 是否仍接近 chance？
4. Specialist 低於 base model 的主要原因是 catastrophic forgetting、資料捷徑、prompt mismatch，還是訓練資料太窄？
5. Evidence-localization pipeline 依賴什麼定位器；若定位器失敗，是否會讓 judge 更有自信地判錯？
