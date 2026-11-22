# 2026-11-22 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。候選提交日期窗口為 **2026-11-15 至 2026-11-21**；擷取日期 2026-11-22（Asia/Taipei）09:00 後。開始時本日非 README Markdown 為 0，新增後為 1；已按 arXiv ID 搜尋庫內候選與獨立筆記，沒有把昨日候選當作已有方法筆記。

## 今日選文

1. [AgentRoboCritic：局部意圖履約，不等於全局任務正確](./01-agentrobocritic-局部意圖履約不等於全局任務正確.md)
   - [2611.26613v1](https://arxiv.org/abs/2611.26613v1)，Yiyang Du 等 10 位作者，2026-11-19 提交。
   - **實讀**：官方 HTML 摘要、§1–6、附錄 A–C、E–F、H–J；相關主表、恢復分母、LoRA 訓練、提示／codebook、局部意圖消融、回饋案例與延遲定義。附錄 G 只讀文字／圖說；未逐項讀附錄 D／Tables 5–8、未逐像素讀圖、未另讀 PDF、未審碼或重跑。
   - **入選理由**：從昨日摘要候選首次讀到方法，補上「評估參照也會錯」的機制：忠實執行錯誤局部目標不屬 Choice，局部履約不可代替全局正確。
   - **證據邊界**：400 人工測試、12,844 critic 訓練動作與 12,163 恢復分析失敗動作分帳；57.7% 是事後觀察恢復，不是 critic 介入增益。後續 lift 證據與 31.9 秒 policy 決策彙總延遲，不能借作即時安全能力。

## 有界搜尋與取捨

本次取得 [cs.RO recent 前 25 筆頁面](https://arxiv.org/list/cs.RO/recent?skip=0&show=25)，實際篩讀前 13 筆標題／metadata；最新公告仍為 2026-11-20。另回訪 AgentRoboCritic 及 Z-sight 的官方無版本摘要頁；不是遍查 cs.CL／cs.AI／cs.RO 所有新稿，也不把尚未出現的 11-21 提交猜成已公告。

- **入選 AgentRoboCritic（2611.26613）**：新增前只有 11-21 日期索引的摘要候選命中，無獨立筆記；本次官方摘要頁只列 v1，未見撤稿／撤回註記。
- **延後 [Z-sight（2611.24940v1）](https://arxiv.org/abs/2611.24940v1)**：Junjie Ye 等 15 位作者，11-18 提交。本次只讀 metadata／摘要；原生視覺 token 空間與部署聯合去噪值得與 RelayWAM 對讀，但尚未讀方法、消融及真機協定，不據摘要數字作判斷。庫內只有 11-20、11-21 候選命中，無獨立筆記；官方頁只列 v1，未見撤稿註記。
- **保留標題級線索**：[PGX（2611.26596）](https://arxiv.org/abs/2611.26596)、[PhyDEX（2611.26565）](https://arxiv.org/abs/2611.26565)、[Mind2Act World（2611.26444）](https://arxiv.org/abs/2611.26444)、[TacInno（2611.26405）](https://arxiv.org/abs/2611.26405)。未讀摘要／方法，未核版本或撤稿狀態，不從標題補因果或評價品質。

不湊第二篇，是把本次閱讀用於第一篇的參照定義、觀測可用時間、標註分母與介入證據；不是說其他候選品質不足。撤稿檢查只是擷取當時官方頁未見註記。

## 庫務與發布

先核 repo root、origin、main、工作樹及 gh 認證，乾淨才 git pull --ff-only，結果已最新。以 Python 標準函式庫取得官方 HTML／摘要頁／列表並輕量抽文，未裝重型依賴。

新增本文及日期索引，更新年度／論文總索引與 README 短入口；研究導覽僅在責任介面路徑補充「局部契約參照不等於全局正確」。不修改既有筆記閱讀聲明。提交前檢查相對連結、每日上限與 git diff --check，只 stage 本次檔案；main push 後用 scripts/deploy_pages_local.sh 本機 strict build／發布 gh-pages，並讀回 Pages source／branch build 和正式頁正文；實際 SHA／HTTP 驗證以本次交付為準，不使用 GitHub Actions。
