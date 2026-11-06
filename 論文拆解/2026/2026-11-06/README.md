# 2026-11-06 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。候選窗口為 **2026-10-30 至 2026-11-05**；擷取時間為 2026-11-06 Asia/Taipei 09:00 後。新增前當日非 README `.md` 為 0，新增後為 1，未超過每日 2 篇上限。

## 今日選文

1. [ARP：快迴路要學會使用過期語意，而非只做快取](./01-arp-快迴路要學會使用過期語意而非只快取.md)
   - [arXiv:2611.05155v1](https://arxiv.org/abs/2611.05155v1)，2026-11-03 提交；作者 Sombit Dey、Luc Van Gool、Danda Pani Paudel。
   - **實讀**：17 頁 PDF 的摘要、§1–5、附錄 A–D（方法／flow matching／prefix、延遲消融、動態干預與資料、DROID／RoboLab／真機計分）；HTML 核對核心介面公式與 Tables 1–6 文字／數值，Figure 3 僅讀 PDF 文字層，未做圖色／誤差棒視覺校驗。未審碼、重跑、全面看圖／影片或追參考文獻。
   - **入選**：昨日僅讀摘要，今天真正補到方法；新增「快視覺 + 過期語意訓練」的資訊路徑，與昨日 VLALagBench 的整模型／chunk 排程問題不同。
   - **重要界限**：同架構消融支持過期記憶訓練的重要性；動態反應為模擬結果，真機採每任務 10 次的進度計分，不當作完整成功率。完整 RoboLab 平均成功率仍低於 π0.5，不用精選子集代表全體。

## 有界候選與取捨

本次檢視官方 [cs.RO recent 前 50 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=50) metadata：頁面最新公告日為 2026-11-05，該日 62 筆；另回查昨日待讀兩篇、讀以下新候選摘要與版本紀錄。這不是七天所有 cs.RO／cs.AI／cs.CL 的完整普查，公告日與作者提交日分開記。只有 ARP 完成方法閱讀。

- **入選 [Asynchronous Robot Policies（2611.05155v1）](https://arxiv.org/abs/2611.05155)**：2026-11-03 提交；完成上述閱讀。庫內原先只有昨日候選索引，沒有既有獨立筆記，沒有重複發文或升格舊閱讀紀錄。
- **續列待讀 [Should the Action Expert Train the VLM?（2611.05249v1）](https://arxiv.org/abs/2611.05249)**：2026-11-03 提交；今日讀摘要與版本，庫內僅昨日候選。梯度回流與 action-token supervision 的因子比較值得追，但本次未讀方法／實驗，不憑摘要效能湊第二篇。
- **新候選 [Where Is VLA Inference Time Spent?（2611.06710v1）](https://arxiv.org/abs/2611.06710)**：2026-11-04 提交；今日僅讀官方摘要／版本。跨 GPU 的瓶頸與優化交互可檢驗「快路徑不隨 VLM 規模增加」是否仍受硬體共享限制，但尚未核對量測方法、時序邊界與閉迴路品質，保留待讀，不當作已支持 ARP 部署效益。
- **新候選 [VABAR（2611.06881v1）](https://arxiv.org/abs/2611.06881)**：2026-11-04 提交；今日僅讀官方摘要／版本。已知變異下的工業任務與 agentic robotics benchmark 很貼合主題，但需追讀任務變異、技能庫、成功判定、評測資料暴露與物理可實現性，今天不以摘要列舉取代方法分析。

**去重與撤稿查核**：寫入前查四個 ID，ARP 與梯度路由論文只命中昨日候選，其餘兩篇無命中，皆無既有獨立筆記。四篇官方無版本摘要頁查核時均僅列 v1，未見 withdrawn／retracted 標記；此為擷取時狀態，不保證未來不修訂。

## 庫務與發布

- 先驗證 git root／origin／main／乾淨工作樹與 gh 認證，再 pull --ff-only，結果已最新，未處置其他工作。
- 使用既有 curl／pdfinfo／pdftotext，未裝重型依賴。web_extract 不支援此環境的 URL 擷取，改用 arXiv 官方 PDF／HTML 與瀏覽工具完成閱讀。
- 更新日期／年度／論文總索引、首頁短入口；研究導覽僅補「資訊有效期」路徑的一段機制差異，不重整其他路徑。
- 相對連結、篇數、diff 與 git diff --check 為提交門檻，只 stage 本次檔案。main push 後用 scripts/deploy_pages_local.sh 本機 strict build／gh-pages 發布；實際 SHA、Pages source／branch build 與正式站驗證，以交付報告為準，不把本段流程說明當成已完成證據。
