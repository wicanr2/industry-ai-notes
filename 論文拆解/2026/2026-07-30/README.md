# 2026-07-30 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍選文，實際新增 2 篇。兩篇皆為 2026-07-28 提交、2026-07-29 出現在 arXiv recent list，且 arXiv ID 未在 repo 出現的新論文；共同聚焦 robot world representation，但獨立處理兩個瓶頸：INTACT 處理 forward model 的反向控制與搜尋成本，DC-WAM 處理 RGB future supervision 的容量錯置與 appearance OOD。兩篇都有獨立價值，並非為湊滿上限。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫，Introduction 由 arXiv HTML 成功取得；未讀全文其他章節。

## 今日選文

1. [INTACT: Isomorphic Intent-to-Action Learning for Search-Free World Models](./01-intact-search-free-world-model-control.md)
   - arXiv：2607.26056v1
   - 分類：Robotics（cs.RO）
   - 選擇理由：把 latent world model 的部署瓶頸定位為 forward prediction 與 inverse action interface 的不對稱，並探索讓搜尋從必要 solver 降為選配 verifier；對即時 Physical AI 控制與 representation-as-interface 都有整理價值。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [DC-WAM: Dynamic-Centric Visual Supervision and Reasoning for World-Action Models](./02-dc-wam-dynamic-centric-supervision.md)
   - arXiv：2607.25918v1
   - 分類：Robotics（cs.RO）
   - 選擇理由：直接追問 photorealistic future prediction 是否把容量浪費在紋理、照明與背景，並以 interaction-induced dynamics 重配 supervision 與 attention；可累積 WAM、VLA robustness 與 training-rich / deployment-lean 的判斷框架。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 今日看過但未選

- 2607.25912v1｜SAM3D-Guided Object-Centric Representation Alignment for Vision-Language-Action Models：以 frozen SAM3D teacher 蒸餾 object-centric 3D prior，主題合適；但與 DC-WAM 同屬 training-time representation supervision，今日以 INTACT 補足控制介面的另一個獨立問題，不超過兩篇上限。

## Commit 狀態

- 待本次 cron 完成 commit / push 後，以最終回覆中的 commit SHA 為準。
