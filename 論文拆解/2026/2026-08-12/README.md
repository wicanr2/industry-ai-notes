# 2026-08-12 論文拆解

今日新增 2 篇。兩篇都位於 VLA、robot learning 與 world-model-style supervision 的交會，但處理不同部署邊界，因此各有獨立價值，並非為湊足篇數而選。

## 今日選文

1. [VANE: Reliable Test-Time Training for Vision-Language-Action Models via Future Visual Representation Prediction](./01-vane-reliable-test-time-training.md)
   - **選擇理由**：把 VLA 的部署期適應改寫成 proposal、shadow validation、commit / rollback 流程，直接處理閉迴路中「未驗證更新會改變後續軌跡」的問題。
   - **閱讀範圍**：arXiv Summary/Abstract + Introduction；未讀其他章節。
2. [JEPA-WAM: Learning Vision-Language-Action Policies with Joint-Embedding World Modeling](./02-jepa-wam-joint-embedding-world-modeling.md)
   - **選擇理由**：把 latent world action model 拆成 predictive target 與 policy integration 兩個問題，用密集 current–future joint representation 塑造 action backbone，且部署時移除預測支線。
   - **閱讀範圍**：arXiv Summary/Abstract + Introduction；未讀其他章節。

## 收錄邊界

- 本日兩篇皆為 arXiv:2608.0xxxx 的近期新稿，repo 內未發現相同 arXiv ID。
- 所有成效數字只轉述摘要或 Introduction 的作者宣稱；筆記未核實 Methods、Experiments、Results 或附錄。

## Commit 狀態

- 已建立筆記與索引；commit / push 資訊以 Git 歷史為準。
