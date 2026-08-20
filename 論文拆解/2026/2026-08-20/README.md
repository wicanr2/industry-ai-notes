# 2026-08-20 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍新增 2 篇，皆為 2026-08-18 投稿、在最近 2 天內的 Physical AI 論文。兩個 arXiv ID 均未在 repo 既有筆記中出現；arXiv 頁面未見 withdrawn / retracted 標記。

兩篇處理不同但互補的系統層：Hydra-0 探索跨 embodiment 的視覺動作介面，連接 world modeling、policy evaluation 與控制；ManiGuard 則把 task success 與 trajectory-level safety 分開，以形式規格統一 benchmark、監控與資料標註。兩者各有獨立價值，並非為湊滿每日上限而選擇的相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [Hydra-0: Action Flow for Generalist World Modeling and Control](./01-hydra0-action-flow-world-model-control.md)
   - arXiv：2608.18077v1
   - 分類：cs.RO
   - 選擇理由：把 embodiment-specific command 轉成 kinematically grounded image-plane action flow，嘗試以同一介面連接異質資料、世界模型評估與實體控制。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [MANIGUARD: A Benchmark and Data Suite for Specification-Grounded Safety Evaluation and Improvement of Robotic Manipulation](./02-maniguard-spec-grounded-robot-safety.md)
   - arXiv：2608.17386v1
   - 分類：cs.RO
   - 選擇理由：明確拆分 task success、engagement 與 safety，以 LTL$_f$ automaton 取代 learned judge，讓 Physical AI 的安全評估更可檢查。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 已檢查 arXiv cs.RO、cs.CL 的近期候選；arXiv API 本次受到 429／timeout，因此改用官方 RSS、abs metadata 與 HTML 正文完成候選查核與有限閱讀。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 的論文筆記，本次新增後為 2 篇。
- 同批檢查了 VLA policy optimization、embodied navigation、language-guided manipulation 與 LLM agent 候選；本日保留的兩篇在跨 embodiment world model 與 specification-grounded safety 上問題邊界較清楚，且彼此互補。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
