# 2026-07-26 論文拆解

今日防重入檢查：開始時 `論文拆解/2026/2026-07-26/` 已建立但沒有非 README 的 `.md` 論文筆記，當日既有非 README 論文筆記數為 0；本次新增 2 篇。兩篇都只根據 arXiv Summary/Abstract 與 Introduction 撰寫，未讀全文其他章節。

## 今日選文

1. [FORGE-plus: Force-Budgeted Recovery for Contact-Rich Assembly with a Frozen LLM Supervisor](./01-forge-plus-frozen-llm-supervisor.md)
   - arXiv：2607.21227v1
   - 主題：LLM supervisor / contact-rich assembly / force-bounded recovery / robot safety
   - 選擇理由：把 LLM 放在受限語意 supervisor 的位置，讓低階控制器硬性執行 force ceiling；這是 LLM + Robotics 中較務實的分層安全設計，不是單純端到端控制敘事。
   - 閱讀範圍：Summary/Abstract + Introduction。

2. [Beyond Episodic Evaluation: Memory Architectural Bottlenecks in Sequential Embodied Question Answering](./02-sequential-eqa-memory-bottlenecks.md)
   - arXiv：2607.21571v1
   - 主題：Embodied QA / sequential evaluation / robot memory architecture / LLM-VLM agents
   - 選擇理由：把 embodied QA 從每題 reset 的 episodic benchmark 推向連續場景，凸顯長期記憶、檢索與世界狀態維護對 Physical AI 的重要性。
   - 閱讀範圍：Summary/Abstract + Introduction。

## commit 狀態

- 本次完成後由 git commit / push 紀錄。
