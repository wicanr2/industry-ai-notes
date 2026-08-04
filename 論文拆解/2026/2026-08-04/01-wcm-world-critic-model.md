# WCM: A World Critic Model for Vision-Language-Action Reinforcement Learning

## 原文資訊
- 論文：WCM: A World Critic Model for Vision-Language-Action Reinforcement Learning
- 作者：Senyu Fei、Xiaopeng Yu、Siyin Wang、Xianzhong Zhao、Jingjing Gong、Xipeng Qiu
- arXiv ID：2607.29613v1
- 分類：Robotics（cs.RO）、Computation and Language（cs.CL）、Computer Vision and Pattern Recognition（cs.CV）
- 發表 / 更新：2026-07-31 / 2026-07-31
- 連結：[abs](https://arxiv.org/abs/2607.29613v1) / [pdf](https://arxiv.org/pdf/2607.29613v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-04

## 為什麼選這篇

這篇位於 VLA、機器人強化學習與 world model 的直接交會點。它關心的不是再做一個更大的動作生成器，而是 critic 到底要把什麼當成「狀態」：若機器人控制具有部分可觀測性，單張影像很可能缺少接觸進度、運動方向與過去失敗等價值判斷所需資訊。

更值得注意的是，作者沒有把解法停在疊更多歷史影格，而是追問 scalar return supervision 是否足以迫使表示學會跨時間動力學。這把問題從「輸入不夠長」移到「訓練目標沒有要求模型理解演化」，對 VLA post-training 的架構判斷有可重用價值。不過本次只讀摘要與 Introduction，以下不把效能宣稱當成已獨立驗證的結果。

## 一句話理解

WCM 讓 VLA 的 critic 一邊估計價值、一邊預測未來 latent state，試圖把歷史觀測壓成對未來控制有用的 predictive state，而不是只對單張影像做回報回歸。

## Summary / Abstract 說了什麼

摘要把 critic-based VLA-RL 的核心缺口描述為 state approximation problem。現有 critic 多半依賴單一影格或單一影格的 VLM latent，但機器人操作是部分可觀測過程；直接加入高維影像歷史又會增加複雜度，而且 scalar return regression 對跨時間動力學提供的監督太弱。

作者提出 World Critic Model（WCM），以輕量 LeJEPA 架構同時預測 future latent state 與估計 value。論文自稱，這種聯合目標能讓 critic 表示捕捉時間結構，並可接到 on-policy、off-policy RL 與 Pi0、Pi0.5、OpenVLA-OFT 等 VLA backbone。摘要也報告跨四個 benchmark、149 個任務及七個真實操作任務的改善；因本次未讀實驗，無法核對任務構成、baseline 公平性、顯著性與額外計算成本。

## Introduction 的問題設定

Introduction 先比較 SFT 與 RL post-training：SFT 受專家示範覆蓋範圍限制，RL 則可透過環境互動改善策略；在 critic-based RL 中，critic 提供較密集的策略改善訊號，因此其 state representation 會直接限制 sample efficiency 與最終政策。

作者接著以 POMDP（partially observable Markov decision process，部分可觀測馬可夫決策過程）定位問題。若真實狀態不能由單次觀測完整恢復，最佳決策需要歷史的 sufficient statistic，也就是一個足以保留決策相關資訊的摘要。單張圖可看出場景外觀，卻未必能知道物體正在如何移動、接觸走到哪一步，或先前動作造成什麼後果。

但有歷史輸入不等於會使用歷史。作者認為 frame stacking 或帶 positional encoding 的 temporal critic，仍可能只把多幀當成較大的靜態向量；若唯一目標是擬合 scalar return，模型沒有強理由學會環境如何演進。因此 WCM 加入預測未來 latent 的 world-model objective，與 value estimation 聯合最佳化，試圖得到 compact、可更新且與未來結果相關的 predictive state。

## 研究的第一性問題

- **基本問題**：在部分可觀測的機器人控制裡，critic 如何從歷史中形成足以估計未來回報的狀態表示？
- **約束**：視覺歷史維度高、時序長；單一 scalar return 的資訊密度低；額外 world-model 目標又可能學到與任務無關的可預測細節。
- **既有方法卡點**：單幀 critic 看不到動態；單純疊幀雖提供資料，卻沒有明確監督要求表示理解跨時間演化。
- **作者試圖移動的邊界**：把 critic 從「觀測到價值的回歸器」改成「先形成 predictive state、再估計價值的世界模型式 critic」。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 找出 critic-based VLA-RL 在 partial observability 下的 representation bottleneck。
- 以 future-latent prediction 與 value estimation 的聯合目標，讓 critic 顯式學習時間動力學。
- 架構可整合不同 VLA backbone，以及 on-policy 與 off-policy 訓練流程。
- 在模擬與真實操作任務上帶來一致改善，尤其強調 OOD generalization。

### 我的保守判讀

- 最有價值的主張是「history availability 不等於 temporal understanding」。這比單純增加 context length 更精確地指出監督訊號的角色。
- future-latent prediction 是否真的得到控制所需的 sufficient statistic，取決於 latent target、prediction horizon 與 loss weighting；Introduction 尚不足以判斷。
- world-model auxiliary loss 也可能保留可預測但與 value 無關的背景變化。是否有 task-relevance 約束，需要讀方法與 ablation。
- 摘要中的 149 tasks 與 real-world results 很廣，但仍需核對每個任務的 rollout budget、seed 數、baseline tuning 與統計變異。
- WCM 的收益可能部分來自參數量、歷史長度或額外訓練訊號，而不只來自「predictive state」本身；需要消融實驗拆解。

## 可放進資料庫的筆記

1. **先分辨 observation 與 state**：機器人看到的單張影像只是 observation，不必然包含決策所需的完整 state。
2. **歷史長度與歷史可用性是兩個問題**：把過去塞進 context，只解決資料可見；訓練目標才決定模型是否提取動態。
3. **critic 也是表示學習器**：它不只是輸出一個 value，內部表示品質會影響 RL 的密集監督是否可信。
4. **scalar supervision 容易欠定**：多種錯誤表示都可能擬合同一個回報，因此需要較具結構的輔助目標。
5. **predictive state 是實用抽象**：不必重建完整世界，只需保留足以預測任務相關未來的 compact summary。
6. **world model 不只服務 planner**：它也可作為 critic representation 的訓練約束，而不一定直接產生 rollout 供搜尋。
7. **廣泛 benchmark 不等於因果歸因完成**：仍要用參數量、歷史、loss 與計算預算對齊的消融來確認改進來源。
8. **OOD 改善要問 OOD 類型**：外觀、物體、動力學、任務組合與 embodiment shift 的難度並不相同。

## 後續想追的問題

1. WCM 的 latent target 如何建立，prediction horizon 多長，是否會阻斷梯度或使用 target encoder？
2. predictive loss 與 value loss 的權重如何設定，對不同 VLA backbone 是否敏感？
3. 149 個任務中的 OOD 是外觀變化、語意組合、物理變化，還是跨 embodiment？
4. 與 frame stacking / temporal critic 比較時，參數量、history window 與訓練算力是否對齊？
5. 真實機器人結果有多少 seed / rollout，失敗是否集中在接觸、遮擋或長時序 credit assignment？
