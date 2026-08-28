# 2026-08-28 論文拆解

本日新增 2 篇 LLM／VLM 與 Robotics／Embodied AI 交會論文。兩個 arXiv ID 均未在 repo 既有筆記出現，官方 abs 頁面未見 withdrawn / retracted 標記。

兩篇有不同且獨立的價值：R³ 問自由形式自然語言推理能否成為機器人操作的 test-time compute；MA-VLA 則問多臂系統能否透過明確的 atomic action assignment，重組出訓練時未見的合作模式。前者偏高階 reasoner 對低階 policy 的 steering，後者偏多執行器分工與組合泛化，並非為湊滿上限而選相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [R³: Training Robots to Reason in Natural Language via Reinforcement Learning](./01-r3-robot-natural-language-reasoning.md)
   - arXiv：2608.26053v1
   - 分類：cs.RO、cs.AI、cs.CL、cs.LG
   - 選擇理由：直接檢驗自由形式語言 reasoning 是否能在執行時增加計算，並作為高階介面 steering 固定的 language-conditioned low-level policy。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [MA-VLA: Multi-Arm Vision-Language-Action Model for Collaboration and Compositional Generalization](./02-ma-vla-multi-arm-compositional-generalization.md)
   - arXiv：2608.25864v1
   - 分類：cs.RO
   - 選擇理由：把多臂分工變成明確的逐臂 atomic action assignment，並用 Arm Shuffle 檢驗模型是否能脫離固定角色、重組未見合作模式。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 cs.RO、cs.AI、cs.CL、cs.LG，優先檢查 robot reasoning、VLA、embodied AI、multi-arm manipulation、world model 與 agentic robotics。
- arXiv API 複合查詢遇到 HTTP 429，因此改讀 arXiv 官方 recent listings，再逐篇回到官方 abs 與 HTML 驗證版本、作者、分類、摘要、Introduction 與撤稿狀態。
- 兩篇均於 2026-08-26 投稿，位於最近 7 天範圍。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 論文筆記，本次新增後為 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
