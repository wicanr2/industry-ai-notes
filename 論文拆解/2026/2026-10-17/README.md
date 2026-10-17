# 2026-10-17 論文研究

今日新增 **1 篇方法閱讀筆記**；不為每日最多 2 篇湊數。寫入前今日非 README 的 `.md` 為 **0**，本次新增後為 **1**。首次提交日篩選窗口為 **2026-10-10 至 2026-10-16**（近 1–7 天）。不回填停更日期，也未將舊筆記改標為已補讀。

## 今日選文

1. [VeriVLA：驗證算力必須買到更好的動作](./01-verivla-驗證算力必須買到更好的動作.md)
   - [arXiv:2610.21985v1](https://arxiv.org/abs/2610.21985v1)，首次提交 2026-10-15；Xueli Sun、Yuxiang Lu、Yantong Liu、Xianzhe Fan、Xi Chen、Zhe Liu、Hengshuang Zhao。
   - **實讀官方 PDF**：摘要、§1–6（含完整 §3 方法、§4 真機／模擬／消融／觸發分析、§5 限制）及附錄 A–D；另核 HTML 部分文字／公式。讀圖說與可抽取文字，未逐圖視覺檢驗、未看影片、未審程式碼、未重跑。
   - **交會價值**：VLA × 潛在世界模型 × 適應式推論算力；把「候選夠不夠好」「能不能排對」「是否值得介入」「是否來得及執行」分帳。
   - **重要邊界**：training-free 只指 trigger；65.5% 是含部分完成的 completion score；326 ms 不含 trigger 與基礎策略，啟動時總延遲為 422 ms；接觸 AUC 不是反事實介入效益。

## 有界搜尋、候選與取捨

擷取日期：**2026-10-17（Asia/Taipei）**。取得官方 [cs.RO recent](https://arxiv.org/list/cs.RO/recent) 與 [cs.CL recent](https://arxiv.org/list/cs.CL/recent) 各前 50 筆列表；**本次實際人工初篩範圍為 cs.RO 第 1–24 項、cs.CL 第 1–4 項**。列表當時最新公告批次為 2026-10-16，與作者首次提交日不同；這不是全週窮盡式文獻回顧。

以下三篇以獨立 metadata 核版本／日期，並查庫內 `.md` arXiv ID，未見既有命中；未帶版本頁都只列 v1、未見 withdrawn／retracted 標記。狀態僅限本次查驗。

- **入選 VeriVLA（2610.21985v1）**：讀到方法、實驗、限制與附錄；有直接世界建模／預訓練消融，又可用成本表校正摘要印象，能對照 RESCUE 的介入效益、Chronos 的時間有效性及 FoveaVLA 的觀測資訊。
- **[T2-z: Test-Time Optimization of Environment Latents for Robotic World Models（2610.22364v1）](https://arxiv.org/abs/2610.22364v1)**：首次提交 2026-10-15。已讀 metadata／摘要；摘要提出由觀測結果適配環境 latent，以處理摩擦、質量或環境規則等不可直接觀察因素。可與 VeriVLA 的世界模型可辨識性形成對照，但**未讀方法／實驗，不把摘要的適配／泛化主張當已驗證結果**，今日不另成筆記。
- **[REKI: Registering Knowledge in VLAs（2610.22178v1）](https://arxiv.org/abs/2610.22178v1)**：首次提交 2026-10-15。已讀 metadata／摘要；摘要提出以 action expert 中持續保留的 register tokens 摘錄近期 VLM 輸出。適合後續研究記憶介面，但**未讀訓練配方、受控對照與實驗協定**；不據摘要宣稱 Pareto 前沿或部署可靠性，今日保留。

其他只到列表標題初篩的方向包括 LIBERO-PeRM、Value as Memory、MOSS、FastVLA、Plans Are Not Executions，以及 cs.CL 的 OmniVerifier-C1、科學點子多樣性與 Grid-Bench；未核獨立 metadata／方法，不列為已完成資格驗證的候選，也不做能力排名。

選一篇是將本次資源集中於可核實方法與數值口徑，不表示未選者較弱，也不承諾明日選題。

## 庫務與發布邊界

- 起始確認正確 repo／origin／main 與乾淨工作樹，才 `git pull --ff-only`；已是最新。
- PDF 以既有 `pdftotext` 抽取，未裝研究用重型依賴；字型 warning 與抽取後端限制記於單篇。
- 更新日期／年度／論文總索引及根 README 短入口；研究導覽只補「選擇算力的介入價值」一條跨篇機制。
- Markdown 是內容來源；發布採本機 `scripts/deploy_pages_local.sh`，不用 GitHub Actions 建置／部署。實際 push、strict build、Pages source／branch build 與正式站驗證結果，以本次交付為準，不在筆記預寫成功。
