# CLAP: Cross-Embodiment Video World Models are Zero-Shot Physical Simulators

## 原文資訊

- 論文：CLAP: Cross-Embodiment Video World Models are Zero-Shot Physical Simulators
- 作者：Kechen Liu、Ola Shorinwa
- arXiv ID：2608.27406v1
- 分類：cs.RO、cs.AI、cs.CV
- 發表 / 更新：2026-08-27 / 2026-08-27
- 連結：[abs](https://arxiv.org/abs/2608.27406v1) / [pdf](https://arxiv.org/pdf/2608.27406v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（Introduction 由 arXiv HTML 取得）
- 擷取日期：2026-08-29

## 為什麼選這篇

這篇位於 world model、跨 embodiment 學習與機器人操作的交會。它不是只問影片生成得像不像，而是問：不同機器手臂、人手與人形機器人的互動影片，能否共同訓練出可用於動作條件預測的物理先驗。這牽涉 Physical AI 的核心資料問題——資料雖多，動作介面卻不一致，甚至根本沒有動作標註。

它也提出一個值得追蹤的資料尺度假說：真正能擴張的單位可能不是單一機器平台的軌跡數，而是經過適當動作表徵對齊後，可共同使用的跨形態影片。若此假說成立，world model 的資料飛輪就不必完全受限於昂貴的單機型遙操作資料；但「共享物理」是否足以跨越感測、控制與接觸差異，仍須讀實驗後再判斷。

## 一句話理解

CLAP 嘗試把不同機器形態與人類影片的異質動作，轉成可共同學習的條件，讓一個影片 world model 先吸收跨形態物理先驗，再落到可部署的機器人動作空間。

## Summary / Abstract 說了什麼

摘要將既有 action-conditioned video model 的主要限制描述為「單一 embodiment」：模型只能使用特定機器平台的資料，難以吸收大量異質影片。CLAP 同時使用三種動作條件：末端執行器姿態、自然語言指令與 learned latent actions，藉此處理各平台動作空間不同，以及人類影片缺少機器控制標籤的問題。

論文自稱採取 curriculum：先用 latent actions 從未標註影片學跨形態的物理先驗，再以 end-effector action space 進一步對齊，使模型可用於真實機器人的零樣本部署。摘要也宣稱，CLAP 在 DROID 等環境接近或超過單一 embodiment 的影片模型，且能以少量資料適配目標平台；這些是摘要中的結果主張，本次沒有閱讀實驗設計與結果表，因此不把它們視為已獨立驗證的結論。

## Introduction 的問題設定

Introduction 先借用 LLM 的尺度化經驗提出類比：語言模型從異質文字中學到共享表徵，那麼 action-conditioned video model 是否也能從跨形態影片中學到可泛化的物理規律？作者認為，瓶頸不是物理定律因機器形態而不同，而是觀測與動作介面的異質性阻礙資料合併。

作者接著把動作表徵拆成互補而不完美的三類。Latent action 可以利用沒有控制標籤的影片，卻不直接對應真實機器命令；end-effector action 較接近部署介面，卻排除沒有機器動作標籤的人類影片；語言則提供較高層、跨形態的意圖描述，但本身不是精確控制訊號。CLAP 的核心主張，是用分階段訓練而非單一表徵，串起「資料規模」與「可執行控制」。

Introduction 宣稱三項貢獻：協調異質動作空間、以 curriculum 從 latent action 過渡到 end-effector grounding，以及把跨形態模型作為目標 embodiment 的少樣本初始化。它還宣稱能透過跨策略規劃與在影片 world model 中做 RL policy fine-tuning，改善真實操作；但這些機制與證據不在本次閱讀邊界內。

## 研究的第一性問題

- **基本問題**：不同身體與控制介面的互動影片，是否包含足夠共享的物理結構，可訓練出能預測「某動作之後世界如何變化」的共同模型？
- **約束**：不同機器人的自由度、座標系、夾具與控制頻率不同；人類影片通常沒有動作標籤；可擴張的影片資料與可直接部署的控制資料不是同一批。
- **既有方法卡點**：單一 embodiment 模型保持介面一致，卻犧牲資料多樣性；完全依賴 latent action 雖能吃進未標註影片，卻留下部署時的語意落差。
- **作者試圖移動的邊界**：將「先跨形態學共享動態，再對齊目標控制介面」變成可重用的訓練順序，降低每個新 embodiment 都從頭蒐集資料與訓練模型的需求。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 以 end-effector pose、語言與 latent action 協調異質動作資料。
- 透過分階段 curriculum，把未標註影片中的物理先驗轉到可部署的動作空間。
- 跨形態模型可直接泛化到真實操作，並提高目標 embodiment 的少樣本適配效率。
- 提供涵蓋多種動作條件與機器形態的模型及程式碼。

### 我的保守判讀

- 最有價值的地方是把「共享物理」與「共享控制介面」明確分開；前者可能跨 embodiment，後者通常不能直接共用。這比單純擴大混合資料集更具可檢驗性。
- 零樣本 physical simulator 是很強的名稱與主張。是否真的學到因果物理，而不是資料中常見外觀、運動模式與任務先驗，需要看跨分布測試、反事實動作與長時程 rollout 的誤差。
- End-effector pose 並未消除 embodiment 差異：接觸幾何、夾具能力、動力學、延遲與控制器仍可能不同。共享表徵能保留多少與任務成功有關的細節，目前無法從 Introduction 判定。
- Curriculum 的效果可能來自更好的初始化、更多資料或表徵選擇；要讀消融實驗才能區分。
- 本次未讀 methods、experiments、results，不能評估資料重疊、比較基準、公平算力、真實機器任務難度或所稱成功率的統計穩定性。

## 可放進資料庫的筆記

1. **共享定律不等於共享介面**：跨平台學習先找可共用的世界動態，再另外處理每個 embodiment 的控制語意。
2. **資料規模與部署語意是兩個瓶頸**：latent action 解決「資料吃不進來」，end-effector grounding 解決「輸出不能執行」，不應用單一表徵同時承擔兩者。
3. **跨形態預訓練可視為物理先驗的攤提**：若基礎動態可轉移，每個新平台只需為其專屬介面支付增量資料成本。
4. **動作表徵是一種資料治理決策**：選擇 pose、語言或 latent action，會直接決定哪些資料能被納入，以及部署時留下何種轉譯風險。
5. **World model 的關鍵不是影片逼真度，而是介入有效性**：應問改變動作條件時，模型是否預測正確的後果，而不只看視覺品質。
6. **「零樣本」應拆解**：可能是模型權重未更新，但仍依賴既有 policy、校正、動作介面或規劃器；評估時要逐項列出。
7. **適配效率比單一排行榜更接近平台價值**：跨 embodiment 基座若能穩定降低新機型資料需求，才可能形成可累積的資料與模型資產。

## 後續想追的問題

1. 各類 embodiment、任務與影片來源如何分配？訓練與測試是否存在場景、物件或任務重疊？
2. Latent action 如何學得，且如何避免把相機運動、外觀變化誤當成可控動作？
3. 跨形態模型對 end-effector action、語言與 latent action 的消融結果各是什麼？
4. 所謂零樣本真實部署還需要哪些 calibration、policy 或規劃元件？
5. 長時程 rollout、接觸豐富操作與反事實動作下，物理一致性如何量化？
