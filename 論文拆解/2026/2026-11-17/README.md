# 2026-11-17 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。候選提交窗口為 **2026-11-10 至 2026-11-16**，於 2026-11-17 Asia/Taipei 實際擷取。開始時今日非 README Markdown 為 0，新增後為 1；舊候選及舊文閱讀聲明保持原樣。

## 今日選文

1. [HEIR：看懂人類指涉，不等於持續更新意圖或完成整段工作](./01-heir-看懂人類指涉不等於持續更新意圖或完成整段工作.md)
   - [2611.17238v2](https://arxiv.org/abs/2611.17238v2)，Yichi Zhang 等 14 位作者；2026-11-12 初稿、2026-11-13 修訂。
   - **實讀**：官方 HTML 摘要、§1、§3–6、附錄 B–D、E.1–E.4，Tables 2–6、9–13 與 Algorithm 1；E.5 的意圖提示及 E.6 planner 前段證據約束。未逐字讀完整提示附錄、逐像素核圖、看影片、審碼或重跑。
   - **入選**：前兩日只列候選，今天首次方法閱讀。人類視角／實測眼動如何進入具身控制，與近期條件鏈、資訊新鮮度與階段完成證據相接；沒有新寫一篇摘要速覽充數。
   - **主要判讀**：一次請求 grounding 不等於執行中持續更新意圖；20 秒 inactivity 是 review trigger，不是完成或安全證據；Completion F1 是文字條件對齊，整合真機 episode 成功率另報。

## 有界搜尋與候選取捨

開啟 [cs.RO recent 首頁前 25 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=25)，檢視返回內容前 18 筆的標題、作者與 comments；最新公告為 2026-11-16。另核 HEIR 與下列 reasoning 論文的官方 metadata／摘要。這是交會研究優先的有界抽樣，沒有遍查所有 cs.CL／cs.AI／cs.RO，也不主張未入選者價值較低。

- **入選 HEIR（2611.17238）**：以全庫 Markdown ID 搜尋去重，原有命中僅 11-15、11-16 候選，沒有獨立筆記；今天讀方法、實驗與部署限制。無版本摘要頁列 v1、v2，未見 withdrawn／retracted；採實際可取得的 v2，不沿用昨日索引的僅 v1 觀察。
- **延後 [Training Reasoning Models in Simulation to Natively Use Real Robots（2611.18562v1）](https://arxiv.org/abs/2611.18562v1)**：2026-11-13 提交、11-16 公告；Jiaming Tang 等。官方摘要提出模擬中的 robot-use RL 與真機轉移，方向高度相關，但本次只讀 metadata／摘要，未讀 PEAR／RURL 方法、訓練任務分割與真機試驗協定，不引用摘要數字作已核結果。值得另次方法閱讀，不為今日第二篇把強主張寫成弱驗證；官方版本頁目前列 v1，未見撤稿標示。
- **僅標題級延後 [Objectives as Policies（2611.18298）](https://arxiv.org/abs/2611.18298)**：VLM cost programs 與接觸操作值得追；本次未讀摘要／方法、未核版本與撤稿，不推測控制流程或保證。
- **僅標題級延後 [ESI（2611.18176）](https://arxiv.org/abs/2611.18176)**：LLM–VLA 自我改進交會符合範圍，但本次未讀方法或驗證閉迴路與資料來源，不把 flywheel 標題當效能證據。
- **不重選 Reins（2611.16632）、SALA（2611.17110）、ACE-CaP-0（2611.16872）**：已有獨立筆記；本次未補讀或改寫舊文。

## 庫務與發布

先確認 root、origin、main、工作樹與 gh 認證；乾淨才 git pull --ff-only，結果已最新。官方 HTML 使用 Python 標準函式庫輕量抽取，未安裝重型依賴。

新增日期筆記／索引，更新年度、論文總索引及根 README 短入口；研究導覽暫不變，避免把既有新鮮度與完成證據警語逐日疊加。新問題留在單篇，待跨篇實驗改變判準再回收。

提交前檢查 Markdown 相對連結、今日篇數及 git diff --check，只 stage 本次檔案；main 提交推送後，依 scripts/deploy_pages_local.sh 在本機 strict build 與 gh-pages 發布，再獨立讀回 Pages source／branch build、正式首頁、日期頁與本文。實際 SHA 與結果見本次交付；不使用 GitHub Actions。
