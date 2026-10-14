# 2026-10-14 論文研究

今日新增 **1 篇方法閱讀筆記**，不為上限湊第二篇。執行前今日非 README 的 `.md` 為 0；本次首次提交窗口為 2026-10-07 至 2026-10-13，入選論文首次提交日為 2026-10-09。未回填停更日。

## 今日選文

1. [Chronos Policy：把時間還給控制介面](./01-chronos-policy-把時間還給控制介面.md)
   - [arXiv:2610.13929v1](https://arxiv.org/abs/2610.13929v1)，Changhao Wang、Jaden Clark、Shuran Song。
   - **實讀**官方 PDF 摘要、§1 導論、§2 相關工作、§3 全部方法、§4 實驗、§5 結論／未來工作、附錄 A–C 架構／訓練／消融／真機計分與結果。未重跑程式；非逐條查證參考文獻，非僅摘要／導論速覽。
   - 重點是 capture time、action query time、時間隨機化與非同步 chunk 執行的分工；分清真機 task score 與完全成功率，保留 combined perturbation 與 OOD 子群失敗。
   - 屬 Physical AI；本文未測 LLM 或語言條件 VLA，不能假裝是已驗證的 LLM × Robotics 系統。

## 候選、來源邊界與取捨

- 本次有界 discovery 查閱 [cs.RO new](https://arxiv.org/list/cs.RO/new) 前四項的列表摘要、[cs.CL recent](https://arxiv.org/list/cs.CL/recent) 前十項的 metadata／標題，以及昨日暫存的三篇候選之官方版本頁／摘要。**不是全週完整檢索**，未把列表 metadata 當方法內容。
- 2026-10-14 09:00 後本次取得的兩個列表仍標示 **2026-10-12 公告批次**。這是本次來源回傳的狀態；不能推定全站沒有更新，也不把公告批次當作者提交日期。
- **入選 Chronos Policy（2610.13929v1，2026-10-09）**：昨日只列候選；今日實讀方法與全部實驗附錄，能把「模型很慢」改寫為資料年齡／行動生效時間的可辨識性問題，也能串接昨日的執行護欄與介入價值。入選前 ID 命中只有昨日候選列項，庫內沒有其獨立筆記，並非重複發文。
- **[SmolWAM（2610.13740v1，2026-10-09）](https://arxiv.org/abs/2610.13740v1)**：重查 metadata／摘要。邊緣 world-action 模型的介面縮減值得研究，但要先核對 hardware、teacher 對照及 world head 消融，才能理解成本與能力分母。本次未讀方法，不把摘要效率數字收入方法筆記；保留候選。
- **[Noise Space Learning for VLA Adaptation（2610.13943v1，2026-10-09）](https://arxiv.org/abs/2610.13943v1)**：重查 metadata／摘要。凍結 VLA、學 context-conditioned noise distribution 是直接交會候選，但需完整核對 PPO／SAC／AWR 的 interaction budgets 與理論條件；本次未讀方法，不判定其有效性，保留候選。
- **[Fly-by-Code（2610.12549）](https://arxiv.org/abs/2610.12549)**：只讀 cs.RO 列表摘要。以診斷程式取得新觀測／測試失敗假說，與 coding agent × 機器人直接相關；仍需核對模擬 probe 特權與真機轉移邊界。本次未開版本全文、未核提交日與撤稿狀態，不能作為已符合全部入選條件的筆記。
- **[MeMoREval（2610.12561）](https://arxiv.org/abs/2610.12561)**：只讀列表摘要。記憶建構與使用成本分開量測值得追蹤；本文方法與完整版本 provenance 未核，不以摘要 benchmark 宣稱代替驗證。
- PanTact／CASTER 只作列表初篩，分別涉及全身 contact 與生成影片的物理落地；未讀方法，不提出效果排序。cs.CL 前十項未進入全文核對，因此不對 RSI-Anything 等題目作能力判斷。

今日只發一篇，是把有限研究時間用於完整的機制、消融與失敗子群閱讀，**不表示其他候選方法較弱**，也不承諾下一次固定入選。

## 庫務與閱讀誠實性

- 入選版本頁查閱時未見 withdrawn／retracted 標記；版本及擷取日期保留於單篇。只驗證查閱當下的來源狀態。
- 直接從 arXiv 下載 PDF／HTML，用現有 `pdftotext` 輕量抽取，未安裝重型依賴。字型 warning 與公式排版限制明載於筆記；下載 HTML 不等於逐節讀完 HTML。
- 昨日候選紀錄與舊速覽筆記不改寫。更新日期／年度／總索引、根短入口；研究導覽只加一條把時間有效性與既有護欄／介入框架串接的線索。
- main 推送、本機 strict build、gh-pages 發布及正式站 URL／正文讀回，依本次最終交付結果為準，不預寫成功。
