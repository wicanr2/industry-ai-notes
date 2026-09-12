# ReactHuman: A Physics-Grounded Benchmark for Human-Like Reactive Decision-Making in Embodied Multimodal LLMs

## 原文資訊
- 論文：ReactHuman: A Physics-Grounded Benchmark for Human-Like Reactive Decision-Making in Embodied Multimodal LLMs
- 作者：Yizhan Li、Jianxin You、Mengyang Xiong、Yinhuan Chen、Zicheng Zhao、Dekun Wu、Dongqing Zhang、Bang Liu
- arXiv ID：2609.10895v1
- 分類：cs.RO、cs.AI
- 發表 / 更新：2026-09-09 / 2026-09-09（v1）
- 連結：[abs](https://arxiv.org/abs/2609.10895v1) / [pdf](https://arxiv.org/pdf/2609.10895v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、benchmark 細節、實驗、結果與附錄
- 擷取日期：2026-09-12

## 為什麼選這篇

Embodied MLLM 的評估常落在兩端：一端是影片問答或物理常識判斷，模型只需說出答案；另一端是導航、整理等長時序任務，錯誤可能混合規劃、記憶與控制問題。ReactHuman 選擇一個不同切面：突發家居危險發生時，模型能否立刻做出合理、安全，而且在幾何與時間上真的可執行的反應。

這篇的獨立價值在於把「懂物理」改成帶後果的決策測試。模型不能只回答物體會往哪裡掉，而要提交 walking command 與手部 keyframe trajectory；計畫隨後由模擬人形機器人執行。這使語意判斷、風險選擇與攔截幾何可以分開診斷，也提醒我們：語言模型給出正確 action label，不代表 Physical AI 系統已能在正確時間到達正確位置。

## 一句話理解

ReactHuman 讓 MLLM 在物理模擬中對突發危險提交並執行反應計畫，將「知道該接、該躲或不動」與「真的安全且接得到」分開評估。

## Summary / Abstract 說了什麼

摘要將 benchmark 的目標定為 human-like reactive decision-making。場景涵蓋 17 種突發事件 family、超過 1,000 個可 bit-for-bit 重現的場景，ground truth 由 240 Hz rigid-body simulation 產生，不依賴人工逐案標註；其中還包含外觀與物理性質衝突的 adversarial objects，例如泡棉鐵砧與鋼製蘋果，用來測模型是否根據觀察到的運動修正外觀先驗。

Introduction 將一次反應拆成三個必要條件：

$$
Q_{\text{reaction}}
= (Q_{\text{reasonable}},\ Q_{\text{safe}},\ Q_{\text{grounded}}).
$$

$Q_{\text{reasonable}}$ 問是否選了可辯護的行動，$Q_{\text{safe}}$ 問是否避免傷害，$Q_{\text{grounded}}$ 問手與身體是否在正確時空位置完成反應。這是概念上的向量，不代表作者把五個 metrics 簡化為單一公式；重點是三者不可互相替代。

摘要自稱，以這套 harness 評估七個 MLLMs 後，模型約有三分之一的 hazard 處理失敗，常依固定行為傾向而非場景做選擇、相信外觀勝過運動線索，即使 action 類型正確也會在 meter-scale 上錯估攔截點，且這些問題沒有隨模型規模縮小。這些結果只取自摘要與 Introduction，本次未讀實驗，因此不能核對模型版本、提示、樣本分布或統計方法。

## Introduction 的問題設定

Introduction 以人類的快速反應說明任務同時需要 semantic judgment 與 intuitive physics：要判斷物體是否值得接，也要預測它何時、從何處到達。若 MLLM 成為家用機器人的認知核心，安全、合理與物理落地便不只是 benchmark 能力，而是部署條件。

作者認為既有 passive physical-reasoning benchmark 與長時序 embodied benchmark 都無法清楚測到這項能力。被動問答不會讓錯誤產生物理後果；長任務則不容易區分模型究竟是誤讀 hazard、選了不安全動作，還是 action 選對但攔截軌跡錯誤。

ReactHuman 採 freeze-and-predict protocol：模擬先運行到關鍵決策點後暫停，模型觀察事件並提交 structured reaction plan，包括 walking command 與 hand-keyframe trajectory，再推導出 Catch、Dodge 或 No-Action。暫停模擬可把 API latency 排除在模型間的 decision-quality 比較之外；計畫隨後由預訓練 RL walking policy 驅動的人形機器人實際執行，因此結果不是停在文字答案。

Introduction 另強調 diagnosis：17 個 event families 刻意隔離不同失敗環節，五個 metrics 則分別檢查 semantic action accuracy、action–intent alignment、safety validity、physical endpoint distance 與 hand-distance evolution。作者還主張場景生成將 LLM 負責的 semantic diversity 與 procedural randomizer 負責的 physical parameters 分開，以保留可重現性。

## 研究的第一性問題

- **基本問題**：一個看似理解畫面的 MLLM，能否把物理預測轉成即時、安全且在時空上可執行的 embodied action？
- **約束**：突發事件決策時間短；物體的語意風險、運動軌跡、人體／機器人可達性與安全規則必須同時滿足；評估還需可重現並能定位錯誤環節。
- **既有方法卡點**：VQA 只測口頭物理判斷，長時序 benchmark 又把多種失敗混在一起；只看 action label 會放過「選對但做不到」的計畫。
- **作者試圖移動的邊界**：從 passive recognition 移到 executable reaction，並把單一分數改造成語意、安全與物理 grounding 的診斷鏈。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出 physics-grounded、freeze-and-predict 的人形機器人突發事件評估，涵蓋 17 event families 與超過 1,000 個可重現場景。
- 讓 MLLM 提交 structured plan，並在同一 physics engine 中執行，使決策有可觀測後果。
- 以五個 metrics 分離 reasonability、safety 與 physical grounding，而非只給單一 leaderboard number。
- 建立可擴張的混合生成管線：LLM 提供語意多樣性，程序式 randomizer 控制物理參數與可重現 ground truth。
- 對七個 MLLMs 的研究顯示，模型的反應安全與物理落地仍有系統性失敗，且未呈現單純的 scale improvement。

### 我的保守判讀

- Benchmark 最重要的設計不是「更危險的題目」，而是把**選擇正確**與**執行正確**分開；這對 robot agent evaluation 是可重用原則。
- Freeze-and-predict 有助隔離 cognition，也刻意排除了真實部署中的 latency。它測的是「若給模型足夠牆鐘時間，決策品質如何」，不能直接證明模型能在真實 hazard 的毫秒級時限內反應。
- Simulator-derived ground truth 精確但不一定完整代表真實安全。接觸模型、人體損傷、材質、感測噪音與 actuator delay 都可能造成 simulation-to-real gap。
- 「像 competent human」帶有規範性：合理反應可能受風險偏好、身體能力、情境與責任規則影響。明確 rule system 提升一致性，也可能把設計者的偏好寫入 benchmark。
- RL walking policy 與 MLLM 共同產生最終結果。若 locomotion controller 的能力或限制主導失敗，需要有 oracle plan 或 controller ceiling 才能分清責任。
- 摘要中的「不隨 model scale 改善」只應視為所測七個模型與設定下的觀察，不宜外推為規模對 embodied reasoning 永遠無效。

## 可放進資料庫的筆記

1. **語言正確不等於行動正確。** Embodied evaluation 至少要檢查 action choice、時序、幾何可達性與執行後果。
2. **安全是向量，不是單一成功率。** 合理、安全、物理落地可能彼此衝突，應分軸呈現，避免平均數掩蓋危險失敗。
3. **把 benchmark 設計成失敗定位器。** Event family 與 metrics 應對應 perception、semantic choice、risk policy、trajectory prediction 與 control 的不同環節。
4. **Freeze protocol 是一種因果隔離。** 暫停世界可排除 API latency、專看決策品質；但部署評估仍需另加 end-to-end deadline。
5. **反外觀題目測的是 evidence update。** 外觀與真實物理屬性衝突時，系統是否根據 motion evidence 修正先驗，比一般物體辨識更接近 world grounding。
6. **可重現場景要分開語意與物理生成權。** LLM 可擴張情境描述，但物理參數與 ground truth 最好由可稽核程序控制。
7. **Committed plan 比 multiple choice 更接近部署。** 一旦模型必須輸出 trajectory，模糊的「我會接住」就會變成可量測的空間與時間誤差。
8. **系統責任要有 ceiling tests。** 用 oracle perception、oracle action 或 oracle trajectory 替換單一模組，才能估計 MLLM 與 controller 各自的失敗上限。

## 後續想追的問題

1. 五個 metrics 的公式、門檻與聚合方式為何；安全錯誤是否會被其他高分抵銷？
2. 306-scene empirical study 與超過 1,000 個可用場景的關係為何，event family 是否均衡？
3. 模型看到哪些影像幀、時間資訊與相機視角；structured output parsing failure 如何計分？
4. RL walking policy 的可達範圍與 oracle ceiling 是多少，如何區分 plan error 與 execution-controller error？
5. 加入感測延遲、API latency、控制週期與 sim-to-real disturbances 後，排名與失敗型態是否改變？
