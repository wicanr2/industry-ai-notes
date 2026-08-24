# 2026-08-24 論文拆解

本日新增 2 篇 2026-08-20 投稿的 Physical AI / world-action modeling 論文。兩個 arXiv ID 均未在 repo 既有筆記出現，arXiv 頁面未見 withdrawn / retracted 標記。

今天是週一，執行時 arXiv RSS 的最新建置仍為 2026-08-23 且週末無新項目，因此依「最近 1–7 天」規則從最近批次選文。兩篇具有不同而獨立的價值：Video2DoorTraversal 處理單一影片如何變成可供接觸式控制學習的任務數位分身；Surgical World-Action Modeling 則處理世界模型如何同時表達視覺演化與控制相關軌跡。沒有用相近變體硬湊數量。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [Video2DoorTraversal: Push Door Traversal via Simulated Door Twins](./01-video2doortraversal-simulated-door-twins.md)
   - arXiv：2608.20251v1
   - 分類：cs.RO
   - 選擇理由：以單段真實 RGB 影片重建 articulated door twin，再用 simulation-in-the-loop agent 產生可執行示範，連接數位分身、資料生成與真機閉迴路控制。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [Towards Surgical World-Action Modeling: A Preliminary Joint Visual-Trajectory Forecasting for Surgical Motion Planning](./02-surgical-world-action-modeling.md)
   - arXiv：2608.20284v1
   - 分類：cs.CV、cs.RO
   - 選擇理由：把未來視覺表示與器械軌跡放進共同預測問題，明確指出影像逼真與動作幾何正確是兩種不能互相替代的 world-model 證據。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 cs.RO recent list、VLA、embodied AI、robot learning、world model 與 LLM/agentic robotics 等主題。
- arXiv API 複合查詢遇到 429 與 timeout，因此改讀 arXiv recent list，並逐篇回到官方 abs 與 HTML 驗證版本、作者、分類、摘要、Introduction 與撤稿狀態。
- 兩篇皆在執行日前 4 天投稿，位於最近 7 天範圍。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 論文筆記，本次新增後為 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
