# 2026-10-16 論文研究

今日新增 **1 篇方法閱讀筆記**，不為上限湊第二篇。執行前今日非 README 的 `.md` 為 **0**；本次首次提交日窗口為 **2026-10-09 至 2026-10-15**（近 1–7 天）。未回填停更日期，也未把舊筆記改標為已補讀。

## 今日選文

1. [FoveaVLA：把下一次觀測變成策略輸出](./01-foveavla-把下一次觀測變成策略輸出.md)
   - [arXiv:2610.20064v1](https://arxiv.org/abs/2610.20064v1)，首次提交 2026-10-14；作者 Bingao Chen、Lihan Zha、C. Karen Liu、Guy Tevet。
   - **實讀**官方 PDF 摘要、§I–VI（含完整方法 §IV-A–D、實驗 §V-A–E）、附錄 A–D 與 Tables IV–X 的文字／試驗規格；另核官方 HTML Tables I–III 等數值。讀過圖說但未逐圖視覺檢驗、未看影片、未重跑。沒有獨立限制章，筆記把由方法與協定辨識的限制另列。
   - **LLM／VLA × Robotics 交會**：從「預測框作輔助任務」轉成「預測框決定下一次觀測」。補上既有控制契約／時間有效性框架中的空間資訊需求。
   - 保留小樣本、深度與視角的互補、MolmoSpaces 對照非受控、框的 Wait=0 不等於端到端零延遲等邊界。

## 有界搜尋與候選取捨

擷取日期：**2026-10-16（Asia/Taipei）**。實際取得官方 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 與 [cs.CL recent](https://arxiv.org/list/cs.CL/recent) 各前 50 筆列表，初篩實際閱讀的文字前段（兩表各前 46 項）；當時最新公告批次為 2026-10-15。**批次日不是作者提交日，列表標題不是方法證據；本次不是全週系統性回顧。** 下列四個 ID 均以庫內搜尋檢查，未見既有筆記／候選命中。

- **入選 FoveaVLA（2610.20064v1）**：取得官方 PDF／HTML 並實讀方法、實驗、附錄；未帶版本頁當時只列 v1、未見 withdrawn／retracted。具體消融可以拆開「框監督」「局部輸入」「幾何線索」，比單純摘要改寫更能累積研究判斷。
- **[Physical Time as a Missing Dimension of Robot Policy Memory Dynamics（2610.20524v1）](https://arxiv.org/abs/2610.20524v1)**：首次提交 2026-10-14；已讀 metadata／摘要，當時只列 v1、未見撤稿標記。摘要涉及實測時間間隔與記憶狀態演化，與 Chronos 時間線索相接；但未讀方法，尚未比較記憶演化與動作時間介面的真正差異，今日保留，不把摘要實驗主張當驗證。
- **[ObjDream（2610.20223v1）](https://arxiv.org/abs/2610.20223v1)**：首次提交 2026-10-14；已讀 metadata／摘要，當時只列 v1、未見撤稿標記。object-centric 表徵與未來狀態方向值得對照觀測選擇，但未讀方法、訓練目標／slots 的建構及消融，不能據摘要斷定方法或公平性。
- **[AdaRSI（2610.20474v1）](https://arxiv.org/abs/2610.20474v1)**：首次提交 2026-10-14；已讀 metadata／摘要，當時只列 v1、未見撤稿標記。摘要把 harness 改動與 executor 微調分開，與 ChunkAct 有潛在對話；但未讀錯誤歸因、資料自收集與算力對照的原文方法，今日不發布其結果數字。
- 其他只到標題初篩的例子：[Atomic-WAM（2610.20157）](https://arxiv.org/abs/2610.20157)、[Towards Agentic Robots（2610.20442）](https://arxiv.org/abs/2610.20442)、[Latent Compaction with Test-Time Training（2610.20582）](https://arxiv.org/abs/2610.20582)。未核其獨立版本／撤稿／方法，不能當已符合全部入選條件的候選或能力排序依據。

另有兩次探索性 ID 查詢（2610.20045、2610.19905）實際回傳非本題領域的統計／量子論文，立即排除，未將它們錯配為機器人研究。上述候選 ID 以列表與獨立 metadata 交叉確認。

只選一篇，是將本次閱讀集中於可核查的方法、消融與評估協定，不表示其餘候選較弱，也不預先承諾明日選題。

## 庫務與發布邊界

- 起始確認 repo root、origin、main 與乾淨工作樹，才執行 `git pull --ff-only`；先數今日篇數再寫入。去重及撤稿檢查見上。
- 僅用直接 HTTP／既有 `pdftotext`／Python 標準庫輕量抽取，未安裝研究用重型依賴。PDF 字型 warning 與 HTML 交叉核對記於單篇。
- 更新日期／年度／論文總索引、根 README 短入口；研究導覽僅補「下一次觀測的空間有效性」一條跨篇機制。
- 內容來源為 Markdown；main push、本機 strict build、gh-pages push、Pages source／branch build 與正式站首頁／當日索引／文章正文是否成功，以本次交付的實際驗證為準，不在此預寫成功。
