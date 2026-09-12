# 2026-09-12 論文拆解

本日新增 2 篇 2026-09-09 提交的 LLM／VLA + Robotics 交會論文。執行前本日非 README 論文筆記為 0；兩篇 arXiv ID 均未在 repository 出現，官方 arXiv 頁面也未見 withdrawn 或 retracted 標記。

兩篇有獨立價值：HuRo 處理 VLA 的資料供應與 human-to-robot observation–action 對齊；ReactHuman 處理 embodied MLLM 從物理理解到可執行安全反應的診斷。前者問如何擴張 policy pretraining source，後者問如何避免把文字上答對誤認為實體行動能力，不是為湊數選取的近似題目。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫，Introduction 均由官方 arXiv HTML 取得；未讀後續方法、benchmark 細節、實驗、結果、限制與附錄。

## 今日選文

1. [HuRo: Robotizing Human Videos for Scalable VLA Pretraining](./01-huro-robotized-human-video-vla.md)
   - arXiv：2609.10706v1
   - 分類：cs.RO、cs.CV、cs.LG
   - 選擇理由：把 human-video scaling 的前提拆成視覺與動作兩層 embodiment alignment，直接處理 real-robot data 稀缺與 VLA 預訓練資料介面問題。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [ReactHuman: A Physics-Grounded Benchmark for Human-Like Reactive Decision-Making in Embodied Multimodal LLMs](./02-reacthuman-physics-grounded-reaction.md)
   - arXiv：2609.10895v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：將 MLLM 的突發危險判斷變成由模擬人形機器人執行的計畫，並分離合理性、安全與物理 grounding，補足被動 VQA 與長時序 benchmark 中間的評估缺口。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋先查 arXiv export API 的 cs.RO、cs.CL、cs.AI 與 cs.LG；cs.CL 成功取得，其他 API queries 遭 HTTP 429，因此改讀官方 cs.RO new listing，並以 VLA、embodied、MLLM、robot learning、world model、manipulation 等方向篩選。
- 對 HuRo、ReactHuman 與 IMLE-VLA 等近期候選取得官方 abs 與 HTML，再按主題交會程度、問題的重要性及與前一日筆記的重複程度選取。
- HuRo 與 ReactHuman 都在近 7 天範圍內；metadata、abstract 與 Introduction 均來自官方 arXiv，未以標題或 teaser 代替正文。
- 未選 IMLE-VLA 的主要原因不是品質不足，而是前一日已收錄 action generator 的頻率／採樣瓶頸；今日兩篇分別補上資料管線與可執行安全評估，資料庫邊際價值較高。
- 第二篇具有獨立價值，因此本日收錄 2 篇且未超過每日上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
