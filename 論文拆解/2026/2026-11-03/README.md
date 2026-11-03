# 2026-11-03 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。近七天候選窗口為 **2026-10-27 至 2026-11-02**；實際擷取為 2026-11-03 Asia/Taipei 09:00 後。新增前當日非 README `.md` 為 0，本次後為 1，未達每日 2 篇上限。

## 今日選文

1. [VLA 啟動抑制：選對任務，不等於獲准啟動](./01-start-suppression-選對任務不等於獲准啟動.md)
   - [arXiv:2610.41609v1](https://arxiv.org/abs/2610.41609v1)，2026-10-30 提交。
   - **實讀**：17 頁 PDF 摘要、導論、§III 方法、§IV 設定／微調／校準／統計、§V-A–F 結果、§VI 討論、§VII 限制與結論，核對表 I–VI；官方 HTML 附錄 B、C。未審碼或重跑，附錄 A、D–F 未逐項核對，不宣稱逐頁全文精讀。
   - **入選理由**：把任務選擇與啟動許可分開，且負例微調出現「沒完成但仍漂移」的具體反例；校準與評測重疊等限制可追到附錄，不只改寫摘要。
   - **主要界限**：單一模擬布局、六 checkpoints；OTHER-TASK／IMPOSSIBLE-ACTION 只測兩個 GR00T，微調只測一配方三 seeds；不把首輪動作敏感度、5 公分 non-start 或未完成任務當成安全認證。

## 有界候選與取捨

查官方 [cs.RO recent 前 50 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=50)，擷取時最新公告為 2026-11-02，當日有 72 筆、頁面僅顯示前 50 筆；另取得以下三篇官方摘要。這是 LLM／Physical AI 交會優先的有界搜尋，不是七天所有 cs.RO／cs.CL／cs.AI 的完整普查。列表 metadata 不當成方法證據。

- **入選 [VLA Policies Do Not Know When Not to Act（2610.41609v1）](https://arxiv.org/abs/2610.41609v1)**：取得 PDF 及 HTML，完成上述方法／實驗／限制閱讀；寫前庫內 ID 無命中，沒有既有獨立筆記。
- **待讀 [When the Simulator Fails, Not the Policy: Auditing Contact Artifacts in Simulated Robot Benchmarks（2610.41857v1）](https://arxiv.org/abs/2610.41857v1)**：2026-10-30 提交，摘要提到 SimuGuard 與碰撞求解器造成的評測偏差，適合後續研究「失敗歸因」。本次只讀摘要與 metadata，未讀方法、程式或實驗；不把引擎修補與提升數字當成本次查證結論。
- **待讀 [REA: A Routed Embodied Agent Runtime for Asynchronous Brain-Cerebellum Control（2610.42053v1）](https://arxiv.org/abs/2610.42053v1)**：2026-10-30 提交，摘要涉及 route memory、邊界觸發 judge 與共用恢復預算；需讀方法才能判斷異步執行與取消／故障如何交接。本次只讀摘要與 metadata，不重述榜單數字作已驗證收益，不為第二篇配額倉促出文。

**去重與撤稿**：寫前查庫內 Markdown，以上三個 arXiv ID 均無既有命中；選文當前官方摘要頁及其餘兩篇官方版本頁只列 v1，未見撤稿標記。後兩篇未獨立輪詢無版本當前頁，若日後選用須重新核對。昨日候選不改寫成已讀，也不將舊文升格為全文閱讀。

## 庫務與發布

- 核對 git root、origin、main、乾淨工作樹與 gh 認證，才 `git pull --ff-only`；結果已最新，沒有處置他人未提交工作。
- 使用現有 `pdftotext -layout`／`pdfinfo`，HTML 用標準庫抽取；未安裝重型依賴。擷取服務不可用及 Python 缺少 bs4 後，改用直接 HTTP＋標準庫完成原文取得，未以摘要填方法空白。
- 更新日期、年度、論文總索引及根 README 短入口；研究導覽只補上新增的「任務選擇／啟動許可」機制區分，不逐日堆疊同義警語。
- 提交前檢查每日篇數、相對連結與 `git diff --check`，只 stage 本次檔案；push main 後走本機 `scripts/deploy_pages_local.sh`，不使用 GitHub Actions 建置／部署。最終交付記錄實際 SHA、Pages source／branch build 與正式站正文驗證，不以此處流程敘述替代成功證據。
