# 2026-10-24 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。寫入前當日非 README `.md` 為 **0**，新增後 **1**；近七日選文窗口為 **2026-10-17 至 2026-10-23**。本次資料取得及閱讀發生於 Asia/Taipei 上午排程期間，不聲稱 09:00 已完成研究。

## 今日選文

1. [P²：進度落後不是安全事件，低成本監測也要分帳驗證](./01-p2-進度落後不是安全事件.md)
   - [arXiv:2610.31613v1](https://arxiv.org/abs/2610.31613v1)：10-22 提交、10-23 cs.RO 公告。
   - **實讀**：官方 8 頁 PDF 摘要與 §I–VIII，方法、模擬、真機、限制，表 I–IV、圖說；加讀 LaTeX 方法／實驗及真機表 III source。未逐圖視覺審查、未審碼、未重跑，沒有附錄。
   - **機制**：成功軌跡的剩餘時間 → VLA activation 的線性 probe → 相對平均成功時長的落後殘差 → 閾值警報；不另訓練動作策略，不等於已建立安全控制器。
   - **關鍵查證**：表 III P² 六個任務值等權平均 **0.72**，原表標 **0.78**；source 保留相同矛盾，故不採「全面領先」結論。這是呈現／聚合口徑問題，不是本筆記重跑或裁定哪個原始結果正確。

## 有界搜尋與候選取捨

讀取 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 與 [cs.CL recent](https://arxiv.org/list/cs.CL/recent) 回傳首頁的前 50 筆標題，重點為 10-23 公告；另回查下列四篇官方版本及無版本摘要頁。這不是遍歷近七日全部論文的系統回顧。交會研究優先，先保證一篇方法與證據讀透，不把候選摘要填成第二篇。

- **入選 [Progress Probes P²（2610.31613v1）](https://arxiv.org/abs/2610.31613v1)**：10-22 提交。能用同策略 activation 比較，且直接補上 RESCUE／BT-Agent 之間「廉價警報是否及時、是否具有介入價值」的證據分界。原文可取得方法、監督口徑與主表；另查 source 釐清不是 PDF 文字錯位。
- **待讀 [Echo（2610.31569v1）](https://arxiv.org/abs/2610.31569v1)**：10-22 提交，題為 *Echo: Coupled Action and Task Status Signal Denoising for Vision Language Action Models*。摘要提出把 stop／failure 維度加入 action chunk 並耦合 denoising；與外掛 probe 可構成好對照，但本次僅摘要／metadata，未讀標籤建構、訓練與真機消融，不能先下方法優劣判斷。
- **待讀 [FastHarness（2610.31427v1）](https://arxiv.org/abs/2610.31427v1)**：10-22 提交，題為 *FastHarness: Experience-Driven Review Scheduling for Vision-Language-Action Policies*。摘要的經驗式 review 排程可接「監督算力何時值得花」，但尚未讀方法／對照／恢復驗證；不引用摘要成本或成功率當已驗證結果。
- **延續待讀 [Agentic World Action Models（2610.30136v1）](https://arxiv.org/abs/2610.30136v1)**：10-21 提交，昨日已列候選。本次重讀摘要及版本狀態，未補讀方法；code／video／action 三串流與技能庫仍值得讀，但不變更昨日閱讀範圍，也不宣稱本日已讀全文。

**去重／撤稿**：寫入前以完整 arXiv ID 搜尋全庫；前三篇無命中，AW-0 只有昨日候選命中，均無重複單篇筆記。當次四篇官方摘要頁均顯示 v1，未見 withdrawn／retracted；僅代表擷取時狀態。

## 庫務與發布

- root／origin／main／乾淨工作樹與 gh 認證確認後，`git pull --ff-only` 回傳已是最新。
- `web_extract` 後端不支援正文擷取，改用 HTTPS 直接取得 arXiv 官方 PDF／HTML／source；以現有 `pdftotext` 輕量讀文，未安裝重型套件。一次 metadata shell quoting 失敗後改用暫存 Python script，成功讀出來源；不以錯誤輸出補內容。
- 新增筆記、日期索引，更新年度／論文總索引與 root 短入口；研究導覽只新增「進度代理、警報時效與介入效益」判斷，不假裝舊筆記已補讀。
- 檢查相對連結、`git diff --check`，只 stage 本次變更，繁中 commit／push；本機執行 `bash scripts/deploy_pages_local.sh`，不以 GitHub Actions 建置或部署。
- 實際 commit、Pages source／branch build、首頁／日期／單篇 URL 的 HTTP 與正文識別驗證，以本次最終交付為準。
