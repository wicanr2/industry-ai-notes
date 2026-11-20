# 2026-11-20 新聞拆解索引

本輪新增 **台灣 1 篇、國外 1 篇**，不補滿上限（台灣 3、國外 2）。研究於 2026-11-20 08:00 後（Asia/Taipei）執行，材料為 11-19 台灣公告／報導及 11-18 國外交易公告。國外頁面只有日期、沒有精確時區與時分，因此標成近兩日材料，不冒稱已核定精確 48 小時窗口。

已讀編輯規範、根 README、研究導覽、11-19 新聞索引及本機 Pages 發布規格／腳本。核對 root、origin、main、乾淨工作樹與 gh 登入後才 pull，回傳已是最新；GitHub 讀回 repository 與 main。當日原無筆記；搜尋既有新聞未見雲豹 AIDC 與 Rockwell／AGILOX 同事件專篇。未有獨立收益證據改變跨日判斷，不更新研究導覽，不批次改寫舊文。

## 台灣

1. [雲豹能源｜雲豹能源搶攻 AI 基建商機，綠電、儲能、AIDC 三箭齊發](https://www.jv-holding.com/newsDetail.aspx?docData_id=618)（官網首頁標 11-19，無個人署名）。
   - 對讀：[中央社／梁家柔｜雲豹能源跨足 AI 資料中心，鎖定台灣與亞太地區開發逾 10 座專案](https://www.cna.com.tw/news/afe/202611190341.aspx)（11-19 19:30）。
   - [01｜雲豹 AIDC：開發容量、供電承諾與算力收入](./01-雲豹AIDC要分開開發容量供電承諾與算力收入.md)。
   - 入選：取得公司原始公告，可以拆解開發容量、集團收入與三種交付義務。兩文均可讀主文；中央社轉述公司新聞稿，不算獨立營運驗證。未取得原始法說投影片、季度財報與專案合約，不把 300 MW 當已完工容量。

## 國外

1. [Rockwell Automation｜Signs Definitive Agreement to Acquire AGILOX](https://www.rockwellautomation.com/en-us/company/news/press-releases/Rockwell-Automation-Signs-Definitive-Agreement-to-Acquire-AGILOX.html)（11-18，無個人署名）。
   - 對讀：[Carlyle｜Agrees to Sell AGILOX to Rockwell Automation](https://www.carlyle.com/media-room/news-release-archive/carlyle-agrees-sell-agilox-rockwell-automation)（倫敦 11-18，無個人署名）。
   - [02｜Rockwell 收購 AGILOX：產品互補、車隊互通與客戶收益](./02-Rockwell收購AGILOX要分開產品互補車隊互通與客戶收益.md)。
   - 入選：買賣雙方原公告均可讀，有明確交易事件與不同車種／通路的組合邏輯。保留財季與曆年上半年兩種交割窗口，不把簽約當交割，不把同屬利害關係人的說法當獨立成效。未取得交易契約或混合車隊技術規格。

## 候選取捨與讀取限制

本輪有界檢查[中央社產經](https://www.cna.com.tw/list/aie.aspx)、[日經中文網繁體首頁](https://zh.cn.nikkei.com/)、上述公司公告及下列單文，不宣稱全面網羅媒體。

### 已讀主文但未選

- [中央社／鍾榮峰｜光陽攜豐田通商簽電動車代理合約，攻日本餐飲外送市場](https://www.cna.com.tw/news/afe/202611190373.aspx)（11-19 21:08，21:21 更新）：讀至編輯署名。有從換電轉向 B2B 充電式車款的商業模式取捨，值得後續追。此次未補光陽／豐田通商原公告、車隊客戶需求與總持有成本資料，不把公司轉述的市場評估當已驗證的技術優劣；與本輪 AI／工廠物流重點相比先留候選，不為台灣名額另湊一篇。
- [中央社／潘智義｜華新迎 60 週年，焦佑倫看好 AI 液冷、SMR 核能等 9 大商機](https://www.cna.com.tw/news/afe/202611190375.aspx)（11-19 21:11，21:31 更新）：讀至編輯署名。多項投資／需求展望混合不同時鐘；未取得分部訂單、客戶驗證及投資原件，不能從九項機會推算 AI 營收。原文中的能源政策與 2035 展望屬受訪者主張，本輪未另行查證，不帶入結論。

### 輔助線索，不作已驗證原件

- [第三方法說整理頁｜雲豹能源 11-19 法說](https://finmoconf.diveinvest.net/presentation/6aff05985daeae5fa8021996)：可讀文字整理，頁面標題與內文季別呈現不同，且未取得原始投影片逐頁核對。未採其額外分期開工規模及其他新數字作筆記證據。官網[財務資訊入口](https://www.jv-holding.com/financialReport.aspx)可讀月營收，但不是法說簡報，不以它補齊缺失。

### 來源不可讀，未從題名推論

- **日經中文網繁體版**：Jina 的 HTTPS 首頁回維護頁與目標 504 警告；HTTP reader 及指定的巢狀 reader 備援亦未取得新聞列表。維護頁帶有舊 metadata，不把該日期當今日報導日期；沒有足夠正文，不選文也不依舊索引補造當日日本產業觀察。
- **Rockwell**：直接 HTTP 403，改用 Jina 後完整新聞主文可讀，因此可使用原公告內容，但仍未取得任何交易契約或技術附件。
- 通用抽文工具不支援目前 search-only backend，改以 HTTP／Jina；擷取資料僅留 scratch，未提交來源全文、HTML 或工具產物。

## 共同觀察：整合的價值，要在接口交付而不是名稱加總中找

雲豹把供電、工程與算力放到同一服務框架，Rockwell 把不同車種與通路放到同一交易框架；兩者都有可辨識的新增事件，卻還不能用組合的完整性證明客戶總成本下降。

差異不能抹平：雲豹是公司開發與業務展望；Rockwell 是已簽約但尚未交割的所有權安排。兩篇共同提出「誰交付、誰驗收、誰承擔失敗」的檢查，不主張兩者存在合作、技術採用或供應關係。新證據尚不足以修改研究導覽的既有收益判準。

## 本輪庫務與發布界線

新增兩篇與本索引，年度／根 README 只加短連結。依序做相對連結檢查、`git diff --check`、限定檔案 stage／繁中 commit／push main，確認本地與遠端 SHA 後才執行本機 `scripts/deploy_pages_local.sh`。不得用 GitHub Actions 建置部署。

本索引不預寫上線成功；實際 main／gh-pages SHA、Pages source、branch build 與首頁／當日索引／各篇正文 HTTP 讀回結果，以本輪最終交付為準。
