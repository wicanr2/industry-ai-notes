# 2026-09-22 論文拆解

本日新增 2 篇近期 LLM／VLM + Robotics 與 Physical AI 論文。執行前本日非 README 論文筆記為 0；兩篇 arXiv ID 均未在 repository 出現，官方 arXiv HTML 也未見 withdrawn 或 retracted 標記。

兩篇價值彼此獨立：第一篇問如何用離散動作介面與少量情境示範，把凍結 VLM 的既有能力轉接到閉環 robot control；第二篇問 mobile manipulator 如何在可移動障礙中共同處理路徑、relocation、接觸可行性與依賴推理，並採用「LLM 提案、幾何規劃驗證」的受限分工。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由官方 arXiv HTML 擷取，且只讀至 Related Work 前。未讀後續方法、實驗、結果、限制與附錄。

## 今日選文

1. [Transferring the Intelligence of VLMs to Robotic Control](./01-robodawn-vlm-robot-control.md)
   - arXiv：2609.22966v1
   - 分類：cs.RO
   - 選擇理由：把 robot learning 的瓶頸拆成能力缺口與介面缺口，探索 frozen VLM + discrete action interface + ICL demonstrations 的閉環控制路徑。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML，讀至 Related Work 前）

2. [Manipulation Feasible Navigation Among Movable Obstacles with Discrete Contact Pushing](./02-namo-llm-verified-dependencies.md)
   - arXiv：2609.23312v1
   - 分類：cs.RO
   - 選擇理由：把 navigation benefit、relocation feasibility 與 whole-body pushing 串成分層系統，並用幾何 verifier 約束 LLM 的 dependency hypotheses。
   - 閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML，讀至 Related Work 前）

## 選文說明

- 候選搜尋涵蓋 cs.RO、cs.AI、cs.CL，以及 robot／robotics／embodied／manipulation／navigation／humanoid／VLA／LLM／agent／reasoning 等關鍵詞，並以 arXiv export API 的 submittedDate 排序。
- 已檢查 repository，兩個不含版本號的 arXiv ID 均未重複。
- RoboDawn 聚焦以介面轉移 VLM 能力；NAMO 論文聚焦可驗證的環境重配置與接觸執行，不是相近方法的重複收錄。
- 本日共收錄 2 篇，未超過每日自動選文上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
