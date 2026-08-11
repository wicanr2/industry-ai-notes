# 2026-08-11 論文拆解

今日新增 2 篇。兩篇都有獨立價值：一篇從網路深度追蹤駕駛 VLA 的 planning token，區分資訊可讀出與原生規劃器可用；另一篇處理腕部相機下的空間部分可觀測與長時域任務進度遺忘。兩者分別對應單次決策的表示介面與跨時間狀態維持，並非為湊篇數而選的相近變體。

## 今日選文

1. [Depth-Wise Probing and Pruning of the Planning Token in a Driving Vision-Language-Action Model](./01-planning-token-depth-pruning.md)
   - arXiv ID：2608.07361v1
   - 選擇理由：把 LLM 內部表示診斷直接連到軌跡規劃介面與部署延遲，並明確區分資訊存在、介面相容與剪層效果。
   - 閱讀範圍：Summary/Abstract + Introduction；未讀其他章節。
2. [AtlasVLA: Persistent World-Ego State Modeling for Vision-Language-Action Models](./02-atlasvla-world-ego-memory.md)
   - arXiv ID：2608.06729v1
   - 選擇理由：把 wrist-only VLA 的失效拆成空間世界遺忘與任務進度遺忘，提供長時域 embodied control 可重用的雙狀態框架。
   - 閱讀範圍：Summary/Abstract + Introduction；未讀其他章節。

## 執行註記

- 兩篇皆為 2026-08-07 首次提交、近 7 天內的新稿；Introduction 均由 arXiv HTML 成功取得。
- arXiv API 本次回傳 HTTP 429，候選發現改由 arXiv 的 cs.RO、cs.CL、cs.AI recent 列表完成；論文 metadata、abstract 與 Introduction 仍直接取自各論文 arXiv 頁面。
- arXiv ID 已在寫入前搜尋 repo，未發現重複；2608.05715 已有筆記，已排除。
- 寫入後確認本日期資料夾只有 2 篇非 README 論文筆記。
- Commit / push：見本次提交紀錄。
