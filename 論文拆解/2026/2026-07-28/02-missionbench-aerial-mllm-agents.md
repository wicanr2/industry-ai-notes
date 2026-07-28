# Zero-Shot Mission-Level Evaluation for Aerial MLLM Agents

## 原文資訊
- 論文：Zero-Shot Mission-Level Evaluation for Aerial MLLM Agents
- 作者：Suman Navaratnarajah, Taehyoung Kim, Jona Ruthardt, Ishaan Bhimwal, Ryousuke Yamada, Yannik Blei, Wolfram Burgard, Yuki M. Asano
- arXiv ID：2607.22014v1
- 分類：Artificial Intelligence (cs.AI)；Computation and Language (cs.CL)；Computer Vision and Pattern Recognition (cs.CV)；Robotics (cs.RO)
- 發表 / 更新：Submitted 2026-07-24 / v1 2026-07-24
- 連結：[abs](https://arxiv.org/abs/2607.22014) / [pdf](https://arxiv.org/pdf/2607.22014)
- 本次閱讀範圍：Summary/Abstract + Introduction；arXiv HTML 取得失敗，Introduction 由 PDF 轉文字擷取；未讀 Methods / Experiments / Results 其他章節
- 擷取日期：2026-07-28

## 為什麼選這篇

這篇是「MLLM 作為 embodied agent reasoning module」的評估論文，而且場景不是常見的室內導航或桌面操作，而是 aerial 3D environments。它關心的不是模型能不能回答單張圖片問題，而是 frozen general-purpose MLLM 能不能從一個高階自然語言任務出發，在閉環中規劃、移動、調整視角並回報結果。

它值得放入資料庫，是因為 Physical AI 的進展需要 benchmark 能抓到「任務層能力」而非單步感知能力。若未來無人機、移動機器人、巡檢系統大量使用 MLLM 當高階控制或任務管理模組，那麼評估也應該對齊真實 mission：agent 是否知道該去哪裡、什麼視角足夠、什麼時候該停止、回報是否正確。

相較於今天另一篇 Pigey 偏系統架構，MissionBench 偏評估基礎設施。兩者互補：一篇問「怎麼補上 orchestration」，另一篇問「怎麼測出 embodied mission-level 能力仍然不足」。

## 一句話理解

這篇提出 MissionBench，測試 frozen MLLM 在空中 3D 環境中是否能從單一高階指令完成長程任務；作者主張現有模型離人類表現仍有明顯差距。

## Summary / Abstract 說了什麼

摘要說，MLLM 正逐漸成為 embodied agents 的核心 reasoning module，但目前還不清楚 general-purpose models 在沒有 aerial-specific fine-tuning 的情況下，能否完成 long-horizon embodied tasks。作者提出 MissionBench：120 個 mission、5 個模擬 3D 環境、4 類任務。Agent 只能使用 egocentric observations 與 action history，自主規劃、導航並回報結果。

摘要宣稱，跨 22 個 open / closed-source MLLMs，最強模型成功率不到 35%，而人類表現為 84.4%。作者因此認為 mission-level competence 不只是 spatial perception，還需要 multi-step planning、adaptive reasoning 與閉環評估。

這些數字同樣只視為摘要中的 claim；本次未讀實驗章節，所以不判斷模型清單、成功判定、任務難度與人類 baseline 的可比性。

## Introduction 的問題設定

Introduction 先指出：MLLM 越來越常被當作 embodied agent 的 general-purpose reasoning module，將自然語言指令與 egocentric visual observations 映射到 actions。核心問題是：frozen general-purpose MLLM 在不做 task-specific adaptation 的情況下，到底能否執行 multi-step embodied missions？

作者認為既有 benchmark 只提供部分證據。VLN 常測路徑層級的 instruction following；object navigation 測是否靠近目標物；ALFRED 等 task-driven benchmark 雖然超越導航，但仍常依賴 step-level subgoals。這些設定不一定能直接測出 frozen MLLM 是否能同時協調 perception、planning、control 與 reporting。

Aerial environments 被作者視為特別嚴格的測試場：UAV mission 對視角敏感且較開放，成功常需要到達有資訊量的位置、維持視覺接觸、隨時間調整動作、並回報 mission-specific outcome。同時，既有研究指出 MLLM 在 aerial viewpoint 下的 spatial reasoning、object localization、depth estimation、relative positioning 仍有困難。

MissionBench 的設計是 120 個任務，分布在 5 個 high-fidelity simulation environments 和 4 類貼近 UAV operation 的任務：Reporting、Inspection、Manipulation、Patrol。每個任務只給單一自然語言指令，agent 要推論去哪裡、如何定位、該回報什麼。作者也強調它不把動作限制在固定距離 primitive，而是讓 agent 預測方向與 magnitude，以測試更細的 viewpoint selection。

## 研究的第一性問題

- **基本問題**：通用 MLLM 是否真的能在 embodied setting 中完成 mission，而不只是對單張圖片或短指令做合理回答？
- **約束**：模型 frozen、zero-shot、沒有 aerial-specific fine-tuning；agent 只能依賴 egocentric observation 與 action history。
- **既有方法卡點**：許多 benchmark 測的是局部能力，例如到達目標、物件辨識或分解子任務，未必測得出完整任務中的視角選擇、停止條件與回報正確性。
- **作者試圖移動的邊界**：把 MLLM embodied evaluation 從 isolated perception / navigation 推向 closed-loop mission-level assessment。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出 MissionBench：120 個 aerial mission，涵蓋 5 個模擬環境與 4 類任務。
- 設計 closed-loop evaluation framework，評估 agent 的移動、視角選擇與任務完成，而不只是單步回答。
- 對 22 個 MLLM 做 empirical analysis，指出最強模型與人類 baseline 仍有大幅差距。
- 主張 mission-level competence 需要 spatial perception 之外的 multi-step planning 與 adaptive reasoning。

### 我的保守判讀

這篇的價值在於提醒：若 MLLM 要進入 Physical AI，benchmark 的單位應該從「圖片問答」提升到「任務閉環」。尤其空中視角對距離、方向、遮擋、目標大小很敏感，能暴露模型在空間控制與資訊蒐集策略上的弱點。

限制方面，Introduction 還看不出模擬環境與真實 UAV 任務的 domain gap 多大，也看不出 continuous-magnitude pose control 是否被模型介面公平地表達。若模型失敗，是因為視覺理解差、action space 不自然、prompt 格式不佳、還是 mission success check 太嚴格？這些都需要讀後續章節才能判斷。

## 可放進資料庫的筆記

- **Mission-level evaluation**：Physical AI 評估的單位應該是完整任務，而不只是局部 perception 或單步 navigation。
- **Closed-loop 比 static VQA 更接近 embodied intelligence**：模型必須根據新 observation 調整行動，才會暴露 planning 與 recovery 問題。
- **Aerial viewpoint 是 MLLM 空間能力壓力測試**：高度、距離、視角、遮擋與目標尺度會放大 spatial reasoning 缺陷。
- **Report outcome 是任務的一部分**：機器人不是只要移動到位置，還要知道何時資訊足夠、如何回報任務結果。
- **Frozen zero-shot 設定的意義**：能檢查 general-purpose pretraining 是否自然轉移到 embodied mission，而不是測 fine-tuning 管線。
- **評估要拆解理解與執行**：若 benchmark 能分辨 mission understanding 與 spatial execution，就更容易定位失敗原因。
- **Scaling 的雙面性**：若規模提升帶來 embodied 能力，代表機會；但若可靠性不足，也可能讓未經專門訓練的模型更快被放進實體系統。

## 後續想追的問題

- MissionBench 的 success check 如何定義？對 report、position、timing 是否有不同評分？
- 22 個 MLLM 的介面是否一致？不同模型在 action formatting 上是否有不公平差異？
- continuous-magnitude pose control 對 language model 是否太不自然，是否需要中介 policy 或 planner？
- 人類 baseline 的操作條件與模型是否可比？人類看到的 observation、歷史資訊與行動限制是否相同？
- 這套 benchmark 能否延伸到 ground robot、warehouse inspection、工地巡檢或災害現場任務？
