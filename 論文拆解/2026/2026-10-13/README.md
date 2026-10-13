# 2026-10-13 論文研究

今日新增 **2 篇方法閱讀筆記**；執行前本日非 README 的 `.md` 為 0。入選兩篇首次提交日均為 2026-10-09，在本次近 1–7 天窗口內；不回填停更日期，也不把舊的導論速覽改稱全文閱讀。

## 今日選文

1. [BT-Agent：固定技能與反應式護欄](./01-bt-agent-固定技能與反應式護欄.md)
   - [arXiv:2610.13862v1](https://arxiv.org/abs/2610.13862v1)，Fabio Hübel 等，2026-10-09。
   - 實讀摘要、導論、相關工作、方法、模擬框架、全部實驗／消融及結論／限制；官方 HTML 為主，PDF 已下載並輕量抽取交叉核對。
   - 問題：如何把慢速 LLM 的技能選擇與本地快速執行檢查隔離？須區分共同技能層上的編排比較、獨立停止測試與真機可靠性。
2. [RESCUE：警報的介入價值](./02-rescue-警報的介入價值.md)
   - [arXiv:2610.13516v1](https://arxiv.org/abs/2610.13516v1)，David Ahmedt-Aristizabal 等，2026-10-09。
   - 實讀摘要、導論、相關工作、完整方法、實驗／robustness controls、成本工作表及限制／結論；HTML 保留公式，PDF 已取得，圖中字型抽取有亂碼。
   - 問題：準確的警報何時仍不值得介入？須把可恢復性、誤報、可用介入與完成成本放在同一 workload 下比較。

兩篇都**不是僅摘要改寫**；也沒有聲稱重現程式或獨立驗證作者結果。配對價值是分開「具強制力的執行契約」與「可選的恢復決策效益」，不能用後者否定安全停止。

## 候選與取捨紀錄

- 本次有界 discovery 使用 [arXiv cs.RO recent](https://arxiv.org/list/cs.RO/recent) 的首 50 項，頁面列示 2026-10-12 公告批次；選中項目的版本頁首次提交為 2026-10-09。這是有限候選池，**不是全週全部 LLM／機器人論文的完整搜尋**。
- **入選 BT-Agent**：LLM + Robotics 直接交會；機上計算、固定技能介面、診斷回饋與物理停止各有不同層級證據，足以形成可驗證部署問題。
- **入選 RESCUE**：VLA runtime evaluation；不是多一個 failure detector，而是可反覆使用的反事實評估與成本檢查。與第一篇機制不同，第二篇不是湊數。
- [Chronos Policy: Learning Robot Policies on Physical Time，2610.13929v1](https://arxiv.org/abs/2610.13929v1)：已讀官方 metadata／摘要，首次提交 2026-10-09。顯式 observation capture time／desired action time 與非同步資料值得追蹤；本次優先把執行護欄／介入效益這組問題讀完，未讀其方法，**暫不收錄，不代表評估其方法較弱**。
- [SmolWAM: A Latent World-Action Model for Robotic Manipulation on Edge Devices，2610.13740v1](https://arxiv.org/abs/2610.13740v1)：已讀 metadata／摘要，首次提交 2026-10-09。邊緣 WAM 介面縮減值得另日核對 hardware、時延與消融；本次不直接把摘要的效率宣稱寫成部署證據，未讀方法，暫不收錄。
- [Noise Space Learning for VLA Adaptation，2610.13943v1](https://arxiv.org/abs/2610.13943v1)：已讀 metadata／摘要，首次提交 2026-10-09。凍結 VLA 並學條件 noise distribution 與適應成本相關，但需另讀演算法／實驗公平性；本次未讀方法，暫不收錄。

## 庫務與閱讀邊界

- 入選前在 repository 搜尋兩個不含版本號的 arXiv ID，均無命中；官方版本頁本次未見 withdrawn／retracted 標記。此為本次查閱狀態，不保證未來不變。
- 抽取工具的 URL extraction backend 不支援內容擷取，改由 Python 標準函式庫直接下載官方 HTML／PDF；使用既有 `pdftotext`，未安裝重型論文解析依賴。
- 年度、總索引與根入口更新；研究導覽僅新增本次跨篇機制：硬護欄與介入效益分開驗證。所有舊筆記閱讀邊界不變。
- Markdown 相對連結、`git diff --check`、本機 strict build、main／gh-pages 推送及正式站讀回結果，以本次最終交付為準；不將未完成發布預先標為成功。
