# 2026-10-30 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。近七天候選窗口採 **2026-10-23 至 2026-10-29**；於 2026-10-30 Asia/Taipei 上午擷取、閱讀與發布，不將完成時間冒稱為排程的 09:00。新增前當日非 README `.md` 為 0，本次後為 1，未達每日 2 篇上限。

## 今日選文

1. [ThinkWorld：預測後果，不等於辨識可執行動作](./01-thinkworld-預測後果不等於辨識可執行動作.md)
   - [arXiv:2610.37666v1](https://arxiv.org/abs/2610.37666v1)，2026-10-27 提交，2026-10-28 列表公告。
   - **實讀**：34 頁 PDF 摘要、§1–5、附錄 A.1–A.6、B.1–B.3、C.1–C.5、D、表 1–9 及相關圖說。已讀 motion tokenizer、VLM／action／RL 訓練契約、獎勵、真機分母與限制；未逐張目視影像、未審碼／重跑，不稱完整視覺審閱。
   - **入選理由**：LLM × 人類影片 × 機器人控制的交會研究，昨天只列待讀；今天追查「訓練時輔助 token 與部署時表徵消費」這個新機制，不把昨日候選冒充已讀。
   - **核心界限**：部署不生成 CoD／未來特徵；被動影片的後果吻合不是可執行動作的因果識別；技能組合使用共同訓練，定性 rollout 不當定量泛化證據。

## 有界候選與取捨

當次重新取得官方 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 與 [cs.CL recent](https://arxiv.org/list/cs.CL/recent)，各前 50 筆。兩者返回的最新公告仍為 **2026-10-28**，不是 2026-10-29／30；因此只是窗口內偏最新可取得公告的有界搜尋，**不是已確認七天全量或今日全部新稿**。以官方摘要頁核對各候選，不以列表標題推測方法。

- **入選 [ThinkWorld（2610.37666v1）](https://arxiv.org/abs/2610.37666v1)**：cs.RO 第 1 筆。直接取得 PDF，讀到方法、訓練、消融、失效軸及限制，對現有研究線索有新價值。
- **待讀 [When, Where, and What to Correct: Human-Guided Adaptive Residual Correction for Robot Policies（2610.37547）](https://arxiv.org/abs/2610.37547)**：cs.RO 第 7 筆，2026-10-27 提交。今天核對官方摘要：人類修正用於界定 residual 何時啟用及探索方向，而非單純當模仿標籤；未讀方法／實驗，不能確認其子空間建構、真機協定或消融。不為第二篇而把摘要成效當驗證結果。
- **待讀 [GEPA-Curator: Curated Learning for Self Improving Agents（2610.37651）](https://arxiv.org/abs/2610.37651)**：cs.CL 第 1 筆，2026-10-27 提交。摘要提出篩選 agent 經驗、分開 prompt／harness／執行／judge 噪聲，與庫內的證據選樣議題有關；今天僅讀摘要，未確認 task curation 規則、retrieval 及實驗公平性，交會研究優先而暫不收錄。

**去重／撤稿核對**：全庫 Markdown 搜尋 ThinkWorld ID，只有昨日候選索引命中，非 README 的正式筆記無命中；ARC 亦只有昨日候選提及，GEPA-Curator 無命中。三篇官方摘要頁當次未見 withdrawn／retracted 公告；ThinkWorld submission history 僅列 v1。候選提及不算正式篇數，不對未讀候選作方法背書。

## 庫務與取用限制

- git root／origin／main／乾淨工作樹及 gh 認證檢查後才執行 `git pull --ff-only`，回傳已是最新。未動他人變更。
- 網頁抽取工具回報 backend 不支援 URL extraction，改直接 HTTPS 讀官方列表、摘要及 PDF。使用現有 `pdftotext -layout`／`pdfinfo`，未安裝重型依賴。字型警告及圖形閱讀限制於單篇揭露。
- 更新日期／年度／總索引、root 短入口；研究導覽僅增加「訓練支架與部署消費」的跨篇辨別，不改寫舊筆記閱讀範圍。
- 提交前驗證 Markdown 相對連結、篇數及 `git diff --check`，僅 stage 本次檔案。push main 後使用 `scripts/deploy_pages_local.sh` 本機 strict build、push gh-pages 及 Pages branch build，不用 GitHub Actions 建置／部署。實際 SHA、source、build 與正式頁面驗證結果由本次交付回報。
