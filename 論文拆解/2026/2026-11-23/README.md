# 2026-11-23 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。提交日期窗口為 **2026-11-16 至 2026-11-22**；實際擷取是 2026-11-23（Asia/Taipei）11:39 後，不當成 09:00 已知。開始時本日非 README Markdown 為 0，新增後為 1；按 arXiv ID 搜尋全庫，區分過去日期索引中的候選與獨立筆記。

## 今日選文

1. [Z-sight：聯合去噪的未來是控制條件，不是候選動作後果](./01-zsight-聯合去噪未來是控制條件不是候選動作後果.md)
   - [2611.24940v1](https://arxiv.org/abs/2611.24940v1)，Junjie Ye 等 15 位作者，2026-11-18 提交。
   - **實讀**：官方 HTML 摘要、§1–5（含 Limitations）、A.1–A.3、B.1、C–D、E.1 協定與 Table E.1、E.2、F–G，主文 Tables 1–8 與圖說；另用 PDF 輕量抽文核對作者及相關表號。未完整讀 B.2／Table E.2 逐任務列，未逐頁讀完 PDF、逐像素讀圖、看影片、審碼或重跑。
   - **入選理由**：11-20 至 11-22 的摘要候選首次進入方法閱讀；部署直接生成原生 latent future，與 RelayWAM 的無部署 future generation 路徑不同。內容 × 噪聲條件介入補上可檢驗機制，但單向 attention 也清楚界定不是候選後果規劃。
   - **證據邊界**：噪聲量是生成條件，不是現實不確定性的校準；44/60 真機完整成功、單任務介入、離線 oracle MSE、SIMPLE Teleop／全 17 任務與 RoboTwin 主榜／消融分母均分開。

## 有界搜尋與取捨

本次取得 [cs.RO recent 前 25 筆頁面](https://arxiv.org/list/cs.RO/recent?skip=0&show=25)，實際篩讀前 15 筆標題／metadata；頁面最新公告仍為 2026-11-20。另回訪 Z-sight、Mind2Act World 的官方無版本摘要／歷史。不是完整遍查 cs.CL／cs.AI／cs.RO，亦不推測尚未公告的週末提交。

- **入選 Z-sight（2611.24940）**：全庫僅 11-20、11-21、11-22 候選命中，無獨立筆記；本次官方摘要頁只列 v1，未見撤稿註記。HTML 作者抽文只留下最後一人，故用摘要頁與 PDF 首頁交叉核對全體作者，不沿用抽文缺漏。
- **延後 [Mind2Act World（2611.26444v1）](https://arxiv.org/abs/2611.26444v1)**：Yuzhi Huang 等作者，2026-11-19 提交。本次讀 metadata／摘要；把記憶決策、物理執行及組合失敗拆開，適合日後與 AgentRoboCritic 對讀，但未讀診斷 harness、任務匹配與實驗方法，不將摘要的失敗歸因當作已驗證結論。全庫只有昨日標題候選；官方頁只列 v1，未見撤稿註記。
- **不重複 [AgentRoboCritic（2611.26613）](https://arxiv.org/abs/2611.26613)**：11-22 已有獨立方法筆記，本次僅在列表命中，未重新檢查該頁的版本／撤稿狀態。
- **保留標題級線索**：[PGX（2611.26596）](https://arxiv.org/abs/2611.26596)、[PhyDEX（2611.26565）](https://arxiv.org/abs/2611.26565)、[TacInno（2611.26405）](https://arxiv.org/abs/2611.26405)、[Reasoning on Call（2611.26341）](https://arxiv.org/abs/2611.26341)。只讀列表，不宣稱讀過摘要、方法或已核撤稿。

只出一篇，是把本次閱讀投入梯度隔離、介入反事實、控制時序與評估分母，而不是判定其他候選不值得。撤稿檢查以擷取時的官方歷史為界。

## 庫務與發布

先核 repo root、origin、main、工作樹與 gh 認證；工作樹乾淨才 git pull --ff-only，結果已最新。網頁擷取工具不可用，改以 Python 標準函式庫取得官方 HTML／摘要／列表與 PDF，再用 HTMLParser／pdftotext 輕量抽文，未安裝重型依賴。

新增本文、日期索引，更新年度／論文總索引與根 README 短入口；研究導覽只在「表徵如何被使用」路徑增加噪聲條件與非反事實規劃的判準，不改既有閱讀聲明。研究期間發現另一工作寫入今日新聞與共用 README，保留其變更；README 只 stage 本次論文差異，不將新聞內容包入本次提交。提交前檢查相對連結、每日上限與 git diff --check，只 stage 本次檔案。若共用 checkout 仍有另一工作變更，使用 scratch 的乾淨 main clone 執行同一個 scripts/deploy_pages_local.sh，避免移動、stash 或提交他人工作；仍是在本機 strict build、發布 gh-pages。讀回 Pages source／branch build 並驗證首頁、日期索引與本文正文；最終發布狀態及 SHA 以本次交付實際輸出為準，不使用 GitHub Actions。
