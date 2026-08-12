# JEPA-WAM: Learning Vision-Language-Action Policies with Joint-Embedding World Modeling

## 原文資訊

- 論文：JEPA-WAM: Learning Vision-Language-Action Policies with Joint-Embedding World Modeling
- 作者：Yihan Lin、Jiawei He、Shifeng Bao、Chen Zhao、Yang Li、Xiaobo Wang、Yan Wang、Cheng Chi、Jing Zhang
- arXiv ID：2608.09381v1
- 分類：Robotics（cs.RO）
- 發表 / 更新：2026-08-10 / 2026-08-10（v1）
- 連結：[abs](https://arxiv.org/abs/2608.09381v1) / [pdf](https://arxiv.org/pdf/2608.09381v1)
- 本次閱讀範圍：Summary/Abstract + Introduction；未讀 Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-12

## 為什麼選這篇

這篇位於 VLA 與 world model 的直接交會。它問的不是如何生成看起來合理的未來影片，而是：若目標是讓機器人動作對分布偏移更穩健，是否能只在 latent space 學到足夠細緻的狀態轉移，訓練時影響 action backbone，部署時又不支付反覆生成未來影格的成本？

JEPA-WAM 值得與其他世界動作模型一起追蹤，因為它把設計焦點拆成兩個容易被混在一起的問題：該預測什麼表徵，以及預測監督如何真正進入動作生成。這比單純加一個 future prediction auxiliary loss 更具可重用性，也反映 Physical AI 的核心取捨：世界模型不只要「懂未來」，還要在空間細節、控制關聯與部署成本之間取得平衡。

## 一句話理解

JEPA-WAM 用密集的當前—未來聯合表徵教 VLA backbone 理解狀態轉移，但在部署時移除預測支線，只保留被這項監督塑形過的動作策略。

## Summary / Abstract 說了什麼

摘要主張，VLA 的 action objective 通常只隱式學習狀態轉移；影片生成式 world action model 雖會明確建模未來，部署時計算成本卻高。既有 latent WAM 較省成本，但可能把未來壓縮得太小，或讓 transition prediction 與 action representation 分離，因而削弱細粒度空間資訊或對策略 backbone 的影響。

JEPA-WAM 建立在預訓練 V-JEPA 空間中，以共享 predictor 同時承接 latent transition prediction 與連續動作生成。其 target 不是單獨編碼某個絕對未來狀態，而是聯合編碼 current / future observations，以 patch-level 結構表達穩定區域、變化區域及局部物體關係。摘要自稱，在 LIBERO-Plus 上，未使用大規模 robot-policy pretraining 的版本達 79.2%；套入預訓練 $\pi_{0.5}$ 的版本達 86.3%，並在 RoboTwin 2.0 與真實雙臂操作中展現視覺、空間偏移下的泛化。

## Introduction 的問題設定

Introduction 將 latent WAM 的缺口拆成兩題。

第一題是 **預測 target 的內容**。若沿用影片生成器中間特徵，該特徵原本為反覆生成未來影格最佳化，不一定直接表達狀態變化；若把未來壓成少量 token 或 subgoal，又可能丟失 manipulation 所需的細粒度空間對應。JEPA-WAM 因而在 V-JEPA 2.1 表徵空間聯合編碼當前與未來觀測，使 target 表達兩者的時間關係，而非重建唯一未來影像，並保留 dense patch-level structure。

第二題是 **預測監督如何進入 action generation**。把預測未來當作額外 action context，可能帶來重複資訊；另設 latent dynamics module 或 auxiliary objective，則可能只微弱影響真正產生 action conditioning 的 representation。作者讓 transition modeling 與 action generation 共用 predictor，使 transition supervision 直接塑造同一 backbone，同時抽取專門表徵供動作生成使用。

一個實務上重要的安排是：latent transition prediction 在訓練時存在，部署時會移除，只留下 action generation。因此論文的提案更接近「以世界建模作為 representation-learning supervision」，而不是讓 controller 在線上每一步都先 rollout latent future。

## 研究的第一性問題

- **基本問題**：如何讓 action policy 明確學到「執行動作後世界如何改變」，又不在部署時承擔影片生成成本？
- **約束**：操作需要細緻空間關係；未來具有多解；predictive objective 必須實際影響控制表徵；部署延遲不能過高。
- **既有方法卡點**：生成式 WAM 成本高；壓縮 latent target 可能丟失 patch-level 資訊；獨立預測模組可能與 action backbone 鬆耦合。
- **作者試圖移動的邊界**：把世界模型從「部署時生成未來」改為「訓練時以結構化 transition target 塑造策略」，並把額外推理成本留在訓練階段。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 在 V-JEPA 空間建立 latent WAM，以共享 predictor 耦合 transition prediction 與 continuous action generation。
- 使用具空間結構的 current–future joint target，保留 dense patch-level information。
- 同一 target formulation 可加入預訓練 VLA，且不改掉原本 perception / action pathways。
- 摘要與 Introduction 報告 LIBERO-Plus、RoboTwin 2.0 與真實操作下的泛化成果。

### 我的保守判讀

- 這個架構最清楚的思想是：若世界模型的功能主要是改善 policy representation，未必需要在部署時顯式生成或輸出未來。
- Joint embedding 避免重建唯一 future 的負擔，但 latent 是否保留真正控制關鍵的物理變數，仍取決於 V-JEPA 表徵與訓練資料；patch-level 稠密並不自動等於懂接觸、力或可供性。
- 共用 predictor 能提高監督耦合，也可能造成 transition objective 與 action objective 的梯度競爭；摘要與 Introduction 無法回答兩者如何配重及是否對所有任務都有利。
- 文中「部署時移除 transition prediction」意味著策略不會在線上顯式檢查預測是否成立；若環境超出訓練分布，這種內化能力能否持續有效仍需實驗支持。
- 目前未讀實驗章，不能核實比較方法的預訓練資料、參數量、action horizon、評估 protocol 與統計變異是否等價。

## 可放進資料庫的筆記

1. **World model 有兩種產品形態**：一種在部署時 rollout future，另一種只在訓練時提供表徵監督；兩者的延遲與可校驗性不同。
2. **先問 predictive target 表達什麼，再問 loss 多大**：絕對 future、state difference、joint current–future relation 會給模型不同的歸納偏置。
3. **壓縮不是免費的**：少量 latent token 雖有效率，卻可能刪掉 manipulation 需要的局部空間對應。
4. **輔助任務必須接上決策幹線**：獨立 dynamics head 即使預測得好，也不代表 action backbone 真的使用其知識。
5. **共享模組提高耦合，也引入梯度協商問題**：transition 與 action 目標是否一致，應成為讀全文時的檢查項。
6. **不生成像素不等於沒有世界模型**：world modeling 的核心可以是可供控制使用的 transition representation，而非可視化影片。
7. **部署零額外支線成本是一種交換**：得到速度，但失去在線上讀出、檢查或規劃多個未來的能力。
8. **OOD 成績應拆分偏移來源**：視覺外觀、物體位置、動力學、embodiment 與任務組合不是同一種泛化。

## 後續想追的問題

1. Joint current–future target 的數學形式如何避免只學到靜態相似性？
2. Transition loss 與 action loss 如何加權？共享 predictor 是否出現梯度衝突？
3. V-JEPA 的預訓練資料與 inductive bias，對接觸豐富或力覺任務是否足夠？
4. 79.2% 與 86.3% 的 baseline 是否在預訓練資料、參數量、action chunking 與評估條件上可比？
5. 移除 predictive branch 後，能否用 probe 證明 action representation 仍保留可泛化的 transition information？
