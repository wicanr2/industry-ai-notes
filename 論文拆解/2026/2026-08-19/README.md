# 2026-08-19 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍新增 2 篇，皆為 2026-08-17 投稿、在最近 2 天內的 LLM/VLA + Robotics 或 Physical AI 論文。兩個 arXiv ID 均未在 repo 既有筆記中出現；arXiv 頁面未見 withdrawn / retracted 標記。

兩篇處理不同尺度：BATON 把 LLM agent 編排長時程機器人技能時的子任務邊界做成可檢查的 transition-aware memory；HAF 則處理通用 VLA 到人形全身移動操作的運動學生成順序，以及凍結 backbone 後的低維部署調整。兩者各有獨立價值，並非為湊滿每日上限而選擇的相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [Don't Drop the BATON: Long-Horizon Robot Manipulation via Agentic Subtask Exploration and Transition-aware Memory](./01-baton-transition-aware-long-horizon.md)
   - arXiv：2608.16889v1
   - 分類：cs.RO、cs.AI、cs.CV
   - 選擇理由：直接位於 LLM coding agent 與 frozen VLA 的交會，將長時程探索成本、錯誤歸因與技能邊界的 entry／handoff／lookahead 條件放進同一個可稽核架構。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [HAF: Adapting Generalist VLAs to Humanoid Whole-Body Loco-manipulation via Hierarchical Action Flow and Spectral Latent RL](./02-haf-humanoid-vla-adaptation.md)
   - arXiv：2608.16837v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：以明確的運動學生成順序與低維頻譜 latent RL 處理 generalist VLA 的 humanoid adaptation，補上 action chunk 內部協調與部署調整的尺度。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 已檢查 arXiv cs.RO、cs.CL、cs.AI 的近期列表；arXiv API 本次受到 429 rate limit，因此以官方 recent list、abs metadata 與 HTML 正文完成候選查核與有限閱讀。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 的論文筆記，本次新增後為 2 篇。
- 同批也檢查了 world-model-guided VLA test-time computation、embodied-agent security 等候選；本日保留的兩篇在 agent orchestration 與 humanoid control 上有較清楚且互補的第一性問題。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
