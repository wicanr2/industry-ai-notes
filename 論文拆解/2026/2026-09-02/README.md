# 2026-09-02 論文拆解

本日新增 2 篇 2026-09-01 投稿的近期論文，均位於最近 1 天，arXiv ID 未在 repo 既有筆記出現；官方 arXiv HTML 頁面未見 withdrawn / retracted 標記。

兩篇都有獨立價值，也都位於 LLM／VLM 與 Robotics／Embodied AI 的交會：VerNav 處理 VLN 中何時應支付生成式語意推理成本；Adaptive Action Chunking 處理 VLA 中一批連續動作可開迴路執行到何時。前者調節決策架構的生成路徑，後者調節控制迴路的重新感知頻率，不是為湊滿上限而選相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [VerNav: Verifier-First Low-Latency Vision-and-Language Navigation](./01-vernav-verifier-first-vln.md)
   - arXiv：2609.00920v1
   - 分類：cs.RO、cs.CV
   - 選擇理由：將逐步生成改為 verifier-first 的條件式計算，只有高不確定導航決策才生成額外 state evidence，直接對應具身 agent 的閉環延遲問題。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [Knowing When to Stop: Adaptive Action Chunking via Internal Cross-Attention Dynamics in VLAs](./02-adaptive-action-chunking-cross-attention.md)
   - arXiv：2609.00908v1
   - 分類：cs.RO
   - 選擇理由：用 action expert 既有的 cross-attention entropy 判斷當前觀察還能支撐多遠的未來動作，將內部訊號轉成動態閉環控制邊界。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 cs.RO、cs.AI、cs.CL、cs.LG，並檢查 VLN、VLA、robotics、embodied AI、agents、reasoning、tool use 與 RL。
- 執行前已依防重入規則確認本日資料夾沒有非 README 論文筆記；兩篇 arXiv ID 亦未在 repository 出現。
- 第二篇與第一篇分別處理 manipulation action execution 與 navigation decision routing，具有獨立研究問題，因此本日收錄 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
