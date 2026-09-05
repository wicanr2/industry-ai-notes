# 2026-09-05 論文拆解

本日新增 2 篇 2026-09-03 投稿的近期 Physical AI／LLM + Robotics 交會論文，均在最近 2 天內，arXiv ID 未在 repo 既有筆記出現；官方 arXiv abs／HTML 未見 withdrawn 或 retracted 標記。

兩篇有獨立價值：WISE 處理 world-model imagination 應如何分配給 VLA post-training；FailBench 則檢查 VLM 作為 robot success judge 時的跨來源與物理證據邊界。前者關心政策如何從候選未來學習，後者關心提供評估／reward 訊號的 judge 是否可靠，形成互補而非近似選題。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [WISE: World-model-guided Imagination Scheduling for Efficient Post-training of Vision-Language-Action Models](./01-wise-imagination-scheduling-vla.md)
   - arXiv：2609.03681v1
   - 分類：cs.RO
   - 選擇理由：把 world-model post-training 拆成關鍵狀態選擇、有界 rollout 與相對監督，正面處理 VLA 的真機互動、模型誤差與算力取捨。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [FailBench: How Reliable are VLMs at Judging Robot Task Success?](./02-failbench-vlm-robot-success-judging.md)
   - arXiv：2609.03611v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：跨 14 個來源測試 VLM robot failure detectors，並把粗略物體位移與接觸證據的可觀測性分開，直接關係到自動 evaluator／reward 的可信度。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 arXiv cs.RO、cs.CL、cs.AI 最新 RSS，並以 robot、embodied、VLA、manipulation、humanoid、world model、LLM、agents、reasoning 與 tool use 等詞篩選；export API 首輪逾時／限流後改用官方 RSS 完成候選發現，再以官方 abs 與 HTML 驗證 metadata、abstract 與 Introduction。
- 執行前依防重入規則確認本日資料夾不存在，當日非 README 論文筆記為 0；兩篇 arXiv ID 亦未在 repository 出現。
- 第二篇不是為補足篇數而選的近似變體：一篇處理 VLA 的想像式後訓練，一篇處理 VLM evaluator 的證據與泛化，因此本日收錄 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
