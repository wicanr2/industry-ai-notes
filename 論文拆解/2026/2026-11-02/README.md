# 2026-11-02 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。近七天候選窗口採 **2026-10-26 至 2026-11-01**；實際擷取時間為 2026-11-02 Asia/Taipei 11:01 後，不冒稱排程標示的 09:00 已取得。新增前當日非 README `.md` 為 0，本次後為 1，未超過每日 2 篇。

## 今日選文

1. [CoRAct：對齊預測後果，不等於實測執行正確](./01-coract-對齊預測後果不等於實測執行正確.md)
   - [arXiv:2610.39543v1](https://arxiv.org/abs/2610.39543v1)，2026-10-29 提交。
   - **實讀**：9 頁 PDF 的摘要、§I、§III-A–C 方法、§IV-A–F 設定／比較／消融／外部修正／真機與 §V 後的限制文字，核對表 I–V；官方 HTML 再核對噪聲公式、分割方式、表 I 反例。未審碼、重跑或逐張目視圖像。
   - **入選理由**：昨日僅列候選，今天實際讀方法，補上「候選動作條件化後果」發生於離線訓練、部署只保留噪聲偏好的機制；可與 HiFOR 的部署直接檢索區分。
   - **主要界限**：waypoint 評分是預測影像的代理，非實測物理後果；表 I 並非每個 OOD 欄位勝出。真機另改關節／頂視介面，trial 總分母不明，不誇稱零改動部署或安全保證。

## 有界候選與取捨

本次查官方 [cs.RO recent 前 50 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=50)，擷取時最新公告仍為 2026-10-30；對先前留下的 CoRAct 取得 PDF 與 HTML，另查 Gym-Anything 官方摘要。這是交會研究優先的有界搜尋，不是窗口內所有 LLM／機器人論文的完整普查，列表 metadata 不當成方法證據。

- **入選 [CoRAct（2610.39543v1）](https://arxiv.org/abs/2610.39543v1)**：去重時僅見前兩日候選索引，沒有獨立閱讀筆記；本次才新增方法／實驗論述，不改寫舊索引成已讀。
- **待讀 [Gym-Anything for Robotics: Scaling physical simulations with digital agents（2610.40565v1）](https://arxiv.org/abs/2610.40565v1)**：2026-10-29 提交。官方摘要涉及 coding-agent 建模與 creation–audit loop；值得後續查 audit 是否真正校準物理可信度、privileged teacher 與學生評估如何隔離。本次只讀摘要與 metadata，未讀方法／實驗，不採摘要的 benchmark 數字作已驗證結論，不為滿額發布第二篇。
- **不重複寫 [HiFOR（2610.40373v1）](../2026-11-01/01-hifor-未來檢索不等於動作後果驗證.md)**：窗口內，但已入庫；今天只作跨篇對照，不冒充新讀或新發現。

**去重與撤稿**：寫入前查全庫 Markdown 的 arXiv ID；CoRAct 僅命中候選，Gym-Anything 無既有筆記。當次兩篇官方摘要頁均只列 v1，未見 withdrawn／retracted 告示；不代表已驗證研究結果。既有 HiFOR 未新做全文或撤稿追蹤。

## 庫務與閱讀限制

- 先核對 git root、origin、main、乾淨工作樹與 gh 認證，再 `git pull --ff-only`，結果已最新；未處置他人變更。
- 下載版本 PDF，以既有 `pdftotext -layout`／`pdfinfo` 及官方 HTML 查證，未安裝重型依賴；抽取字型警告與未讀程式已在單篇標明。
- 更新本日期／年度／論文總索引與根 README 短入口；研究導覽只新增「離線評分、部署偏好與實測校準」的跨篇機制區分。
- 提交前檢查每日篇數、Markdown 相對連結與 `git diff --check`；只 stage 本次檔案。push main 後以 `scripts/deploy_pages_local.sh` 本機 strict build、推送 gh-pages、要求 branch build，另讀回 source／build 與首頁、新索引／文章正文。實際 SHA 與發布結果見當次交付；不使用 GitHub Actions 建置／部署。
