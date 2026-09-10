# TANGO: Humanoid Navigation in Cluttered Environments with a Whole-Body Vision-Language-Action Model

## 原文資訊
- 論文：TANGO: Humanoid Navigation in Cluttered Environments with a Whole-Body Vision-Language-Action Model
- 作者：Anqi Li、Yuxin Chen、Zhaobo Li、Zhuo Cao、Junli Ren、Masayoshi Tomizuka、Dhruv Shah
- arXiv ID：2609.09158v1
- 分類：cs.RO、cs.AI
- 發表 / 更新：2026-09-08 / 2026-09-08（v1）
- 連結：[abs](https://arxiv.org/abs/2609.09158v1) / [pdf](https://arxiv.org/pdf/2609.09158v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、方法、實驗、結果與附錄
- 擷取日期：2026-09-10

## 為什麼選這篇

語言導航常把機器人近似成平面上的一個點：高層模型預測 waypoint 或離散方向，低層控制器再負責走過去。對人形機器人而言，這個抽象會遺失關鍵物理條件；同一條路徑可能要求縮手、側身、調整軀幹或跨過障礙，能否通過取決於整個身體隨時間改變的幾何形狀。

TANGO 把語言指令、第一人稱影像與 29 自由度全身動作放進同一個 VLA 問題。它值得收錄，不是因為「端到端」本身必然優於模組化，而是因為它迫使 navigation intent 與 whole-body traversability 在同一決策介面中被考慮，直接碰到 LLM／VLM 與人形控制之間最容易被高層規劃忽略的 embodiment gap。

## 一句話理解

對人形機器人來說，導航不是先找二維路徑再交給身體執行，而是路徑選擇本身就必須知道整個身體是否能穿過三維空間。

## Summary / Abstract 說了什麼

摘要將 TANGO 定位為語言條件的人形 whole-body vision-language navigation framework。輸入是自然語言指令與 egocentric RGB observations，輸出則是供下游全身控制使用的 29-DoF joint-space actions。

可用下列概念式表示其問題設定：

$$
\mathbf{A}_t = \pi(\ell,\mathbf{o}_{1:t}), \qquad
\mathbf{A}_t = \{\mathbf{a}_{t},\ldots,\mathbf{a}_{t+H-1}\},\quad
\mathbf{a}_i \in \mathbb{R}^{29}.
$$

其中 $\ell$ 是語言指令，$\mathbf{o}_{1:t}$ 是截至時間 $t$ 的視覺與身體觀測，$H$ 是一次預測的 action horizon；$\mathbb{R}^{29}$ 表示動作直接描述 29 個關節自由度。這是便於理解的簡化式；Introduction 另提到部署端仍使用 motion tracker 與 real-time action chunking，因此不應把系統理解成語言模型直接驅動馬達。

作者以模擬環境合成碰撞自由的 traversal behavior：先做 global path planning，再生成 kinematic whole-body motion、編輯避障動作，最後用 RL-based tracking 取得動態上可執行的監督訊號。摘要自稱在模擬 VLN 與障礙協商上優於比較方法，並在 Unitree G1 上做零樣本實機部署；本次未讀實驗章，不能判斷效果量、失敗率或場景覆蓋。

## Introduction 的問題設定

Introduction 先指出，人形機器人的幾何外形會隨手臂、軀幹與腿的姿態持續改變。對輪式或被簡化成點質量的 agent 可行的路徑，未必能讓人形機器人的全身安全通過；所以規劃層看似合法的動作，可能在 embodiment 層不可執行。

作者把既有工作分成三類缺口：VLN 多使用二維 waypoint 或離散動作，難表示全身可通行性；whole-body VLA／humanoid foundation model 常以高層 locomotion command 驅動下游控制器，導航模型沒有直接推理全身幾何；collision-aware RL 雖能處理特定穿越情境，卻可能依賴特定任務先驗與訓練分布，不易擴到長時序、語言引導的多樣場景。

TANGO 因而直接從語言與第一人稱 RGB 預測全身 joint-space action，並以模擬資料管線解決大規模語意任務與物理可行動作難以同時取得的問題。作者自稱會開源資料管線、資料集、VLA、checkpoint 與部署系統；本次只把它視為 Introduction 中的承諾，尚未驗證實際釋出狀態與可重現性。

## 研究的第一性問題

- **基本問題**：語言導航決策如何同時滿足「往哪裡走」與「這個具有特定身體幾何的機器人如何通過」？
- **約束**：觀測主要來自 egocentric RGB；空間有地面、側向與頭頂障礙；全身動作維度高，還要符合動態可執行性與即時控制需求。
- **既有方法卡點**：高層 waypoint 把身體當成固定 footprint；導航與控制分離後，規劃器可能提出低層無法安全實現的路徑。
- **作者試圖移動的邊界**：從 planar language navigation，移到以 whole-body action space 表示、同時學習語意意圖與全身 traversability 的 VLA。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出語言條件、面向雜亂室內環境的人形 whole-body VLA 導航框架。
- 從自然語言與第一人稱 RGB 直接預測 29-DoF joint-space actions。
- 建立 global planning、kinematic motion generation、obstacle-aware editing 與 RL tracking 串成的模擬資料管線。
- 在模擬中兼顧 VLN 與障礙穿越，並零樣本部署到 Unitree G1 實機。
- 計畫開源資料、模型與部署系統。

### 我的保守判讀

- 最重要的觀念是 **navigation abstraction 必須配合 embodiment**。對人形機器人，固定半徑或二維 footprint 可能不足以描述可通行性。
- 「直接預測全身動作」仍不等於完全取消模組：訓練資料由多階段規劃／編輯／追蹤流程生成，部署也需要 low-level motion tracker。較準確的說法是把原本導航端未表示的全身決策移入 learned policy。
- 模擬生成的 collision-free trajectory 可能帶入 planner、資產與動作模板的偏好；零樣本實機結果能否涵蓋材質、感知噪聲、動態障礙與跌倒恢復，需讀實驗與失敗案例。
- 29-DoF action space 增加表達力，也擴大資料與安全驗證負擔。模型是否真的形成幾何推理，或主要模仿資料管線的穿越模式，Introduction 無法區分。
- 作者的 state-of-the-art、robust 與 zero-shot 主張均來自摘要／Introduction；本次未檢查 baselines、統計不確定性、實機 trial 數或安全界線。

## 可放進資料庫的筆記

1. **導航抽象不是中性的。** 把 agent 當成點、圓或固定 footprint，會預先刪掉某些 embodiment 才有的可行解與風險。
2. **規劃可行不等於身體可行。** 路徑、姿態、碰撞幾何與動態穩定性需要在同一條執行鏈上對帳。
3. **Whole-body navigation 是時變幾何問題。** 機器人的可碰撞外形會隨動作改變，而不是固定成本地圖。
4. **端到端政策背後仍有模組化資料工廠。** 生成 supervision 的 planner、motion editor 與 tracker 會決定模型能學到哪些行為。
5. **模擬資料品質要同時看語意與動力學。** 場景多樣不代表動作可執行；動作可執行也不代表語言任務多樣。
6. **高層與低層介面仍然存在。** 即使 VLA 輸出 joint targets，motion tracker、action chunking 與硬體控制仍承擔穩定性。
7. **Zero-shot sim-to-real 應拆成多個轉移。** 視覺、幾何、動態、控制延遲與語言分布各自可能是瓶頸。
8. **安全評估不應只看是否到達。** 全身碰撞、最小間隙、姿態穩定、恢復能力與對動態障礙反應都應分帳。

## 後續想追的問題

1. 模擬資料中的語言、場景與穿越動作如何配對；是否存在可被模型利用的模板捷徑？
2. 與 modular baseline 比較時，感知、scene access、motion tracker 與計算預算是否一致？
3. 實機 zero-shot 測試有多少 trial、哪些障礙組合，以及碰撞／跌倒／人工介入如何記錄？
4. 29-DoF 預測錯誤如何被 low-level tracker 修正；tracker 的能力占最終成功多少？
5. 遇到移動中的人、未見材質或需要重新規劃的封路時，政策是否具有閉環恢復能力？
