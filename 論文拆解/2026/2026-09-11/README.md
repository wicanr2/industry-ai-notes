# 2026-09-11 論文拆解

本日新增 2 篇 2026-09-09 提交的 VLM／VLA + Robotics 交會論文。執行前本日非 README 論文筆記為 0；兩篇 arXiv ID 均未在 repository 出現，官方 arXiv 頁面也未見 withdrawn 或 retracted 標記。

兩篇有獨立價值：Show-Harness 檢查 VLM 與機器人之間的語意 action interface，嘗試讓模型、人與不同 embodiment 共用離散微動作；FreqFM 則檢查 Flow Matching action generator 的座標與尺度假設，把軌跡頻率顯式納入 source、objective 與 guidance。前者是系統介面問題，後者是生成建模問題，不是為湊數選取的近似題目。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫，Introduction 均由官方 arXiv HTML 取得；未讀後續方法、實驗、結果、限制與附錄。

## 今日選文

1. [Show-Harness: Just a VLM Agent Can Play Robots](./01-show-harness-vlm-robot-interface.md)
   - arXiv：2609.10522v1
   - 分類：cs.RO、cs.AI、cs.CV、cs.MM
   - 選擇理由：把 embodied capability 的瓶頸部分重寫為 action interface 問題，探索封閉前沿 VLM、小型開源 VLM、人與不同機器人能否共用可讀、細粒度的操作語彙。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [Frequency-Conditioned Flow Matching for Vision-Language-Action Models](./02-frequency-conditioned-flow-matching-vla.md)
   - arXiv：2609.10405v1
   - 分類：cs.RO
   - 選擇理由：把 action trajectory 的頻率異質性顯式放進 Flow Matching 全管線，直指 action chunk 並非扁平向量，以及 source／loss／guidance 尺度不一致的問題。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋先查 arXiv export API 的 cs.RO、cs.CL、cs.AI 與 LLM／robotics 複合 queries；API 持續回 HTTP 429，之後改讀官方 cs.RO、cs.CL、cs.AI recent listing，各取得最近 100 筆並以 robot、embodied、VLA、manipulation、humanoid、reasoning、agent 等詞篩選。
- 另對 Show-Harness、FreqFM、generated-video manipulation 與 VLA data curation 等近期候選取得官方 abs 與 HTML，再按主題交會程度、問題的新穎性與兩篇之間的獨立價值選取。
- 兩篇皆在近 7 天範圍內；metadata、abstract 與 Introduction 均來自官方 arXiv，未以標題或 teaser 代替正文。
- 第二篇具獨立價值：一篇研究跨模型／跨 embodiment 的語意控制介面，一篇研究 action generator 的頻率條件化，因此本日收錄 2 篇且未超過每日上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
