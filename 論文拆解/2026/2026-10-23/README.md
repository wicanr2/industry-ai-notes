# 2026-10-23 論文研究

今日新增 **1 篇方法閱讀筆記**，不湊第二篇。寫入前當日非 README `.md` 為 **0**，新增後為 **1**。選文窗口為 **2026-10-16 至 2026-10-22**；擷取／閱讀於本次 Asia/Taipei 上午排程期間，並非聲稱 09:00 已完成所有查證。

## 今日選文

1. [CW-WAM：力參考要分開追蹤與安全](./01-cwwam-力參考要分開追蹤與安全.md)
   - [arXiv:2610.30117v1](https://arxiv.org/abs/2610.30117v1)，10-21 首次提交（UTC），cs.RO 10-22 公告。
   - **實讀**：官方 8 頁 PDF 摘要、§I–VI，含完整方法、slow–fast 控制、實驗 A–G 與 discussion；表 I–II、圖說與可抽取標記。未做 PDF 畫面或逐圖審查、未審碼、未重跑，沒有附錄。
   - **方法新增**：命令—實測力矩配對歷史、獨立預測串流、pair-causal attention、10 秒 wrench memory；預測作 20 Hz 導納回饋參考，再由 1 kHz impedance controller 追蹤。
   - **判斷界線**：插入／釋放／追蹤預測力分開；主榜只及示範分布內，人工 gains／順應方向仍是方法一部分，不能把追蹤自己預測的力改稱安全力。

## 有界搜尋、候選與取捨

本次閱讀 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 回傳首頁的標題與 metadata（最新公告日 10-22），重點看世界模型／具身交會，另回查下列四個官方摘要／版本頁。這是有界候選搜尋，不是全週 LLM 文獻的系統性回顧。

- **入選 [CW-WAM（2610.30117v1）](https://arxiv.org/abs/2610.30117v1)**：能取得方法、控制介面及受控消融；直接接續昨天 PhysWord 的「預測接觸不等於實測」問題，把實測回流與安全參考再分開。
- **優先待讀 [Agentic World Action Models（2610.30136v1）](https://arxiv.org/abs/2610.30136v1)**：10-21 提交。摘要把 code／video／action 三串流及技能程式重用連起來，符合 LLM × robotics 優先範圍。本次僅摘要／metadata，未讀資料標註管線、執行迴圈與基線公平性，不以摘要聲稱填第二篇。
- **保留 [PhysiCalWorld（2610.30125v1）](https://arxiv.org/abs/2610.30125v1)**：10-21 提交。摘要的 exploratory clip／physics descriptor 可接續 T2-z 的互動可辨識性；未讀方法／泛化實驗，不能將 latent 結構當已辨識物理參數。
- **延續待讀 [UniWALM（2610.28626v1）](https://arxiv.org/abs/2610.28626v1)**：10-20 提交，昨天已列候選。摘要的 language-as-memory 與 FMC 仍值得方法閱讀；今天未補讀，不更改昨天的範圍，不引用摘要成功率作驗證。

**去重／撤稿檢查**：寫入前查四個完整 arXiv ID，只有 UniWALM 命中昨天 README 候選，無正式單篇重複。四個目前官方摘要頁均列 v1，未見 withdrawn／retracted。這只代表本次擷取狀態。

## 庫務與發布

- root／origin／main／乾淨工作樹及 gh 認證確認後，`git pull --ff-only` 回傳已是最新。
- PDF 使用現有 `pdftotext -layout`，字型警告未阻止抽取，未新增重型相依套件。
- 新增單篇與日期索引，更新年度／總索引及 README 短入口；研究導覽只補「預測參考／實測追蹤／獨立安全」的新判斷，不將舊筆記冒充補讀。
- 相對連結／`git diff --check` 後只 stage 本次變更，繁中 commit／push，再執行本機 `scripts/deploy_pages_local.sh`。不使用 GitHub Actions 建置或部署。
- 實際 main／gh-pages SHA、Pages source／branch build、首頁／日期／單篇 HTTP 與正文識別驗證，以本次最終交付為準。
