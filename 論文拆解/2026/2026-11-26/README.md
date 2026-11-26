# 2026-11-26 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。提交日期候選窗口為 2026-11-19 至 2026-11-25；擷取與閱讀時間是 2026-11-26（Asia/Taipei）09:00 後。開始時今日非 README Markdown 為 0，新增後為 1；三個正式候選 arXiv ID 已查全庫，沒有既有筆記／候選命中。

## 今日選文

1. [MRBench：最少手臂是任務模型的結論，不是現場必要性的證明](./01-mrbench-最少手臂是任務模型的結論不是現場必要性的證明.md)
   - [2611.32803v1](https://arxiv.org/abs/2611.32803v1)，Yanzhe Chen、Zhijun Cao、Ruihe An、Chang Gong、Mike Zheng Shou；2026-11-24 15:25:53 UTC 提交。
   - **實讀**：官方 PDF 摘要、§1–7、附錄 A.1–A.7 的文字、任務卡、主文 Tables 1–4、附錄 Tables 5–15 與提示片段。未逐圖視覺核驗、逐讀參考文獻、看影片、審碼或重跑；限制來自任務排除與協定，不冒稱有獨立 Limitations 章。
   - **入選理由**：LLM／多 agent × 異質機器人交會；新增「充分隊伍不等於必要隊伍」的評估層，方法能追到工作圖、量測、精確搜尋與不對稱審查，不只是協作成功率。
   - **主要邊界**：盲化 prover 的相機仍可見手臂；最小性只相對工作模型、固定基座及 privileged grasps。主表為 one-shot 選隊，不能和另定義的 equal-budget 改隊協定混讀；executor 收整份步驟，執行增益不全是隊伍選擇。借物子類改善區間含零。

## 有界搜尋與候選取捨

取得並篩讀 [cs.RO recent 前 25 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=25)的標題／metadata；頁面當下顯示 2026-11-25 公告首批 25 筆，總列表 587 筆，並未遍查全站或全列表。以下正式候選均另讀官方摘要及 submission history，日期按提交而非公告判斷。

- **入選 MRBench（2611.32803）**：官方只列 v1，未見撤稿註記。方法、主表、消融與協定可取，集中讀出必要性證據層，不強求第二篇。
- **延後 [PyRUA-Dex（2611.33144v1）](https://arxiv.org/abs/2611.33144v1)**：Feixiang Ruan 等 20 位作者；2026-11-24 18:56:44 UTC。已讀官方摘要／metadata：coding agents 開發靈巧雙手程式策略，適合後續檢查探索、蒸餾、隨機化與真機界限。本次未讀方法／實驗，不把摘要的 benchmark 或真機宣稱當已核結果。官方只列 v1，未見撤稿註記。
- **延後 [iWAM（2611.33141v1）](https://arxiv.org/abs/2611.33141v1)**：Vansh Kapoor、Max Sobol Mark、Sreyas Venkataraman、Max Simchowitz、Aviral Kumar；2026-11-24 18:56:04 UTC。已讀官方摘要／metadata，單次 backbone 特徵與 flow-map 訓練可接既有 WAM 資訊路徑問題；未讀方法與實驗，不由摘要斷言速度／成功率或因果機制。官方只列 v1，未見撤稿註記。
- **僅標題級線索**：OmniAct（2611.33158）、ROAM-Bench（2611.33143）、EmbodiSafety（2611.33054）、Atomic Policy（2611.32813）、DeCoNav-Act（2611.32683）、DexWAC（2611.32654）。未核版本／撤稿或讀方法，沒有由名稱判定品質及結果。

撤稿檢查以官方摘要／版本歷史擷取當下為界；未入選是本次閱讀預算取捨，不表示品質較差。

## 庫務與發布範圍

先核 repo root、origin、main、乾淨工作樹與 gh 認證，才 pull --ff-only，結果已最新。本次透過 Python 標準函式庫取得官方列表及摘要、curl 下載官方版本 PDF，用既有 pdftotext 抽文；web extract backend 回報不支援 extraction，沒有依賴其失敗結果補寫內容，未安裝重型依賴。

新增本文與日期索引，更新年度／總索引及根 README 短入口。研究導覽僅補會改變判斷層的「必要隊伍／最小模型／現場成本」線索；不改舊筆記閱讀範圍。提交前檢查每日上限、相對連結與 git diff --check，只 stage 本次檔案，以繁中 commit push main，再在本機執行 scripts/deploy_pages_local.sh。實際 SHA、Pages branch source／build、正式首頁與新增日期／正文獨立驗證，以最終交付為準，不使用 GitHub Actions。
