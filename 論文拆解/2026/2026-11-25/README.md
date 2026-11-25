# 2026-11-25 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。提交日期窗口為 **2026-11-18 至 2026-11-24**；實際擷取／閱讀為 2026-11-25（Asia/Taipei）09:00 後。開始時本日非 README Markdown 為 0，新增後為 1；三個正式候選 ID 已查全庫，無既有筆記／候選命中。

## 今日選文

1. [ACAP：並行推理縮短工期，不等於控制權交接已具物理安全](./01-acap-並行推理縮短工期不等於控制權交接已具物理安全.md)
   - [2611.31205v1](https://arxiv.org/abs/2611.31205v1)，Zexin He 等六位作者，2026-11-23 UTC 提交。
   - **實讀**：官方 PDF 摘要、§1–7，尤其 §3 方法、§4 協定／指標、§5 主表與 timing；附錄 A 逐任務結果、B 指令／評分、C 協調成本、D 移動操作、E 資料／幾何推理案例、F 限制及 Tables 1–10。未逐條讀參考文獻、完整讀附錄 G 影像、看影片、審碼、下載資料集或重跑。
   - **入選理由**：LLM coding agents × 真機操作交會；把推理並行與物理耦合分開，提供 persistent members、訊息確認、事件等待、動態控制權和 Fixed 對照，能追方法而不只改寫摘要。
   - **判讀邊界**：Direct 可以並行發命令，且與 members 的 reasoning effort 不同；Fixed 比較還包含角色指令改動。時間節省不是費用節省，進度採歷史最高值，沒有專用 motion-level collision checker。owner、工作區准入及政策授權分帳。

## 有界搜尋與候選取捨

本次取得並篩讀 [cs.RO recent 前 25 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=25)的標題與 metadata，頁面日期另核對為 2026-11-24 公告；不是遍查全站或全部 565 筆。公告日期與提交日期不同，以下按官方摘要／submission history 核版本與時間。

- **入選 ACAP（2611.31205）**：官方摘要／歷史只列 v1，未見撤稿註記；PDF 方法、主表及限制可讀，投入閱讀與逐項證據邊界，不強求再加一篇。
- **延後 [Embo-Harness（2611.31201v1）](https://arxiv.org/abs/2611.31201v1)**：Xiao-Ming Wu 等 15 位作者，2026-11-23 UTC 提交。已讀官方 metadata／摘要，四個 harness 元件與受控介入值得後續讀；本次未讀方法／實驗，不能把摘要中的 RoboLab-120 與真機數字當已核實的比較。本篇與昨日 Embodied-Harness（2611.27689）名稱近似但 ID 不同，不因相似標題誤判重複。官方歷史只列 v1、未見撤稿註記。
- **延後 [RUIBench（2611.31115v1）](https://arxiv.org/abs/2611.31115v1)**：Yanzhe Chen 等 11 位作者，2026-11-23 UTC 提交。已讀官方 metadata／摘要，接口抽象與驗證缺口可接後續問題；未讀 13 種接口如何控制感知／執行差異，故不由摘要認定已隔離所有混淆。官方歷史只列 v1、未見撤稿註記。
- **標題級線索**：VITA-WAM（2611.31195）、EmboEagle（2611.31173）、WeaveVLA（2611.31126）、Real2Worlds2Real（2611.31098）、ReWeave（2611.31053）、SayDo（2611.30957）。只看列表，未核其版本／撤稿、未讀摘要或方法，不由題目推測品質或結果。

撤稿檢查以擷取當下官方版本歷史／摘要註記為界，不保證未來狀態不變。未入選是本次閱讀預算取捨，不表示論文較差。

## 庫務與發布範圍

先核 root、origin、main、乾淨工作樹與 gh 認證，才 git pull --ff-only，結果已最新。網頁 extract backend 不支援 URL extraction，改以 Python 標準函式庫讀官方列表／摘要、curl 下載 PDF，並用既有 pdftotext 抽文；另開官方版本摘要核對，未安裝重型研究依賴。

新增本文與日期索引，更新論文年度／總索引及根 README 短入口；研究導覽只補一則會改變接口判準的跨篇線索：資訊新鮮之外，另須檢查控制權與依賴證據失效。沒有改寫舊筆記的閱讀範圍。

提交前檢查本次 Markdown 相對連結、每日上限及 git diff --check，只 stage 本次檔案；以繁中 commit push main，再依 scripts/deploy_pages_local.sh 本機 strict build／發布 gh-pages。實際 SHA、Pages source／branch build 與首頁、日期索引、文章正文的獨立讀回結果，以本次最終交付為準，不用 GitHub Actions 建置或部署。
