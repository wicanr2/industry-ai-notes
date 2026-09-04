# 2026-09-04 論文拆解

本日新增 2 篇 2026-09-02 投稿的近期 Physical AI／Embodied AI 論文，均位於最近 2 天，arXiv ID 未在 repo 既有筆記出現；官方 arXiv metadata／HTML 未見 withdrawn 或 retracted 標記。

兩篇有獨立價值：第一篇檢查 world model 的離線 rollout 指標是否能代表 feedback control；第二篇澄清 VLA strict／pretrain-exposed zero-shot，並受控分析跨 embodiment transfer。前者是評估協定與閉迴路資訊結構，後者是 VLA 的資料 exposure、表示與硬體泛化，不是為湊滿上限而選相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [Do Better Imagined Rollouts Mean Better Robot Control? A Controlled Study of World-Model Evaluation Under Feedback](./01-world-model-evaluation-under-feedback.md)
   - arXiv：2609.02811v1
   - 分類：cs.RO
   - 選擇理由：把 prediction horizon 與 measurement-update interval 分開，檢查離線 world-model ranking 是否對齊閉迴路控制。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [ZETA: A Controlled Study of Zero-Shot Cross-Embodiment VLA Transfer for Tabletop Manipulation](./02-zeta-cross-embodiment-vla-transfer.md)
   - arXiv：2609.02546v1
   - 分類：cs.RO
   - 選擇理由：區分 strict 與 pretrain-exposed zero-shot，並控制資料預算以拆解 representation、source diversity、co-training 與 target exposure。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋使用 arXiv export API，涵蓋 cs.RO、cs.CL、cs.AI，並篩選 robot、embodied、VLA、manipulation、navigation、world model、LLM、agents、reasoning 與 tool use。
- 執行前依防重入規則確認本日資料夾不存在，當日非 README 論文筆記為 0；兩篇 arXiv ID 亦未在 repository 出現。
- 第二篇不是第一篇的近似變體：一篇處理 feedback-aligned evaluation，一篇處理 cross-embodiment VLA protocol 與 transfer factors，因此本日收錄 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
