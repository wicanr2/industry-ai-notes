# 2026-08-04 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍新增 2 篇。arXiv API 在本次查詢中最新可取得的相關投稿日期為 2026-07-31，仍在近 7 天範圍內；兩個 arXiv ID 均未在 repo 出現，也未見 withdrawn / retracted 標記。

兩篇都有獨立價值：WCM 處理 VLA 強化學習中 critic 如何從歷史形成 predictive state；HAM-VLN 處理 MLLM 導航 agent 如何以空間化、階層式記憶控制長程 context。前者是 value representation，後者是 agent memory 與導航決策，並非為湊滿上限而選擇相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [WCM: A World Critic Model for Vision-Language-Action Reinforcement Learning](./01-wcm-world-critic-model.md)
   - arXiv：2607.29613v1
   - 分類：cs.RO、cs.CL、cs.CV
   - 選擇理由：把 critic 的 partial-observability 問題從「加入更多歷史」推進到「用 future-latent prediction 學 predictive state」，直接連結 VLA、RL 與 world model。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [HAM-VLN: Harnessing Hierarchical Agentic Memory for Zero-Shot Vision-and-Language Navigation](./02-ham-vln-hierarchical-agentic-memory.md)
   - arXiv：2607.29600v1
   - 分類：cs.RO
   - 選擇理由：把 MLLM agent memory 與深度定位的 world graph、導航進度及失敗反思綁在同一次決策呼叫，提供長程 embodied agent 的成本與記憶設計案例。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 今日看過但未選

- 2607.29596v1｜FibVLA：以 Fibonacci sampling 壓縮時間觀測，效率議題合適；但今日 WCM 的 state-representation 問題與 HAM-VLN 的 agent-memory 問題具有更清楚且互補的第一性缺口。
- 2607.29172v1｜CLIFT：以 closed-loop iterative fine-tuning 適配閉源 robot foundation model，部署議題很有價值；但需要更仔細核對其資料生成與 API access 假設，留待後續。
- 2607.29687v1｜Diagnosing Compositional Generalization in Sequential Robot Tasks：組合泛化診斷值得追蹤；今日先優先收錄更直接位於 LLM/VLA 與 robotics 交會的兩篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
