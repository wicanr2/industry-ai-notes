# 2026-11-13 論文研究

今日新增 **1 篇方法閱讀筆記**，不為兩篇上限湊數。候選窗口為 **2026-11-06 至 2026-11-12**；於 2026-11-13 Asia/Taipei 09:00 後擷取。開始時今日非 README Markdown 為 0，本次新增 1；未把舊筆記改稱已補讀全文。

## 今日選文

1. [LEASH：逐次授權不等於持續安全，而通過樣本不等於辨識能力](./01-leash-逐次授權不等於持續安全而通過樣本不等於辨識能力.md)
   - [LEASH: Stay Safe in Agentic Robotics（2611.14115v1）](https://arxiv.org/abs/2611.14115v1)，Qinfeng Zhu、Weiguang Zhao、Ke Sun、Xihao Guo、Yunxi Jiang、Rui Zhang、Lei Fan、Kaizhu Huang；2026-11-10 提交。
   - **實讀**：官方 HTML 摘要、§1–6、A.2、A.3 安全道具說明、B.1–B.2、C.2–C.4、D 前段；未逐項讀完整任務表、C.1 全分類結果，未審碼／重跑或看影片。筆記逐節列出來源位置。
   - **入選**：接續昨日摘要候選，今天實際讀方法，補足三層權限、commit hook 範圍、共享政策的基線混合、通過樣本的選擇偏差與真機分母。不把 lease 名稱當作已提供到期／撤銷規格。
   - **保留**：非完整元件消融；action／commit 被拒候選無 evaluator 標籤；真機每任務一次且使用安全道具／部分預抓取。危害包括潛在危害，SSR 包含安全拒絕／及時終止，不等於生產完成率。

## 有界搜尋與取捨

重查 [cs.RO recent 前 50 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=50) 的標題、作者與 comments；頁面當次仍顯示最新公告 2026-11-11，共 437 筆、該日 69 筆，本次僅看前 50，不聲稱遍查近七天所有分類或已取得 11-12 完整公告。優先 LLM × Robotics／Physical AI，不是純 LLM 全面普查。

- **入選 LEASH（2611.14115）**：昨日僅列待讀，庫內無獨立論文筆記；今日新增方法／實驗／限制閱讀，不重寫昨日歷史。
- **待讀 [Elastic-WAM（2611.14257v1）](https://arxiv.org/abs/2611.14257v1)**：Haitian Li 等；2026-11-10 提交。今日重讀官方 metadata／摘要；自適應時空 refinement 與固定預算對照值得追，但未核方法、控制總延遲與消融，不將摘要結果當作已讀驗證。保留昨日候選，不重複產出摘要筆記。
- **待讀 [LaST0.5（2611.14048v1）](https://arxiv.org/abs/2611.14048v1)**：Xuheng Zhang 等；2026-11-10 提交。今日只讀 metadata／摘要；interaction-centric latent 與 progress 觸發重採樣可能延伸表徵使用／有效期線索，但尚未核監督資料、重採樣控制與公平比較，不因摘要榜分湊第二篇。
- **排除重複 [Memory Clock（2611.14488）](https://arxiv.org/abs/2611.14488v1)**：昨日已寫方法筆記，今日不另寫。

去重搜尋全庫 arXiv ID：LEASH／Elastic-WAM 先前只出現在昨日日期索引，LaST0.5 未命中；獨立非 README 筆記均無上述三個 ID。三個無版本官方摘要頁當次均僅列 v1，未見 withdrawn／retracted 標記；這是擷取當下狀態，不保證未來版本。

## 擷取與庫務

先查 git root／origin／main／乾淨工作樹與 gh 認證，才 git pull --ff-only（已最新）。通用網頁擷取後端仍回報不支援 URL 抽取，改用 Python 標準函式庫取得 arXiv 官方 HTML，以輕量 parser 抽取段落、表格欄位及 MathML LaTeX alttext，未安裝重型依賴。未讀 PDF，不以圖片標題代替視覺檢查。

更新日期、年度、論文總索引與根 README 短入口。研究導覽只補一則與 Nav2／啟動抑制的機制對讀：單次授權的範圍、已通過候選的統計分母及持續安全仍須分開，不宣稱跨篇整合或重標舊文。

提交前檢查相對連結、每日篇數、diff 與 git diff --check，只 stage 本次檔案；push main 後以本機 scripts/deploy_pages_local.sh 發布。實際 main／gh-pages SHA、Pages source／branch build 與首頁／本日索引／文章正文讀回，見本次交付報告。不使用 GitHub Actions 建置部署。
