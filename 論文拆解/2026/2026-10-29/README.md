# 2026-10-29 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。近七天窗口為 **2026-10-22 至 2026-10-28**；於 2026-10-29 Asia/Taipei 上午研究與發布，不冒稱 09:00 即完成。寫入前當日非 README `.md` 為 0，本次後為 1，上限為 2。

## 今日選文

1. [LongChang：發現規律，要分開答案正確與證據支持](./01-longchang-發現規律要分開正確與證據支持.md)
   - [arXiv:2610.37649v1](https://arxiv.org/abs/2610.37649v1)，2026-10-27 提交、2026-10-28 列表公告。
   - **實讀**：14 頁 PDF 摘要、§1–8、附錄 A.1–A.5，含方法／任務、文字觀測、工具／探索／報告／judge 介面、主評估、介入比較、演化場景及限制，核對表 1–9。未審碼、未重跑、未獨立校準 judge，圖形只讀文字與圖說。
   - **入選理由**：LLM × 物理探索的交會研究；接續 T2-z 的環境可辨識性，把問題前移到「如何自己選擇能區分假說的介入」，並分開完整答案與證據支持。
   - **關鍵界限**：不是 VLA 像素控制，不是 explorer 訓練法；LLM judge 分數不是已獨立驗證的真機或通用科學能力。指引消融包含多個提示改動，器材存取不等於每次造工具的因果收益。

## 有界候選與取捨

來源為當次 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 與 [cs.CL recent](https://arxiv.org/list/cs.CL/recent) 首頁，各前 50 筆；最新公告均為 **2026-10-28**。這是窗口內偏最新公告的有界檢索，不是七天全量回顧。先以列表發現候選，再查官方摘要／版本；提交日與公告日分開記錄。

- **入選 [Can LLMs Uncover Hidden Physical Laws through Free Exploration?（2610.37649v1）](https://arxiv.org/abs/2610.37649v1)**：cs.CL 第 2 筆。取得 PDF／HTML 並閱讀方法、實驗、限制及附錄；其「正確／支持」分帳對現有研究線索有新增價值，不以模型排行為主題。
- **待讀 [ThinkWorld: World Imagination Reinforces Chain-of-Dynamics Reasoning（2610.37666v1）](https://arxiv.org/abs/2610.37666v1)**：cs.RO 第 1 筆。人類影片、離散 motion tokens 與想像回饋，符合 LLM × embodied 交會方向。今日核對官方摘要與版本，下載 HTML 作候選備存，但**未閱讀方法與實驗**，不聲稱已確認其訓練細節或轉移收益，留待完整研究而非湊第二篇。
- **待讀 [When, Where, and What to Correct: Human-Guided Adaptive Residual Correction for Robot Policies（2610.37547v1）](https://arxiv.org/abs/2610.37547v1)**：cs.RO 第 7 筆。稀疏人類修正與 residual 探索的介面值得追查。今日只讀官方摘要／版本，未讀方法、真機協定或消融；不以摘要數字當經驗證成效，暫不收錄。

**去重／撤稿狀態**：新增前以三個完整 arXiv ID 搜尋全庫 Markdown，均無命中。三篇官方摘要頁當次均只列 v1，未見 withdrawn／retracted；僅代表 2026-10-29 擷取時狀態。候選提及不等於已產生第二／第三篇筆記。

## 庫務與取用限制

- 已檢查 git root、origin、main、乾淨工作樹及 gh 認證，安全執行 `git pull --ff-only`，回傳已是最新。
- 網頁抽取服務 backend 不支援 URL 擷取，改用直接 HTTPS 取得官方列表、摘要、HTML／PDF。用現成 `pdftotext -layout` 輕量閱讀；字型警告與未讀範圍在單篇揭露，未安裝重型依賴。
- 更新日期／年度／總索引及 root 短入口；研究導覽只補上「可區分介入、完整辨識與證據支持」跨篇線索，不把舊筆記改標為已讀全文。
- 提交前驗證相對連結、每日篇數及 `git diff --check`，僅 stage 本次檔案。push 後以 `scripts/deploy_pages_local.sh` 在本機 strict build、push gh-pages 並要求 Pages branch build，不使用 GitHub Actions 建置／部署。實際 SHA、Pages source／build 與正式頁面正文驗證以本次交付結果為準。
