# 2026-11-07 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。候選提交日期窗口為 **2026-10-31 至 2026-11-06**；擷取時間 2026-11-07 Asia/Taipei 09:00 後。寫入前當日非 README `.md` 為 0，新增後為 1，未超過每日 2 篇上限。

## 今日選文

1. [隔離梯度之前，先問誰教表徵學動作](./01-gradient-routing-隔離梯度之前先問誰教表徵學動作.md)
   - [Should the Action Expert Train the VLM?（arXiv:2611.05249v1）](https://arxiv.org/abs/2611.05249v1)，2026-11-03 提交；Asher James Hancock 等九位作者，完整名單與 provenance 見單篇。
   - **實讀**：23 頁 PDF 摘要、§1–5、附錄 A–E 的方法、資料／訓練設定、評估／評分規則、安全表及限制；HTML 核對方法介面。圖只讀文字層／圖說，未做圖片、影片、程式碼或重跑核驗。
   - **入選理由**：前兩日待讀題目今天補到方法。以動作 token 監督 × 梯度路由拆開訓練訊號，能補足「表徵如何被使用」路徑的 backward 學習問題，而不再只比較部署讀取。
   - **保留界限**：總 steps 不等於各元件更新預算；操作與駕駛關閉 token 的實作／CE 分母不完全相同；進度不是安全或完整任務成功，PanClean rubric 不另測擦洗；只有模擬、單 training seed，不當作真機與廣泛 VLM 能力保留證據。

## 有界搜尋與候選取捨

本次打開 [cs.RO recent 前 50 筆頁](https://arxiv.org/list/cs.RO/recent?skip=0&show=50)，檢視最前方新作 metadata，最新公告日為 2026-11-06（該日 81 筆），再讀以下新候選與兩篇既有待讀候選的官方摘要／版本。沒有普查七天所有 cs.RO／cs.AI／cs.CL；公告日與作者提交日分開記，排序不是閱讀品質排名。今天只有入選篇完成方法閱讀。

- **入選 [Should the Action Expert Train the VLM?（2611.05249v1）](https://arxiv.org/abs/2611.05249)**：2026-11-03 提交；舊庫僅兩日候選提及，沒有既有獨立筆記。今天實際補讀，不升格舊文閱讀範圍。
- **新列待讀 [OopsieRecover（2611.08462v1）](https://arxiv.org/abs/2611.08462)**：2026-11-05 提交。語意介入如何形成可遷移修正、何時呼叫與如何限制控制，有很強的交會研究價值；本次僅讀摘要，尚未核對 abduction／cost 建構與修正分母，不把「少量示範能泛化」當已驗證結果。
- **新列待讀 [VLA-Tug／Failure Prediction and Classification…（2611.08425v1）](https://arxiv.org/abs/2611.08425)**：2026-11-05 提交。早期失敗偵測與校準值得追，但摘要的界限與跨分布成立比例須讀假設、校準集與實驗才能理解；今天未讀方法，不轉述成普遍安全保證。
- **續列待讀 [Where Is VLA Inference Time Spent?（2611.06710v1）](https://arxiv.org/abs/2611.06710)**：2026-11-04 提交；今日核對摘要／版本，尚未讀方法。跨 GPU 的計時邊界與優化交互仍值得獨立研究，不以摘要背書端到端控制收益。
- **續列待讀 [VABAR（2611.06881v1）](https://arxiv.org/abs/2611.06881)**：2026-11-04 提交；今日核對摘要／版本，尚未讀方法。需讀任務變異、技能庫與成功條件，故不把六類任務及 agent baseline 列舉寫成完整 benchmark 分析。

**去重／撤稿查核**：搜尋上述五個 ID；入選篇及兩個既有候選原先只見候選索引，兩個新候選無舊庫命中，沒有重複獨立筆記。查核時五個官方無版本頁均只列 v1，未見 withdrawn／retracted 標記；此為擷取時狀態，不代表未來不修訂。僅完成一篇深讀，其餘保留候選，不因每天最多兩篇而強行發布摘要改寫。

## 庫務與發布

- root／origin／main／工作樹與 gh 認證先行確認；工作樹乾淨才 pull --ff-only，已是最新，未處置其他工作。
- 用既有 curl／pdfinfo／pdftotext 輕量抽取，未裝重型閱讀依賴。pdftotext 報一項字型類型警告，文字與表格可讀；公式以 HTML 核對，不以抽取後柱狀文字配對數值。
- 更新日期、年度、論文總索引與根 README 短入口；研究導覽只補新 backward 機制，不重整原有路徑。
- 相對連結、篇數及 git diff --check 為提交門檻；只 stage 本次檔案。main push 後以 scripts/deploy_pages_local.sh 本機 strict build／gh-pages 發布；實際 SHA、source、branch build 與正式站讀回結果以交付回報為準。
