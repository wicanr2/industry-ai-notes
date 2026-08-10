# 2026-08-10 論文拆解

今日新增 2 篇。兩篇都有獨立價值：一篇檢查 world model 是否能跨 robot embodiment 泛化；另一篇用真實量測診斷數值模擬器與生成式 world model 的物理忠實度，沒有以相近主題硬湊篇數。

## 今日選文

1. [XEWorld: Can Action-Conditioned World Models Generalize to Unseen Robot Embodiments?](./01-xeworld-cross-embodiment-world-models.md)
   - arXiv ID：2608.05799v1
   - 選擇理由：以 held-out robot 和相同場景隔離 embodiment 變因，直接檢驗 world model 學到的是可轉移動態還是視覺樣式。
   - 閱讀範圍：Summary/Abstract + Introduction；未讀其他章節。
2. [GAUGE: A Measurement-Grounded Benchmark for Physical Fidelity in Simulation Engines and Video World Models](./02-gauge-physical-fidelity-benchmark.md)
   - arXiv ID：2608.05948v1
   - 選擇理由：以真實軌跡、校準參數與不確定性，區分視覺合理、方程形式正確與物理參數正確，是 Physical AI 評估的重要基礎問題。
   - 閱讀範圍：Summary/Abstract + Introduction；未讀其他章節。

## 執行註記

- 兩篇皆為 arXiv 近 7 天內的新稿，Introduction 均由 arXiv HTML 成功取得。
- arXiv ID 已在寫入前搜尋 repo，未發現重複。
- 寫入後再次確認本日期資料夾只有 2 篇非 README 論文筆記。
- Commit / push：見本次提交紀錄。
