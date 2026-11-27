# 2026-11-27 論文研究

今日新增 **1 篇方法閱讀筆記**；不為第二個名額縮減閱讀深度。候選提交窗口為 2026-11-20 至 2026-11-26；擷取／閱讀為 2026-11-27（Asia/Taipei）09:00 後。開始前本日非 README Markdown 為 0，新增後為 1。正式候選三個 arXiv ID 已查全庫 Git-tracked Markdown，均未命中。

## 今日選文

1. [Memory Is Not Ground Truth：撤回記憶導航權，不等於物件不存在](./01-memory-authority-撤回記憶導航權不等於物件不存在.md)
   - [2611.34915v1](https://arxiv.org/abs/2611.34915v1)，Sumukh Shrote、Shenbagaraj Kannapiran、Eric Eaton、Camillo Jose Taylor；2026-11-25 18:57:52 UTC 提交。
   - **實讀**：官方 HTML 摘要、§I–VII 正文、§IV-A–D 方法、§V 的 E0–E4、Tables I–V 與 §VI 限制；另下載版本 PDF、pdftotext 核對方法／表格／Discussion。未逐圖視覺核驗、審碼、逐讀參考文獻或重跑。
   - **新增機制**：把物件存在信念、歷史保存與目前導航權分開；幾何分組避免把近似重訪全當新證據，一次負證據已撤回正常直接導航權。
   - **證據界線**：三個配對起點共用歷史，測到高階目標發布即停止，不是全自主導航成功；移動中的新記憶 promotion 也不是 dormant 復權成效。不能從選 frontier 推成省時／省能。

## 有界搜尋與取捨

取得並篩讀 [cs.RO recent 首 25 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=25)標題與 metadata。頁面顯示 2026-11-26 首批 25／109 筆，recent 總列表 592 筆；未遍查全站、全列表或所有 LLM 分類。以下正式候選另讀官方摘要與版本歷史，均在近七日窗口。日期按 submission history，不把公告日當提交日。

- **入選 Memory Is Not Ground Truth（2611.34915v1）**：VLM × 持久機器人記憶／導航交會，正文可取得；既有記憶主題之外新增「保留歷史不等於保留行動權」的判斷層，優先深讀方法及實驗分母。
- **延後 [SOLVE（2611.34750v1）](https://arxiv.org/abs/2611.34750v1)**：Xiang Li、Hongyu Zhou、Ya-Li Li、Tao Li、Rui Zhang、Junjie Lai、Weihua Zhang、Shengjin Wang；2026-11-25 17:25:17 UTC。已讀摘要／metadata，取得 HTML 但本次未閱讀其方法與實驗；稀疏 keyposes 與 planner 的責任邊界值得後續讀，不能把摘要的成本、成功率及零樣本宣稱直接當核實結果。
- **延後 [DTU-Bench（2611.34538v1）](https://arxiv.org/abs/2611.34538v1)**：Yanran Jiang、Cécile Paris、Dana Kulić、Leimin Tian；2026-11-25 15:20:36 UTC。已讀摘要／metadata，HTML 已取得但未讀方法／實驗；執行中改指令與物理狀態耦合可接既有撤銷問題。摘要的成功率與 scripted release 改善仍待方法／協定核對，不列為本日驗證結果。
- **僅標題級線索**：Cairn（2611.34914）、RePace（2611.34864）、Toward Agentic Robotics（2611.34778）、RoboEvo²（2611.34675）、M²AdaptVLA（2611.34560）。未核其版本／撤稿或方法，不由標題判定效果。

正式候選三篇官方歷史皆只見 v1，未見 withdrawn／撤稿標記；檢查以本次擷取為界。延後是閱讀預算取捨，不是品質否定。

## 庫務與發布範圍

核 repo root／origin／main／乾淨狀態與 gh 認證後，pull --ff-only 顯示已最新。本次 web extraction 介面回報不支援；改用 Python 標準函式庫抓官方列表／摘要／HTML，下載版本 PDF，以既有 pdftotext 核對，未安裝重型依賴。

新增本文與單篇，更新年度／論文總索引、根 README 短入口；研究導覽只加「歷史真實、當前支持、導航權、整段收益」這個新判斷層，不更改舊文閱讀範圍。提交前檢查每日上限、相對連結與 git diff --check，只 stage 本次檔案；push main 後本機執行 scripts/deploy_pages_local.sh，獨立讀回 source／branch build／遠端 SHA 與正式首頁、日期索引及文章正文。實際發布結果以最終交付為準，不使用 GitHub Actions 建置或部署。
