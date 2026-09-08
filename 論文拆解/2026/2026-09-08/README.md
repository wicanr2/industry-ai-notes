# 2026-09-08 論文拆解

本日新增 2 篇最近 4 天內的 LLM／VLM + Robotics 交會論文。兩篇 arXiv ID 均未在 repo 既有筆記出現，官方 abs 頁未見 withdrawn 或 retracted 標記。

兩篇有獨立價值：RoboRMBench 檢查語意等價改寫是否讓相同機器人軌跡得到矛盾 reward；LSS 則將 physical-reasoning rationale 當成訓練期表徵鷹架，嘗試避免部署時逐步生成 reasoning 的成本。前者是 reward 介面的不變性，後者是 action policy 的語意 supervision 與推論效率，不是為湊數而選的近似題目。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [Same Trajectory, Contradictory Rewards (ROBORMBENCH): Paraphrase Fragility in Vision Language Reward Models](./01-robormbench-paraphrase-fragility.md)
   - arXiv：2609.05401v1
   - 分類：cs.RO、cs.CL
   - 選擇理由：將 paraphrase robustness 從語言品質問題連到 robot reward 與政策優化，並以固定軌跡、只改寫指令的設計隔離語言介面脆弱性。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [Reasoning Without Inference Cost: Latent Semantic Scaffolding for Robot VLA Policies](./02-latent-semantic-scaffolding-vla.md)
   - arXiv：2609.04893v1
   - 分類：cs.RO
   - 選擇理由：區分推論時生成 reasoning 與訓練時語意表徵塑形，並比較 phase-local 與 episode-pooled alignment，對低延遲長時序 VLA 有獨立方法價值。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋使用 arXiv export API，取得按 submitted date 排序的 cs.RO 最近 100 篇，並以 language、LLM、VLA、embodied、world model、reasoning、agent 等詞篩選；另嘗試 cs.CL、cs.AI 與 cs.CV，官方 API 本次回傳 timeout 或 HTTP 429，故未把失敗查詢當成完整發現來源。
- 本日兩篇都在近 7 天範圍內；metadata 與 abstract 來自官方 Atom entry，Introduction 來自官方 arXiv HTML，未以標題或 teaser 代替正文。
- 執行前依防重入規則確認本日非 README 論文筆記為 0；兩篇 arXiv ID 亦未在 repository 出現。
- 第二篇具獨立價值：一篇測 reward 對語言等價變換的穩定性，一篇把 reasoning supervision 移到 VLA 訓練期，因此本日收錄 2 篇且未超過每日上限。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
