# 2026-11-16 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。候選提交日期窗口 **2026-11-09 至 2026-11-15**，於 2026-11-16 Asia/Taipei 10:35 後實際擷取；不是把本次取得的來源冒充 09:00 已知。開始時今日非 README Markdown 為 0，本次新增 1；舊文閱讀聲明不變。

## 今日選文

1. [Reins：條件動作鏈與旁白新鮮度，要分開驗證](./01-reins-條件動作鏈與旁白新鮮度要分開驗證.md)
   - [2611.16632v1](https://arxiv.org/abs/2611.16632v1)，Pengfei Ye、Zhiyang Dou、Yuxiang Ma、Haonan Chen、Heng Yang、Edward H. Adelson；2026-11-12 提交。
   - **實讀**：官方 HTML 摘要、§1–4、附錄 A–C、Tables 1–4；PDF 前兩頁文字交叉核 Figure 2。未逐像素讀圖、看影片、審碼或重跑。
   - **入選**：昨日只是標題級候選，今天正式讀方法。LLM × 真機操作交會，能拆開鏈內回傳條件、旁白時間窗／送達，以及 sim-ready 與 policy learning 的證據界限。
   - **主要保留**：去整體 harness 不等於 guard-only 消融；不同模型使用不同服務 tier，追蹤差異不能全歸模型；真機 88% 是 Sol 五任務合計 22/25，非部署可靠度；模擬 twin 未參與真機主實驗。

## 有界搜尋與取捨

本次開啟 [cs.RO recent 前 25 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=25)，檢視返回頁面的前 18 筆標題／作者／comments；頁面最新公告為 2026-11-13，這是近七日窗口內有界抽樣，非遍查 cs.RO／cs.CL／cs.AI。週一早上尚未有更晚公告，不據此宣稱沒有新研究。

- **入選 Reins（2611.16632）**：新增前全庫只有昨日候選索引命中，沒有獨立筆記；本次已讀方法、實驗與限制。
- **延後 [HEIR（2611.17238v1）](https://arxiv.org/abs/2611.17238v1)**：重新讀官方 metadata／摘要，語音、量測 gaze 與第一人稱影片對齊操作／導航軌跡值得研究，但本次沒讀方法、標註協定與實驗，不把摘要描述當查證結果，也不為第二篇湊速覽。
- **僅標題層延後 [EgoX（2611.16728）](https://arxiv.org/abs/2611.16728)**：標題的跨 embodiment 與 dreaming 和既有 latent／world-model 主題有關，但本次未讀摘要／方法，不推測流程與效益。
- **不重選 SALA（2611.17110）與 ACE-CaP-0（2611.16872）**：已有獨立筆記，見[昨日](../2026-11-15/README.md)與[前日](../2026-11-14/README.md)索引；本次未補讀它們。

撤稿／版本：Reins、HEIR 的無版本官方摘要頁本次只列 v1，未見 withdrawn／retracted。EgoX 只記發現，未核版本／撤稿狀態，不列為可直接入選。去重按全庫 Markdown arXiv ID 搜尋，候選提及不當成已完成筆記。

## 庫務

root／origin／main／工作樹與 gh 認證已檢查，乾淨才 pull --ff-only，結果已最新。HTML 以 Python 標準函式庫抽取，PDF 以既有 pdftotext 輕量讀取，沒有安裝重型依賴。

新增日期筆記與本索引，更新年度、論文總索引與根 README 短入口。研究導覽新增一則關於旁白窗口內生延遲的跨篇補註，沒有複製每日分析或改寫歷史閱讀範圍。

提交前檢查相對連結、篇數、diff 與 git diff --check；只 stage 本次檔案，以繁中訊息 commit、push main，再執行 scripts/deploy_pages_local.sh 本機 strict build／gh-pages 發布，獨立驗正式首頁、日期與本文、Pages source／branch build；實際 SHA 與驗證結果見本次交付，不使用 GitHub Actions。
