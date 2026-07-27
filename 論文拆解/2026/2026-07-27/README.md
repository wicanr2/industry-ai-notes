# 2026-07-27 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍選文；實際新增 2 篇。兩篇都偏向 Physical AI / LLM+Robotics 交會中的資料、語言 grounding 與 VLA 評估問題；只根據 arXiv Summary/Abstract 與 Introduction 撰寫，未讀全文其他章節。

## 今日選文

1. [AXIS: A Growable Community-Driven Data Engine for Scalable Robot Manipulation](./01-axis-scalable-robot-manipulation-data-engine.md)
   - arXiv：2607.21588v1
   - 分類：Robotics (cs.RO)
   - 選擇理由：把 robot manipulation 的 bottleneck 從單一 policy 轉向可持續擴張的資料引擎，包含社群遙操作、任務生成、成功檢查、資料清理與 VLA evaluation；適合放入 Physical AI 資料基礎設施脈絡。
   - 閱讀範圍：Summary/Abstract + Introduction

2. [Scale Up Strategically: Learning Compositional Generalization via Bias-Aware Evaluation and Data Collection for Robotic Manipulation](./02-bias-aware-compositional-robot-manipulation.md)
   - arXiv：2607.21582v1
   - 分類：Robotics (cs.RO)；Computer Vision and Pattern Recognition (cs.CV)
   - 選擇理由：針對 language-conditioned robot manipulation 的 shortcut 與 factor-level grounding 問題，提出用 FDR / FDH 診斷 instruction factor bias，再反過來指導資料收集；比單純擴充資料更接近可操作的 VLA 評估與資料策略。
   - 閱讀範圍：Summary/Abstract + Introduction

## 今日未選但留意

- 2607.21571｜Sequential EQA Memory：已於 2026-07-26 收錄，今日避免重複。
- 2607.21522｜GS-Agent：已於 2026-07-25 收錄，今日避免重複。

## Commit 狀態

- 待本次 cron 完成 commit / push 後，以最終回覆中的 commit SHA 為準。
