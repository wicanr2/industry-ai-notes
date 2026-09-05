# WISE: World-model-guided Imagination Scheduling for Efficient Post-training of Vision-Language-Action Models

## 原文資訊
- 論文：WISE: World-model-guided Imagination Scheduling for Efficient Post-training of Vision-Language-Action Models
- 作者：Chenhao Zhang、Hanyu Zhao、Hang Cheng、Tengfei Pan、Long Zeng
- arXiv ID：2609.03681v1
- 分類：cs.RO
- 發表 / 更新：2026-09-03 / 2026-09-03（v1）
- 連結：[abs](https://arxiv.org/abs/2609.03681v1) / [pdf](https://arxiv.org/pdf/2609.03681v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Methods、Experiments、Results 與附錄
- 擷取日期：2026-09-05

## 為什麼選這篇

VLA 的後訓練常被寫成「再收更多示範」或「讓機器人在真實環境繼續試錯」，但這兩條路都把昂貴的實體互動當成主要燃料。WISE 改問一個更接近系統設計的問題：既然 world model 可以先預演候選動作，是否應該把想像算力集中在真正會影響成敗的互動狀態，而不是整段軌跡平均使用？

這篇值得收錄，不只因為它把 world model 接到 VLA post-training，而是因為 Introduction 清楚指出三個彼此耦合的決策：**何時想像、往後想多遠、如何把相對結果轉成可信的學習訊號**。這比「world model 預測得更像」更接近 Physical AI 的部署約束：算力有限、長 rollout 會累積誤差、真機探索又有碰撞與磨耗成本。

## 一句話理解

WISE 想把 world-model imagination 從全程大量生成，改成在互動關鍵點做有界的候選未來比較，再用比較結果改進真實情境中的 VLA 動作。

## Summary / Abstract 說了什麼

摘要把 VLA 後訓練的兩種主要成本放在一起：監督式微調需要昂貴的專家示範，強化學習則可能需要昂貴且不穩定的真實探索。World model 能先評估候選行為，但它的價值取決於使用位置與可靠範圍，並非 rollout 越長、次數越多就越好。

WISE 的摘要級流程是：在與互動相關的狀態才啟動想像；從 VLA 產生多個候選 action chunks；由 action-conditioned、multi-view world model 做有界 rollout；再以進度與完成訊號評估候選未來，使用相對優劣回饋政策。這裡的 **action chunk** 可理解為一次產生的一小段連續動作，而不是每一步都重新決策。

**論文自稱**：在 $\pi_0$ 與 $\pi_{0.5}$ 上，WISE 對多種 manipulation tasks 有一致改善；相較 full imagination，GPU 計算時間約降低 80%，真實環境測試也呈現更好的 robustness 與 distribution-shift generalization。這些都是摘要中的結果宣稱，本次未讀實驗章節，不能判斷比較設定、統計穩健性或 80% 的計算邊界。

## Introduction 的問題設定

Introduction 先把 VLA 定位成整合視覺、語言與動作生成的通用操作基礎模型，再指出 pretrained policy 仍需適應特定環境與互動模式。模仿學習的瓶頸是高品質機器人示範；真實世界 RL 的瓶頸則是互動成本，以及碰撞、硬體磨耗或損壞風險。

作者接著把 world model 的限制由「預測準不準」擴成「如何分配想像」。粗略移動階段可能已是 pretrained VLA 的強項，接觸或操作轉折點才更需要預測性比較；但把 imagined rollout 拉長，又會疊加模型誤差。因此核心缺口不是缺少更多 imagined futures，而是缺少一個 imagination scheduler。

Introduction 所描述的 WISE 在互動相關狀態產生多個候選 action chunks，以多視角 world model 預測短期後果，再由 reward model 評估 progress 與 completion。作者特別說明，多步想像用於 **counterfactual evaluation**，不是把合成 state-action pairs 直接當成監督資料；政策仍從真實互動 context 中產生與修正動作。這是在降低 model bias 直接污染政策資料的風險。

## 研究的第一性問題

- **基本問題**：如何用不完美的 world model 改進 VLA，同時少收示範、少做危險的真機探索？
- **約束**：world-model inference 有計算成本；長期預測會累積誤差；不同任務階段的想像價值不相等；評分模型本身也可能出錯。
- **既有方法卡點**：若整段軌跡全面 rollout，會把算力花在低資訊狀態；若把 imagined trajectory 直接當訓練資料，預測偏差可能變成政策偏差。
- **作者試圖移動的邊界**：從「用不用 world model」移到「只在何處、何種 horizon、以何種監督介面使用 world model」。

可把作者的直覺寫成一個概念性資源配置問題：

$$
\max_{\mathcal{S}, H}\; \text{policy gain}(\mathcal{S},H)-\lambda\,\text{compute}(\mathcal{S},H)-\mu\,\text{model error}(H)
$$

其中 $\mathcal{S}$ 是啟動想像的狀態集合，$H$ 是預測 horizon，$\lambda$ 與 $\mu$ 分別代表算力與模型誤差的代價。這不是論文在 Introduction 給出的正式目標式，而是我對其第一性取捨的概念化整理。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出一個協調關鍵狀態選擇、有界未來預測、軌跡評估與真實 context 政策更新的整合框架。
- 用候選未來的相對結果提供 group-relative policy optimization 訊號，而非直接模仿 imagined state-action pairs。
- 在兩個 VLA backbone、模擬與真實操作情境中改善表現，並顯著減少 world-model 計算。

### 我的保守判讀

- 最重要的可重用觀念是 **imagination allocation**，不一定是 WISE 的特定模組。若瓶頸是接觸感知或 reward model 無法辨別成敗，選擇性 rollout 仍可能只是更有效率地使用錯誤訊號。
- 「互動相關狀態」如何被辨認，是整個系統的閘門；若偵測晚了或漏掉關鍵狀態，節省算力可能以漏失修正機會為代價。
- 相對評分能降低對絕對 reward calibration 的需求，但不能自動消除 world model 在所有候選上共同犯錯的問題。
- 摘要宣稱的約 80% 節省需要知道比較的是 inference calls、GPU time、端到端 wall-clock，還是只計 world-model 部分；本次閱讀範圍不足以確認。

## 可放進資料庫的筆記

1. **想像不是免費資料，而是一種要排程的感測／計算資源。**
2. **Physical AI 的後訓練介面可分三層：選狀態、限 horizon、轉監督。** 三層任何一層失真都會影響政策。
3. **長 horizon 不等於高價值。** 預測長度增加資訊，也同步增加 compound error。
4. **關鍵點密集、其餘時間稀疏。** 操作任務中的學習價值可能集中在接近、接觸、釋放與失敗前兆，而不是均勻分布。
5. **比較候選可能比相信絕對分數容易。** 但前提是 model error 不會讓候選排序一起翻轉。
6. **合成未來用來批判真實動作，未必要直接取代真實資料。** 這是一種較保守的 world-model 使用方式。
7. **節省真機互動不等於零真機成本。** 真實 context、狀態閘門與分布轉移仍須被持續校準。

## 後續想追的問題

1. Interaction-relevant states 的選擇器用什麼訊號訓練？漏報與誤報各自造成多大代價？
2. Bounded rollout 的 horizon 如何設定，是否依任務、狀態或不確定性動態改變？
3. Progress／completion reward model 在接觸密集、遮擋或多視角不一致時是否可靠？
4. 約 80% 計算節省的完整分母與硬體設定為何？端到端 latency 是否同步下降？
5. 候選未來若受到同一 world-model bias 影響，group-relative 更新是否會放大共同誤差？
