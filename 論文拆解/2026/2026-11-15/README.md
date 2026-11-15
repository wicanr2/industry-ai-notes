# 2026-11-15 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。候選提交日期窗口 **2026-11-08 至 2026-11-14**，於 2026-11-15 Asia/Taipei 09:00 後擷取。開始時今日非 README Markdown 為 0，本次新增 1；未更動任何舊文閱讀聲明。

## 今日選文

1. [SALA：語意對齊是監督橋梁，不是接觸動力學等價](./01-sala-語意對齊是監督橋梁不是接觸動力學等價.md)
   - [2611.17110v1](https://arxiv.org/abs/2611.17110v1)，Jiachun Jin、Zetong Zhou、Haonan Wang、Xiao Yang、Jun Zhu、Zhijie Deng，2026-11-12 提交。
   - **實讀**：官方 HTML 摘要、§1–5 全部正文及附錄 §6–11，包含方法、資料／訓練、模擬／真機、消融、檢索、標註與任務成功條件；核 Tables 1–7 及圖說。未核圖像所有曲線點、未讀 PDF、未審碼／重跑／觀看影片。
   - **入選**：昨日僅記候選，今天正式讀方法。可拆清動作監督錨點、語言軟鄰居、SoftVQ 與 action expert 的實際學習路徑，符合 LLM × Embodied AI 交會優先。
   - **核心保留**：預訓練 scaling 是單次 run 的離線 L1，不等於真機成功曲線；真機主表同時增加 latent 與人類資料；語意檢索改善尚非接觸動力學等價。

## 有界搜尋與候選取捨

當次開啟 [cs.RO recent 前 50 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=50)，讀取返回頁面的標題／作者／comments，優先檢視前 18 筆；頁面列共 481 筆，最新公告 2026-11-13 的 106 筆中前 50。這是近七天窗口內的有界抽樣，不宣稱遍查全部 cs.RO／cs.CL／cs.AI，也不把週末公告未更新當成沒有新研究。

- **入選 SALA（2611.17110）**：已完成上述方法與實驗閱讀；新增前全庫僅昨日候選索引提及，沒有獨立筆記，非重複收錄。
- **待讀 [HEIR（2611.17238v1）](https://arxiv.org/abs/2611.17238v1)**：Yichi Zhang 等，2026-11-12 提交。只讀官方 metadata／摘要；語音、量測 gaze、第一人稱影片與導航／操作軌跡的配對值得追，但本次未讀方法與標註／評估協定，不把摘要的離線或真機評估描述當成已核成果。不為第二篇湊速覽。
- **僅標題層延後**：[Reins（2611.16632）](https://arxiv.org/abs/2611.16632)，頁面標題關注多模態模型零樣本長程真機操作；本次沒有讀摘要／方法，不據標題推論能力。
- **不重選 ACE-CaP-0（2611.16872）**：昨日已出獨立筆記；其具體閱讀與限制見[昨日索引](../2026-11-14/README.md)，本次未重新補讀。

去重：新增前搜尋全庫 Markdown，SALA 僅命中昨日候選索引；HEIR、Reins 無命中。撤稿／版本：SALA 與 HEIR 無版本官方摘要頁當次只列 v1，未見 withdrawn／retracted；Reins 只作標題級發現，未核版本狀態，不列為可直接入選。所有狀態僅截至本次擷取。

## 庫務與發布

先查 git root／origin／main／工作樹與 gh 認證，乾淨才 pull --ff-only，結果已最新。以 Python 標準函式庫取得官方 HTML、輕量 parser 抽取正文與表格，沒有安裝重型依賴。

更新日期／年度／論文總索引與根 README 短入口。研究導覽不變：本次可比較輔助目標與梯度路徑，但尚不改寫跨篇判準，避免逐日堆疊補註。

提交前檢查相對連結、篇數、diff 與 git diff --check；只 stage 本次檔案，繁中 commit 並 push main。發布依本機 scripts/deploy_pages_local.sh strict build／gh-pages 流程，另讀回 Pages source／branch build 及首頁、日期與本文正文；實際結果與 SHA 見本次交付，不使用 GitHub Actions。
