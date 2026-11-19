# 2026-11-19 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。提交窗口為 **2026-11-12 至 2026-11-18**，於 2026-11-19（Asia/Taipei）擷取。開始時今日非 README Markdown 為 0，新增後為 1；全庫 ID 去重後才新增。

## 今日選文

1. [PEAR：模擬學會位姿決策，不等於免除控制器與任務覆蓋](./01-pear-模擬學會位姿決策不等於免除控制器與任務覆蓋.md)
   - [2611.18562v1](https://arxiv.org/abs/2611.18562v1)，Jiaming Tang 等 11 位作者，2026-11-13 提交。
   - **實讀**：官方 HTML 摘要、§1、§3–6、附錄 A–H，Tables 1–7 及 Figures 1–11 圖說。已讀方法、資料／課程、各類評估、完整 RoboDojo、真機逐次失敗與提示；未逐像素讀圖、看影片、審碼或重跑。沒有冒稱讀過 PDF。
   - **入選**：11-17 只列候選，本次首次讀方法。用稀疏終局 reward 學位姿決策、從 LIBERO 課程遷移到真機，能補上近期直接控制研究的訓練端證據。
   - **關鍵判讀**：無技能 harness 不等於無控制器；18/30 真機試驗集中在兩類模擬已訓練任務；完整 RoboDojo 的 context 耗盡、BF16 成功率與 NVFP4 吞吐分開看。組內混合 reward 的簡化機率分析明列假設，非作者實測。

## 有界搜尋、去重與候選取捨

開啟 [cs.RO recent 前 25 筆頁面](https://arxiv.org/list/cs.RO/recent?skip=0&show=25)，本次檢視返回的前十筆標題／作者／comments（最新公告 2026-11-18）；另取得以下三篇官方摘要頁，及 PEAR 的官方 HTML 方法。是交會研究優先的有界抽樣，不代表遍查 cs.RO／cs.CL／cs.AI 或替全部候選排名。

- **入選 PEAR（2611.18562）**：全庫 Markdown 搜尋原先只有 11-17 候選命中，沒有獨立筆記；無版本摘要頁只列 v1，未見撤稿標示。
- **延後 [Making Future-Predictive Representations Actionable／RelayWAM（2611.22994v1）](https://arxiv.org/abs/2611.22994v1)**：Fangchuan Wang 等，2026-11-17 提交。摘要提出把 future supervision 與 action pathway 接起來，適合與既有表徵路徑對讀。今日只讀官方 metadata／摘要，沒有取得並閱讀方法、消融及真機協定；不把摘要效能數字寫成已核結果。摘要頁只列 v1、未見撤稿標示；全庫搜尋未命中既有筆記。
- **延後 [Fly as Instructed（2611.22883v1）](https://arxiv.org/abs/2611.22883v1)**：Zhexuan Zhou 等，2026-11-17 提交。摘要中的指令消耗、進度／終止與幾何回饋值得追；今日僅讀 metadata／摘要，不由標題或摘要補出訓練及安全細節。摘要頁只列 v1、未見撤稿標示；全庫搜尋未命中既有筆記。
- **標題級候選，不延伸結論**：recent 前十筆另有 [Auditing a Learned Simulator for Legged Robots（2611.23118）](https://arxiv.org/abs/2611.23118) 與 [TCP4D（2611.23143）](https://arxiv.org/abs/2611.23143)。本次只見標題／列表 metadata，未核方法、版本及撤稿狀態，不作方法判讀。

只挑一篇，是把時間用在附錄中的反例及公平比較，不是斷言延後論文較差。舊 HEIR、Reins 等既有筆記不重寫，不改它們原閱讀聲明。

## 庫務與發布

先查 root、origin、main、工作樹與 gh 認證；工作樹乾淨才 git pull --ff-only，結果已最新。擷取工具不支援 URL extract 後改用 Python 標準函式庫直接取得官方 HTML，沒有安裝重型依賴。

新增日期筆記及索引，更新年度／論文總索引及根 README 短入口。研究導覽維持原樣：本文的新訓練問題先留單篇，尚未有跨篇整合實驗改變共同判準，不每天追加同義警語。

提交前檢查相對連結、每日上限及 git diff --check，只 stage 本次檔案；push main 並比對遠端 SHA 後，在本機執行 scripts/deploy_pages_local.sh 做 strict build 與 gh-pages 發布，另讀回 Pages source／branch build、首頁、日期索引與本文。實際 SHA、HTTP 驗證與發布結果見本次交付；不使用 GitHub Actions。
