# 2026-08-14 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍新增 2 篇。兩篇皆為 2026-08-11 至 2026-08-12 的近期投稿，arXiv ID 未在 repo 出現，metadata 也未見 withdrawn / retracted 標記。

兩篇具有獨立價值：G0.5 檢視模型內部的統一 autoregressive reasoning-action stream；SHAPER 檢視凍結模型外部的 skill 與 context harness 演化。前者問「VLM 是否應直接成為 actor」，後者問「不改權重時應優化 agent system 的哪一層」，不是為湊滿上限而選擇相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [G0.5: One Autoregressive Stream for Robot Reasoning and Action](./01-g05-autoregressive-robot-reasoning-action.md)
   - arXiv：2608.11739v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：以學習式跨 embodiment action codec 壓縮控制 token，重新檢驗推理與動作由同一 VLM decoder 生成的可行性及代價。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [Self-Evolving Embodied Agents via Skill-Harness Evolution](./02-shaper-skill-harness-evolution.md)
   - arXiv：2608.11350v1
   - 分類：cs.CL、cs.RO
   - 選擇理由：把 embodied adaptation 從權重更新移到可重用技能與 context-code harness，連結 LLM agent systems、固定 action interface 與機器人適應。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 今日看過但未選

- 2608.11671v1｜StellaVLA：以結構化 demonstration 做 in-context OOD adaptation，價值明確；但和近期 notebook 已持續收錄的 in-context VLA 軸線較接近，今日優先保留 SHAPER 的 agent-harness 系統視角。
- 2608.11521v1｜RIFT：以 anticipation token 一次建立 future K/V cache，處理 world-action model 的 rollout latency；議題重要，但 2026-08-12 與 08-13 已收錄多篇 world-action model，今日先選架構分工更互補的兩篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
