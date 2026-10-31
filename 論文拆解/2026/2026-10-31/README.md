# 2026-10-31 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。近七天窗口採 **2026-10-24 至 2026-10-30**；於 2026-10-31 Asia/Taipei 上午擷取與閱讀。新增前當日非 README `.md` 為 0，本次後為 1，未達每日 2 篇上限。

## 今日選文

1. [OpenFlyV2：機載閉迴路，要分開記憶、生成與安全](./01-openflyv2-機載閉迴路要分開記憶生成與安全.md)
   - [arXiv:2610.39287v1](https://arxiv.org/abs/2610.39287v1)，2026-10-29 提交。
   - **實讀**：15 頁 PDF 的摘要、§1、§2.1–2.6、§3、§4.1–4.7、表 1 與相關圖說；涵蓋事件記憶、運動先驗、flow matching、兩階段監督／RL、非同步執行與評估限制。未逐張目視圖像、未審碼或重跑。
   - **入選理由**：LLM × 航空實體控制的交會研究；把歷史壓縮與生成起點對機載預算的影響分開測試，能接續庫內記憶、時間介面與外部護欄問題。
   - **核心界限**：MSP 優勢集中在單步預算；局部 denoising 20 ms 不是完整延遲；48% 是 seen/unseen 與單／雙地標合併的真機成功率，不是 unseen 或安全率。

## 有界候選與取捨

查閱官方 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 前 50 筆，當次最新公告為 **2026-10-30**；再定向核對以下三篇官方摘要頁及其中一篇 PDF。這是窗口內有界選樣，**不是完整遍歷七天所有 LLM／機器人新稿**。列表只能作發現 metadata，不當作方法證據。

- **入選 [OpenFlyV2（2610.39287v1）](https://arxiv.org/abs/2610.39287v1)**：讀到完整方法、實驗及 discussion，新增「事件內容快取／每輪 prefix 快取／committed action prefix」三種有效期的辨別。
- **待讀 [HiFOR: Hierarchical Foresight with Action-Guided World Grounding for Vision-Language-Action Model（2610.40373v1）](https://arxiv.org/abs/2610.40373v1)**：2026-10-29 提交。官方摘要提出跨時間尺度未來預測與 action-guided retrieval，可接續昨日 ThinkWorld 的部署消費問題；本次未讀方法／實驗，不判定 mask、retrieval 或消融是否支持因果使用。不為滿兩篇而改寫摘要發布。
- **待讀 [From Reasoning to Action: Consequence-Grounded Alignment for Vision-Language-Action Models／CoRAct（2610.39543v1）](https://arxiv.org/abs/2610.39543v1)**：2026-10-29 提交。摘要提出以 movement／waypoints 對齊獎勵優化 action noise distribution；和後果驗證、獎勵校準相關，但本次僅核對摘要，未確認 reward、模型共同盲點與比較公平性，保留候選。

**去重與撤稿**：新增前以三個 arXiv ID 搜尋全庫 Markdown，三者均無命中。三篇未鎖版本的官方摘要頁當次均僅列 v1，未見 withdrawn／retracted 通知；未對候選做全文背書。查核只代表當次可見狀態。

## 庫務與取用限制

- 先確認 git root、origin、main、乾淨 status 與 gh 認證，再 `git pull --ff-only`，回傳已最新；未動他人變更。
- 原文 PDF 直接 HTTPS 下載，使用既有 `pdftotext -layout`／`pdfinfo`，未裝重型依賴。字型警告、作者名稱及頁數 metadata 差異，皆在單篇揭露。
- 更新日期／年度／總索引與 root 短入口；研究導覽只新增跨篇的「歷史、承諾命令與安全」辨別，不更動舊筆記閱讀範圍。
- 提交前驗證相對連結、篇數及 `git diff --check`，僅 stage 本次檔案。main push 後以 `scripts/deploy_pages_local.sh` 本機 strict build、push gh-pages 與 Pages branch build；實際發布結果於本次交付回報，不使用 GitHub Actions 建置／部署。
