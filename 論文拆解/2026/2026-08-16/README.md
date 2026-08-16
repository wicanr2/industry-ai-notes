# 2026-08-16 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍新增 2 篇。兩篇皆為 2026-08-13 的近期投稿，arXiv ID 未在 repo 的既有單篇筆記中出現，abs metadata 未見 withdrawn / retracted 標記。

兩篇都以 robot/VLA failure 為核心，但處理不同系統層次：FIRE-VLA 補足訓練期 unresolved rollout groups 缺少 corrective information 的問題；ContactGuard 則在部署期利用 planned action 預測接觸後 latent，於真正接觸前做 abort。前者是 post-training data/supervision routing，後者是 runtime predictive verification，具有獨立資料庫價值，並非為湊滿上限而選擇的相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [FIRE-VLA: Failure-Informed Self-Evolution for Vision-Language-Action Models in Autonomous Driving](./01-fire-vla-failure-informed-self-evolution.md)
   - arXiv：2608.13395v1
   - 分類：cs.RO
   - 選擇理由：區分一般相對 reward learning 與整組 rollout 都失敗時的 corrective-information 缺口，並嘗試用同尺度、具 privileged future 的 teacher 處理 VLA 尾端失敗。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [ContactGuard: Pre-Contact Execution Monitoring with Action-Conditioned Latent World Models](./02-contactguard-pre-contact-monitoring.md)
   - arXiv：2608.13438v1
   - 分類：cs.RO、cs.AI、cs.CV
   - 選擇理由：把 failure detection 前移到 contact 之前，並將 latent world model 定位為不侵入原 policy 的 predictive verifier，直接對應真實 manipulation 的安全與停機邊界。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 2026-08-16 為週日，arXiv 最新一批仍是 2026-08-13 投稿；因此從最近 3 天候選中選取，而非用較舊或弱相關論文補量。
- 昨日索引曾將 ContactGuard 列為看過但未選；今日重新比較最新候選後，因其 pre-contact、policy-decoupled monitoring 視角具有獨立部署價值而收錄，arXiv ID 並未在既有單篇筆記重複。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
