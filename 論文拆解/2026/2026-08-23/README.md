# 2026-08-23 論文拆解

本日新增 2 篇 2026-08-20 投稿的 LLM/VLM + Robotics / Physical AI 交會論文。兩個 arXiv ID 均未在 repo 既有筆記出現，arXiv 頁面未見 withdrawn / retracted 標記。

兩篇處理不同資料瓶頸：EXIMO 用 VLM 引導既有 VLA 在新任務中探索、收集成功軌跡並蒸餾；What Matters for Latent Actions 則研究如何從大量無標註影片取得可供下游控制使用的 action prior。前者是適應期的互動資料生成，後者是預訓練期的影片表示，具有獨立價值，並非為湊滿每日上限而選擇近似變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [EXIMO: VLM Guided Exploration of VLA Policies](./01-eximo-vlm-guided-vla-exploration.md)
   - arXiv：2608.19891v1
   - 分類：cs.AI
   - 選擇理由：把 VLM 從永久線上規劃器改造成新任務探索與資料蒐集的臨時教師，再用 SFT 與 residual RL 內化能力。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [What Matters for Latent Actions in Robot Learning](./02-what-matters-latent-actions.md)
   - arXiv：2608.19613v1
   - 分類：cs.RO、cs.CV
   - 選擇理由：在共同框架比較 41 種 latent-action 設計，直接處理無標註影片如何轉成 action prior，以及便宜 proxy 能否預測下游控制效用。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 VLA、embodied AI、robot learning、LLM agent 與 tool use 等主題。arXiv API 複合查詢遇到 503 / 429，因此改用 Semantic Scholar 與 OpenAlex 做發現，再逐篇回到 arXiv abs 與 HTML 驗證版本、作者、分類、摘要、Introduction 與撤稿狀態。
- 兩篇皆在執行日前 3 天投稿，位於最近 7 天範圍。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 論文筆記，本次新增後為 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
