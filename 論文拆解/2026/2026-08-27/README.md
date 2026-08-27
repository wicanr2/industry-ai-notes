# 2026-08-27 論文拆解

本日新增 2 篇 LLM／多模態 foundation model 與 Robotics 交會論文。兩個 arXiv ID 均未在 repo 既有筆記出現，官方 abs 頁面未見 withdrawn / retracted 標記。

兩篇具有不同且獨立的價值：WorldEcho／WorldSync 檢驗 action-conditioned world model 是否真的服從 off-expert 動作，而不只生成合理影片；ARLI 則處理大型 VLA 推論延遲如何破壞 RL 的狀態假設。前者偏 learned simulator 的條件忠實度，後者偏即時控制與線上學習的系統時序，並非為湊滿上限而選相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [Do Robotic World Models Really Follow Actions?](./01-worldecho-worldsync-action-following.md)
   - arXiv：2608.24885v1
   - 分類：cs.RO、cs.CV
   - 選擇理由：把 world model 的評估從畫面合理性推進到 off-expert 動作下的條件忠實度，直接影響它能否成為 policy evaluation／improvement 的可靠模擬器。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [Learning to Act While Waiting](./02-arli-rl-under-vla-latency.md)
   - arXiv：2608.23831v2
   - 分類：cs.RO、cs.LG
   - 選擇理由：指出 VLA 推論延遲會進入環境動態並破壞標準 RL 的 Markov 假設，將模型速度、非同步控制與 online adaptation 放進同一問題設定。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- 候選搜尋涵蓋 cs.RO、cs.AI、cs.CL、cs.LG，並優先檢查 VLA、embodied AI、robot learning、world model、agentic robotics 與語言／多模態條件控制。
- arXiv API 複合查詢遇到 429 與 timeout，因此改讀 arXiv 官方 RSS，再逐篇回到官方 abs 與 HTML 驗證版本、作者、分類、摘要、Introduction 與撤稿狀態。
- 兩篇分別於 2026-08-25 與 2026-08-24 投稿；ARLI 於 2026-08-26 更新至 v2，均位於最近 7 天範圍。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 論文筆記，本次新增後為 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
