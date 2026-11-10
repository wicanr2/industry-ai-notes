# 2026-11-10 論文研究

今天新增 **1 篇方法閱讀筆記**，不湊第二篇。近七天候選窗口為 2026-11-03 至 2026-11-09，於 2026-11-10 Asia/Taipei 09:00 後查核；提交日期與列表公告日期分開記。寫入前今日非 README Markdown 為 0，新增後為 1，未變更舊筆記閱讀範圍。

## 今日選文

1. [AMP1：直接控制，要分開策略修正、時間與恢復權限](./01-amp1-直接控制要分開策略修正時間與恢復權限.md)
   - [On Agentic Manipulation Policies，arXiv:2611.09892v1](https://arxiv.org/abs/2611.09892v1)，2026-11-06 提交、11-09 列表公告；Chen Chen 等十三位作者，Apple，完整作者與日期口徑見單篇。
   - **實讀**：31 頁 PDF 的摘要、§1、§2A–2D、§3、§4A–4G；S1 真機／計時與 Table S1、S3 逐輪範例文字；主文圖表數字與圖說。未完整讀 S2、S4–S6，未逐圖視讀、審查程式或重跑。
   - **入選**：模型在執行期間可編輯幾何與程式、直接指定定時軌跡，能拆出技能抽象粒度、錯誤可觀測性與策略修正權；真機恢復消融及計時定義足夠支撐有界方法分析。
   - **保留**：零樣本／few-shot／continual 分開；真機恢復權限不對稱、推理不計入執行預算；RoboDojo 有五次練習 run 的驗證集選擇，主榜不當成牆鐘效率或安全證明。

## 有界搜尋與候選取捨

- 檢查 [cs.RO recent 前 50 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=50) 的標題／作者與分類資訊，最新公告為 2026-11-09，該日 60 筆中本次只看前 50。它是交會主題優先的有界探索，不是近七天全部 LLM／機器人分類普查。
- **入選 [AMP1（2611.09892v1）](https://arxiv.org/abs/2611.09892)**：取得版本 PDF 並讀上述方法／結果；庫內沒有既有候選或獨立筆記命中，適合追問「更直接的控制權何時有益」。
- **待讀 [Can LLMs Debug Robots by Editing Their Weights?（2611.09376v1）](https://arxiv.org/abs/2611.09376)**：2026-11-06 提交。摘要把 lexical repair 與一般機器人能力取得分開，適合延伸表徵／介入問題；今天只核 metadata／摘要，未讀方法、配對評測與修改保留準則，不將摘要成效寫成獨立驗證。
- **待讀 [ODEAction: From Predicting Chunks to Evolving Actions（2611.09672v1）](https://arxiv.org/abs/2611.09672)**：2026-11-06 提交。可與 chunk 邊界、連續性與控制時間線對讀；今天只核 metadata／摘要，未讀 action field 的訓練目標、積分器與公平計算預算，不憑摘要補方法。未為湊第二篇發布速覽。
- 先前候選 Where Is VLA Inference Time Spent?／VABAR 本日不重複展開；沒有補讀就不把舊候選升格為完整閱讀。

**去重／撤稿**：以三個新候選 ID 搜尋庫內 Markdown，寫入前皆無命中；本日只新增 AMP1。三個官方無版本頁與 submission history 當次只列 v1，未見 withdrawn／retracted 標記。這是擷取時狀態，不是對日後版本的保證。

## 庫務與發布

先驗 root／origin／main／乾淨工作樹與 gh 認證，才 git pull --ff-only（已最新）。PDF 以 curl／pdfinfo／pdftotext 輕量處理，不安裝重型依賴。更新日期、年度、論文總索引與根 README 的短入口；研究導覽不逐日疊加案例，這次以單篇交叉連結接回既有時間／恢復問題，未宣稱新整合已被驗證。

相對連結、篇數與 git diff --check 為提交門檻；只 stage 本次檔案。main push 後使用本機 scripts/deploy_pages_local.sh，不使用 GitHub Actions 建置或部署。遠端 SHA、Pages source／branch build、首頁與新增頁正文的實際讀回，以本次交付訊息為準。
