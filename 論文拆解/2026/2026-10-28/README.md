# 2026-10-28 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。近七天選文窗口為 **2026-10-21 至 2026-10-27**；研究於 2026-10-28 Asia/Taipei 上午執行，不冒稱 09:00 已完成。寫入前今日非 README `.md` 為 0，本次新增後為 1。

## 今日選文

1. [PIFR：恢復進度，不等於記住任務或安全搶占](./01-pifr-恢復進度不等於記住任務或安全搶占.md)
   - [arXiv:2610.35576v1](https://arxiv.org/abs/2610.35576v1)，2026-10-26 提交。
   - **實讀**：11 頁 PDF 摘要、§1–6 的導論、任務／資料建構、方法、實驗、消融及結論；表 1、3、4，另以官方 HTML 核對表 4。圖像只讀擷取文字／圖說及正文，不估讀圖中曲線；references 未逐篇追讀，未審碼／重跑／驗證真機，未見獨立 limitations 節或方法附錄。
   - **新增機制**：中斷後從新位置重新 grounding；候選 BCE、最大正負分排序與恢復加權，不改在線候選／導航流程。
   - **判斷修正**：協定重發下一指令不是模型自行記住欠下的任務；原子任務邊界切換不是緊急安全搶占；入口段 Resume SR 不是整條任務鏈成功率。消融的排序必要性、baseline 身分及小增益的不確定性均保留。

## 有界候選與取捨

來源為當次 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 與 [cs.CL recent](https://arxiv.org/list/cs.CL/recent) 首頁，各前 50 筆；最新公告欄位均為 **2026-10-27**。這是近七天窗口內、偏最新公告的有界檢索，不是七天所有論文的完整回顧。提交日與公告欄位分開記錄。

- **入選 [Preemptive Instruction Following with Resumption（2610.35576v1）](https://arxiv.org/abs/2610.35576v1)**：cs.RO 第 17 筆，2026-10-26 提交。承接昨日 Nav2 的政策生命週期，新增「恢復進度／重辨目標／安全停切」的責任區分；已取得並閱讀方法、評估與消融，不以摘要充當驗證。
- **待讀 [RoboDoctor（2610.35604v1）](https://arxiv.org/abs/2610.35604v1)**：cs.RO 第 15 筆，同日提交。官方摘要提出固定權重下的診斷、介入、操作與持久經驗，也明說跨 episode 經驗貢獻仍需受控試驗。今日只核對摘要／版本，未讀方法與實驗，不把其分數或自我改進主張寫成已驗證第二篇。
- **待讀 [Profiling a Frontier Agent with EBench（2610.35832v1）](https://arxiv.org/abs/2610.35832v1)**：cs.RO 第 3 筆，同日提交。agent 直接控制與呼叫既有 policy 的交接邊界值得接續 AW-0／FastHarness；今日只讀官方摘要與版本，未檢查操作設定、成本口徑或任務分解，因此不引用摘要結果替模型排名。
- cs.CL 首頁僅作純 LLM 候選發現補充；今日優先把與現場任務恢復直接相關的一篇讀深，而不是硬加一篇尚未讀方法的研究。

**去重／撤稿狀態**：新增前以三個完整 arXiv ID 搜尋全庫 Markdown，均無命中；三篇官方摘要頁的提交歷史當次均只列 v1，未見 withdrawn／retracted。此狀態只及 2026-10-28 擷取，不推定日後不會更新。

## 庫務與取用限制

- 已驗證 git root、origin、main、乾淨工作樹及 gh 認證，再 `git pull --ff-only`，回傳已是最新。
- 網頁抽取工具因 search-only backend 無法擷取 URL；改以 HTTPS 直接取官方列表、摘要頁、PDF 與 HTML 成功，未用二手摘要補方法。PDF 由既有 `pdftotext -layout` 輕量抽取，字型警告與未讀範圍已在單篇揭露，未安裝重型依賴。
- 更新日期／年度／總索引與 root 短入口；研究導覽只增加「邏輯恢復、感知重接與安全切換」的跨篇區分，不改動任何舊筆記的閱讀範圍。
- 提交前檢查相對連結、每日篇數與 `git diff --check`，僅 stage 本次檔案；push 後依本機 `scripts/deploy_pages_local.sh` strict build／gh-pages 發布，不使用 GitHub Actions 建置或部署。實際 SHA、Pages source／branch build 與 HTTP／正文驗證見本次交付回報。
