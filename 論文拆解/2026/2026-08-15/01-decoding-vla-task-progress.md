# Decoding Task Progress from VLA Representations

## 原文資訊

- 論文：Decoding Task Progress from VLA Representations
- 作者：Atiksh Bhardwaj、Edward Weiyi Duan、Prithwish Dan、Wei-Chiu Ma、Preston Culbertson
- arXiv ID：2608.13474v1
- 分類：cs.RO
- 發表 / 更新：2026-08-13 / 2026-08-13
- 連結：[abs](https://arxiv.org/abs/2608.13474v1) / [pdf](https://arxiv.org/pdf/2608.13474v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-15

## 為什麼選這篇

VLA（Vision-Language-Action）開始從「能不能完成任務」走向「部署時能不能看懂它正在發生什麼」。這篇把 LLM/VLM 的機制可解釋性工具帶進機器人控制：不另外訓練大型監控模型，而是問 VLA 內部是否已經形成可讀取的「任務進度」訊號。

它的價值不只在一個 probe。Introduction 明確區分「讀得到某特徵」與「能用該特徵改變模型行為」；這能防止把相關性誤說成控制機制。對 Physical AI 而言，內部狀態若能成為低成本 runtime telemetry，可能比事後只看成功率更接近實際部署需求。

## 一句話理解

作者想確認：VLA 在執行操作時，內部是否已編碼「離任務完成還有多遠」，以及這個訊號能否用來監測失速或分布外狀態。

## Summary / Abstract 說了什麼

論文以 $\pi_{0.5}$ 的 residual stream（Transformer 各層持續傳遞與更新的隱藏表示）為觀察對象，嘗試用線性 probe 解碼任務進度。可把 probe 簡寫為：

$$
\hat{p}=\varphi(\mathbf{z})=\mathbf{w}^{\top}\mathbf{z}+b,
$$

其中 $\mathbf{z}$ 是某層內部表示，$\mathbf{w}$ 與 $b$ 是 probe 學到的線性參數，$\hat{p}$ 是預測進度。本文把 progress 定義為軌跡剩餘時間的正規化比例；直觀上，它是一個描述「距離結束尚有多少」的標量，而不是完整的世界狀態。

**論文自稱：**此訊號可從 activation 線性讀出，而且在尚未用機器人資料訓練前的 PaliGemma backbone 中就已出現。單一 probe 可泛化到未見任務；以多種 prompt 訓練後，語言反事實改動也會使訊號跟著變化。但把 probe 方向注入模型，並不能形成有意義的 policy steering。

摘要也自稱，這個 probe 可作為無需失敗標籤的 OOD（out-of-distribution，分布外）偵測器，用「進度停滯」辨識異常，表現可與既有方法競爭。這些都是摘要中的結果宣稱，本次未讀實驗章節，未獨立核對評估設計與數值。

## Introduction 的問題設定

Introduction 從部署落差開始：VLA 借用預訓練 VLM 的語意與視覺先驗，但針對新機器人或新任務 fine-tune 後，可能降低語言敏感度、對感知擾動變脆弱，甚至在訓練場景假設被改動時失效。現有研究已記錄 failure，卻還缺少可在執行期間觀察內部狀態的基本儀表。

作者認為，VLM/LLM 已成熟的 representation probing 可自然移植到 VLA；不過既有工作多問模型「知道世界中的什麼」，較少問它「相對於任務終點走到哪裡」。任務進度是 scalar、task-conditional 且與序列行為直接相關，因此是一個較適合 runtime monitoring 的候選量。

核心假設是：VLA 已經同時讀取視覺與語言，動作也必然隨任務階段變化，所以進度資訊可能已存在 policy 的表示裡，不必再外掛一個完整估計模型。作者進一步把問題拆成 weak decodability、strong decodability 與 steerability，避免把線性相關、對正確輸入的依賴，以及對輸出的因果控制混為一談。

## 研究的第一性問題

- **基本問題：**一個直接控制機器人的多模態模型，內部是否有足夠穩定的任務狀態訊號可供外部讀取？
- **約束：**監控器應輕量、能跨任務，且不能只記住時間索引或單一 prompt 的表面規律。
- **既有方法卡點：**外部 VLM 進度估計器增加另一套模型與校準成本；只看最終成功率又無法在執行中提早暴露失速。
- **作者試圖移動的邊界：**把 VLA 從黑箱 policy 變成可插入簡單 telemetry 的 policy，同時明確承認「可觀察」不等於「可控制」。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 定義 generative model 中 weak decodability、strong decodability 與 steerability 的差異。
- 顯示 $\pi_{0.5}$ 的 task progress 可線性解碼，且會對語言反事實產生合理變化。
- 顯示相同方向不能有效 steering，為 observability 與 controllability 畫出界線。
- 把 progress probe 用作 label-free OOD detector，並宣稱具有跨任務、跨擾動泛化能力。

### 我的保守判讀

- 「線性可讀」是一個好診斷訊號，但仍不代表模型具有可組合、可因果操作的顯式進度概念。
- progress 以正規化剩餘時間表示，可能混合真正的語意階段、動作節奏與資料蒐集慣例；是否能跨不同速度、停頓與恢復流程，需讀實驗才能判斷。
- 不能 steering 反而是重要的負面邊界：probe 可能只讀到伴隨變數，或注入方式沒有對準模型實際控制機制。
- 摘要中的 OOD 競爭力尚不能直接等同工業安全監測；真實部署還要面對感測漂移、長尾故障與誤報成本。

## 可放進資料庫的筆記

1. **可解碼不等於可控制：**representation probe 回答「訊號在哪裡」，不自動回答「模型靠它做決策」。
2. **部署需要過程指標：**成功率是 episode 結束後的結果；progress、confidence、constraint margin 才可能形成 runtime telemetry。
3. **內部訊號可減少外掛模型：**若 policy 已編碼某個語意量，先測試簡單讀出器，再決定是否增建昂貴監控網路。
4. **反事實是 probe 的必要檢查：**改變語言任務但維持相似影像，可測試 probe 是否真的 task-conditional。
5. **時間代理變數風險：**任何「進度」研究都要排除固定軌跡長度、動作頻率與資料切片造成的捷徑。
6. **VLA 可解釋性的實用入口：**不必先追求完整因果電路；能跨任務偵測停滯的簡單儀表，也可能先產生部署價值。
7. **pretraining 與 robot fine-tuning 要分層檢查：**若訊號在 VLM backbone 已存在，後訓練可能是在保留、扭曲或重新利用它。

## 後續想追的問題

1. 訓練與測試軌跡如何排除「剩餘影格數」或固定任務長度的捷徑？
2. weak / strong decodability 的操作定義、對照組與統計門檻為何？
3. OOD 類型是否涵蓋真實硬體故障、物體位姿偏差與恢復行為，而不只是合成擾動？
4. steering 失敗是特徵非因果、注入層錯誤，還是 action head 抵消了 backbone 變化？
5. 這個進度訊號能否和安全 monitor、人工接管門檻或 recovery policy 形成閉迴路？
