# Depth-Wise Probing and Pruning of the Planning Token in a Driving Vision-Language-Action Model

## 原文資訊
- 論文：Depth-Wise Probing and Pruning of the Planning Token in a Driving Vision-Language-Action Model
- 作者：Harisankar Babu、Benjamin Coors、Christopher Lang、Hendrik Berkemeyer、Tamim Asfour、Simon Foell
- arXiv ID：2608.07361v1
- 分類：cs.RO、cs.CV
- 發表 / 更新：2026-08-07 / 2026-08-07（v1）
- 連結：[abs](https://arxiv.org/abs/2608.07361v1) / [pdf](https://arxiv.org/pdf/2608.07361v1)
- 本次閱讀範圍：Summary/Abstract + Introduction；未讀 Related Work、方法、實驗、結果與討論等其他章節
- 擷取日期：2026-08-11

## 為什麼選這篇

這篇位在 LLM 與 Physical AI 的直接交界：大型語言模型不只產生文字，而是置於駕駛 VLA 的決策路徑中，最後必須把內部表示交給軌跡規劃器。它問的不是「模型能不能開車」這類過大的問題，而是更可操作的系統問題：真正與動作相關的資訊在第幾層出現？深層網路都不可或缺，還是有些層只是在把資訊轉成下游規劃器熟悉的格式？

這個切入點有獨立價值，因為 Physical AI 的部署瓶頸不只是能力，也包括閉迴路延遲。若能區分「資訊已存在」與「表示已能被既有 action head 使用」，模型壓縮就不必只看通用語言指標，而能直接對齊控制介面。不過，本次沒有讀實驗章節，摘要列出的數字只能記為作者自稱，不能視為已核驗結論。

## 一句話理解

作者沿著駕駛 VLA 的 32 層解碼器追蹤單一 planning token，試圖分清導航意圖何時已可讀出、何時才轉成原生規劃器可用的軌跡表示，並據此探索剪層。

## Summary / Abstract 說了什麼

研究對象是一種把完整計畫壓入單一 planning token，再由生成式規劃器解碼成軌跡的駕駛 VLA。作者從每一層取出 token，使用兩個訊號觀察深度演化：線性分類器能否讀出導航命令，以及凍結的原生規劃器能否把該層表示解碼成相容軌跡。

摘要自稱，導航語意在第一個解碼層後便能以 97.7% 準確率線性讀出，相對的隨機水準是 16.7%；但與原生規劃器的相容性仍隨深度逐步改善，open-loop Avg-L2 到最後一層才達最低 2.11 公尺。作者另稱，替第一層訓練新的 readout 可補回不少差距，因此早期層可能已含規劃資訊，只是格式尚未對齊既有規劃器。

摘要也自稱，以 planning token 的角度偏移替各層排序後，可移除 32 層中的 8 層，把相對 open-loop 誤差增幅控制在約 5%，並量得 1.33 倍 decoder 加速。摘要同時主動收斂外推：結論只涵蓋所評估的 ORION checkpoint 與 Bench2Drive 設定；在該樣本量下，也沒有解析出特定能力類別的顯著退化。

## Introduction 的問題設定

Introduction 先把端到端駕駛架構描述為「感知輸出轉成 token → transformer 推理 → action head 產生軌跡」。作者認為，大模型深度雖可能有助於稀有或非結構場景，但也帶來安全關鍵控制器難以承受的延遲。現有加速或蒸餾屬於事後處理；更基本的問題是，任務相關計算究竟如何分布在網路深度中。

論文利用 ORION 類架構中的單一 planning token，把這個問題縮成一個可觀察介面。令第 \(l\) 層的 planning token 為 \(h_l\)，原生且凍結的軌跡規劃器為 \(g\)，則作者觀察 \(g(h_l)\) 隨層數的變化。白話來說，不是只問中間層「藏了什麼」，而是直接把每層表示交給已部署的下游模組，看看它能不能立即使用。這被作者稱為 trajectory-space logit lens。

同時，作者另以線性 probe 讀取離散導航意圖。兩條曲線若分離，就表示「資訊能被新訓練的簡單讀出器取得」不等於「資訊已符合原生規劃器的輸入格式」。Introduction 宣稱觀察到的正是這種分離：意圖很早出現，planner compatibility 則逐層成熟。

剪層部分的直覺也從 token 介面出發。若一層前後 token 分別為 \(h_l\) 與 \(h_{l+1}\)，角度變化可概念化為

\[
\Delta_l = \arccos\!\left(\frac{h_l^\top h_{l+1}}{\lVert h_l\rVert\,\lVert h_{l+1}\rVert}\right).
\]

\(\Delta_l\) 越小，代表該層對 planning token 方向的改變越小；作者據此測試它是否較可能被移除。這只是 pruning heuristic，不等於小角度就證明該層沒有其他作用。

## 研究的第一性問題

- **基本問題**：VLA 的控制決策資訊，是在網路深層才生成，還是早已存在、只是在後續逐步轉換成 action head 可用的表示？
- **約束**：駕駛控制需要低延遲；剪層不能只保住語言能力，也要保住軌跡品質與各情境能力。
- **既有方法卡點**：一般 probe 衡量「可以被訓練出的讀出器解碼」，未必反映部署中的原生規劃器能否直接使用；只看個別中間層輸出品質，也未必能判斷整層移除後的連鎖影響。
- **作者試圖移動的邊界**：把可解碼性、介面相容性與實際剪層分開量測，讓 VLA 壓縮從通用模型指標往 action-space 診斷靠近。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出以凍結原生規劃器讀取各層 planning token 的 trajectory-space native-head lens。
- 同時用線性 probe 與軌跡解碼，區分早期語意資訊與後期 planner compatibility。
- 在五類 Bench2Drive 能力上觀察相似的相容性演化。
- 以 token 角度變化做剪層排序，得到 8/32 層可移除與 1.33 倍加速的結果。

### 我的保守判讀

- 最重要的概念不是某個加速倍數，而是「presence 與 usability 不同」：representation 裡已有訊息，不代表既有控制頭能使用。
- 單一 planning token 讓診斷很乾淨，但也可能是特定架構的優點；多 token、跨層連接或不同 action decoder 未必有相同現象。
- open-loop 軌跡誤差與真實閉迴路安全之間仍有距離。本次未讀後續章節，無法判斷剪層在 closed-loop、長尾事件或時序穩定性上的代價。
- 線性 probe 高準確率不等於該資訊在因果上驅動動作；它可能只是可讀出的相關訊號。
- 作者已把外推限制在單一 checkpoint 與 benchmark，這個邊界應保留，不能把「8 層可剪」泛化成所有 VLA 的固定比例。

## 可放進資料庫的筆記

1. **資訊存在不等於介面可用**：probe 可讀出的是 representational availability；原生 action head 能用的是 interface compatibility。
2. **對 Physical AI 做 mechanistic analysis 時，最好在 action space 驗證**，而不是只在 token 或分類空間描述內部表示。
3. **單點瓶頸介面有利於診斷**：若整個計畫必須通過一個 token，就能比較清楚地追蹤深度演化；代價是結論可能較架構特定。
4. **剪層排序與逐層讀出是不同問題**：某層單獨解碼得差，不代表移除它對最終計算的影響最大。
5. **延遲—誤差 frontier 比單一加速數字更重要**：部署決策需要知道不同剪枝強度的連續交換關係。
6. **open-loop 指標是前置篩選，不是安全證明**：駕駛模型最終仍要看閉迴路、長尾場景與控制穩定性。
7. **跨能力類別沒有顯著差異，不等於差異不存在**：樣本量與統計檢定力會限制可見度。

## 後續想追的問題

1. 8 層剪枝在 closed-loop Bench2Drive 或實車條件下，是否仍維持相同誤差—延遲交換？
2. 線性 probe 的導航意圖對最終軌跡是否具有因果影響，還是只是伴隨訊號？
3. 角度變化 criterion 與其他 pruning 指標相比，在不同 checkpoint 是否穩定？
4. 新 readout 能補回第一層多少差距，其額外計算成本與校準需求為何？
5. 這套診斷能否延伸到多 planning token、擴散式 action head 或操作型 VLA？
