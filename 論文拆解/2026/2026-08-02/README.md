# 2026-08-02 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍新增 2 篇。週末 arXiv 沒有更新批次，因此採用最近可取得的 2026-07-30 新投稿；兩個 arXiv ID 均未在 repo 出現，也未見 withdrawn / retracted 標記。

兩篇都有獨立價值：World Action Planner 聚焦 VLM 與 world model 如何在測試時提出、預演與修正機器人計畫；Behavior-Aligned Representations 則聚焦 VLA 如何利用語言、物體與末端軌跡等中介表示，把多 embodiment 資料轉成可轉移能力。不是為了湊滿上限而選擇相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [World Action Planner: Generalizable Decision-Making with Action-Conditioned World Models](./01-world-action-planner.md)
   - arXiv：2607.27599v1
   - 分類：cs.AI、cs.RO
   - 選擇理由：把 VLM 的語意規劃與 action-conditioned world model 的物理預演接成閉環，直接處理端到端 imitation policy 對新 layout、組合任務與長期轉場的泛化瓶頸。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [Cross-Embodiment Transfer via Behavior-Aligned Representations](./02-behavior-aligned-cross-embodiment.md)
   - arXiv：2607.27549v1
   - 分類：cs.RO、cs.AI、cs.CV、cs.LG
   - 選擇理由：追問異質 robot data 為何不會自動帶來 transfer，並比較 language motions、bounding boxes、end-effector traces 等跨硬體中介表示；對 VLA 資料 scaling 與語言在 Physical AI 中的合理角色都有價值。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 今日看過但未選

- 2607.28624v1｜PhiZero: A World Model Built Around Physical Language：physical-language world model 很有潛力，但摘要與分類較偏通用影片生成 / 理解；相較之下，今日兩篇的 robot action、planning 與 cross-embodiment 問題更直接。
- 2607.27782v1｜RedFlow：以 failure rollout 建立 flow-matching VLA 的 action-level correction，主題合適；但今日已用 WAP 處理 test-time planning、以 behavior alignment 處理 data transfer，兩者提供更互補的研究問題。
- 2607.28391v1｜TacWAM：觸覺 future supervision 對 contact-rich manipulation 有價值；但近期資料庫已有多篇 WAM representation 筆記，今日優先補足 VLM planner 與 cross-embodiment alignment。

## Commit 狀態

- 待本次 cron 完成 commit / push 後，以最終回覆中的 commit SHA 為準。
