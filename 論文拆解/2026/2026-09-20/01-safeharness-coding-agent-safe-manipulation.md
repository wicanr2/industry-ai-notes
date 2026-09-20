# Coding Agents with an Obstacle-Aware Harness for Safe Robot Manipulation

## 原文資訊

- 論文：Coding Agents with an Obstacle-Aware Harness for Safe Robot Manipulation
- 作者：Bingxin Xu、Yuzhang Shang、Zhen Dong、Emilio Ferrara
- arXiv ID：2609.20822v1
- 分類：cs.RO、cs.AI、cs.CL、cs.CV
- 發表 / 更新：2026-09-17 / 2026-09-17（v1）
- 連結：[abs](https://arxiv.org/abs/2609.20822v1) / [pdf](https://arxiv.org/pdf/2609.20822v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML）
- 擷取日期：2026-09-20

## 為什麼選這篇

這篇位在 LLM agent、robot manipulation 與安全控制的交界。它研究的不是讓語言模型直接輸出低階動作，而是讓 coding agent 寫出呼叫感知與控制工具的機器人程式；這種介面較容易檢查與修改，但「程式可讀」不代表「規劃會把安全視為硬條件」。

它值得收錄，是因為作者把失敗定位得比「模型看不懂障礙物」更細：agent 可能辨認到障礙、也能在文字推理中重述禁碰要求，最後仍選擇碰撞路線。若這個觀察可被後續實驗支持，問題就從感知或 prompt wording，轉成 agent harness 是否把自然語言限制編譯成可驗證的規劃與執行約束。

## 一句話理解

機器人 coding agent 會「說出」安全限制卻未必「執行」限制，因此需要在路徑與接觸兩個階段都加入可驗證、可重規劃的 obstacle-aware harness。

## Summary / Abstract 說了什麼

論文研究一種帶安全限制的 manipulation 任務：每個目標都搭配一個不可碰觸的障礙物。作者自稱，原始 coding agent 多數情況仍會碰撞；問題不是沒有辨認障礙，也不是 prompt 未寫明禁碰，而是規劃時沒有把安全提升為與完成任務同級的優先條件。

作者把一次操作拆成兩種物理風險：一是移動到目標附近的 free-space route，二是抓取、放置等 contact-rich moment。SafeHarness 因而包含兩個對應部件：route 端先把物件落到 bounding boxes 與 waypoint 路徑，經規劃、驗證及必要時重規劃後才執行；contact 端則依鄰近障礙調整接觸位置與策略。

摘要報告 SafeHarness 的 task success 為 71.9%、collision avoidance 為 87.5%，分別比所稱 previous SOTA 高 6.5 與 27.0 個百分點；相較同一 agent 未加 harness，作者報告為 2.3 倍與 1.5 倍。這些數字只是摘要與 Introduction 中的作者報告，本次未閱讀實驗章節，不能據此判斷樣本數、變異、比較設定或外部效度。

若以 $S$ 表示任務成功事件、$C$ 表示全程未碰撞事件，真正的安全完成條件應是：

$$
S_{\mathrm{safe}} = S \cap C.
$$

白話來說，只完成任務或只沒碰撞都不夠；機器人必須同時達成目標且遵守安全限制。這也提醒我們，分開報告 task success 與 collision avoidance 時，不能直接推得兩者交集有多大。

## Introduction 的問題設定

Introduction 先描述 coding agent 的演進：語言模型可組合 perception/control APIs 寫出 controller，後續系統再加入失敗後改寫、skill library 與 test-time compute。作者強調，這類 agent 的機器人能力其實由外部 harness 所提供的工具與執行結構共同形成，而不是只存在於語言模型本身。

接著論文指出既有評估多以「是否達成目標」計分，沒有同時衡量途中碰了什麼。作者據此區分 success 與 safety，並主張增加 collision-free demonstrations 或只在 prompt 重述限制，未必會讓限制進入行動決策。

問題診斷沿著操作階段展開：route 端缺少繞開障礙的可行路徑概念，也不會在中途不可行時重規劃；contact 端則沒把抓取或放置本身視為受同一安全條件約束。Introduction 因而把方法主張寫成「先在 agent 外部建立安全決策介面」，而不是期待更強模型自行把語言要求穩定轉成幾何行為。

最後，作者宣稱 SafeHarness 在 SafeLIBERO 上改善任務成功與避碰，且改善來自 harness 而非更換模型。本次閱讀停在 Introduction，沒有查核後續方法對安全的形式化程度、實驗對照與失敗案例。

## 研究的第一性問題

- **基本問題**：自然語言中的「不要碰」如何變成機器人每個規劃與執行階段都必須滿足的物理條件？
- **核心約束**：安全不只存在於 free-space path；接觸目標時的進入方向、位置與腕部姿態也可能移動或撞擊鄰近物。
- **既有方法卡點**：agent 能辨認、描述限制，卻可能仍以最短路徑和任務完成作為事實上的單一目標；語言遵循與幾何可行性之間缺少編譯層。
- **作者試圖移動的邊界**：把安全從 prompt 中的軟提醒，移到 harness 內的規劃、驗證、重規劃與 contact strategy。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 首度在 collision-scored manipulation benchmark 上研究 coding agent 的安全操作。
- 將 route safety 與 contact safety 分開處理，避免只修正途中路徑而忽略接觸階段。
- 在不修改底層模型／policy 的條件下，以 obstacle-aware harness 改善任務成功及避碰。
- 顯示更強規劃模型或 prompt 明示限制，未必足以修補安全優先序。

### 我的保守判讀

- 最值得保留的洞見是：**知道限制、說出限制、把限制編譯成可執行約束，是三種不同能力**。這比單一 benchmark 數字更有普遍性。
- 摘要使用「enforce」與 Introduction 使用近似保證的語言，但只讀前段無法確認是形式化保證、幾何檢查保證，還是受感知誤差與有限案例約束的經驗結果。
- bounding box 與 waypoint 把問題變得可檢查，但 2D／近似幾何可能漏掉深度、末端執行器 swept volume、動態障礙與定位誤差。
- route/contact 二分很實用，卻未必涵蓋推、拖、插入等持續接觸任務；這些行為難以切成乾淨的 free-space 與 contact moment。
- 兩個邊際指標無法告訴我們安全成功率 $P(S\cap C)$；需讀實驗表格確認是否另有 joint metric，以及改善是否集中在少數任務。
- 目前不能外推到人機共域、動態障礙或 safety-critical hardware，也不能確認重規劃延遲是否符合即時控制需求。

## 可放進資料庫的筆記

1. **語言限制需要可執行的編譯層**：prompt 是規格輸入，不是物理保證；中間仍需 grounding、可行性檢查與執行監控。
2. **可解釋不等於可控制**：agent 的 reasoning trace 能提到障礙，卻不代表該資訊真的支配最後的 controller。
3. **成功與安全要用交集計分**：只報任務成功或只報碰撞率，都可能掩蓋「安全地完成」的實際比例。
4. **安全條件要跨階段保持**：同一限制必須從路徑、接觸到執行監控持續有效，不能只在規劃起點檢查一次。
5. **Harness 是模型能力的一部分**：在 embodied agent 中，工具、驗證器、重試邏輯與低階技能決定的能力，可能不亞於 foundation model。
6. **失敗診斷要區分感知、理解、優先序與控制**：四者需要不同修補方法，不能都歸因為模型「不夠聰明」。
7. **硬限制最好在行動產生前介入**：事後 safety filter 能修動作，卻未必能替 agent 選擇另一條路或另一側抓取。

## 後續想追的問題

1. 論文所稱安全「enforcement」是否有形式化保證？感知框與控制誤差如何納入 margin？
2. SafeLIBERO 是否報告 $P(S\cap C)$，而不只是 task success 與 collision avoidance 的邊際比例？
3. route verification、重新感知與 replanning 的延遲是多少，是否會造成新的控制 dead time？
4. 方法如何處理 swept volume、動態障礙，以及整段接觸式操作？
5. 改善來自何種元件；是否存在因過度保守而無法完成任務的失敗型態？
