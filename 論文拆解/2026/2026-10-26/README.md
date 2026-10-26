# 2026-10-26 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。選文窗口 **2026-10-19 至 2026-10-25**；寫入前今日非 README `.md` 為 **0**，新增後 **1**。來源及閱讀於 Asia/Taipei 上午排程期間取得，不聲稱 09:00 已完成研究。

## 今日選文

1. [AW-0：程式能改善動作預測，不代表應該直接執行](./01-aw0-程式條件與執行收益要分帳.md)
   - [Agentic World Action Models，arXiv:2610.30136v1](https://arxiv.org/abs/2610.30136v1)，2026-10-21 提交。
   - **實讀**：官方 50 頁 PDF 的摘要、導論、§2 方法、§3 實驗／消融、相關工作及結論開頭；附錄 A、B.1–B.2 開頭、C 部分 baseline、E 評分定義、F.1、I、J.2、K 相關標註／技能規則、L 限制。逐項範圍及未讀章節見單篇，非逐頁全文精讀；未審碼、重跑或逐圖檢查。
   - **機制**：code → video → action 共同去噪；預設程式只作條件，hybrid 才直接執行，兩種價值分開驗證。
   - **關鍵界線**：模擬 hybrid 同時改訓練示範管線，不能獨立歸因切換；真機 71.1% 為分項 rubric，不是完整成功率；無例外就登記 stage 完成，並非獨立物理後置條件成立。

## 有界搜尋與候選取捨

本次取得 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 與 [cs.CL recent](https://arxiv.org/list/cs.CL/recent) 首頁，各含 50 筆列表；cs.RO 首日為 10-23 公告。僅作有界候選檢視，不是近七日所有論文的系統性回顧。優先接續已有待讀、且能對照監督／介入及技能介面的交會研究。

- **入選 [AW-0（2610.30136v1）](https://arxiv.org/abs/2610.30136v1)**：先前只列候選；今日首次讀方法及執行／資料／評估相關附錄。能把「程式是規劃條件」與「程式值得接管」拆成兩個可測命題，且附錄主動揭露 hybrid 比較的資料混雜。
- **待讀 [Echo（2610.31569v1）](https://arxiv.org/abs/2610.31569v1)**：10-22 提交；今日重查官方摘要／metadata，耦合 action 與 stop／failure 訊號值得與 P² 外掛 probe 對照。但未取得並讀方法／實驗，不以摘要成效填第二篇。
- **已收錄、不重複 [P²](../2026-10-24/01-p2-進度落後不是安全事件.md) 與 [FastHarness](../2026-10-25/01-fastharness-少審查不等於低風險.md)**：recent 列表仍出現，不因還在列表就重寫成新研究。
- cs.CL 列表中的 harness／long-horizon state 等題名僅屬發現線索，未核對原文，故不形成技術結論，也不硬湊純 LLM 第二篇。

**去重與撤稿**：以完整 arXiv ID 搜尋全庫 Markdown；AW-0 先前命中只有 10-23／24／25 的候選，Echo 亦僅待讀。兩篇當次官方摘要頁均僅 v1、未見 withdrawn／retracted，狀態僅及本次擷取。寫入後再次計數，仍在每日最多兩篇內。

## 庫務與發布

- 先驗證 repo root、origin、main、工作樹乾淨及 gh 認證，再 `git pull --ff-only`，回傳已是最新。
- `web_extract` 後端無法抽取 URL，改用 HTTPS 直接取官方列表／摘要／PDF，再用既有 `pdftotext`；未安裝重型依賴。PDF 有字型警告，實際可讀文字範圍列於單篇；公式保守重述。一次列表摘要 inline Python 括號錯誤已修正並成功輸出，未拿失敗輸出當來源。
- 更新日期／年度／論文總索引與 root 短入口；研究導覽新增跨篇「條件表徵與接管收益」界線，不更改舊筆記閱讀標記。
- 執行相對連結檢查與 `git diff --check`，只 stage 本次變更、繁中 commit／push，之後本機 `bash scripts/deploy_pages_local.sh` 發布；不用 GitHub Actions 建置或部署。
- 實際 main／gh-pages SHA、Pages source／branch build 與首頁／日期／單篇 HTTP／正文驗證，以本次最終交付結果為準。
