# 2026-08-18 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍新增 2 篇，皆為 2026-08-14 投稿、在最近 7 天內的 Physical AI 論文。兩個 arXiv ID 均未在 repo 既有筆記中出現；arXiv 頁面未見 withdrawn / retracted 標記。

兩篇處理不同層次：BICPO-VLA 將非同步 action chunk 的推論延遲重述為行為正確與交棒連續的雙重控制問題；PRM-as-a-Judge 1.5 則將 rollout 從最終成功率展開成進度、退步與恢復的過程評估。方法與測量各有獨立價值，並非為湊滿每日上限而選擇的相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [BICPO-VLA: Behavior-Identified Continuation Preference Optimization for Smooth Asynchronous Vision-Language-Action Control](./01-bicpo-vla-asynchronous-handoff.md)
   - arXiv：2608.13924v1
   - 分類：cs.RO
   - 選擇理由：把非同步 VLA 的 request-to-handoff state drift 視為獨立控制問題，區分任務語意與交棒相容性，補足只談模型速度或一般平滑度的視角。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [PRM-as-a-Judge 1.5: A Toolkit for Robot Process Assessment](./02-prm-as-a-judge-robot-process-assessment.md)
   - arXiv：2608.14284v1
   - 分類：cs.RO、cs.CV
   - 選擇理由：用 progress curve 區分失敗端進展、退步後恢復與成功端品質，並把 process reward model 本身的可靠性納入評估，對 embodied model 比較有獨立價值。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 2026-08-18 可取得的最新一批 arXiv 候選主要為 2026-08-14 投稿；兩篇都在最近 4 天內，未使用較舊論文補量。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 的論文筆記，本次新增後為 2 篇。
- 今日也檢查了近期 VLA、embodied agent、world model、robot process assessment 與 LLM agent 候選；已收錄的 arXiv ID 均排除，第二篇因評估層價值與第一篇控制層價值不同而保留。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
