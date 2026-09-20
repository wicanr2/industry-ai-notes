# 2026-09-20 論文拆解

本日新增 2 篇 2026-09-17 提交的 LLM／VLM + Robotics 交會論文。執行前本日非 README 論文筆記為 0；兩篇 arXiv ID 均未在 repository 出現，官方 arXiv 頁面也未見 withdrawn 或 retracted 標記。

今天是週日，arXiv 沒有當日新一輪平日公告，因此從近 7 天選取高價值候選。兩篇都在問如何避免把大型模型直接塞進每個控制步驟，但價值彼此獨立：SafeHarness 把語言安全限制轉成可驗證的規劃／接觸結構；Workspace Models 把 VLM 的歷史 saliency 判斷移到訓練期，再蒸餾成輕量記憶。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；第一篇 Introduction 由官方 arXiv HTML 取得，第二篇因 HTML 抽取不完整，改從官方 PDF 以 `pdftotext` 擷取且只讀至第 2 節前。未讀後續方法、實驗、結果、限制與附錄。

## 今日選文

1. [Coding Agents with an Obstacle-Aware Harness for Safe Robot Manipulation](./01-safeharness-coding-agent-safe-manipulation.md)
   - arXiv：2609.20822v1
   - 分類：cs.RO、cs.AI、cs.CL、cs.CV
   - 選擇理由：清楚區分 agent 能辨認／重述限制，與 harness 真正把限制編譯成路徑和接觸約束；對 embodied agent safety 有直接的架構意義。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML）

2. [Workspace Models: Lightweight Robotic Memory via Saliency-Driven Supervision](./02-workspace-models-robot-memory.md)
   - arXiv：2609.20820v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：把昂貴 VLM 從部署時記憶摘要器改成訓練期 saliency teacher，提供長期 robot memory、推論延遲與計算放置的獨立思考框架。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 PDF 文字抽取，讀至第 2 節前）

## 選文說明

- 候選搜尋涵蓋 cs.RO、cs.CL、robot／embodied／VLA／world model／agent／reasoning 等關鍵詞，並以 arXiv export API 的 submittedDate 排序。
- 已檢查 repository，兩個不含版本號的 arXiv ID 均未重複。
- 第二篇處理的是長期記憶與 compute placement，不是第一篇安全 harness 的近似變體，具有獨立價值，因此收錄 2 篇並未為湊滿上限。
- 本日共收錄 2 篇，未超過每日自動選文上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
