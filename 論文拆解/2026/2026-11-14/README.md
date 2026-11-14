# 2026-11-14 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊兩篇。候選提交日期窗口 **2026-11-07 至 2026-11-13**，於 2026-11-14 Asia/Taipei 09:00 後擷取。開始時今日非 README Markdown 為 0，本次新增 1；未修改舊筆記閱讀聲明。

## 今日選文

1. [ACE-CaP-0：經驗取得成本與凍結程式可靠度要分帳](./01-ace-cap-經驗取得成本與凍結程式可靠度要分帳.md)
   - [2611.16872v1](https://arxiv.org/abs/2611.16872v1)，ACE-CaP Team、Changxu Wei、Yunpeng Qing 等，2026-11-12 提交。
   - **實讀**：官方 HTML 摘要、§1–6，包含完整方法、六種開發條件、八項真機任務 Table 1 與結論限制。圖說可讀，但未核圖像內所有數值；未讀附錄 A、未逐項核參考文獻、未審碼／重跑或觀看影片，未下載 PDF。
   - **入選**：把開發時的經驗選擇與部署時的程式執行分開，補足請求示範、按需模擬與實體感測假設的機制；能檢查成品重複成功是否被錯當成開發流程可重複。
   - **保留**：每條件一次開發、充電器單任務流程對照；八任務無全 recipe 因子消融。十次場景重置排除示範收集，不能當人力總上限；程式凍結也不代表持續安全。

## 有界搜尋與候選取捨

實際檢查 [cs.RO recent 前 50 筆](https://arxiv.org/list/cs.RO/recent?skip=0&show=50) 的標題／作者／comments；當次顯示共 481 筆、最新公告 2026-11-13 的 106 筆中前 50。此為近七天窗口內的有界抽樣，不聲稱遍查七天全部文章，也未全面普查 cs.CL／cs.AI。

- **入選 ACE-CaP-0（2611.16872）**：全文 HTML 可取、方法與成本口徑可核，優先完成一篇實質閱讀。
- **待讀 [SALA（2611.17110v1）](https://arxiv.org/abs/2611.17110v1)**：Jiachun Jin、Zetong Zhou、Haonan Wang、Xiao Yang、Jun Zhu、Zhijie Deng，2026-11-12 提交。只讀官方 metadata／摘要。語言相似度監督未配對人／機器人 latent actions 對應值得追；但未讀方法、資料、消融與控制成效，不把摘要的雙軸 scaling 宣稱當已驗證結果，不為第二篇湊摘要筆記。
- **待讀 [Maximizing LLM Utility While Managing LLM Fallibility（2611.17020v1）](https://arxiv.org/abs/2611.17020v1)**：Ekta U. Samani、Christopher G. Atkeson，2026-11-12 提交。只讀 metadata／摘要；這是 review，適合作為可靠性估計與依賴調整的後續專題，但尚未核其風險界限假設，不把摘要的 bounded risk 轉寫成機器人安全保證。
- **既有候選延後**：[Elastic-WAM／LaST0.5 見昨日索引](../2026-11-13/README.md)，今天未重新查證，不假裝新增閱讀。

搜尋全庫 Markdown 的上述三個新候選 arXiv ID，新增前均無命中。三個無版本官方摘要頁當次只列 v1、未見 withdrawn／retracted；版本狀態僅截至本次擷取。本文所列觀測分數均為作者結果，未自行重跑。

## 庫務與發布

先查 git root／origin／main／工作樹與 gh 認證；乾淨才 pull --ff-only，結果已最新。用 Python 標準函式庫取得官方 HTML、輕量 parser 抽取正文與表格，未安裝重型依賴。

更新日期／年度／論文總索引與根 README 的短入口。研究導覽不變：今天尚未新增足以改寫跨篇機制判準的證據，具體對讀與未解問題留在單篇，避免逐日疊加同義警語。

提交前檢查相對連結、篇數、diff 與 git diff --check；只 stage 本次檔案、繁中 commit、push main。本機 scripts/deploy_pages_local.sh 建置／部署，另讀回 Pages source、branch build 與正式首頁／日期／本文正文；實際 SHA 與 HTTP 驗證結果見當次交付，不使用 GitHub Actions。
