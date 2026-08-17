# 2026-08-17 論文拆解

本日依「LLM / Physical AI / LLM + Robotics」範圍新增 2 篇，皆為 2026-08-14 的近期投稿。兩個 arXiv ID 均未在 repo 既有內容中出現；API metadata 與 arXiv HTML 未見 withdrawn / retracted 標記。

兩篇都位於 VLA 與機器人操作的交會，但解決不同邊界：Reflex 將未來狀態預判、推論延遲與動態 benchmark 放入同一閉環問題；ART 則將 agentic tool use 注入端到端 VLA，探索能力擴充與原動作 policy 隔離。兩者具有獨立資料庫價值，並非為湊滿每日上限而選擇的相近變體。

兩篇筆記都只根據 arXiv Summary/Abstract 與 Introduction 撰寫；Introduction 均由 arXiv HTML 成功取得，未讀全文其他章節。

## 今日選文

1. [Reflex: Enabling Fast and Predictive Vision-Language-Action Models for Reaction-Critical Manipulation](./01-reflexvla-reaction-critical-manipulation.md)
   - arXiv：2608.14379v1
   - 分類：cs.RO、cs.AI
   - 選擇理由：靜態 benchmark 容易掩蓋 VLA 延遲；這篇同時處理動態操作 benchmark、近未來表徵與 serving latency，直接對應 Physical AI 的時間閉環。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

2. [Evolve Vision-Language-Action Model into an Agent with On-the-fly Tool-use](./02-art-vla-on-the-fly-tool-use.md)
   - arXiv：2608.14047v1
   - 分類：cs.RO、cs.AI、cs.CV
   - 選擇理由：把 LLM agent 的 tool-use 介面帶入端到端 VLA，以 adapter 隔離工具推理與原 action generation，對 robot foundation model 的可擴充性有獨立價值。
   - 閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）

## 選文說明

- arXiv 在 2026-08-17（週一）可取得的最新一批候選為 2026-08-14 投稿；兩篇都在最近 3 天內，無須用較舊或弱相關論文補量。
- 已依每日最多兩篇的防重入規則檢查本日資料夾；執行前沒有非 README 的論文筆記，本次新增後為 2 篇。

## Commit 狀態

- 已由本次 cron 建立筆記與索引；commit / push 識別碼以最終回覆為準。
