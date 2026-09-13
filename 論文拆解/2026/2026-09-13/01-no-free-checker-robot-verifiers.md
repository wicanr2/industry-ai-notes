# No Free Checker: A Survey of Verifiers for Robot Policies

## 原文資訊
- 論文：No Free Checker: A Survey of Verifiers for Robot Policies
- 作者：Yang Wan、Xihang Yue、Zhirui Liu、Ziyuan Chu、Shuxun Wang、Yuhan Chen、Xiaonan Jiang、Xukun Zhu、Yubo Dong、Linchao Zhu
- arXiv ID：2609.09250v1
- 分類：cs.RO、cs.AI、cs.CV、cs.LG、eess.SY
- 發表 / 更新：2026-09-08 / 2026-09-08
- 連結：[abs](https://arxiv.org/abs/2609.09250v1) / [pdf](https://arxiv.org/pdf/2609.09250v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML）；未讀後續章節、個別文獻整理、結論與附錄
- 擷取日期：2026-09-13

## 為什麼選這篇

VLA、robot world model 與 embodied agent 的能力若要進入實體環境，問題不只在「能不能產生動作」，還在「誰來判斷這個動作是否正確、安全、值得拿來訓練」。這篇 survey 把 success detector、reward model、runtime monitor、安全過濾器與形式規格放進同一個 verifier 框架，適合補上目前資料庫偏重 policy architecture、較少整理評分機制的缺口。

它的價值不只是列舉工具，而是提出 availability（可取得性）與 credibility（可信度）兩條軸。這讓 verifier 不再被當成中立真值來源，而是一個有成本、延遲、密度、假設與被鑽漏洞風險的測量系統。對機器人後訓練、推論時候選動作排序與 world-model rollout 評估，這個視角都有直接用途。

## 一句話理解

機器人 policy 沒有免費、即時、密集又可信的「裁判」；任何 verifier 都是在判斷成本與判斷可信度之間做取捨。

## Summary / Abstract 說了什麼

論文把 robot verifier 定義為一個評分映射：

$$
V(c, x) \rightarrow s
$$

其中 $c$ 是 context，可包含觀測、目標與語言指令；$x$ 是待判斷的 candidate，可從單一 action chunk、子任務軌跡一路到完整 policy；$s$ 是 score，可為布林值、純量、向量或機率分布。白話說，verifier 的工作是讀取「當時情境」與「候選行為」，再輸出一個可供訓練、選擇或評估使用的判斷。

摘要自稱 survey 約 150 個 verifier，並按判斷來源分成四族：人類、規則／形式方法、學習式／預訓練模型，以及模型內生訊號。作者用兩個性質比較它們：

- **Availability**：一次判斷多貴、多早能取得、可以多密集地詢問。
- **Credibility**：高分究竟能多大程度支持「任務真的完成得好」。

摘要的核心觀察是，判斷愈便宜、愈早、愈密集，通常愈難直接保證真實任務表現；因此沒有「free checker」。作者也指出，文獻常從三條路驗證 verifier 本身：與人類標註的一致性、用它訓練後所得 policy 的表現，以及在 reward hacking 搜尋下是否仍穩健。

## Introduction 的問題設定

Introduction 先把 verifier 放回 robot-learning pipeline：它可以過濾或重加權預訓練示範、供應後訓練 reward、在推論時排序候選動作，也可以評估 world model 產生的 rollout。換言之，同一種「評分介面」會影響資料、學習、決策與最終評估，不只是 benchmark 結束後才出現。

接著，作者指出實體世界的驗證比數學或程式碼困難：成功常只能由不完美感測推斷；真機 rollout 昂貴且慢；安全判斷不能總等到任務結束；而表現往往同時包含進度、安全與品質，不能壓成單一成功／失敗標籤。

四類 verifier 因此各有結構性邊界：人類判斷接近任務意圖但昂貴而稀疏；規則與形式方法可重複，卻依賴狀態估計和物理假設是否成立；學習式判斷密集且便宜，但可信度依賴校準與分布外泛化；模型內生訊號最容易取得，卻首先描述的是模型自己，而不是真實任務是否完成。

## 研究的第一性問題

- **基本問題**：當 robot policy 產生一段行為時，系統如何取得足以支援訓練、選擇或停止執行的可信判斷？
- **約束**：真機試驗有時間與硬體成本；感測不完美；安全判斷有低延遲需求；任務品質多維且可能被代理分數簡化。
- **既有方法卡點**：便宜而密集的分數容易成為可被 policy 利用的 proxy；較接近任務意圖的判斷則難以大量供應。
- **作者試圖移動的邊界**：不尋找單一「最好 verifier」，而是建立可比較的座標，要求研究者說清楚判斷從哪裡來、何時可用、成本多高，以及高分能證明什麼。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 統整約 150 個 robot verifier，並以判斷來源分成四類。
- 提出 availability–credibility 的比較框架與「no free checker」觀察。
- 整理 verifier 自身的三種驗證方式，並預告九項讓 verifier claim 可被檢查的報告指標。

### 我的保守判讀

- 這個框架的強項是把 verifier 從「答案產生器」還原成測量裝置，迫使我們同時記錄成本與誤差來源。
- 「可信度隨可取得性上升而下降」在 Introduction 中是跨類別的概括性觀察；它是不是穩定經驗規律、各類內部是否存在反例，仍須讀後續 survey 方法與證據。
- 本次沒有檢查約 150 篇文獻如何搜尋、納入或編碼，也沒有讀九項指標的完整定義，因此不能判斷 survey 的覆蓋率與重現性。
- 人類判斷也不是無條件 ground truth；主觀差異、標註介面與任務規格本身，都可能把偏差帶進所謂高可信度判斷。

## 可放進資料庫的筆記

1. **Verifier 是測量系統，不是真值本身**：記錄 score 前，先記錄它觀察到什麼、漏掉什麼，以及誰定義成功。
2. **評分管線四問**：判斷成本多少、最早何時出現、能問多密、被最佳化後是否仍代表原任務。
3. **Proxy 被使用就會改變行為分布**：離線準確率高，不等於 policy 主動搜尋高分漏洞時仍可靠。
4. **模型內生訊號的語意邊界**：不確定度、likelihood 或 reachability 先描述模型信念，不能直接等同實體成功率。
5. **早期安全與終局成功是不同 verifier 任務**：前者要求低延遲與保守性，後者需要完整任務語意，最好不要共用單一分數假裝兼顧。
6. **形式保證依賴介面假設**：規格再嚴謹，若狀態估計、動力學或任務 predicate 不成立，保證不會自動轉移到真實世界。
7. **驗證 verifier 要加入對抗性搜尋**：除了和固定標註比對，也要測試 policy 是否能找到「高分但做錯」的行為。
8. **資料、訓練、推論、評估可能共用同一偏差**：若同一 verifier 貫穿整條鏈，高分可能只是閉環自我一致，而非外部有效性。

## 後續想追的問題

1. 約 150 個 verifier 的搜尋範圍、納入準則與分類一致性如何處理？
2. 九項報告指標是否能形成實務上的 verifier model card？
3. Availability 與 credibility 能否量化成 Pareto frontier，而非只做定性定位？
4. 作者如何區分 reward hacking、感測失誤、任務規格不完整與模型校準失敗？
5. 多個低可信度 verifier 的交叉檢查，能否組成比單一高成本人類判斷更好的安全閘門？
