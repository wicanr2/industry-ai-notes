# 2026-11-01 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。近七天候選窗口採 **2026-10-25 至 2026-10-31**，於 2026-11-01 Asia/Taipei 上午核對官方來源。新增前當日非 README `.md` 為 0，本次後為 1，未達每日 2 篇上限。

## 今日選文

1. [HiFOR：未來檢索，不等於動作後果驗證](./01-hifor-未來檢索不等於動作後果驗證.md)
   - [arXiv:2610.40373v1](https://arxiv.org/abs/2610.40373v1)，2026-10-29 提交。
   - **實讀**：11 頁 PDF 的摘要、§1、§3.1–3.6 方法、§4.1–4.4 評估／消融／定性分析與 §5；核對表 1–3、圖 4–7 可抽取數值／說明，再以官方 HTML 核對方法公式。未逐張目視、未審碼或重跑；表 1 提到但未隨該版本提供的 Appendix 未讀。
   - **入選理由**：接續 ThinkWorld 的部署消費問題，這篇確實讓動作去噪直接讀取預測 latent，可具體拆開「預測」「取用」與「候選動作後果驗證」。
   - **核心界限**：AWR 的查詢依賴動作，不代表預測世界以每個候選動作重新生成；注意力圖不是內容特異性介入證據。成功率不等於物理安全。

## 有界候選與取捨

本次查閱官方 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 前 50 筆，當次最新公告仍為 2026-10-30；再定向核對昨日留下的兩篇官方摘要頁，對 HiFOR 取得 PDF／HTML 並深入閱讀。這是窗口內有界選樣，不是七天所有 LLM／機器人論文的完整普查；列表僅作發現 metadata。

- **入選 [HiFOR（2610.40373v1）](https://arxiv.org/abs/2610.40373v1)**：昨日僅列候選，未有獨立筆記，今天新讀方法／評估後新增；不是把昨天的候選描述冒充已讀。保留資料工程成本、HDM／AWR 消融歸因與預測有效期的研究問題。
- **待讀 [CoRAct／From Reasoning to Action: Consequence-Grounded Alignment for Vision-Language-Action Models（2610.39543v1）](https://arxiv.org/abs/2610.39543v1)**：2026-10-29 提交。當次僅核對官方摘要及版本歷史；其摘要涉及 action-conditioned future prediction 與 noise-space 對齊，適合之後對照 HiFOR，但本次未讀方法與實驗，不判定獎勵可靠性或閉迴路效益，也不為滿兩篇另出摘要改寫筆記。
- **排除已入庫 [OpenFlyV2（2610.39287v1）](../2026-10-31/01-openflyv2-機載閉迴路要分開記憶生成與安全.md)**：窗口內但昨日已寫，不重複選文；舊筆記不修改閱讀範圍。

**去重與撤稿**：新增前以 arXiv ID 搜尋全庫 Markdown；HiFOR／CoRAct 只命中昨日候選索引，沒有獨立筆記。兩篇未鎖版本官方摘要頁當次均只列 v1，未見 withdrawn／retracted 通知；僅代表當次可見狀態，不對未讀內容背書。

## 庫務與擷取限制

- 先確認 root、origin、main、乾淨工作樹及 gh 認證，再 `git pull --ff-only`，結果已最新，未處置他人變更。
- 通用擷取工具不支援當前 backend；直接下載 arXiv PDF，使用既有 `pdftotext -layout`／`pdfinfo`，另讀官方 HTML 核對公式；未安裝重型依賴。字型警告與未取得 Appendix 已在單篇揭露。
- 更新日期／年度／論文總索引與根 README 短入口；研究導覽僅新增「部署直接消費不等於候選後果驗證」跨篇辨別。
- 提交前檢查篇數、相對連結與 `git diff --check`，只 stage 本次檔案。main push 後以 `scripts/deploy_pages_local.sh` 在本機 strict build、推送 gh-pages、要求 Pages branch build；實際 SHA、source／build 與正式網址讀回結果見當次交付回報。不使用 GitHub Actions 建置／部署。
