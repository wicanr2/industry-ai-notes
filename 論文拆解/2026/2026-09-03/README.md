# 2026-09-03 論文拆解

本日新增 2 篇 2026-09-01 投稿的近期論文，均位於最近 2 天，arXiv ID 未在 repo 既有筆記出現；官方 arXiv abs／HTML 頁面未見 withdrawn 或 retracted 標記。

兩篇都有獨立價值，且都位於 MLLM／VLA 與 Robotics／Embodied AI 的交會：EmbodiedSkills 處理 VLA agent 如何用 runtime skill contract 檢查、執行、驗證與恢復；DroneCATS 則固定 drone agent 架構，比較不同 MLLM 在搜索、接近、追蹤、多機指揮與自我終止協定上的能力。前者是可靠性架構，後者是能力診斷，不是為湊滿上限而選相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [EmbodiedSkills: A Unified Framework for Orchestrating, Training, and Deploying VLA Agents](./01-embodiedskills-vla-agent-runtime.md)
   - arXiv：2609.01281v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：以 executable skill contract 分離模型提案與 runtime 執行，並把 preflight、bounded execution、post-action verification 與 recovery 放入同一閉環。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [Evaluating Multimodal LLMs as Generalist Vision-Language-Action Agents for Drone Control: Commanding, Approaching, Tracking and Searching](./02-dronecats-mllm-drone-control.md)
   - arXiv：2609.01404v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：把搜索、移動、等待與 self-declared arrival 都交給可替換 MLLM，將 navigation 與 protocol adherence／termination 能力拆開觀察。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 arXiv cs.RO、cs.CL、cs.AI RSS，並篩選 robot、embodied、VLA、manipulation、navigation、LLM、agents、reasoning 與 tool use；arXiv export API 本次回傳 HTTP 429，因此改用官方分類 RSS 做 discovery，再以官方 abs／HTML 頁面核對內容與 provenance。
- 執行前已依防重入規則確認本日資料夾不存在，當日非 README 論文筆記為 0；兩篇 arXiv ID 亦未在 repository 出現。
- 第二篇不是第一篇的近似變體：一篇提出 agent runtime 與 skill interface，一篇建立 drone benchmark 並定位 action protocol／termination failure，因此本日收錄 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
