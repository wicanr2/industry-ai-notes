# 2026-08-26 論文拆解

本日新增 2 篇 LLM／多模態模型與 Robotics 交會的 VLA 論文。兩個 arXiv ID 均未在 repo 既有筆記出現，官方 abs 頁面未見 withdrawn / retracted 標記。

兩篇具有不同且獨立的價值：CounterAlign 處理昂貴機器人正例如何轉成帶不確定性的反事實糾錯監督；Pointing-VLA 則處理多模態 hidden states 如何透過具型別的空間介面交給 robot planner／executor。前者偏資料與學習訊號，後者偏模型—控制系統邊界，並非為湊滿上限而選相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [CounterAlign: Counterfactual Supervision for Vision-Language-Action Models](./01-counteralign-counterfactual-vla.md)
   - arXiv：2608.21740v1
   - 分類：cs.RO
   - 選擇理由：把成功示範重新配成反事實指令—動作樣本，並正面處理錯配不一定是真負例的標籤歧義；適合用來思考機器人資料的「監督密度」。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [Pointing-VLA: Typed Spatial Grounding Interfaces for Vision-Language-Action Manipulation](./02-pointing-vla-typed-spatial-grounding.md)
   - arXiv：2608.23138v1
   - 分類：cs.RO、cs.AI、cs.CV
   - 選擇理由：將 point、功能區熱圖與 trajectory 視為不同型別的 robot-facing interface，凸顯模型能力能否可靠進入 planner／executor，取決於介面契約而不只 backbone。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 cs.RO、cs.AI、cs.CL，並優先檢查 VLA、embodied AI、robot learning、world model、agentic robotics 與語言條件控制。
- arXiv API 複合查詢遇到 429 與 timeout，因此改讀 arXiv 官方 RSS，再逐篇回到官方 abs 與 HTML 驗證版本、作者、分類、摘要、Introduction 與撤稿狀態。
- 兩篇分別於 2026-08-22 與 2026-08-24 投稿，均位於最近 7 天範圍。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 論文筆記，本次新增後為 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
