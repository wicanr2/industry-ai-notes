# 2026-09-09 論文拆解

本日新增 2 篇最近 5 天內的 LLM／VLM + Robotics 交會論文。兩篇 arXiv ID 均未在 repo 既有筆記出現，官方 abs 頁未見 withdrawn 或 retracted 標記。

兩篇有獨立價值：第一篇以 task graph、event memory、transition verification 與 VLA executor 拆分長時序操作系統；RoboSPA 則把細粒度空間 grounding、程序規劃與難度退化做成可診斷 benchmark。前者處理系統架構，後者處理測量基礎設施，不是為湊數而選的近似題目。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫，未讀全文其他章節。第一篇 Introduction 由 arXiv HTML 取得；RoboSPA 的 arXiv HTML 尚未提供，改由官方 PDF 擷取 Introduction，並因雙欄文字順序限制採保守表述。

## 今日選文

1. [Towards Neuro-Symbolic Procedural Reasoning for Long-Horizon Vision-Language-Action Manipulation](./01-neuro-symbolic-procedural-vla.md)
   - arXiv：2609.05369v1
   - 分類：cs.RO、cs.CV
   - 選擇理由：把長程序所需的依賴、分支、事件記憶與狀態驗證，和 VLA 的連續控制分層，提供可檢查的長時序系統觀點。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [RoboSPA: Can VLA Models Go Beyond Simple Scenes and Short-Horizon Tasks?](./02-robospa-spatial-procedural-assessment.md)
   - arXiv：2609.05324v1
   - 分類：cs.RO、cs.AI、cs.CV
   - 選擇理由：以空間／程序複雜度與五級難度壓力測試 VLA，並強調 step-level diagnosis，補足單一成功率難以定位失敗來源的缺口。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 arXiv PDF 擷取；HTML 尚未提供）

## 選文說明

- 候選搜尋檢查 arXiv 的 cs.RO、cs.CL、cs.AI、cs.LG 與 cs.CV recent listings，並以 robot、embodied、VLA、manipulation、world model、LLM、reasoning、agent 等主題篩選。官方 export API 本次回傳 HTTP 429 或 timeout，因此未把失敗的 API 查詢當成完整發現來源。
- 本日兩篇都在近 7 天範圍內；metadata 與 abstract 來自官方 abs 頁，Introduction 來自官方 arXiv HTML 或 PDF，未以標題或 teaser 代替正文。
- 執行前依防重入規則確認本日非 README 論文筆記為 0；兩篇 arXiv ID 亦未在 repository 出現。
- 第二篇具獨立價值：一篇提出 graph-memory-verification-VLA 分工，一篇建立可分級的空間與程序能力測量，因此本日收錄 2 篇且未超過每日上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
