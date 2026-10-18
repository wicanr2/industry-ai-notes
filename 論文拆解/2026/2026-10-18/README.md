# 2026-10-18 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊滿每日上限。寫入前本日非 README `.md` 為 **0**，本次新增後為 **1**；首次提交日篩選窗口 **2026-10-11 至 2026-10-17**。昨日僅列候選的 T2-z 今日另建正式方法筆記，不將昨日紀錄改標為已讀全文。

## 今日選文

1. [T2-z：環境適配先問互動能否辨識](./01-t2z-環境適配先問互動能否辨識.md)
   - [arXiv:2610.22364v1](https://arxiv.org/abs/2610.22364v1)，首次提交 2026-10-15。
   - **實讀範圍**：官方 PDF 摘要、§1–5（完整方法及實驗／消融）、附錄 A–E（架構、資料、評估、基線、互動數／維度／PCA／效率）；另以官方 HTML 交叉核對部分主表、消融與成本。圖像只讀圖說及抽取數字，未逐圖視覺審查，未讀附錄 F 逐張定性圖、未審碼或重跑。主文沒有獨立 limitations 章，筆記明分評估邊界及自己的失效推論。
   - **研究價值**：將「候選能否排序」前移為「互動能否辨識當前環境」，連接 VeriVLA、Chronos 及 FoveaVLA 的資訊／時間限制。
   - **最重要口徑**：訓練不需物理參數真值但仍需按環境分組；測試候選保證至少有解；混合單位 Physical Error 平均不叫像素；18.09 秒只是一張 H200 上適配加五段 query 的 compute-only 計時。

## 有界搜尋、候選與取捨

擷取日期：**2026-10-18（Asia/Taipei）**。取得官方 [cs.RO recent](https://arxiv.org/list/cs.RO/recent)／[cs.CL recent](https://arxiv.org/list/cs.CL/recent) 各 50 筆列表，實際標題初篩為 **cs.RO 前六筆、cs.CL 前六筆**，另回查昨日保留候選 REKI；不是一週全庫窮盡回顧。

以庫內 Markdown 搜尋 arXiv ID：T2-z 與 REKI 都只命中昨日日期索引中的候選紀錄，未發現獨立正式筆記；不把候選出現當成已完成閱讀。兩者未帶版本的官方摘要頁本次都僅列 v1、首次提交日均為 2026-10-15，未見 withdrawn／retracted 文字標記；狀態限於本次讀回。

- **入選 T2-z（2610.22364v1）**：原文 PDF 與 HTML 都能取得；完整方法及評估附錄讓環境分組、候選可達性、混合量綱與成本口徑可被具體檢查，足以修正對「少量互動即可泛化」的直覺。
- **保留 [REKI: Registering Knowledge in VLAs（2610.22178v1）](https://arxiv.org/abs/2610.22178v1)**：重新取得官方 metadata／摘要。VLA 的 register memory 與近期觀測介面有關，但本次未讀方法、訓練混合及實驗協定；不依摘要的模型尺寸／Pareto／振盪改善主張另造第二篇。保留不等於研究較弱。
- **僅列表初篩、未完成資格核驗**：cs.RO 的 LIBERO-PeRM、Value as Memory、CoDA、Spark-0、Dexterity from Supervised Play；cs.CL 的 OmniVerifier-C1、Training Reasoning Models to Generate Diverse Scientific Ideas、MindEval2、Grid-Bench、Knowledge That Is Linear Before Fine-Tuning Generalizes After It、AI Consilium。當次優先集中在可延伸已有控制機制問題的 T2-z；上述未讀獨立版本頁／方法，不對其能力和撤稿狀態下結論。

## 庫務與發布邊界

- 已確認 repo root、origin、main、乾淨工作樹與 GitHub 認證後才 `git pull --ff-only`，已是最新。
- 通用 web extractor 回報目前 backend 無法擷取 URL，改用 `curl` 直接取得官方 PDF／HTML／列表，並以既有 `pdftotext` 輕量抽取，未安裝重型研究依賴。
- 更新日期／年度／論文總索引、根 README 短入口；研究導覽只增一條「環境可辨識性」跨篇機制。
- Markdown 為真實來源；使用本機 `scripts/deploy_pages_local.sh`，不用 GitHub Actions 建置／部署。實際 push、strict build、Pages branch build／source 及正式站讀回結果以交付回報為準，不預寫成功。
