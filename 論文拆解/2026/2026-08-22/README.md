# 2026-08-22 論文拆解

本日新增 2 篇 2026-08-19 至 2026-08-20 投稿的 VLA / Robotics 交會論文。兩個 arXiv ID 均未在 repo 既有筆記出現，arXiv 頁面未見 withdrawn / retracted 標記。

兩篇都研究 VLA 適應新技能時如何避免丟失舊能力，但解法位於不同層次：OrthoSkillVLA 管理參數更新的子空間、模組別容量與輸出解碼；Self-Demonstrated Generative Control 則在目標硬體上產生自我排練資料，管理微調資料的覆蓋範圍。這形成「更新幾何」與「資料排練」兩條可比較路徑，兩篇具有獨立價值，並非為湊滿每日上限而選擇近似變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [OrthoSkillVLA: Continual Skill Learning via Gradient-Informed Skill Subspace Adaptation](./01-orthoskillvla-continual-skill-subspace.md)
   - arXiv：2608.19589v1
   - 分類：cs.RO、cs.CV
   - 選擇理由：把 VLA 內部的語意、動作表示與速度讀出視為不同干擾介面，以模組別正交子空間 budget 與小型技能專家平衡穩定—可塑性。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [Fine-Tuning VLAs with Self-Demonstrated Generative Control for Multi-Task Manipulation](./02-self-demonstrated-vla-finetuning.md)
   - arXiv：2608.19490v1
   - 分類：cs.RO、cs.CV、cs.LG
   - 選擇理由：利用 base VLA 在目標硬體上的不完美 rollout 保存語意—行為先驗，處理跨 embodiment 微調的遺忘與專家資料成本。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 cs.RO 與 cs.CL 的最新 RSS，並檢視 VLA、embodied、robot learning、LLM agent 等題名；arXiv API 複合查詢遇到 429 / timeout，因此改以官方分類 RSS 取得最新候選，再用 arXiv Atom 單篇 metadata 與 HTML 驗證內容。
- 兩篇分別在執行日前 2 至 3 天投稿，位於最近 7 天範圍。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 論文筆記，本次新增後為 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
