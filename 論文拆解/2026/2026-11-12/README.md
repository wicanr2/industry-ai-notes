# 2026-11-12 論文研究

今天新增 **1 篇方法閱讀筆記**，不為上限湊第二篇。近七天候選窗口為 **2026-11-05 至 2026-11-11**，於 2026-11-12 Asia/Taipei 09:00 後擷取。寫入前今日非 README Markdown 為 0；本次新增 1 篇。未替舊文改標補讀全文。

## 今日選文

1. [Memory Clock：等待不能算進度，而事件壓縮也會刪掉工作](./01-memory-clock-等待不能算進度而事件壓縮也會刪掉工作.md)
   - [Is Your Robot's Memory Just a Clock? Temporal Shortcuts in Memory-Augmented VLA Policies（2611.14488v1）](https://arxiv.org/abs/2611.14488v1)，Chubin Zhang、Bo An；2026-11-10 提交、11-11 列表公告。
   - **實讀**：官方 HTML 摘要、§1–7、附錄 A 統計／變異相關段落、F.7、H.1、I.1–I.6／表 31–38，以及 J 開頭的探索性證據／能力門檻。非所有附錄全文；未審程式或重跑。
   - **入選**：不只比較有無記憶，而是拆開物理中斷、內容寫入、顯式時間與槽位索引，並提供修正的乾淨成本與 micro-stop 反例。可延伸 IMEP 的記憶歸因問題。
   - **保留**：全為模擬閉迴路；事件 detector 仍使用模擬輪廓／無噪力訊號；容差曾在 test split 開發，再凍結至 held-out。表 36 周邊成功總數與 paired lost／gained 敘述有算術不一致，未據此自行重算顯著性；詳見單篇。

## 有界搜尋與候選取捨

檢查 [cs.RO recent 前 50 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=50) 的標題、作者、分類與 comments。當次最新公告為 2026-11-11，該日共 69 筆；recent 列表共 437 筆，**本次只看前 50**，不是掃完近七天所有分類。以 LLM × Robotics／Physical AI 交會及能增添可驗證機制為優先，並非純 LLM 研究的完整普查。

- **入選 [Memory Clock（2611.14488）](https://arxiv.org/abs/2611.14488)**：取得版本 HTML，完成上述方法／實驗／限制閱讀。比單純新架構排名更能追蹤記憶的錯誤資訊路徑，今天集中完成這一篇。
- **待讀 [LEASH: Stay Safe in Agentic Robotics（2611.14115v1）](https://arxiv.org/abs/2611.14115)**：Qinfeng Zhu、Weiguang Zhao、Ke Sun、Xihao Guo、Yunxi Jiang、Rui Zhang、Lei Fan、Kaizhu Huang；2026-11-10 提交。只讀官方 metadata／摘要。RoboRisk 的閉迴路安全評估與 task／action／commit gates 值得追蹤，但未核方法、lease 的撤銷／到期語意、危害分母、基線及真機失效，不把摘要的降低 harm 宣稱當已讀實驗結論。保留待讀，不湊第二篇。
- **待讀 [Elastic-WAM: Adaptive Spatiotemporal Imagination for Efficient Robot Control（2611.14257v1）](https://arxiv.org/abs/2611.14257)**：Haitian Li 等十一位作者；2026-11-10 提交。只讀 metadata／摘要。按狀態分配時空 refinement 的計算預算，適合與既有 WAM 路徑對讀；尚未讀三階段訓練、stop 規則、延遲計時／公平預算與安全失效，不推論其速度收益已轉為全系統控制收益。

**去重與撤稿**：寫入前以三個 arXiv ID 搜尋全庫無命中，並再確認獨立論文筆記沒有相同 ID；三個官方無版本摘要頁的 submission history 均僅列 v1，未見 withdrawn／retracted 標記。這是當次擷取狀態，並非對未來版本保證。只有 Memory Clock 新增為獨立筆記。

## 擷取限制與庫務

先驗 git root、origin、main、乾淨工作樹與 gh 認證後，git pull --ff-only（已最新）。通用網頁擷取工具回報目前後端僅能搜尋、不支援 URL 抽取；改用 Python 標準函式庫讀取官方頁面，以輕量 HTML parser 保留段落、表格欄位與 MathML 的 LaTeX alttext，未安裝重型依賴。閱讀依 HTML 文字與表格，不假稱另讀 PDF 或觀看圖片／影片。

更新日期、年度、論文總索引與根 README 短入口；研究導覽只新增一則連到 IMEP 的機制補註：從記憶內容的特異性，補問時間戳／槽位與事件等價；不宣稱兩套 protocol 已整合測試，也不改舊筆記閱讀範圍。

提交前檢查每日篇數、Markdown 相對連結、完整 diff 與 git diff --check，只 stage 本次檔案。main push 後以本機 scripts/deploy_pages_local.sh 發布，不使用 GitHub Actions；實際 main／gh-pages SHA、Pages source／branch build 與正式站正文讀回，以本次交付訊息為準。
