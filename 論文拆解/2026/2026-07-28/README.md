# 2026-07-28 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍選文；實際新增 2 篇。兩篇都偏向 LLM/MLLM 與 embodied / robotics 的交會：一篇看 generalist robot 的 inference-time orchestration，另一篇看 aerial MLLM agent 的 mission-level 評估。兩篇皆只根據 arXiv Summary/Abstract 與 Introduction 撰寫，未讀全文其他章節。

## 今日選文

1. [Addressing the Orchestration Gap in Generalist Robots via Physical Agency](./01-pigey-physical-agency-orchestration-gap.md)
   - arXiv：2607.21725v1
   - 分類：Robotics (cs.RO)
   - 選擇理由：直接切中 VLA / robot foundation model 的系統缺口：同一組 frozen skills 直接提示與放進閉環 orchestrator 時，任務能力可能差很多；適合累積「LLM/VLM 作為 robot manager」的思考框架。
   - 閱讀範圍：Summary/Abstract + Introduction

2. [Zero-Shot Mission-Level Evaluation for Aerial MLLM Agents](./02-missionbench-aerial-mllm-agents.md)
   - arXiv：2607.22014v1
   - 分類：Artificial Intelligence (cs.AI)；Computation and Language (cs.CL)；Computer Vision and Pattern Recognition (cs.CV)；Robotics (cs.RO)
   - 選擇理由：把 MLLM embodied evaluation 從單步視覺問答 / 導航推到閉環 mission-level 任務，能補上「Physical AI 如何評估高階任務能力」的資料庫脈絡。
   - 閱讀範圍：Summary/Abstract + Introduction；arXiv HTML 取得失敗，Introduction 由 PDF 轉文字擷取

## 今日未選但留意

- 2607.22535｜Robot-Factored World Models via Robot Rendering：很好的 Physical AI / world model 題目，但與今日兩篇相比，較偏 action-conditioned video world model，較少 LLM/MLLM 交會；先保留觀察。
- 2607.22530｜ViTacWorld：接觸豐富操作與 visuo-tactile world model 值得追，但今日已選兩篇更接近 LLM/MLLM embodied agent 主線。

## Commit 狀態

- 待本次 cron 完成 commit / push 後，以最終回覆中的 commit SHA 為準。
