# 2026-09-06 論文拆解

本日新增 2 篇 2026-09-03 投稿、於 2026-09-04 列入近期清單的 LLM／foundation model + Robotics 交會論文；兩篇都在最近 3 天內，arXiv ID 未在 repo 既有筆記出現，官方 abs 頁亦未見 withdrawn 或 retracted 標記。

兩篇有獨立價值：AdaRoboVLG 處理語意／情境先驗如何經由穩定介面進入跨機械手抓取合成；FWBC-VLA 處理接觸力的本體估計如何同時回饋 VLA 動作與全身補償。前者聚焦「任務理解—物理可行性」的模組邊界，後者聚焦「語意動作—接觸控制」的閉環，並非為湊數而選的近似變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [Adaptive Vision-Language Grasping via Composable Foundation Priors and Generalizable Grasp Synthesis](./01-adarobovlg-composable-grasp-priors.md)
   - arXiv：2609.04096v1
   - 分類：cs.RO、cs.AI、cs.CV
   - 選擇理由：用結構化抓取介面解耦 foundation-model priors 與物理抓取合成，能檢視模組更新、跨手型泛化與介面資訊瓶頸。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [FWBC-VLA: Force-Aware Whole-Body Compensation for Contact-Rich Loco-Manipulation](./02-fwbc-vla-force-aware-compensation.md)
   - arXiv：2609.03889v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：以本體訊號估計接觸演化，並讓高層 VLA 與低層 whole-body compensation 共用同一物理回饋介面，直接碰觸 contact-rich Physical AI 的部署難題。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 arXiv cs.RO、cs.CL、cs.AI、cs.CV、cs.LG 的官方 recent 清單，並以 robot、embodied、VLA、manipulation、humanoid、world model、LLM、agents、reasoning 與 tool use 等詞篩選。官方 export API 本次回傳 HTTP 429，故改以官方 recent、abs 與 HTML 頁完成候選發現、metadata、abstract 與 Introduction 驗證。
- 執行前依防重入規則確認本日資料夾不存在，當日非 README 論文筆記為 0；兩篇 arXiv ID 亦未在 repository 出現。
- 第二篇具獨立價值：一篇研究 foundation priors 與抓取合成的可組合介面，一篇研究 sensorless force feedback 與全身控制閉環，因此本日收錄 2 篇，且未超過每日上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
