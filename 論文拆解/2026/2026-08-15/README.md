# 2026-08-15 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍新增 2 篇。兩篇皆為 2026-08-13 的近期投稿，arXiv ID 未在 repo 出現，API metadata 也未見 withdrawn / retracted 標記。

兩篇具有獨立價值：第一篇把 LLM/VLM 的 representation probing 帶入 VLA runtime monitoring，區分可解碼性與可控制性；第二篇把 VLN 評估從理想化相機移到 humanoid model、controller、embodiment 與場景共同構成的物理系統。兩者不是為湊滿上限而選擇的相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [Decoding Task Progress from VLA Representations](./01-decoding-vla-task-progress.md)
   - arXiv：2608.13474v1
   - 分類：cs.RO
   - 選擇理由：用線性 probe 讀取 VLA 的任務進度，並明確檢驗「可觀察」是否等於「可 steering」，對部署監控與 VLA 可解釋性有直接價值。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [HumanoidVLN: A Physics-Grounded Simulator and Benchmark for Vision-Language Navigation Across Diverse Humanoid Embodiments](./02-humanoidvln-physics-grounded-benchmark.md)
   - arXiv：2608.12860v1
   - 分類：cs.RO
   - 選擇理由：將自然語言導航、雙足動力學、控制器與跨 humanoid morphology 納入同一 benchmark，補足理想化 VLN 評估忽略 physical execution 的缺口。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 今日看過但未選

- 2608.13438v1｜ContactGuard：pre-contact latent world-model monitoring 很接近實際安全需求，但近期 notebook 已密集收錄 world-action model；今日優先保留較少見的 VLA 內部進度解碼視角。
- 2608.13026v1｜Temporal GRPO：VLA post-training 的時間 credit assignment 議題重要，但與近期 RL / failure-aware VLA 軸線較接近；HumanoidVLN 的跨 embodiment 物理評估提供較獨立的資料庫價值。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
