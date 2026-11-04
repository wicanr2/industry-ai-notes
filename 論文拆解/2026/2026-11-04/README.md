# 2026-11-04 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。近七天候選窗口為 **2026-10-28 至 2026-11-03**；實際擷取時間為 2026-11-04 Asia/Taipei 09:00 後。新增前當日非 README `.md` 為 0，本次後為 1，未超過每日 2 篇上限。

## 今日選文

1. [Route-Guided CBF-QP：安全投影，不等於軌跡可恢復](./01-route-guided-cbf-安全投影不等於軌跡可恢復.md)
   - [arXiv:2611.01713v1](https://arxiv.org/abs/2611.01713v1)，2026-11-01 提交。
   - **實讀**：5 頁 PDF 摘要、§I／II、§III-A–D 方法、§IV-A–D 實驗及§V 結論；官方 HTML 核對公式（1）–（10）及表 I／II。圖說已讀，但未逐幀看圖／影片；未審碼、未重跑，未逐篇補讀參考文獻。原文沒有獨立限制章／附錄。
   - **入選**：能清楚拆出固定 VLA → 堵路偵測 → 左右候選 → 軟路標與硬 CBF → 重接的控制介面；主表同時留下平均收益、Goal 退步與步數成本，不只改寫摘要。
   - **界限**：單一模擬 benchmark、同一 backbone；路標／分數／控制規格未完整，未報統計區間，硬約束也未達零碰撞。不推稱實機安全或全面優於基線。

## 有界候選與取捨

取得官方 [cs.RO recent 前 50 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=50)及[後 50 筆](https://arxiv.org/list/cs.RO/recent?skip=50&show=50)列表。擷取時最新列表為 2026-11-03，該日 149 筆，整個 recent 頁面共 573 筆；本次只取前 100 筆列表 metadata，並以以下三篇官方摘要頁補足候選核對。這不是七天全部 cs.RO／cs.CL／cs.AI 的普查；選文 Route-Guided 另直接取得原文，不聲稱它位於已讀前 100 筆中。列表與摘要只是發現線索，方法依 PDF／HTML。

- **入選 [Route-Guided CBF-QP Repair for Safe Vision-Language-Action Models（2611.01713v1）](https://arxiv.org/abs/2611.01713v1)**：完成上述方法與實驗閱讀。研究價值在恢復方向與安全約束的分工，不在最大平均漲幅。
- **待讀 [D&A: Decoupling Description and Assessment Enables VLMs as Zero-Shot Robotic Reward Models（2611.03622v1）](https://arxiv.org/abs/2611.03622v1)**：2026-11-02 提交；本次僅讀摘要與 metadata。描述與評分分離、用絕對成功 rubric 避免時間排序偏誤，值得後續查提示、失敗樣本與下游 RL；未讀方法／實驗，不將摘要的泛化與效能主張當成已驗證結果。
- **待讀 [VLALagBench: Understanding When and Why VLA Inference Latency Matters（2611.03103v1）](https://arxiv.org/abs/2611.03103v1)**：2026-11-02 提交；本次僅讀摘要與 metadata。適合續查同步／異步、延遲與吞吐如何共同影響完整任務，但尚未核對延遲注入協定及預測模型，不引用摘要數字當部署定律。保留下一輪，不倉促湊第二篇。

**去重與撤稿**：新增前查庫內論文 Markdown，以上三個 arXiv ID 均無命中；三篇無版本當前摘要頁均僅列 v1，未見 withdrawn／retracted 標記。下次選用待讀候選仍須重新核對，不能將今天記錄候選當成已完成方法閱讀。

## 庫務與發布

- 已確認 git root、origin、main、乾淨工作樹及 gh 認證，才 pull --ff-only；結果已最新，未處置其他人的工作。
- 擷取服務不支援 extract 後，改直接 HTTP 取得官方摘要、HTML、PDF，使用既有 pdftotext／pdfinfo 與 Python 標準庫；PDF 有字型警告，方法公式及主表再以 HTML 核對。未安裝重型研究依賴。
- 更新日期／年度／論文總索引及根 README 短入口。研究導覽已保留恢復／安全分帳路徑，本次未形成足以改寫跨篇判斷的新證據，因此不逐日加同義警語。
- 提交前檢查每日篇數、相對連結、diff 與 git diff --check，只 stage 本次檔案；push main 後用本機 scripts/deploy_pages_local.sh strict build／發布，不使用 GitHub Actions。實際 SHA、Pages source／branch build 及正式站正文驗證以交付報告為準，不將此處的流程說明當成發布成功證據。
