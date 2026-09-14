# 2026-09-14 論文拆解

本日新增 2 篇 2026-09-10 提交的 VLA + Robotics 交會論文。執行前本日非 README 論文筆記為 0；兩篇 arXiv ID 均未在 repository 出現，官方 arXiv 頁面也未見 withdrawn 或 retracted 標記。

今天是週一上午，arXiv 當日新稿尚未形成可穩定查核的候選集，因此依規則從近 7 天選取高價值論文。兩篇都處理 action head 的部署瓶頸，但價值彼此獨立：IMLE-VLA 問如何同時降低生成延遲並保留多模態動作；ActSafeGuard 問如何把硬限制一致地放入訓練與推論，而不是部署時才事後修正。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫，Introduction 均由官方 arXiv HTML 取得；未讀後續方法、證明、實驗、結果細節、限制與附錄。

## 今日選文

1. [IMLE-VLA: Fast Single-Step Action Generation for Vision-Language-Action Policies](./01-imle-vla-single-step-action-generation.md)
   - arXiv：2609.10915v1
   - 分類：cs.RO、cs.CV
   - 選擇理由：把 VLA 即時性重新定義為「單步生成如何保留多模態 action coverage」，避免只用普通 regression 以模式坍縮換取速度。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [ActSafeGuard: Differentiable and Training-Aligned Constraint Enforcement for Flow-Matching Policies](./02-actsafeguard-training-aligned-constraints.md)
   - arXiv：2609.11697v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：將 per-step hard feasibility 與 policy learning 放進同一個可微分算子，清楚區分「期望上安全」和「每一步都在形式化可行集合內」。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 cs.RO、cs.CV、cs.AI、VLA、embodied AI、world model、robot agent 與 LLM；arXiv export API 回傳 HTTP 429，因此改用官方 abs／HTML 頁面與搜尋索引交叉取得 metadata、abstract 與 Introduction。
- 已檢查 repository，兩個不含版本號的 arXiv ID 與 versioned ID 均未重複。
- 兩篇各自處理效率與硬限制，問題、評估指標與部署風險不同；第二篇具有獨立價值，不是為湊滿每日上限。
- 本日共收錄 2 篇，未超過每日自動選文上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
