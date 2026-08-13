# 2026-08-13 論文拆解

今日新增 2 篇。兩篇都位於語言／視覺模型與機器人控制的交會，但分別處理「如何從失敗學後果」與「action token 如何保留語意」兩個獨立瓶頸，因此不是為湊足篇數而選。

## 今日選文

1. [FACT: Failure-Aware Causal Training for World-Action Models](./01-fact-failure-aware-world-action-model.md)
   - **選擇理由**：把失敗 rollout 從不可模仿的壞示範，改寫成可用的 action-conditioned consequence supervision；直接關係到 WAM、自我改進與安全候選動作評分。
   - **閱讀範圍**：arXiv Summary/Abstract + Introduction；未讀其他章節。
2. [Lost in Reconstruction: Aligning Action Representations with Language in Vision-Language-Action Models](./02-salt-language-aligned-action-tokenizer.md)
   - **選擇理由**：指出 reconstruction-only action tokenizer 可能在語言進入 policy 前就丟掉動詞相關結構，將 language grounding 問題推進到 VLA 的 action interface。
   - **閱讀範圍**：arXiv Summary/Abstract + Introduction；未讀其他章節。

## 收錄邊界

- 兩篇皆為最近 3 天內發布的 arXiv v1 新稿，且 repo 內未發現相同 arXiv ID。
- Introduction 均由 arXiv HTML 成功取得。
- 所有成效數字只轉述 Abstract 或 Introduction 的作者宣稱；筆記未核實 Methods、Experiments、Results 或附錄。

## Commit 狀態

- 已建立筆記與索引；commit / push 資訊以 Git 歷史為準。
