# 2026-08-30 論文拆解

本日新增 2 篇 LLM + Robotics／Physical AI 交會論文。兩篇皆於 2026-08-27 投稿，位於最近 7 天，arXiv ID 未在 repo 既有筆記出現；官方 abs 頁面未見 withdrawn / retracted 標記。

兩篇有獨立價值：STEP 聚焦多模態 LLM 如何以顯式狀態帳本支援工業人機協作規劃；TrapVLA 聚焦語言觸發的 VLA backdoor 如何控制機器人的失敗形態。前者處理規劃可靠性與執行介面，後者處理模型供應鏈與物理安全，不是為湊滿上限而選相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [STEP: State-Aware Task Estimation and Planning with Multi-Modal LLMs for Human-Robot Collaboration](./01-step-state-aware-human-robot-planning.md)
   - arXiv：2608.27225v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：把多模態 LLM 規劃的核心風險從「文字是否合理」改寫成「狀態與轉移是否一致」，並直接對應結構化工業人機交接。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [TrapVLA: Trapping Vision-Language-Action Models in Configured Failure Modes](./02-trapvla-configured-failure-backdoors.md)
   - arXiv：2608.26578v1
   - 分類：cs.RO、cs.CV
   - 選擇理由：將 VLA 攻擊從任意失敗提升到可配置、看似自然的局部控制失敗，為 Physical AI 安全評估補上失敗形態與可控性。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 cs.RO、cs.AI、cs.CL、cs.LG，優先檢查 VLA、embodied AI、robot planning、world model、LLM agents、reasoning、RL 與 alignment。
- 先排除 2026-08-29 已收錄的 CLAP（2608.27406v1）與 FlashVLA（2608.27384v1），再檢查本日兩篇 ID 未重複。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 論文筆記，本次新增後為 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
