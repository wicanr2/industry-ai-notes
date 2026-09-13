# 2026-09-13 論文拆解

本日新增 2 篇 2026-09-08 提交的 Physical AI／VLA + Robotics 交會論文。執行前本日非 README 論文筆記為 0；兩篇 arXiv ID 均未在 repository 出現，官方 arXiv 頁面也未見 withdrawn 或 retracted 標記。

今天是 arXiv 不公告新稿的週末，因此依規則從近 7 天候選選取。兩篇有獨立價值：No Free Checker 建立 robot verifier 的成本—可信度框架；SyncWorld 處理跨相機與 embodiment 的 action–visual mapping 校準。前者問誰能可信地評分行為，後者問 world model 如何在新 setup 中忠實模擬行為，不是為湊數選取的近似題目。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫，Introduction 均由官方 arXiv HTML 取得；未讀後續方法、survey 主體、實驗、結果細節、限制與附錄。

## 今日選文

1. [No Free Checker: A Survey of Verifiers for Robot Policies](./01-no-free-checker-robot-verifiers.md)
   - arXiv：2609.09250v1
   - 分類：cs.RO、cs.AI、cs.CV、cs.LG、eess.SY
   - 選擇理由：把訓練 reward、推論排序、安全監控與最終評估統整為 verifier，並用 availability 與 credibility 揭露 Physical AI 評分訊號的結構性取捨。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [SyncWorld: Visual Calibration Enables World Models as Zero-Shot Simulators](./02-syncworld-visual-calibration.md)
   - arXiv：2609.09155v1
   - 分類：cs.CV
   - 選擇理由：把跨相機、robot placement 與 embodiment 泛化收斂為 setup-specific Action–Visual Mapping，並將短校準互動改造成 world model 的 in-context 適應介面。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 VLA、robotics、embodied AI、world model 與 LLM／agent；arXiv export API 遭 HTTP 429，因此改用官方 arXiv search、abs 與 HTML 頁面，並按公告日期排序。
- 今天是週日，官方 cs.RO／cs.CL RSS 明示週六、週日跳過更新且無新 entries，因此依規則選取 2026-09-08 的近 7 天高價值論文。
- 已排除 repository 既有的 TANGO（2609.09158v1）與 HuRo（2609.10706v1）等重複候選。
- 兩篇 metadata、abstract 與 Introduction 均來自官方 arXiv；沒有以標題或 teaser 代替正文。
- 第二篇補足 world-model deployment calibration，與第一篇的 policy verification 問題互補，具有獨立價值；本日收錄 2 篇且未超過每日上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
