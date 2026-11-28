# 2026-11-28 論文研究

今日新增 **1 篇方法閱讀筆記**，不為第二個名額縮減方法與實驗辨識。候選窗口採 2026-11-21 至 2026-11-27；擷取與實讀為 2026-11-28（Asia/Taipei）09:00 後。開始時本日非 README Markdown 為 0，新增後為 1。

## 今日選文

1. [DTU-Bench：清掉舊動作，不等於撤銷舊工作的物理承諾](./01-dtu-bench-清掉舊動作不等於撤銷舊工作的物理承諾.md)
   - [2611.34538v1](https://arxiv.org/abs/2611.34538v1)，Yanran Jiang、Cécile Paris、Dana Kulić、Leimin Tian；2026-11-25 15:20:36 UTC 提交。
   - **實讀**：官方 HTML 摘要、§1–6 正文，含 §3 任務／評估方法、§4 設定／受控診斷、§5 主表／配對續行／姿勢介入／helper 結果與結論；另下載版本 PDF，以 pdftotext 核對。未取得／未讀正文所指的 supplementary material，完整 coverage／排除、checkpoint、視覺介入與取消測試細節均保留未知；未審碼、重跑或逐圖視覺核驗。
   - **新機制與判準**：協定已清掉舊指令的待執行動作，仍需處理抓握與姿勢留下的物理承諾；同狀態新舊指令續行區分目標途經與指令依賴，Held-10／Final 區分暫時達標與終點達標。
   - **不外推**：鬆爪退臂是外部 scripted assistance，改善部分換物件任務也伴隨無支撐向下運動；不是 learned recovery、持續安全或真機撤銷已驗證。

## 有界搜尋與候選取捨

本次重新取得 [cs.RO recent 首 25 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=25)並讀完標題／metadata；頁面仍標示 2026-11-26 首 25／109 筆、recent 總列表 592 筆，未顯示較新的日批次。本次未遍查其他分類或全站；不由此斷言近兩日全站沒有新論文。三篇正式候選另抓官方摘要與版本歷史；以下日期皆為 submission history，不把列表公告日當提交日。

- **入選 [DTU-Bench（2611.34538v1）](https://arxiv.org/abs/2611.34538v1)**：昨日僅候選，今日補上方法與主實驗閱讀，接續佇列撤銷、持物承諾與反事實評估；不改昨日閱讀標記。
- **延後 [SOLVE（2611.34750v1）](https://arxiv.org/abs/2611.34750v1)**：2026-11-25 17:25:17 UTC。本次已讀官方摘要／metadata，稀疏末端 keyposes、planner 插值與執行回饋值得後續讀；尚未讀方法與實驗，摘要的成本、成功率及 zero-shot 數字不列今日核實結果。
- **延後 [Toward Agentic Robotics（2611.34778v1）](https://arxiv.org/abs/2611.34778v1)**：2026-11-25 17:39:10 UTC。已讀官方摘要／metadata；harness 的受控研究與基礎模型能力交互作用值得深讀，但未讀七組研究的實際比較與預算，不能把摘要的規模或增益直接當公平對照。為保留 DTU-Bench 的方法／副作用分析深度，今天不勉強新增第二篇。
- **僅標題級線索**：Cairn（2611.34914）、RePace（2611.34864）、RoboEvo²（2611.34675）等；未查方法／撤稿，不以標題推論效果。

正式候選三篇的現行摘要歷史僅見 v1，未見 withdrawn／retracted 標記。全庫 Git-tracked Markdown 按精確 ID 查重：三篇原先都僅出現在 2026-11-27 候選索引，沒有既有非 README 單篇筆記；候選提及不算已收錄。延後是閱讀預算取捨，不是品質否定。

## 庫務與發布範圍

先確認 repo root、origin、main、乾淨工作樹及 gh 認證，再 pull --ff-only，顯示已最新。擷取介面不支援 extraction，改用 Python 標準函式庫 urllib／HTMLParser 直接取官方 HTML／摘要／列表；使用既有 pdftotext 輕量抽取版本 PDF，不安裝重型依賴。PDF 字型警告未阻止文字輸出，公式與數字以 HTML／PDF 文字交叉核對。

新增本日索引與一篇筆記，更新年度／論文總索引、根 README 短入口；研究導覽只補「清佇列仍留下物理承諾」及同狀態指令對照的新判斷，不逐日堆同義摘要。提交前檢查相對連結、每日上限與 git diff --check，只 stage 本次檔案。push main 後本機執行 scripts/deploy_pages_local.sh，獨立讀回遠端 SHA、Pages source／branch build，並驗首頁、新索引與文章正文。實際發布結果以本次交付報告為準，不使用 GitHub Actions 建置或部署。
