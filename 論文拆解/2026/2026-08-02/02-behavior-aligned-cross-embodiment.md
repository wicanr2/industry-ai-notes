# Cross-Embodiment Transfer via Behavior-Aligned Representations

## 原文資訊
- 論文：Cross-Embodiment Transfer via Behavior-Aligned Representations
- 作者：Ajay Sridhar、Jensen Gao、Jonathan Yang、Jean Mercat、Suneel Belkhale、Dorsa Sadigh
- arXiv ID：2607.27549v1
- 分類：Robotics（cs.RO）、Artificial Intelligence（cs.AI）、Computer Vision（cs.CV）、Machine Learning（cs.LG）
- 發表 / 更新：2026-07-30 / 2026-07-30
- 連結：[abs](https://arxiv.org/abs/2607.27549v1) / [pdf](https://arxiv.org/pdf/2607.27549v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-02

## 為什麼選這篇

跨 embodiment 資料被視為擴大 robot foundation model / VLA 訓練規模的重要來源，但不同機器人的影像外觀、相機位置、關節結構與 action space 不一致，資料放在一起不代表能力自然轉移。這篇沒有只追求更大的混合資料集，而是追問：不同 embodiment 之間是否需要一個較穩定、又與行為相關的中介表示？

作者比較語言動作描述、物體 bounding box、末端執行器軌跡等 behavior-aligned representations。這和「LLM + Robotics」的關聯不只在 VLA 名稱中的 language，而在語言究竟能否成為跨硬體共享行為空間的一部分；同時，摘要稱 end-effector trace 比所比較的語言表示更有效，提醒我們不要把語言普遍化成所有 embodiment 對齊問題的最佳介面。

## 一句話理解

與其硬把不同機器人的 observation 與 action space 對齊，不如用跨硬體較穩定、又能預測行為的中介表示，協助 VLA 從多 embodiment 資料中學到可轉移能力。

## Summary / Abstract 說了什麼

摘要把 behavior-aligned representation 定義成同時具備兩種性質的中介訊號：對 embodiment 的差異較不敏感，且對 robot action 仍有預測力。作者考察的例子包括物體 bounding boxes、language motions 與 end-effector motion traces，並讓 VLA 在預測動作之外也學習這些表示。

作者建立 simulation benchmark 來評估：先用多種 embodiment 的資料預訓練，再以有限資料轉移到新 embodiment。摘要自稱，末端執行器軌跡在所比較的表示中尤其有利；表示的幫助會隨 prior dataset 變大而增加，也可讓 action-free data 對轉移有用。作者另稱，在 sim-to-real cross-embodiment transfer 中，這些表示使真實機器人 policy 的 task completion progress 改善 28%。本次未讀實驗，因此不知道指標定義、變異、基線與失敗分布。

## Introduction 的問題設定

Introduction 從 scale 切入：通用模型通常受益於大型、多樣資料，但 robot data collection 經常綁定特定硬體。若要重用不同平台的資料，cross-embodiment policy 必須處理 observation 與 action space 的巨大差異，並最好能轉移到訓練時尚未出現的新硬體。

作者指出，既有結果並不一致：混合 embodiment 資料有時能改善某些 generalization axis，卻常未顯著優於只用 target embodiment 資料。既有顯式對齊方法可能需要統一相機姿態、重畫 robot 外觀、分割遮罩，或事先知道 deployment robot；這些要求限制規模化。

核心提案是把 alignment 從原始 observation / action space 移到 behavior-aligned representation。語言動作與二維末端軌跡等表示，可能提供一個跨 embodiment 較不變、但仍與動作相關的推理空間。作者因此建立 RoboCasa-X，研究不同表示及其加入 VLA 的方式，並在 Introduction 中預告：end-effector trace 最突出、表示可隨 prior data scale 受益、推論時不一定要輸出該表示，也能使用 action-free data。

## 研究的第一性問題

- **基本問題**：不同機器人的資料，如何在 observation 與 action interface 不同時仍共享可轉移的行為知識？
- **約束**：中介表示必須對 embodiment 差異相對穩定，又不能抽象到失去 action prediction 所需資訊；而且最好能自動抽取，不依賴大量人工對齊。
- **既有方法卡點**：直接混合資料容易讓模型學到 embodiment-specific correlation；顯式統一相機、外觀或 action space 又成本高，且可能要求預先知道目標硬體。
- **作者試圖移動的邊界**：不要求原始輸入輸出完全同構，而是在訓練中建立共享的行為中介層，讓異質資料透過相似的物體與末端運動關係彼此支援。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 系統性研究 behavior-aligned representations 對 VLA cross-embodiment transfer 的影響。
- 建立 RoboCasa-X benchmark，以多 embodiment 預訓練與 limited-data adaptation 評估新 embodiment 轉移。
- end-effector traces 在所比較表示中最有影響力，且表示效益會隨 prior dataset 增大。
- 訓練時的 auxiliary representation 可在推論時不必繼續輸出，並可橋接 action-free data。
- 模擬資料預訓練後的真實機器人 task progress 可因這些表示改善 28%。

### 我的保守判讀

- 這篇最重要的觀點可能是「共享模型」不等於「共享表示」。資料規模只有在模型找到跨 embodiment 的對應關係時，才可能轉化為有效 transfer。
- end-effector trace 的優勢很合理：它比 raw joint action 更跨硬體，又比粗粒度語言保留更多幾何與時序資訊。但它仍可能依賴 camera calibration、segmentation 品質與可比的末端執行器定義。
- 語言若表現較弱，不代表語言對 robot planning 無用；較可能表示自然語言描述的粒度不足以承擔精細動作對齊。語言可負責任務語意，軌跡則負責幾何行為，兩者可能是互補層級。
- 「改善 28%」是 task completion progress，不等同 success rate 增加 28 個百分點。沒有讀指標與誤差條件前，不應放大解讀。
- benchmark 是否涵蓋足夠不同的 morphology、camera setup、controller 與 task family，會決定結論能否超出 kitchen manipulation。

## 可放進資料庫的筆記

1. **跨 embodiment transfer 是 correspondence problem**：真正瓶頸不只在資料量，而在不同硬體資料之間缺乏可學的對應座標。
2. **好的共享表示要同時滿足 invariant 與 predictive**：太 embodiment-specific 無法共享；太抽象又不能支持 action prediction。
3. **語言不是唯一 universal action space**：語言擅長任務與意圖，末端軌跡可能更適合承載連續幾何行為。
4. **中介表示可以只是 training scaffold**：若推論時不必生成，auxiliary prediction 的價值在塑造 backbone，而非增加部署介面。
5. **action-free data 的可用性取決於替代 supervision**：若影像可抽取物體框或運動軌跡，就可能在沒有 robot action label 時仍提供行為結構。
6. **顯式對齊與隱式對齊的成本不同**：前者較可控但需工程規格；後者較可擴展，但把對應品質風險移給抽取器與表示學習。
7. **比較 transfer 要有 target-only baseline**：多來源資料若沒有超過只用目標 embodiment 的政策，就不能只用「訓練資料更大」宣稱成功。
8. **百分比必須連同指標名稱閱讀**：task progress、success rate、relative improvement 與 percentage point 是不同量。

## 後續想追的問題

1. RoboCasa-X 的 embodiment 差異包含哪些 morphology、相機、action space 與 controller 變化？
2. language motions、bounding boxes、2D traces 與其他表示如何抽取，抽取錯誤是否會成為新的 domain gap？
3. 28% task-progress 改善的基準值、統計變異、任務數與真實機器人 failure mode 是什麼？
4. end-effector trace 對沒有清楚「末端」定義的移動、人形或多接觸 embodiment 是否仍成立？
5. 多種表示是否互補；例如語言處理任務層級、trace 處理運動層級，能否比單一表示更穩定？
