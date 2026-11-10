# 2026-11-10 新聞拆解索引

本輪新增 **台灣 1 篇、國外 1 篇**，不補滿上限。研究於 2026-11-10 08:00（Asia/Taipei）後開始，選 11-09 的台灣功能上線及日本半導體材料簽約事件。動態支援文件僅作當刻可讀的規則背景，不把其全部內容冒充昨日新功能。

已讀編輯規範、根 README、研究導覽、11-09／11-08 新聞索引及本機發布腳本；核對 root、origin、main、乾淨工作樹與 gh 身分，才 `git pull --ff-only`，結果已是最新。開始時本日無新聞筆記；全庫搜尋未見 Gemini 購物專篇，JSR 僅為 11-05 至 11-07 的候選，未有正式原件拆解。本輪只增加兩篇與日期／年度／根入口；研究導覽沒有足以變更的跨日判斷，舊文不改。

## 台灣

1. [Google／Google Gemini 團隊〈用 Gemini 讓購物變得更簡單〉](https://blog.google/intl/zh-tw/products/explore-get-answers/gemini-shopping/)（11-09）。
   - 筆記：[01｜Gemini 購物的候選覆蓋、資料新鮮度與履約](./01-Gemini購物要驗證候選覆蓋資料新鮮度與履約.md)。
   - 同事件：[中央社／吳家豪報導](https://www.cna.com.tw/news/ait/202611090093.aspx)（11-09 13:38）。以台灣市場事件分類，沒有再算國外一篇。
   - 入選：用 [Shopping Graph](https://support.google.com/googleshopping/answer/14336735)、[Gemini 購物說明](https://support.google.com/gemini/answer/16730149?hl=en)、[商家同步規則](https://support.google.com/merchants/answer/14999713?hl=en-GB)、[availability 規格](https://support.google.com/merchants/answer/6324448?hl=en)拆出資料提交、落地頁、結帳及配送責任，避免只有「AI 改變購物」的敘事。
   - 實讀：官方公告全文、中央社主文至編輯、四份動態文件正文；未登入實測或下單，不保證全部台灣商家有直接結帳，不引用全球清單量估台灣覆蓋。

## 國外

1. [日經中文網繁體版〈三井化學宣佈收購全球第二大光刻膠廠商 JSR〉](https://zh.cn.nikkei.com/industry/manufacturing/64650-2026-11-09-14-09-33.html)（11-09，主文未見個人署名）。
   - 筆記：[02｜三井收購 JSR 的控制權、融資與協同時鐘](./02-三井收購JSR要分開控制權融資與協同時鐘.md)。
   - 核心原件：[三井適時披露英文 PDF，10 頁](https://jp.mitsuichemicals.com/content/dam/mitsuichemicals/sites/mci/documents/release/2026/261109e.pdf)、[JSR 公告](https://jsr.co.jp/jsr_e/news/2026/20261109.html)、[JIC／JICC 公告](https://www.j-ic.co.jp/en/news/20261109-jic-jicc-pressrelease-en)，均為 11-09。
   - 入選：由先前計畫候選升為正式簽約與可核對資金結構；分開含債總額／股權價值、資金共投／表決權、普通股／夾層，以及簽約／交割／客戶驗證。處分、核心營業利益與歸屬母公司利益另列，不把獲利回升全歸半導體。
   - 實讀：日經全部主文、兩家公告全文、三井 PDF 全文文字；未核日文原件、完整合約及客戶資料。PDF 文字層可讀，沒有逐頁影像核表；數字以原表名稱及算式核對，保留淨利歸屬口徑差異。

## 候選取捨與讀取限制

### 台灣／中央社候選

已檢查[產經列表](https://www.cna.com.tw/list/aie.aspx)及科技導覽。除入選 Gemini 主文，以下只讀列表題名、時間與連結；不視為已讀全文或已驗證數字。

- [業成高功率雷射封裝產線放量展望](https://www.cna.com.tw/news/afe/202611090239.aspx)（11-09 18:53）：可追轉型，但本輪未補官方法說、客戶驗證與設備／產能原件，不由預期季度推定量產已完成。
- [佳世達資料中心與 AI 伺服器展望](https://www.cna.com.tw/news/afe/202611090265.aspx)（11-09 20:42）：未補分部財務、訂單／交付與現金口徑；不以明年放量題名作已實現收入。
- [10 月出口紀錄](https://www.cna.com.tw/news/afe/202611090213.aspx)、[前十月對美出口占比](https://www.cna.com.tw/news/afe/202611090215.aspx)（11-09）：按同次統計發布合併候選，未讀財政部原表及產品／基期拆解，不拿總量當 AI 終端使用。
- [台星新創交流商機](https://www.cna.com.tw/news/afe/202611090275.aspx)、[衛星應用展示與媒合](https://www.cna.com.tw/news/afe/202611090254.aspx)（11-09）：未核商機與正式合約、展示與驗收分母；無新增可核對機制，不湊第三篇。
- [Google 第八代 TPU 陣容](https://www.cna.com.tw/news/afe/202611090282.aspx)（11-09 21:56，國外候選）：未補官方型號、可比工作負載、可用區與交付原件，不從算力爆發題名推效能／成本，也不因同公司已有台灣選文就混成一個事件。

### 日經中文網繁體版候選

本輪先試技能指定的巢狀 reader，回傳系統維護／403 頁；改用一般 Jina reader 後，[繁體首頁](https://zh.cn.nikkei.com/)與 JSR 主文可讀。維護頁不當新聞，首頁行情也不作 08:00 時點快照。

除入選 JSR 全文，下列只讀首頁標題、摘要、日期線索與連結，沒有閱讀單篇全文或原件：

- [松下與優衣庫在中國試煉、向全球競爭](https://zh.cn.nikkei.com/industry/management-strategy/64647-2026-11-09-10-48-42.html)（11-09）：值得追在地設計與供應鏈，但未核增產預算、跨國移轉成本與利潤，本輪不由摘要論證全球複製成功。
- [中國六家 AI 公司與美國兩家公司營收比較](https://zh.cn.nikkei.com/china/ccompany/64644-2026-11-09-10-14-47.html)（11-09）：昨日已列候選，仍未補年化／實現營收及合併範圍，不引用摘要比較或推導能力排名。
- [本田轉向「中國標準件」](https://zh.cn.nikkei.com/columnviewpoint/column/64529-2026-11-10-05-00-33.html)（11-10）：僅首頁入口；未讀標準件定義、採購條款及供應商影響，不從題名推斷供應鏈全面替換。
- [機器人會反抗人類嗎？](https://zh.cn.nikkei.com/columnviewpoint/column/64596-2026-11-09-05-00-23.html)：[昨日已拆](../2026-11-09/README.md)，沒有新的停止權限或控制實驗，不重複寫。

## 共同觀察與下一證據

兩篇不是同一條產業因果鏈，只共用一種檢查方法：**不要把可見入口當成下游已兌現。** Gemini 要從候選與快照追到可履約；JSR 要從簽約與控制追到資金、驗證與經常現金。這是本筆記的比較模型，不代表兩家公司有技術／供應關係。

Gemini 至 12-10 優先追台灣支援範圍與可比資料一致性；JSR 至 12-10 追核准及融資新文件，之後按實際交割重排追蹤時鐘。未取得數據就保留未知，詳細指標與反事實見單篇。未有實測結果，不增寫研究導覽的跨日結論。

## 發布界線

來源擷取使用本機 HTTP／Jina；通用 web_extract 工具本輪回報 search-only backend 不支援抽文，已改路徑取得正文，並非以失敗工具或標題生成筆記。所有擷取資料留 scratch，不提交新聞全文。

本輪須完成 Markdown 相對連結檢查、`git diff --check`、指定檔案 commit／main push，再用 `bash scripts/deploy_pages_local.sh` 本機 strict build 及推 gh-pages；最後另讀 Pages API、首頁、日期索引與兩篇正文。實際 SHA 及發布結果見交付回覆；此索引不預先宣稱上線，也不使用 GitHub Actions 建置／部署。
