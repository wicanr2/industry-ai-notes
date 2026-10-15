# 2026-10-15 論文研究

今日新增 **1 篇方法閱讀筆記**，不為上限湊第二篇。執行前今日非 README 的 `.md` 為 **0**；本次以首次提交日 **2026-10-08 至 2026-10-14** 為近 1–7 天窗口。未回填其他日期，也未改寫舊筆記為已補讀全文。

## 今日選文

1. [ChunkAct：把程序記憶編譯成執行契約](./01-chunkact-把程序記憶編譯成執行契約.md)
   - [arXiv:2610.18874v1](https://arxiv.org/abs/2610.18874v1)，首次提交 2026-10-13；作者 Bingxin Xu、Wenrui Bao、Xinxin Liu、Jiawei Zhou、Yuzhang Shang、Emilio Ferrara。
   - **實讀**官方 PDF 摘要、§1–2、§3.1–3.4 方法、§4.1–4.5 實驗、§5 結論、附錄 A–B／Tables 4–5；另核 HTML Tables 1–3 與相關正文。不是導論速覽，未重跑程式；本文沒有獨立限制章，筆記明列由方法條件與評估範圍辨認的限制。
   - 直接屬 **LLM × Robotics／VLA** 交會：讓 planner 以 chunk 而非單 primitive 調度，保留現場感知、局部驗證與 typed error hand-off。
   - 特別保留兩個來源口徑問題：每組／總 episode 數文字矛盾，以及 Table 1 的 checkpoint 差額與正文不一致；不以摘要收益遮掉實驗邊界。

## 有界搜尋、候選與取捨

擷取日期：**2026-10-15（Asia/Taipei）**。本次實際檢視 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 前 50 項、[cs.CL recent](https://arxiv.org/list/cs.CL/recent) 回傳文字前段（約前 43 項）的 metadata／標題，並重查下列候選版本頁及摘要；**不是全週完整文獻回顧，列表不是方法證據**。兩個列表此次皆以 2026-10-14 為最近公告批次，不將批次日期當作者提交日期。

- **入選 ChunkAct（2610.18874v1）**：庫內搜尋 ID 沒有既有命中；與既有 Harness／BT-Agent／RESCUE 線索相關，但新增「程序知識何時由文件變成可執行介面」的機制問題，且方法、實驗與附錄均可讀。未帶版本頁當時只列 v1，未見 withdrawn／retracted 標記。
- **[Make π0.5 Learn to Call Astra for Reliable Robot Manipulation（2610.14117v1）](https://arxiv.org/abs/2610.14117v1)**：首次提交 2026-10-09；已讀官方 metadata／摘要，亦成功下載與抽取 PDF，**但沒有閱讀抽取後方法／實驗文字**。摘要呈現 local CALL head 觸發外部恢復的方向，與介入時機線索相關；要核對標籤、切換及對照公平性才能寫方法論述。今日不入選、不引用摘要成功率作驗證結果。
- **[Noise Space Learning for VLA Adaptation（2610.13943v1）](https://arxiv.org/abs/2610.13943v1)**：首次提交 2026-10-09；重讀 metadata／摘要。前兩日只列候選，仍沒有獨立筆記；不是因重複發文而排除。凍結 VLA 的適應介面值得另讀，但本次未讀方法、理論與各演算法的互動資源對照，保留候選。
- **[LoopWAM（2610.18873）](https://arxiv.org/abs/2610.18873)**、**[EmbodiedEvo（2610.18867）](https://arxiv.org/abs/2610.18867)**、**[LIBERO-RIG（2610.18843）](https://arxiv.org/abs/2610.18843)**：只作 cs.RO 列表 metadata／標題初篩，分別提示部署迴圈、自改進 coding agent、硬體配置魯棒性方向；未核獨立版本頁、提交日、撤稿與方法，不當成已符合全部入選條件的研究證據。
- cs.CL 的 **[Tev（2610.18868）](https://arxiv.org/abs/2610.18868)**、**[Hybrid Reasoning Agents（2610.18861）](https://arxiv.org/abs/2610.18861)** 只作列表標題初篩；與 agent 成本／長程決策可能相接，但未讀方法，不從題名做能力排序。

只發一篇，是把本次閱讀集中於完整方法、消融、失敗與報告口徑，不表示其餘候選較弱，也不承諾明日必選。

## 庫務與來源限制

- 開始時確認 root／origin／main、乾淨工作樹及 `git pull --ff-only`；今日上限與庫內 ID 搜尋在寫入前執行。
- 網頁抽取工具回報 backend 不支援 URL extraction，改用直接 HTTP 取得官方頁面／PDF／HTML；沒有用搜尋片段補內文。未安裝重型依賴；PDF 字型 warning 與 HTML 交叉核對記於單篇。
- 更新日期／年度／論文總索引、根短入口；研究導覽僅補一條將「穩定程序編譯」接到既有執行／介入／時間框架的線索。
- main push、本機 strict build、gh-pages／Pages source／branch build 及正式站首頁、當日索引、文章正文的驗證結果，見本次交付；不在研究筆記預寫部署成功。
