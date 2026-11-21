# 2026-11-21 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。提交日期窗口為 **2026-11-14 至 2026-11-20**；擷取日期為 2026-11-21（Asia/Taipei）09:00 後。開始時本日非 README Markdown 為 0；新增後為 1。先以 arXiv ID 搜尋全庫，候選索引命中不當成已有獨立筆記。

## 今日選文

1. [Grana：進度標籤是程序帳本，不是物理完成度](./01-grana-進度標籤是程序帳本不是物理完成度.md)
   - [2611.24926v1](https://arxiv.org/abs/2611.24926v1)，Zi-ang Cao 等 17 位作者，2026-11-18 提交。
   - **實讀**：官方 HTML 摘要、§1–5、附錄 A–E、Tables 1–15 文字、Figures 1–9 圖說；已讀標註建構、兩階段模型、訓練目標、離線 RL／加權 BC、主表消融與在線 MPC。未另讀 PDF、逐像素讀圖、看影片、審碼或重跑。
   - **入選理由**：把昨日摘要候選首次讀到方法。進度依有序、等權子任務與品質事件建構，補上 Memory Clock 的「等待不等於工作」以外的標籤定義問題。
   - **重要界限**：離線打分可用未來觀測；D15 預測和 D100 policy 改善分帳；自選子任務的 zero-shot 紅車結果不如 GPT composition；0.8B 在線 MPC 與 4B 主表不同。沒有把局部 RMSE 改善推成即時安全或完整工作保證。

## 有界搜尋、去重與候選取捨

檢視 [cs.RO recent 前 25 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=25) 本次頁面前 15 筆標題／metadata，最新公告日為 2026-11-20；另回訪昨日兩個候選的官方無版本摘要頁。交會研究優先，非遍查 cs.RO、cs.CL、cs.AI 的全部論文。

- **入選 Grana（2611.24926）**：新增前僅昨日日期索引候選一處命中，無獨立筆記；官方無版本摘要頁只列 v1，未見撤稿／撤回註記。
- **延後 [AgentRoboCritic（2611.26613v1）](https://arxiv.org/abs/2611.26613v1)**：Yiyang Du 等 10 位作者，2026-11-19 提交、11-20 列表公告。本次只讀 metadata 與摘要；以 local intent 為條件的 action-level critique 值得後續讀標註、critic 校準與評估，但未讀方法，不以摘要 accuracy 宣稱泛化或控制可靠。新增前全庫 ID 無命中；無版本摘要頁只列 v1，未見撤稿註記。
- **延後 [$Z$-sight（2611.24940v1）](https://arxiv.org/abs/2611.24940v1)**：Junjie Ye 等 15 位作者，2026-11-18 提交。本次重讀 metadata／摘要，原生視覺 token 空間與 future／action 聯合去噪可對照 RelayWAM；尚未讀方法、資料、消融及真機協定，不補猜細節。全庫僅昨日候選命中；無版本摘要頁只列 v1，未見撤稿註記。
- **僅標題級線索**：[PGX（2611.26596）](https://arxiv.org/abs/2611.26596)、[PhyDEX（2611.26565）](https://arxiv.org/abs/2611.26565)、[TacInno（2611.26405）](https://arxiv.org/abs/2611.26405)、[Reasoning on Call（2611.26341）](https://arxiv.org/abs/2611.26341)。未核其摘要、版本或撤稿狀態，不作研究結論。

不湊第二篇，是把本輪閱讀用在 Grana 的標籤內插、未來觀測、selector 反例及 D100／MPC 附錄；不是宣稱延後候選品質較差。撤稿檢查只代表擷取時官方頁未見註記。

## 庫務與發布

先核對 repo root、origin、main、工作樹與 gh 認證；乾淨才 git pull --ff-only，結果已最新。web_extract 因後端僅支援 search 無法取文，改由 Python 標準函式庫擷取官方 HTML，未安裝重型依賴。摘要頁與列表另用 web 核對。

新增筆記／日期索引，更新年度／論文總索引與根 README 短入口；研究導覽只在「完整工作」路徑追加程序記帳與離線／在線界限，不改舊文閱讀聲明。提交前檢查相對連結、每日上限及 git diff --check，只 stage 本次檔案。main push 後使用 scripts/deploy_pages_local.sh 本機 strict build／發布 gh-pages，另讀回 Pages source、branch build 及正式頁正文；實際 SHA／HTTP 驗證見本次交付，不使用 GitHub Actions。
