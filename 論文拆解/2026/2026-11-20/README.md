# 2026-11-20 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。提交日期窗口為 **2026-11-13 至 2026-11-19**，於 2026-11-20（Asia/Taipei）取得來源；公告日期與提交日期分開核對。開始時本日非 README Markdown 為 0，新增後為 1；全庫 arXiv ID 去重後才寫入。

## 今日選文

1. [RelayWAM：可解碼未來不等於動作使用，而使用也不等於有益](./01-relaywam-可解碼未來不等於動作使用而使用也不等於有益.md)
   - [2611.22994v1](https://arxiv.org/abs/2611.22994v1)，Fangchuan Wang 等 7 位作者，2026-11-17 提交。
   - **實讀**：官方 HTML 摘要、§1–6、附錄 A–E、Tables 1–6、Figures 1–6 圖說；已讀 transition 方法、聯合訓練／cache 推論、因子消融、真機設置及探針／擦除協定。未逐像素讀圖、看影片、審碼、重跑或聲稱已讀 PDF。
   - **新增價值**：把昨日僅列摘要候選的研究，首次讀到方法。transition 的跨深度讀取、反向重新塑造 backbone 與殘差未來介入，補上既有「訓練支架／部署使用」問題的具體機制。
   - **判讀**：二乘二支持 future supervision 與接口互補；動作對擦除敏感不等於正確利用。LIBERO-PRO 位置泛化、真機單一操作族及未等化成本保留為反例與限制。

## 有界搜尋、去重與候選取捨

檢視 [cs.RO recent 前 25 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=25) 本次回傳的前 15 筆標題／metadata（公告頁最新為 2026-11-19），另追昨日 RelayWAM 候選。直接取得下列三篇官方摘要頁，選文再讀官方 HTML。這是 LLM／Physical AI／Embodied AI 交會優先的有界抽樣，不代表遍查 cs.RO、cs.CL 與 cs.AI 或全部排序。

- **入選 RelayWAM（2611.22994）**：原先全庫僅昨日候選一處命中，沒有獨立筆記。無版本摘要頁只列 v1，未見撤稿註記。本日正式新增，不改昨日閱讀聲明。
- **延後 [$Z$-sight: Unifying Vision-Language-Action and Latent World Modeling（2611.24940v1）](https://arxiv.org/abs/2611.24940v1)**：Junjie Ye 等 15 位作者，2026-11-18 提交。摘要的 VLM 原生視覺 token 空間與部署聯合去噪，適合與今日無 future generation 路徑對照；本次僅讀 metadata／摘要，未讀方法、消融及真機協定，故不據摘要數字寫方法筆記。
- **延後 [Grana: Compositional Reward Modeling for Long-Horizon Robot Manipulation（2611.24926v1）](https://arxiv.org/abs/2611.24926v1)**：Zi-ang Cao 等 17 位作者，2026-11-18 提交。摘要對子任務進度與時間代理失真很有價值，可接 Memory Clock；本次僅讀 metadata／摘要，未驗證標註協定、組合方法及 downstream policy 效果，不補猜。
- 上述兩篇延後候選的無版本摘要頁均只列 v1、未見撤稿註記；新增前全庫搜尋均未命中。
- **僅標題級線索**：[Phoenix（2611.24938）](https://arxiv.org/abs/2611.24938)、[DiWALI（2611.24836）](https://arxiv.org/abs/2611.24836)、[HINT-WAM（2611.24789）](https://arxiv.org/abs/2611.24789)。只見列表 metadata，未讀摘要／方法或核版本與撤稿狀態，不作方法判讀。

不湊第二篇，是把閱讀用在 RelayWAM 的殘差目標與主表反例；不是斷言延後候選較差。

## 庫務與發布邊界

已先核對 git root、origin、main、工作樹與 gh 認證；乾淨才 git pull --ff-only，結果已最新。URL 擷取工具不支援 extract，改用 Python 標準函式庫取得 arXiv 官方 HTML，沒有安裝重型依賴。

新增本文與日期索引，更新年度／論文總索引及根 README 短入口；研究導覽僅在既有「表徵如何被使用」路徑追加新方法邊界，不逐日重複同義警語。提交前檢查相對連結、每日上限、diff 與 git diff --check，只 stage 本次檔案。main push 後依 scripts/deploy_pages_local.sh 在本機 strict build／發布 gh-pages，另讀回 Pages source／branch build 與正式站；實際 SHA 和 HTTP 驗證結果見本次交付，不使用 GitHub Actions。
