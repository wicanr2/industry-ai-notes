# Self-Evolving Embodied Agents via Skill-Harness Evolution

## 原文資訊
- 論文：Self-Evolving Embodied Agents via Skill-Harness Evolution
- 作者：Peidong Wang、Zhiming Ma、Ying Chang、Xufang Luo、Xiaocui Yang、Shi Feng、Yuqing Yang、Dongsheng Li
- arXiv ID：2608.11350v1
- 分類：Computation and Language（cs.CL）、Robotics（cs.RO）
- 發表 / 更新：2026-08-11 / 2026-08-11
- 連結：[abs](https://arxiv.org/abs/2608.11350v1) / [pdf](https://arxiv.org/pdf/2608.11350v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-14

## 為什麼選這篇

這篇把 embodied agent 的適應單位，從模型權重移到模型外部的 agent system。它關心的不只是「要不要 fine-tune VLM」，而是技能文字、context 組裝、動作介面、output parsing 與 execution wrapper 如何共同決定機器人在環境中的表現。這正好位於 LLM agent harness 與 robotics 的交會。

它和今日另一篇 G0.5 的價值不同：G0.5 研究推理與動作是否應在模型內共享生成流；SHAPER 則假設模型可以凍結，改為演化模型外的程序性知識與 context-code harness。兩者分別代表 parametric architecture 與 non-parametric system adaptation，並非為了湊滿兩篇而選的相近變體。

## 一句話理解

SHAPER 讓同一個凍結 VLM 一方面規劃行動、一方面根據少量 rollout 回饋改寫外部技能與 context harness，以不更新權重的方式適應 embodied environment。

## Summary / Abstract 說了什麼

摘要把 embodied agent 視為圍繞 foundation model 建成的系統：模型權重只是其中一部分，skills、context、action interface 與 execution harness 都會影響表現。SFT / RL 需要資料、reward、可存取權重和額外訓練；既有 train-free code-centric 方法又常假設環境提供可程式化 robot API。

作者提出 SHAPER，在模型參數凍結的前提下，透過目標環境 rollout 演化可重用技能與 context-code harness。相同的凍結模型兼任 planner 與 artifact optimizer：前者執行任務，後者讀取 rollout 回饋後修訂外部技能和情境組裝方式。摘要自稱，在 VLABench 與 ESI-Bench 上，這種 skill-and-harness optimization 可與 pure execution、SFT 及 verifier-free selection / voting 等 test-time scaling 基準比較，並提供不更新模型的實用途徑。

## Introduction 的問題設定

Introduction 先把 embodied AI 從單一 policy model 擴展成 agent system。模型要透過受限 action interface，在部分視覺回饋下行動；可重用技能、context construction、過去動作與失敗如何呈現、解析器和 wrapper，都可能改變實際行為。

作者接著指出兩類現有適應方式的限制。第一類是 SFT / RL：需要權重存取、任務示範或 reward，以及額外 optimization。第二類是 train-free robot programming：LLM 可撰寫或修復呼叫 robot-specific API 的程式，但固定或受限 action space 未必提供完整 API、debug hook 與 execution monitor。

SHAPER 把 adaptation target 改成兩種外部 artifact。`skill` 是自然語言程序、動作 recipe、失敗恢復規則或任務分解策略；`context-code harness` 則決定哪些 observation、prior action、execution outcome 與 feedback 被送給 planner，以及如何組織。模型在互動時擔任上層 planner，在 evolution 階段用另一組 prompt 擔任 artifact optimizer；兩個角色共享權重但有不同輸入與任務。

Introduction 宣稱在 VLABench 中，上層 VLM 透過 VLA actor 這個低階工具執行；在 ESI-Bench 則使用 benchmark 的 environment action interface。這使研究試圖跨越「有 VLA low-level controller」與「固定介面 agent」兩種設定，但本次未讀實驗，無法判斷泛化程度與 rollout 成本。

## 研究的第一性問題

- **基本問題**：當不能或不想更新 foundation model 權重時，embodied agent 能否靠改良外部程序性知識與 context construction 適應新環境？
- **約束**：權重可能不可得；互動資料稀少；環境只有固定 action interface；實體 rollout 昂貴且失敗可能有風險。
- **既有方法卡點**：SFT / RL 把 adaptation 綁在參數更新；code-centric agent 又常依賴可程式化 API 與除錯設施。
- **作者試圖移動的邊界**：把 agent harness 從人工固定的 prompt / wrapper，變成可由 rollout feedback 迭代最佳化的非參數資產。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 將 train-free embodied adaptation 形式化為凍結模型周圍的 skills 與 context-code harness 最佳化。
- 提出 SHAPER，使用少量目標環境 rollout 讓同一模型執行與修訂外部 artifact。
- 不依賴更新模型參數，也不把可程式化 robot API 當成唯一 action substrate。
- 在不同低階 action interface 的 embodied benchmark 上，與 fine-tuning 和 sampling-heavy baseline 比較。

### 我的保守判讀

- 最可重用的觀點是：agent 的能力邊界由「模型 × harness × action interface × feedback」共同決定，單看 backbone 容易錯置歸因。
- 自我改寫技能不必然等於穩定改善；artifact 可能過度貼合少數 rollout、累積錯誤規則，或把偶然成功合理化。
- 同一模型兼任 planner 與 optimizer 會共享盲點。若 rollout summary 本身遺失關鍵狀態，optimizer 可能只改善文字敘事而非控制策略。
- train-free 不等於 cost-free：環境互動、重複推論、回饋摘要與 artifact 搜尋都有成本，實體機器人上的安全代價尤其重要。
- Introduction 提到兩個 benchmark，但尚不足以判斷技能能否跨任務、場景或 embodiment 重用，也無法核對與 SFT 的資料預算是否公平。

## 可放進資料庫的筆記

1. **把 agent 當系統，不只當模型**：最終行為是 backbone、context、skills、介面、parser 與 execution loop 的乘積。
2. **adaptation target 不只有 weights**：程序性知識、失敗恢復規則與 context policy 也能成為可優化狀態。
3. **harness 是資訊控制面**：它決定模型看到什麼、以何種順序看到、哪些執行結果能回流，而不只是 prompt 包裝。
4. **固定 action interface 是重要現實約束**：能寫 Python/robot API 的 agent 成功，不代表相同方法能移植到封閉或離散介面。
5. **同模自我優化要防共同盲點**：planner 與 optimizer 共用模型時，應引入外部驗證、失敗分類或可檢查的 acceptance rule。
6. **train-free 應報完整成本**：除了 gradient step，還要計算 rollout 數、token、wall-clock、環境 reset 與失敗風險。
7. **技能資產要測 transfer 與 forgetting**：若每個環境都重寫一套技能，它比較像 test-time search，不一定形成可複利知識庫。
8. **artifact evolution 需要版本治理**：技能與 harness 應保留 provenance、回滾點、適用條件和造成改善的證據。

## 後續想追的問題

1. SHAPER 如何表示、選擇與合併 skill；context-code harness 能修改到什麼程度？
2. optimizer 使用的 rollout summary 是否由規則、另一模型或同一模型產生，會遺失哪些失敗訊號？
3. 與 SFT、voting、selection 比較時，rollout、token、時間與可用 feedback 預算是否對齊？
4. 演化後技能能否跨任務或跨 embodiment 轉移，是否出現過度適配與舊能力退化？
5. 若部署到真實機器人，如何設定 artifact acceptance、sandbox、回滾與安全監督？
