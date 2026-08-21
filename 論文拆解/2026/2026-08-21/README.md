# 2026-08-21 論文拆解

本日新增 2 篇 2026-08-20 投稿的 LLM / Robotics / Embodied AI 交會論文。兩個 arXiv ID 均未在 repo 既有筆記出現，arXiv 頁面未見 withdrawn / retracted 標記。

兩篇處理不同層次：EAFG 把部分可觀測下的「先驗不是證據」轉成主動取證、可行性閘門與停止決策；DECOWAM 則把足式移動操作中的底座、手臂與相機 ego-motion 重新拆成語意對齊的 world-action interfaces。前者偏規劃控制流，後者偏 embodiment-aware 表示，具有獨立價值，並非為湊滿每日上限而選擇相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [Evidence-Gated Task and Motion Planning with Vision-Language Models](./01-eafg-evidence-gated-tamp.md)
   - arXiv：2608.20084v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：把 VLM 的世界先驗降為待驗證假設，透過可執行探索取得現場證據，再決定規劃、繼續取證或停止。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [DECOWAM: Decoupled Whole-Body World-Action Model for Legged Mobile Manipulation](./02-decowam-whole-body-world-action.md)
   - arXiv：2608.20114v1
   - 分類：cs.AI、cs.RO
   - 選擇理由：將移動操作相對固定底座的差異具體拆成動態視角、多頻率控制與階層意圖，並用顯式因子化處理全身 world-action prediction。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 cs.RO / cs.AI / cs.CL / cs.CV 的 robot、embodied、VLA、reasoning 與 agent 關鍵詞；部分 arXiv API 查詢遇到 429，因此以成功取得的跨分類最新結果做有界選擇，不以較舊弱項補量。
- 兩篇均在執行日前一日投稿，屬最近 1 天的新論文。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 論文筆記，本次新增後為 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
