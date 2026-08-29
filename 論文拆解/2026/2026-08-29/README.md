# 2026-08-29 論文拆解

本日新增 2 篇 Robotics／Embodied AI 論文，皆位於最近 7 天，且 arXiv ID 未在 repo 既有筆記出現；官方 abs 頁面未見 withdrawn / retracted 標記。

兩篇有不同且獨立的價值：CLAP 聚焦跨 embodiment 影片 world model 的資料與動作表徵對齊；FlashVLA 聚焦 flow-matching VLA 的推論排程、延遲與非同步時間一致性。前者處理「如何擴張可學習的物理經驗」，後者處理「如何讓模型持續而及時地輸出控制」，並非為湊滿上限而選相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [CLAP: Cross-Embodiment Video World Models are Zero-Shot Physical Simulators](./01-clap-cross-embodiment-world-models.md)
   - arXiv：2608.27406v1
   - 分類：cs.RO、cs.AI、cs.CV
   - 選擇理由：把跨機器形態與人類影片的資料擴張問題，具體化為 latent action、語言與 end-effector action 的表徵分工，直接關聯 Physical AI 的 world model 與資料飛輪。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [FlashVLA: Streaming Action Decoding for Fast and Asynchronous VLA Inference](./02-flashvla-streaming-action-decoding.md)
   - arXiv：2608.27384v1
   - 分類：cs.RO
   - 選擇理由：從 chunk-isolated decoding 的共同原因處理同步停頓與非同步 stale context，呈現 VLA 架構、推論排程與閉迴路控制共同設計的價值。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 cs.RO、cs.AI、cs.CL、cs.LG，並優先檢查 VLA、embodied AI、robot world model、robot planning、LLM agent、reasoning、RL 與 alignment。
- 兩篇均於 2026-08-27 投稿與更新，距本次擷取日 2 天。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 論文筆記，本次新增後為 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
