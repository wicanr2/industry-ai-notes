# 2026-11-24 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。提交日期窗口為 **2026-11-17 至 2026-11-23**；實際擷取／閱讀為 2026-11-24（Asia/Taipei）09:00 後。開始時本日非 README Markdown 為 0，新增後為 1；已搜尋全庫 arXiv ID，區分過去候選與獨立筆記。

## 今日選文

1. [Embodied-Harness：不更新權重，仍須分開經驗取得與凍結驗收](./01-embodied-harness-不更新權重仍須分開經驗取得與凍結驗收.md)
   - [2611.27689v1](https://arxiv.org/abs/2611.27689v1)，Zhenxuan Fan 等 8 位作者，2026-11-20 提交。
   - **實讀**：官方 PDF 摘要、§1、§2、§3.1–3.4 方法、§4.1–4.4 設定／實驗／消融／分析、§5 結論，Tables 1–6 與相關圖說／正文數值；另以官方 HTML 核對方法與協定。未逐條讀參考文獻、逐像素讀圖、看影片、審碼或重跑；PDF Figure 6 圖內抽文有亂碼，不據以補內容。無獨立限制章節，詳列本筆記從方法／實驗辨識的缺口。
   - **入選理由**：LLM／VLM agent × 操作的交會研究；Actor／Reflector、雙尺度記憶與跨嘗試指引更新有可拆解方法，主表與消融也能支持具體問題。與 ACE-CaP-0 的經驗取得成本、AgentRoboCritic 的事後診斷形成問題對讀，而不是再寫一次高成功率摘要。
   - **證據邊界**：零示範不等於零試錯；權重固定不等於資訊固定。修訂輪、記憶隔離、凍結後獨立驗收及總成本描述不足，不判定洩漏，也不宣稱已排除適應效應。真機僅三任務、各十次；成功、部分進度、分類分布與因果診斷分帳。

## 有界搜尋與候選取捨

本次取得並篩讀 [cs.RO recent 前 25 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=25)的標題與 metadata，最新公告為 2026-11-23；不是遍查全部 508 筆或全部 cs.CL／cs.AI。列表公告日與論文提交日不同，以下入選按官方提交歷史確認。

- **入選 Embodied-Harness（2611.27689）**：全庫無 ID 命中；官方無版本摘要／歷史僅列 v1，未見撤稿註記；PDF 與 HTML 方法皆可取得。閱讀投入資訊路徑、控制界面、消融和評估隔離，不以第二篇補數。
- **延後 [NavRSI（2611.27499v1）](https://arxiv.org/abs/2611.27499v1)**：Guangzhao Dai 等作者，2026-11-20 提交。已讀官方 metadata／摘要；聲稱透過 designer 改寫 harness，且 privileged simulator diagnostics 只給 designer，是適合後續辨識開發／部署資訊差異的對照。本次未讀方法與實驗，不能由摘要認定其驗收隔離已充分。全庫無 ID 命中，官方歷史只列 v1、未見撤稿註記。
- **延後 [Outcome Interfaces for Risk-Aware Planning After Robot Damage（2611.27939v1）](https://arxiv.org/abs/2611.27939v1)**：Hassan Iqbal、Krishna Kumar，2026-11-20 提交。已讀官方 metadata／摘要；受損機器人的後果／風險介面有價值，但不屬本次優先的 LLM × 操作交會，且尚未讀風險校準、探測與公平預算方法。不將摘要中的校準數字當成已驗證安全界限。全庫無 ID 命中，官方歷史只列 v1、未見撤稿註記。
- **標題級線索**：[EvoTER（2611.27797）](https://arxiv.org/abs/2611.27797)、[SOAR（2611.27639）](https://arxiv.org/abs/2611.27639)、[Ego4Gen（2611.27513）](https://arxiv.org/abs/2611.27513)、[ROSWORLD（2611.27467）](https://arxiv.org/abs/2611.27467)。只看列表，未讀摘要／方法，未核版本或撤稿，不據標題替它們下結論。
- **未重讀昨日候選**：Mind2Act World 仍只是既有日期索引中的候選，不把昨日摘要閱讀冒充今日方法閱讀。

撤稿檢查以擷取時的官方摘要／歷史為界，不等於保證未來狀態不變。未入選是本次範圍與閱讀預算取捨，不是判定論文品質不佳。

## 庫務與發布範圍

先核對 root、origin、main、乾淨工作樹及 gh 認證，才執行 git pull --ff-only，結果已最新。網頁擷取工具回報其 search-only backend 不支援 URL extraction，改用 Python 標準函式庫／curl 讀官方摘要、列表與 HTML，PDF 用既有 pdftotext 輕量抽文；未安裝重型研究依賴。

新增本文及日期索引，更新年度、論文總索引與根 README 短入口。研究導覽已有經驗取得／凍結驗收的問題線索，今日未形成足以改寫跨篇判斷的新證據，故不逐日追加同義補註。提交前檢查本次 Markdown 相對連結、每日上限與 git diff --check，只 stage 本次檔案；以繁中 commit 推至 main，再用本機 scripts/deploy_pages_local.sh strict build／發布 gh-pages，獨立讀回 Pages source／branch build 並驗證首頁、日期索引與文章正文。最終 SHA 與實際發布結果以本次交付工具輸出為準，不使用 GitHub Actions 建置或部署。
