# 2026-09-21 論文拆解

本日新增 2 篇 2026-09-18 提交的 LLM／VLM + Robotics 與 Physical AI 論文。執行前本日非 README 論文筆記為 0；兩篇 arXiv ID 均未在 repository 出現，官方 arXiv 頁面也未見 withdrawn 或 retracted 標記。

今天是週一、執行時間早於 arXiv 新一輪公告，因此從近 7 天候選中選取兩篇高價值論文。兩篇的價值彼此獨立：第一篇處理機器人故障後何時應自行行動、查感測器或向人求助；第二篇處理如何把大規模第一人稱人類互動資料對齊到 VLA／WAM 預訓練。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由官方 PDF 以 `pdftotext` 擷取，且只讀至第 2 節 Related Work 前。未讀後續方法、實驗、結果、限制與附錄。

## 今日選文

1. [When Should a Failing Robot Ask? Initiating Corrective Human-Robot Dialogue from Audited Sensor Evidence](./01-when-should-failing-robot-ask.md)
   - arXiv：2609.21942v1
   - 分類：cs.RO、cs.AI、cs.HC
   - 選擇理由：把「是否求助」拆成感測證據可診斷性、模型實測可靠度與求助成本，對 embodied agent 的故障恢復與不確定性治理有直接價值。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 PDF 文字抽取，讀至 Related Work 前）

2. [AtomEgo: Exploring Ego–Robot Integration for Embodied Foundation Model Pretraining](./02-atomego-ego-robot-pretraining.md)
   - arXiv：2609.21461v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：在統一問題設定下比較三種 ego–robot 共訓橋接路徑，讓「資料規模」與「embodiment alignment 品質」能被分開思考。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 PDF 文字抽取，讀至 Related Work 前）

## 選文說明

- 候選搜尋涵蓋 cs.RO、cs.AI、cs.CL，以及 robot／embodied／VLA／world model／agent／reasoning 等關鍵詞，並以 arXiv export API 的 submittedDate 排序。
- 已檢查 repository，兩個不含版本號的 arXiv ID 均未重複。
- 第一篇建立感測證據與求助政策的評估框架；第二篇建立 human ego data 與 robot data 的預訓練對齊框架，並非相近方法的重複收錄。
- 本日共收錄 2 篇，未超過每日自動選文上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
