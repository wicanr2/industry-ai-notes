# 2026-10-25 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。寫入前當日非 README `.md` 為 **0**，新增後 **1**；選文窗口為 **2026-10-18 至 2026-10-24**。本次來源於 Asia/Taipei 上午排程期間取得及閱讀，不聲稱研究在 09:00 已全部完成。

## 今日選文

1. [FastHarness：少審查不等於低風險，先把選樣與恢復分帳](./01-fastharness-少審查不等於低風險.md)
   - [arXiv:2610.31427v1](https://arxiv.org/abs/2610.31427v1)：10-22 提交、10-23 公告。
   - **實讀**：官方 13 頁 PDF 摘要、§1–6、附錄 A–F，含方法、控制迴圈、統計分數、評估協定、表 1–7 與限制。文字抽取閱讀，未逐圖視覺審查、未核對 source、未審碼／重跑或獨立驗證外部 baseline。
   - **機制**：階段樣本與已審查結果 → 自適應 review 間隔 → 新觀測新動作；錯誤後逐 chunk 審查、局部修復／waypoint 與原故障分開驗證。
   - **關鍵界線**：自適應選樣的 Wilson 分數不是未審查動作安全保證；80% 對 97.19% 來自不同評估樣本／場景配置，未受控識別排程收益。文中 Fold 失敗即使經過 20 次 review 也未觸發恢復。

## 有界搜尋與取捨

本次取得 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 及 [cs.CL recent](https://arxiv.org/list/cs.CL/recent) 首頁（各 50 筆列表，10-23 公告），以交會研究與既有監測／介入線索優先；不是遍歷近七日所有論文的系統回顧。從昨日候選續讀一篇，讓方法與協定讀透，不把待讀摘要填成第二篇。

- **入選 [FastHarness（2610.31427v1）](https://arxiv.org/abs/2610.31427v1)**：昨日僅列候選，本日首次新增方法筆記；直接接 P² 的低成本監測、RESCUE 的介入價值與 BT-Agent 的執行護欄。PDF 可取得完整規則、計數口徑、基線差異及失敗 trace，能提出比摘要更可驗證的判斷。
- **待讀 [Echo（2610.31569v1）](https://arxiv.org/abs/2610.31569v1)**：10-22 提交。本日重查摘要／metadata，狀態訊號與動作耦合仍值得對照；未補讀方法、資料建構與真機實驗，不引用摘要成效作已驗證結果。
- **待讀 [Agentic World Action Models（2610.30136v1）](https://arxiv.org/abs/2610.30136v1)**：10-21 提交。本日僅重查摘要／metadata；code／video／action 共同建模與技能重用符合範圍，但未讀訓練／執行及基線控制，不聲稱已讀方法。

**去重／撤稿狀態**：以完整 arXiv ID 搜尋全庫 Markdown，三篇既有命中僅為日期索引候選，沒有既有獨立單篇。三篇官方無版本摘要頁擷取時均只列 v1，未見 withdrawn／retracted；狀態僅及本次擷取。今日新增後再計數，仍在兩篇上限內。

## 庫務與發布

- repo root／origin／main／乾淨工作樹與 gh 認證確認後，`git pull --ff-only` 回傳已是最新。
- `web_extract` 後端不支援擷取，改以 HTTPS 直接取得 arXiv 官方列表、摘要頁與 PDF，再用現有 `pdftotext` 輕量抽取，未裝重型依賴。一次過長 inline Python 被 cron command parser 擋下後，改用 scratch Python script 成功取得候選；沒有用失敗輸出補正文。
- 新增筆記與日期索引，更新年度／論文總索引與 root 短入口；研究導覽僅增加「審查選樣與恢復結果分帳」的跨篇判斷，不改寫舊筆記的閱讀範圍。
- 相對連結與 `git diff --check` 通過才提交；只 stage 本次檔案、繁中 commit／push，然後本機 `bash scripts/deploy_pages_local.sh` 發布，不使用 GitHub Actions 建置或部署。
- 實際 main／gh-pages SHA、Pages source／branch build 與首頁／日期／單篇正文驗證，以本次最終交付為準。
