# 2026-09-24 論文拆解

本日新增 2 篇近期論文。執行前本日非 README 論文筆記為 0；兩篇 arXiv ID 均未在 repository 出現，官方 arXiv 頁面未見 withdrawn 或 retracted 標記。

兩篇價值彼此獨立：第一篇處理 VLA／WAM 評估是否真的測到 language grounding；第二篇處理 LLM agent 如何把反覆控制從 context 移成可重用 executable harness。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫，未讀後續方法、實驗、結果、限制與附錄。

## 今日選文

1. [RoboFollow: Unveiling the Instruction Following Mirage in Embodied Agents](./01-robofollow-instruction-following-mirage.md)
   - arXiv：2609.25636v1
   - 分類：cs.RO
   - 選擇理由：以高場景熵讓語言成為必要資訊，重新檢查 robot task success 是否真的代表 instruction following。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML 與 PDF 文字版，讀至 Related Work 前）

2. [Grow the Harness, Not the Context: From Strategy-Free Scaffolds to Reusable Specialist Agents](./02-growing-harness-reusable-agent-control.md)
   - arXiv：2609.26760v1
   - 分類：cs.AI、cs.SE
   - 選擇理由：把重複 agent control 從模型 context 外移為可測試、可回滾的持久程式，提供不同於擴大模型與 context 的系統路徑。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML，讀至 Related Work 前）

## 選文說明

- arXiv API 本次回傳 HTTP 406，因此改以 arXiv 官方 abs／HTML、近期分類搜尋結果與 PDF 文字擷取完成候選核對；這是 discovery 管道限制，不影響兩篇官方頁面與 Introduction 的取得。
- 候選範圍涵蓋 cs.RO、cs.AI、cs.CL、cs.CV 與 cs.LG 的 robot／embodied／VLA／LLM agent／reasoning 等主題。
- 已檢查 repository，兩個不含版本號的 arXiv ID 均未重複。
- 本日共收錄 2 篇，未超過每日自動選文上限；第二篇有獨立的 agent architecture 價值，不是為了補足篇數。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
