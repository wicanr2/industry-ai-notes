# 2026-09-10 論文拆解

本日新增 2 篇 2026-09-08 提交的 LLM／VLM + Robotics 交會論文。執行前本日非 README 論文筆記為 0；兩篇 arXiv ID 均未在 repository 出現，官方 arXiv 頁面也未見 withdrawn 或 retracted 標記。

兩篇有獨立價值：TANGO 把語言導航從二維 waypoint 提升為人形機器人的全身時變幾何與 29-DoF 動作問題；DeCAL 則以接觸感知的觸覺調度與視觸未來想像，處理靈巧操作中的遮擋與物理部分可觀測性。前者重點是 whole-body traversability，後者重點是 contact-rich manipulation，不是為湊數而選的近似題目。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫，Introduction 均由官方 arXiv HTML 取得；未讀後續方法、實驗、結果、限制與附錄。

## 今日選文

1. [TANGO: Humanoid Navigation in Cluttered Environments with a Whole-Body Vision-Language-Action Model](./01-tango-whole-body-vla-navigation.md)
   - arXiv：2609.09158v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：把人形導航的路徑、全身姿態與碰撞幾何放入同一 VLA action space，挑戰把 agent 簡化成二維點或固定 footprint 的慣例。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [DeCAL: Towards Physically-Grounded Dexterous Vision-Language-Action Models via Contact-Aware Latent Co-Imagination](./02-decal-visuotactile-vla.md)
   - arXiv：2609.09119v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：不只把觸覺加進 VLA，而是問何時應提高觸覺權重，並聯合建模未來視覺與接觸動態，直指靈巧操作的部分可觀測性。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋查詢 arXiv export API 的 cs.RO、cs.CL、cs.AI 與 cs.CV recent results，並以 robot、embodied、VLA、manipulation、humanoid、reasoning、agent 等詞篩選；其中一組複合查詢收到 HTTP 429，之後以較簡單的 cs.RO 查詢取得並核對候選。
- 兩篇皆在近 7 天範圍內；metadata、abstract 與 Introduction 均來自官方 arXiv，未以標題或 teaser 代替正文。
- 第二篇具獨立價值：一篇處理全身導航的動作表示與資料生成，一篇處理觸覺條件融合與接觸未來建模，因此本日收錄 2 篇且未超過每日上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
