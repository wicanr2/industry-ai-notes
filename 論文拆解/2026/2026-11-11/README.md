# 2026-11-11 論文研究

今天新增 **1 篇方法閱讀筆記**，不為上限湊第二篇。近七天候選窗口為 2026-11-04 至 2026-11-10，於 2026-11-11 Asia/Taipei 09:00 後檢查。寫入前今日非 README Markdown 為 0，新增後為 1；未把舊筆記改標為補讀全文。

## 今日選文

1. [雙臂操作：可達條件、局部恢復與安全驗證](./01-bimanual-可達條件與局部恢復不能代替安全驗證.md)
   - [Bridging Task Planning and Execution for Language-Conditioned Bimanual Manipulation，2611.12409v1](https://arxiv.org/abs/2611.12409v1)，Emanuele Cuzzocrea、Giuseppina Iannotti、Luca Rossini、Arturo Laurenzi、Nikos Tsagarakis；2026-11-09 提交、11-10 列表公告。
   - **實讀**：8 頁版本 PDF 的摘要、§I–II、§III A–E 方法、§IV A–B 實驗、§V 結論／未來工作，Table II–IV 與 Fig. 5–6 數字／圖說；未逐張視讀動作照片、觀看影片、審查程式或重跑。
   - **入選**：把側面空間、IK 可達性、阻擋原因與階段失敗歷史串入規劃／恢復，能用九個真機情境與兩級基線分析資訊增量及修正權限。
   - **保留**：固定底座、CAD／平行面夾取假設；成功 run 查詢成本、恢復決策子成本、純運動展示時間與總牆鐘分開。VLM 驗證不是形式化安全保證。

## 有界搜尋與候選取捨

- 檢查 [cs.RO recent 前 50 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=50) 標題、作者與分類；當次最新公告為 2026-11-10，該日 165 筆只檢查前 50。這是 LLM × Robotics 優先的有界探索，不是全 arXiv／全部近七天分類普查。
- **入選 [Bridging Task Planning and Execution（2611.12409）](https://arxiv.org/abs/2611.12409)**：取得原文 PDF，完成上述方法與實驗閱讀；不是僅依摘要推導流程。
- **待讀 [Correctness Boundaries of Typed Plans for Natural-Language Robot Fleet Control（2611.12654v1）](https://arxiv.org/abs/2611.12654)**：Artem Tuzov 等六位，2026-11-09 提交。只讀官方 metadata／摘要；摘要主動披露模擬完成條件、替換未完成 runs 與任務報告範圍，適合後續延伸 fleet control 的語意／執行界線。尚未讀方法、44-case benchmark 規格與原始 traces，不發布為方法筆記。
- **待讀 [A Benchmark and Layered Evaluation Protocol for Evidence-Grounded Shared Belief Updating in Connected Robotics（2611.11842v1）](https://arxiv.org/abs/2611.11842)**：Ranulfo Bezerra、Kimitoshi Yamazaki，2026-11-09 提交。只讀 metadata／摘要；其 evidence-prefix 評估與資訊匹配 structured-list 對照有價值，但尚未核查生成規範、統計與實驗，不將摘要數字當成已核結果，亦未為湊第二篇寫速覽。

**去重與撤稿**：三個候選 ID 在寫入前搜尋庫內無命中；三個官方無版本摘要頁當次 submission history 均只列 v1，未見 withdrawn／retracted 標記。這只是擷取當下狀態，非對後續版本保證。今天僅一個 ID 升格獨立筆記。

## 庫務與擷取限制

先驗 git root、origin、main、乾淨工作樹與 gh 認證後，git pull --ff-only（已最新）。通用網頁擷取工具回報僅搜尋後端不支援抽取；改用 Python 標準函式庫直接讀 arXiv HTML，再用 curl／pdfinfo／pdftotext 取得版本 PDF。初次 HTML 清理因無 bs4 失敗，改用無新增依賴的處理；未安裝重型套件。PDF 有字型警告，Table I 旋轉欄名不可靠，故不依其欄位宣稱跨方法全面比較。

更新日期、年度、論文總索引與根 README 短入口；研究導覽這次不變，以單篇連結 AMP1／Nav2 作問題對讀，沒有新增已驗證跨篇整合或改寫既有判斷。

提交前檢查相對連結、每日篇數與 git diff --check，只 stage 本次檔案。main push 後按本機 scripts/deploy_pages_local.sh 發布，不使用 GitHub Actions。實際 SHA、Pages source／branch build、正式首頁與新增頁正文讀回結果，以本次交付訊息為準。
