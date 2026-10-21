# 2026-10-21 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。寫入前本日非 README `.md` 為 **0**，新增後為 **1**。選文窗口 **2026-10-14 至 2026-10-20**，入選論文首次提交 10-16。擷取與閱讀是本次上午排程實際執行期間，不宣稱所有資訊在 09:00 已取得。

## 今日選文

1. [IMEP：記憶敏感，不等於使用了事實](./01-imep-記憶敏感不等於使用了事實.md)
   - [arXiv:2610.23372v1](https://arxiv.org/abs/2610.23372v1)，首次提交 2026-10-16 12:23:56 UTC。
   - **實讀範圍**：官方 41 頁 PDF 摘要、主文 §1–5、可重現聲明；重點附錄 A.3、B.2–B.5、C.1、E.2、F.1、F.4，G 的撤回／事後修訂與 H 的 artifact 綁定部分。不是所有附錄逐頁讀完；詳細段落、表格與未讀邊界見單篇。未審碼、未重跑、未逐圖核對。
   - **新增機制**：同時報淨成功差與配對翻轉，再用保留／改變事實的替換及微擾控制，區分記憶依賴與事實特異性。接續 Mem4Act／REKI，沒有改寫舊篇閱讀範圍。
   - **重要限制**：U 控制包含安裝程序；ChainBench 正向結果是 curated records／特定 reader／共用錄製執行，非完整 live agent 或真機安全。整體四問框架在實驗後形成；部分實驗證據撤回，與整篇撤稿分開處理。

## 有界搜尋、候選與取捨

本次查看 [arXiv cs.RO recent](https://arxiv.org/list/cs.RO/recent) 首頁靠前候選標題（至少前 25 筆），頁面當時最新列表日期為 **10-20**；搭配昨日保留的三篇候選，回查五個官方摘要／版本頁，其中一篇下載 PDF 深讀。這不是全部 arXiv、全部 LLM 類別或全週 733 entries 的完整系統性回顧。列表公告日期與首次提交日期分開：以下 Physical Words／PhysRSI 首次提交均為 10-19，而非列表的 10-20。

- **入選 [IMEP（2610.23372v1）](https://arxiv.org/abs/2610.23372v1)**：昨日只是待讀候選；今日取得方法與實驗，直接回答記憶內容歸因缺口。保留其陽性、陰性、實作譜系及事後分析界限，值得獨立深讀。
- **優先待讀 [Physical Words（2610.26854v1）](https://arxiv.org/abs/2610.26854v1)**：10-19 提交；官方摘要用 action words 組織 latent reasoning，對應語意與物理動態的介面。僅讀摘要／metadata，未讀訓練目標、baseline 與實驗；不以高成功率摘要宣稱填滿第二篇。
- **保留 [Where is Physical RSI capability from?（2610.26848v1）](https://arxiv.org/abs/2610.26848v1)**：10-19 提交；摘要的固定互動預算與 workspace／history 介入可能補足重複嘗試的評估問題。僅讀官方摘要，尚未查五軸指標、比較公平性與 observational scaling 的識別限制，不從關聯推因果。
- **保留 [ORD-WM（2610.23156v1）](https://arxiv.org/abs/2610.23156v1)**：10-16 提交；物體剛體運動與幾何保留值得接續 world model 主題，但本次仍只回查摘要／metadata，未讀方法與控制評估。
- **保留 [Value as Memory（2610.22368v1）](https://arxiv.org/abs/2610.22368v1)**：10-15 提交；value caching 與 online RL 涉及不同收益來源，本次只回查摘要／metadata，不將作者摘要增益改稱本筆記已驗證因果。

**去重／撤稿檢查**：寫入前用完整 arXiv ID 搜尋 `論文拆解/`，IMEP、ORD-WM、VaM 僅有舊日期 README 的候選記錄，沒有獨立正式筆記；兩個新候選沒有舊命中。五個未帶版本官方摘要頁本次皆只列 v1，未見 withdrawn／retracted 標記。這只是擷取當下頁面狀態；IMEP 本文對部分實驗 evidence 的撤回已另列，不與整篇撤稿混同。

## 庫務與發布

- 已確認正確 root、origin、main、乾淨工作樹與 gh 認證，再執行 `git pull --ff-only`，回傳已是最新。
- 新增單篇／日期索引；更新年度／論文總索引與根 README 短入口。研究導覽新增記憶事實特異性的跨篇判斷，不改寫舊筆記。
- 官方摘要抽取工具因後端僅支援搜尋而無法擷取，改用標準庫 HTTP 直接讀取官方 HTML；PDF 以 `curl` 下載、既有 `pdftotext -layout` 輕量擷取，未安裝重型依賴。字型警告未阻止文字抽取；不由未核對圖像補寫數字。
- 相對連結與 `git diff --check` 通過後只 stage 本次檔案，以繁中 commit 並 push `origin/main`；本機 `scripts/deploy_pages_local.sh` strict build／發布，不使用 GitHub Actions 建置或部署。
- 實際 SHA、Pages source／branch build 與首頁／日期／單篇 HTTP 及正文驗證結果，以本次最終交付回報為準。
