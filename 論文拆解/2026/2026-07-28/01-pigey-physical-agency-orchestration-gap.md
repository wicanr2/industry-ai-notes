# Addressing the Orchestration Gap in Generalist Robots via Physical Agency

## 原文資訊
- 論文：Addressing the Orchestration Gap in Generalist Robots via Physical Agency
- 作者：Liane Galanti, Dhruv Shah, Tri Dao
- arXiv ID：2607.21725v1
- 分類：Robotics (cs.RO)
- 發表 / 更新：Submitted 2026-07-23 / v1 2026-07-23
- 連結：[abs](https://arxiv.org/abs/2607.21725) / [pdf](https://arxiv.org/pdf/2607.21725)
- 本次閱讀範圍：Summary/Abstract + Introduction；未讀 Methods / Experiments / Results 其他章節
- 擷取日期：2026-07-28

## 為什麼選這篇

這篇很符合「LLM + Robotics / Embodied AI」交會：它不是單純再訓練一個更大的 VLA policy，而是問一個系統層問題：既有 VLA 或技能如果已經會做一些低階動作，為什麼仍然無法完成需要世界知識、條件判斷、失敗恢復與進度追蹤的任務？

作者把這個缺口稱為 **orchestration gap**：同一組 frozen skills，直接被任務文字提示時做不好，但放進閉環的 high-level orchestrator 後，可能完成更複雜的真實機器人任務。這對 Physical AI 很重要，因為它把「智慧」拆成 motor skill、perception、planning、verification、recovery 等模組，而不是把所有能力都押在單一端到端 policy。

我選它的原因不是因為摘要中的數字看起來大，而是因為 Introduction 提出的分工框架有可重用性：機器人泛化不一定只靠資料規模，也可能靠 inference-time 的流程設計，把 LLM/VLM 的高階推理限制在「能被觀察驗證、能重新規劃」的閉環中。

## 一句話理解

這篇主張：通用機器人的難點常不是「手會不會動」，而是如何在真實觀察中把任務拆解、選技能、檢查結果並失敗恢復；Pigey 嘗試用 inference-time orchestrator 補上這個缺口。

## Summary / Abstract 說了什麼

摘要說，一般用途機器人需要同時處理 perception、world knowledge、planning、success detection、recovery 與 low-level control；當前許多方法試圖透過大規模 pre-training 把這些能力都塞進 learned policy。作者改採 decomposition：用一個 high-level agent manager / orchestrator 管理既有 language-conditioned policy/control agent。

他們提出 Physical Agency orchestrator，名為 Pigey。Pigey 可以控制既有 vision-language-action policies 與 parameterized skills，不額外蒐集資料或 post-training，就嘗試解決需要推理的真實世界任務。摘要宣稱，在 LIBERO-PRO 上，Pigey 將成功率從 12.8% 提升到 53.3%；在真實機器人 reasoning-limited tasks 上，也把 frozen policy 從接近零提升到超過 90%。

這些數字我只把它們視為作者摘要中的 claim；本次沒有閱讀實驗章節，所以不評估 benchmark 設計、統計穩健性或失敗案例分布是否支持這些幅度。

## Introduction 的問題設定

Introduction 用一個家用機器人例子開場：「小孩要來，把玩具放到盤子上，把危險物品放到盒子裡。」這個任務表面上像 pick-and-place，但其實要求機器人分辨 toy / hazard、找出被遮住的物品、處理抓取失敗、判斷桌面是否真的安全。作者藉此說明：general-purpose manipulation 是 full stack 問題，不只是 motion 問題。

作者接著對主流 data scaling 路線做出保守批評：VLA policies 從大型示範資料中學到更好的 visuomotor skills，這當然必要，因為接觸、抓取、embodiment-specific control 需要互動資料。但有些 task-level 能力，例如 negation、progress tracking、recovery、world knowledge，不一定能用「再多一批示範」最直接地補起來。

在 prior work 的鋪陳中，作者把現有方法分成幾類：VLA scaling 強化 control 和 grounding，但直接 prompting 仍要求單一 network 在一次 forward pass 中完成 perception / reasoning / planning / verification / recovery / acting；code-as-policies 與 task planners 增加結構，但常依賴 symbolic APIs、hand-built primitives、privileged simulator state 或 code-level action space；reasoning-VLAs 把更多 deliberation 放進 policy，但需要額外訓練，也不一定解決 success detection 與 recovery。

Pigey 的核心設計是 inference-time loop：frontier VLM 產生短的 concrete subgoal，選擇 frozen backend 執行，從新的 observation 驗證結果，失敗則重新規劃或恢復。Introduction 強調 low-level backend 只收到短可執行 subgoal，而不是完整抽象任務。這使作者可以比較同一 frozen skill 在 direct prompting 與 orchestrated loop 下的差異，並把差異命名為 orchestration gap。

## 研究的第一性問題

- **基本問題**：如果機器人已經有可用的低階技能，還缺什麼才能完成具備常識、條件、順序與恢復需求的任務？
- **約束**：不能假設無限收集新 robot data；不能假設每個任務都有手工 symbolic API；高階推理必須回到真實觀察中被驗證。
- **既有方法卡點**：端到端 VLA 容易把「會動」與「會判斷任務狀態」混在一起；直接提示 frozen policy 時，抽象語意、否定條件、隱藏物與失敗恢復可能沒有穩定落地。
- **作者試圖移動的邊界**：把泛化的一部分從 training-time policy scaling 移到 inference-time orchestration，讓 VLM/LLM 負責可檢查的 task-level control loop，而不是直接控制每個 motor decision。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出「orchestration gap」作為衡量同一 frozen skill 在直接提示與 agentic loop 中能力差距的概念。
- 提出 Pigey：閉環 inference-time orchestrator，負責 planning、skill selection、verification、recovery。
- 宣稱不額外蒐集資料或 post-training，就能讓既有 VLA / parameterized skills 在 LIBERO-PRO 與真實機器人任務上有明顯提升。
- 宣稱增益集中在 reasoning-limited tasks，而不是已經簡單的 pick-and-place。

### 我的保守判讀

這篇的有趣之處在於「把端到端模型沒有穩定學到的 task management 外接出來」。如果成立，它提醒我們：Physical AI 的可用性可能不只取決於 foundation model 本身，也取決於上層 orchestrator 是否能把抽象任務變成短、可驗證、可恢復的動作序列。

但 Introduction 也讓我保留幾個疑問：orchestrator 使用 frontier VLM 時，系統能力有多少來自 VLM 的常識與視覺理解？失敗恢復規則有多少是 prompt / tool schema / backend routing 的工程設計？在更開放、更低可觀測性的場景中，verification 是否仍然可靠？這些需要讀方法與實驗細節後才能判斷。

## 可放進資料庫的筆記

- **Orchestration gap**：同一組 frozen skills 在 direct prompting 與 closed-loop orchestration 中的表現差距，可作為 robot agent 架構是否有效的診斷概念。
- **不要把泛化全歸因於資料量**：某些失敗是 task-level reasoning / progress tracking / recovery 的失敗，不一定是 motor skill 不夠。
- **短 subgoal 比抽象任務更適合交給 motor policy**：高階系統負責拆解，低階技能只負責可執行片段。
- **驗證是 agentic robotics 的核心元件**：如果不能從 observation 判斷是否完成，planning 和 recovery 都會變成假閉環。
- **VLM 作為 manager，而非直接控制器**：VLM 的角色可以是選技能、檢查狀態、重新規劃，而不是輸出連續控制。
- **Reasoning-limited vs motor-bound failure**：評估機器人時應區分是動作能力不足，還是任務理解、常識、順序、否定、恢復不足。
- **Inference-time 系統設計也是 scaling 路線**：不改權重也可能透過流程設計釋放既有模型與技能的潛力。

## 後續想追的問題

- Pigey 的 verification 具體如何實作？是純 VLM 判斷、規則檢查，還是混合工具？
- LIBERO-PRO 的任務設計是否真的隔離 reasoning-limited failure，而不是剛好適合 orchestrator？
- 真實機器人任務中，失敗恢復案例有多少依賴 prompt engineering 或人工設計的 backend routing？
- 若低階 VLA 本身更強，orchestration gap 會縮小、放大，還是轉移到更高階任務？
- 這種架構能否套到多機器人、長時間家務、或工業流程中需要狀態記憶與安全約束的任務？
