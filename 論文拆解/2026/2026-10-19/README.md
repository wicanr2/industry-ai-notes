# 2026-10-19 論文研究

今日新增 **1 篇方法閱讀筆記**，未湊滿上限。寫入前本日非 README `.md` 為 **0**，新增後為 **1**。篩選窗口為 **2026-10-12 至 2026-10-18** 的近期提交／更新；本次選文首次提交在 2026-10-15。

## 今日選文

1. [REKI：記憶要保存分辨動作所需的過去](./01-reki-記憶要保存分辨動作所需的過去.md)
   - [arXiv:2610.22178v1](https://arxiv.org/abs/2610.22178v1)，首次提交 2026-10-15。
   - **實讀範圍**：官方 PDF 摘要、§1–8，附錄 A／A.1、C／C.1／C.2、D 的評估口徑與 D.1／D.4、Table 8／9／10、E.1／E.2／Table 11；完整資料清理／取樣細節及逐任務表未逐項閱讀，圖像只讀圖說與文字。未審碼、未重跑。
   - **機制收穫**：以 register attention 的單向依賴實現跨 flow-step／跨 chunk 快取；同權重移除歷史的消融比跨模型榜單更接近記憶的介入價值。
   - **口徑限制**：真機 task score 含 partial credit；21.8 ms 主榜計時與附錄 22.8 ms 微基準是不同實驗；短窗口消除振盪不等於長期記憶與物理安全。

## 有界候選、去重與取捨

擷取日 **2026-10-19（Asia/Taipei）**。本次是以近期未完成候選 REKI 為起點的「控制記憶」主題搜尋／原始頁回查，不是近一週全 arXiv 的窮盡回顧。共回查三篇候選的官方 metadata／摘要，再集中閱讀其中一篇方法；另查庫內 T2-z 作排重對照。

- **入選 REKI（2610.22178v1）**：先前只在 10-17／10-18 日期索引列候選，沒有正式筆記；今日另建方法閱讀筆記，不改寫歷史紀錄。完整 PDF 可取得，快取依賴、同模型消融、真機評分和計時協定足夠具體。
- **保留 [Mem4Act: Effective Latent Memory for Long-Horizon Robotic Manipulation（2610.22323v1）](https://arxiv.org/abs/2610.22323v1)**：官方 metadata／摘要已讀，首次提交 2026-10-15；latent memory、時序聚合及 memory-first 訓練值得後續與 REKI 比較，但本次未讀其方法與實驗，不能把摘要的成功率或機制主張當成已驗證結果，不為第二篇名額趕寫。
- **保留 [Value as Memory: Online Value-Guided Post-training for General Robot Policies（2610.22368v1）](https://arxiv.org/abs/2610.22368v1)**：官方 metadata／摘要已讀，首次提交 2026-10-15；以 value history 表示進度與 online RL 是另一條路，本次未讀方法與受控對照，不由摘要歸因兩種收益。
- **去重排除 [T2-z（2610.22364v1）](../2026-10-18/01-t2z-環境適配先問互動能否辨識.md)**：昨日已有正式筆記，不另建。

庫內全文搜尋：REKI 只命中兩天候選紀錄；Mem4Act、VaM 未命中。三篇本次取得的未帶版本官方摘要頁均只列 v1，未見 withdrawn／retracted 標記；此結論只限本次讀回，不涵蓋未查候選或日後更新。

## 庫務與發布邊界

- 已驗證 root／origin／main、乾淨工作樹與 GitHub 認證後 `git pull --ff-only`，已是最新。
- 官方 PDF 直接以 `curl` 取得，使用既有 `pdftotext`，未安裝重型研究依賴。字型警告未阻止抽取；公式以原文附近敘述交叉檢查，未從不清楚的圖像補數字。
- 更新日期／年度／論文總索引與根 README 短入口。研究導覽只新增「歷史可辨識性」一條，連接時間、觀測與環境辨識，不把所有新文都塞進導覽。
- Markdown 為真實來源；以本機 `scripts/deploy_pages_local.sh` 發布，不用 GitHub Actions 建置／部署。實際 SHA、push、strict build、Pages source／branch build 與正式站讀回結果以交付回報為準。
