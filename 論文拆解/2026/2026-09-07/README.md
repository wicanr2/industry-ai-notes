# 2026-09-07 論文拆解

本日新增 2 篇最近 5 天內的 VLA／Robotics 論文。兩篇 arXiv ID 均未在 repo 既有筆記出現，官方 abs 頁未見 withdrawn 或 retracted 標記。

兩篇有獨立價值：EGR 研究 VLA 如何依狀態分辨當下真正有用的感測模態，R2S-Eval 則研究如何以 real-to-sim 與 VLM preference 建立較可擴展的政策評估。前者是多感測器控制的訓練可靠性，後者是 robot foundation model 的評估基礎設施，不是為湊數而選的近似題目。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [Sensing Which Modality Matters: Evidence-Gated Regularization for Robust VLA Policies](./01-evidence-gated-robust-vla.md)
   - arXiv：2609.03142v1
   - 分類：cs.RO、cs.CV、cs.LG
   - 選擇理由：把多模態 robustness 拆成忽略無關干擾與依賴有效單一模態兩個狀態相依問題，適合檢查 VLA 的 sensor fusion 是否學到真正任務證據。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [R2S-Eval: Robot Evaluation with Real-to-Sim Calibration via Vision-Language Models](./02-r2s-eval-vlm-robot-ranking.md)
   - arXiv：2609.03276v1
   - 分類：cs.RO
   - 選擇理由：將實機評估、校準模擬 rollout、VLM pairwise judge 與排序驗證串成 evaluation stack，可用來思考 Physical AI 擴展時的測試成本與代理偏差。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 arXiv cs.RO、cs.CL、cs.AI、cs.CV、cs.LG 的官方 recent 清單，並以 robot、embodied、VLA、manipulation、humanoid、world model、LLM、agents、reasoning 與 tool use 等詞篩選。
- 官方 export API 多數查詢本次回傳 HTTP 429 或 timeout，故改用官方 recent、abs 與 HTML 頁完成候選發現、metadata、abstract 與 Introduction 驗證；未以標題或 teaser 代替正文。
- 執行前依防重入規則確認本日非 README 論文筆記為 0；兩篇 arXiv ID 亦未在 repository 出現。
- 第二篇具獨立價值：一篇處理多模態政策的感測器捷徑，一篇處理政策評估的 sim/judge 代理鏈，因此本日收錄 2 篇，且未超過每日上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
