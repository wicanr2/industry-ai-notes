# 2026-09-27 論文拆解

本日新增 2 篇近期論文。執行前本日非 README 論文筆記為 0；兩篇 arXiv ID 均未在 repository 出現，官方 arXiv 頁面未見 withdrawn 或 retracted 標記。

兩篇價值彼此獨立：第一篇處理 coding agent 如何從單次示範建立機器人程式、規格與驗證迴圈；第二篇處理 World Action Model 如何跨控制週期重用未完成的未來想像，以降低重規劃延遲。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫，未讀後續方法、實驗、結果、限制與附錄。

## 今日選文

1. [RAPID: Robot Agentic Programming from Demonstrations](./01-rapid-agentic-programming-from-demonstrations.md)
   - arXiv：2609.30249v1
   - 分類：cs.RO、cs.AI、cs.CV
   - 選擇理由：把 demonstration 從模仿資料提升為 task specification、primitive 與 verification environment 的共同來源，直接處理 agentic coding loop 在實體操作缺乏測試介面的問題。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML，讀至 Related Work 前）

2. [Rolling-WAM: World Action Models with Rolling Imagination](./02-rolling-wam-rolling-imagination.md)
   - arXiv：2609.30247v1
   - 分類：cs.RO、cs.AI、cs.CV
   - 選擇理由：以近程完整、遠程漸進的 rolling denoising 重排計算時序，探索保留世界模型視覺想像與提高閉迴路反應性之間的折衷。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML，讀至 Related Work 前）

## 選文說明

- 候選範圍涵蓋 arXiv 最近一週的 cs.RO、cs.AI、cs.CL 與 cs.CV，並優先檢查 robot agent、VLA、WAM、embodied reasoning 與 manipulation。
- arXiv API 查詢在執行環境中未獲准執行，因此改用 arXiv 官方 recent 分類頁、abs 與 HTML 完成 discovery 與內容核對；兩篇 Introduction 均成功取得。
- 已檢查 repository，兩個不含版本號的 arXiv ID 均未重複。
- 本日共收錄 2 篇，未超過每日自動選文上限；兩篇分別聚焦可驗證 agentic programming 與即時 world-action inference，第二篇具有獨立價值，不是為補足篇數。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
