# 2026-10-27 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。選文窗口為 **2026-10-20 至 2026-10-26**；實際研究於 2026-10-27 Asia/Taipei 上午進行，不冒稱 09:00 已完成。寫入前今日非 README `.md` 為 0；本次新增後為 1。

## 今日選文

1. [Natural-Language to Nav2：政策合法，不等於指令正確或物理安全](./01-nav2-政策合法不等於指令正確或物理安全.md)
   - [arXiv:2610.32633v1](https://arxiv.org/abs/2610.32633v1)，2026-10-23 提交。
   - **實讀**：官方 23 頁 PDF 摘要、§1–8 方法／實驗／discussion／結論；補充 S1–S3、S6–S7 文字與表格，S4–S5 圖說／說明。未檢視軌跡圖像、未審碼或重跑；references 未逐篇追讀。
   - **新增機制**：LLM 翻成有限政策契約，情境驗證後整筆提交，任務快照與跨任務限制分開；透過 global costmap 沿用既有 Nav2。
   - **證據界線**：schema 合法不等於符合指令；正確政策的導航收益不等於語言端到端可靠；global costmap 不等於 local-controller 硬安全約束。

## 有界候選與取捨

來源為當次 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 與 [cs.CL recent](https://arxiv.org/list/cs.CL/recent) 的首頁，各前 50 筆；最新公告欄位均為 2026-10-26。這是有界檢索，不是七天所有 arXiv 的完整回顧；公告日與論文提交日分開判讀。

- **入選 [Natural-Language to Nav2（2610.32633v1）](https://arxiv.org/abs/2610.32633v1)**：列表第 14 筆；對工業 AMR 的政策生命週期、接收一致性與安全責任界線有直接價值，且原文主動區分語言錯誤、軟體故障及正確政策導航。已取得並閱讀方法與實驗，不止改寫摘要。
- **待讀 [Backtrack（2610.32941v1）](https://arxiv.org/abs/2610.32941v1)**：2026-10-23 提交，列表第 5 筆；官方摘要提出 frozen VLA 上的失敗 head 與動作回退，適合接續 RESCUE／P²。今日僅核對官方摘要與版本，未讀方法／實驗，故不以摘要成效填第二篇。
- **續列待讀 [Echo（2610.31569v1）](https://arxiv.org/abs/2610.31569v1)**：2026-10-22 提交；重查摘要與歷史，狀態訊號及 action 的耦合仍有價值，但今日未補讀方法與真機消融。過往只是候選，不冒充已讀舊筆記。
- cs.CL 首頁僅作純 LLM 研究發現補充；本次優先把一篇與現場作業介面直接相關的交會研究讀深，不強行增加純 LLM 第二篇。

**去重／撤稿**：新增前以完整 arXiv ID 搜尋全庫 Markdown；2610.32633、2610.32941 無命中，2610.31569 僅過往候選。三篇官方摘要歷史當次均只列 v1，未見 withdrawn／retracted；此狀態僅及 2026-10-27 擷取。

## 庫務

- 已確認 root、origin、main、乾淨工作樹及 gh 認證，再 `git pull --ff-only`，回傳已是最新。
- 官方 PDF 以 HTTPS 下載，用既有 `pdftotext -layout` 輕量抽取；一項字型警告不遮掩，實讀／未讀範圍見單篇，未安裝重型依賴。
- 更新日期／年度／總索引及 root 短入口；研究導覽只新增「政策合法、語意正確、物理守界」跨篇區分，不改舊筆記閱讀邊界。
- 提交前檢查相對連結與 `git diff --check`，僅 stage 本次檔案；push 後依 `scripts/deploy_pages_local.sh` 本機 strict build／gh-pages 發布，不用 GitHub Actions 建置或部署。實際 SHA、Pages source／branch build 及 HTTP／正文驗證見本次交付回報。
