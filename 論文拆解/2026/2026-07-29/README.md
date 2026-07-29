# 2026-07-29 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍選文，實際新增 2 篇；兩篇皆為 2026-07-28 提交、arXiv ID 未在 repo 出現的新論文。第一篇處理 frozen VLA 的測試階段模態適應，第二篇處理 compact VLA 的結構化蒸餾與邊緣部署，價值相互獨立，並非為湊滿上限。兩篇都只根據 arXiv Summary/Abstract 與 Introduction 撰寫，未讀全文其他章節。

## 今日選文

1. [A Causality-aware Infer-diagnose-refine Framework for Test-time Modality Adaptation in VLA Models](./01-idr-test-time-vla-modality-adaptation.md)
   - arXiv：2607.25516v1
   - 分類：Robotics (cs.RO)
   - 選擇理由：把 VLA 模態融合改寫成逐時間步的 inference-time 診斷與修正問題，且不要求重訓 frozen backbone；適合累積 Physical AI 部署、反事實干預與動態感知依賴的思考框架。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [CoTinyVLA: Chain-of-Thought Distillation for a Sub-Billion-Parameter Vision-Language-Action Model](./02-cotinyvla-structured-supervision.md)
   - arXiv：2607.25487v1
   - 分類：Artificial Intelligence (cs.AI)；Computer Vision and Pattern Recognition (cs.CV)
   - 選擇理由：用雙視角時間輸入、分層 CoT 蒸餾與語言增強，挑戰「VLA robustness 必須依賴大型 backbone」的假設；同時連到 embedded robotics 的記憶體限制。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 今日未選但留意

- 2607.24744v1｜Data Pyramid for Embodied Manipulation：對 embodied data recipe 很有整理價值，但屬綜述／資源地圖，今日兩篇更集中於可檢驗的 VLA 系統問題，因此未超過每日上限。

## Commit 狀態

- 待本次 cron 完成 commit / push 後，以最終回覆中的 commit SHA 為準。
