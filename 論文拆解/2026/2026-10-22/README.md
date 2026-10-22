# 2026-10-22 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。寫入前本日非 README `.md` 為 **0**，新增後為 **1**；選文窗口 **2026-10-15 至 2026-10-21**。實際擷取／閱讀於本次 Asia/Taipei 上午排程執行期間，不宣稱所有來源在 09:00 已讀到。

## 今日選文

1. [PhysWord：語意錨點不等於接觸真值](./01-physword-語意錨點不等於接觸真值.md)
   - [arXiv:2610.26854v2](https://arxiv.org/abs/2610.26854v2)，首次提交 10-19，v2 更新 10-20（UTC）。昨日 v1 僅列待讀，今天首次讀方法，不改寫昨日邊界。
   - **實讀範圍**：官方 24 頁 PDF 摘要、§1–5、附錄 A–G 的資料／標註／平台／量化結果／表徵分析文字／失敗／實作／計時／評估協定。讀取主要表格及圖說；非逐圖核對、未審碼或重跑，詳見單篇。
   - **方法新增**：動詞分類與未來視覺／觸覺 latent 直接共同監督同一 hidden state，以分時段 Physical Words 引導 action chunk。
   - **判斷邊界**：延伸流程消融支持整套語意介面，未隔離單一分類 loss；預測觸覺回饋使用訓練示範開頭初始化，仍有視覺閉迴路，不是獨立安全感測器。主榜異質預訓練與模態不能當受控機制識別。

## 有界搜尋、候選與取捨

本次讀 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 前 18 筆標題及後續列表 metadata，頁面最新公告日為 **10-21**；延續昨天 PhysWord 候選，另回查六個官方摘要／版本頁。這不是全領域 LLM／全週所有論文的系統性回顧。新公告日與首次提交日分開記載。

- **入選 [Physical Words（2610.26854v2）](https://arxiv.org/abs/2610.26854v2)**：取得新版本方法、主榜與多項控制消融，能補上未來表徵的語意組織，以及預測觸覺與真測量的界線。
- **優先待讀 [UniWALM（2610.28626v1）](https://arxiv.org/abs/2610.28626v1)**：10-20 首次提交，摘要提出同步 world/action/language 生成與語言回餵記憶，直接接續 IMEP／Mem4Act；本次僅讀摘要／metadata，未讀 FMC 目標或記憶消融，不以摘要成功率湊第二篇。
- **保留 [Industrial ReMEmbR（2610.28624v1）](https://arxiv.org/abs/2610.28624v1)**：10-20 首次提交，摘要把 fleet video 寫入與按需 caption 計算分離，值得追問搜尋品質與 token／重建資料的隱私邊界。僅摘要閱讀，不接受「遮掉人即 GDPR 合規」為已驗證結論。
- **保留 [TaskWAM（2610.28431v1）](https://arxiv.org/abs/2610.28431v1)**：10-20 首次提交，摘要的 stage confusion、Mode／State Tokens 與今日問題相近；未讀 StageBench、baseline、公平性與控制迴圈，不寫成已證實互補。
- **保留 [PhysRSI（2610.26848v1）](https://arxiv.org/abs/2610.26848v1)**：10-19 首次提交，固定互動預算與 workspace／history 介入仍值得方法閱讀；本次只回查摘要，不能把 observational scaling 當因果。
- **保留 [ScaleNav（2610.25690v1）](https://arxiv.org/abs/2610.25690v1)**：10-19 首次提交，網路影片、模擬動作對齊及局部語言導航符合範圍；本次僅摘要／metadata，未讀三階段方法或 benchmark 改編細節。

**去重／撤稿**：寫入前搜尋六個完整 arXiv ID；Physical Words／PhysRSI 只有昨日 README 候選命中，其他無命中，沒有重複正式單篇。六個官方未帶版本頁本次未見 withdrawn／retracted；PhysWord 列 v1／v2，其餘列 v1。本次狀態不保證未來不變。

## 庫務與發布

- 確認 root／origin／main／乾淨工作樹及 gh 認證，才 `git pull --ff-only`，回傳已是最新。
- 官方摘要以標準庫 HTTP 取得；擷取工具後端不支援 extract，改直接讀官方 HTML。PDF 用現有 `pdftotext -layout`，字型警告未阻止文字抽取，未裝重型依賴。
- 新增單篇及日期索引，更新年度／論文總索引與根 README 短入口；研究導覽新增「語意組織與感測校正」判斷，沒有把舊篇冒充補讀。
- 相對連結與 `git diff --check` 檢查後，只 stage 本次檔案；繁中 commit／push main，再執行本機 `scripts/deploy_pages_local.sh` strict build／發布，不以 GitHub Actions 建置或部署。
- 實際 SHA、Pages source／branch build 與首頁／日期／文章 HTTP 及正文驗證結果，以本次最終交付回報為準。
