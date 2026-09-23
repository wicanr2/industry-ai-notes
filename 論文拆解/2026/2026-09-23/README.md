# 2026-09-23 論文拆解

本日新增 2 篇近期 Physical AI／Embodied AI 論文。執行前本日非 README 論文筆記為 0；兩篇 arXiv ID 均未在 repository 出現，官方 arXiv 頁面也未見 withdrawn 或 retracted 標記。

兩篇價值彼此獨立：第一篇處理 embodied world model 的多視角評估單位，問多段看似合理的影片是否共同描述同一個物理事件；第二篇處理 world-action model 的表示介面，問連續動作能否寫成視覺 backbone 原生 token，避免額外 action expert。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由官方 arXiv HTML 擷取，且只讀至 Related Work 前。未讀後續方法、實驗、結果、限制與附錄。

## 今日選文

1. [TriWorldBench: A Tri-View Consistency Perspective on Embodied World Models](./01-triworldbench-multiview-world-model-evaluation.md)
   - arXiv：2609.26314v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：把 world-model evaluation 從逐視角畫質提升為共同事件的一致性、任務對齊與相機角色感知評估。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML，讀至 Related Work 前）

2. [An Action Is Worth One Patch: Unified World–Action Modeling with PatchWAM](./02-patchwam-action-as-visual-token.md)
   - arXiv：2609.25961v1
   - 分類：cs.RO
   - 選擇理由：用固定 Action-as-Patch codec 測試 action generation 究竟需要專用 expert，還是主要受限於與視覺 backbone 不相容的表示介面。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML，讀至 Related Work 前）

## 選文說明

- 候選搜尋涵蓋 cs.RO、cs.AI、cs.CL、cs.CV 與 cs.LG，並以 robot／embodied／VLA／manipulation／navigation／world model／LLM／agent／reasoning 等關鍵詞篩選，依 arXiv submittedDate 排序。
- 已檢查 repository，兩個不含版本號的 arXiv ID 均未重複。
- TriWorldBench 聚焦評估證據；PatchWAM 聚焦 action representation 與共享生成路徑，兩者不是同類方法的重複收錄。
- 本日共收錄 2 篇，未超過每日自動選文上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
