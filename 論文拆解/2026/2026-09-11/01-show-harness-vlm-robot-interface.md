# Show-Harness: Just a VLM Agent Can Play Robots

## 原文資訊
- 論文：Show-Harness: Just a VLM Agent Can Play Robots
- 作者：Yanzhe Chen、Zechen Bai、Zhijun Cao、Wenzheng Zeng、Kevin Qinghong Lin、Yiqi Lin、Guoqiang Liang、Kevin Yuchen Ma、Qiming Huang、Mike Zheng Shou
- arXiv ID：2609.10522v1
- 分類：cs.RO、cs.AI、cs.CV、cs.MM
- 發表 / 更新：2026-09-09 / 2026-09-09（v1）
- 連結：[abs](https://arxiv.org/abs/2609.10522v1) / [pdf](https://arxiv.org/pdf/2609.10522v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、方法、實驗、結果與附錄
- 擷取日期：2026-09-11

## 為什麼選這篇

VLM 擅長辨識物體、空間關係與拆解長時序目標，但「知道要做什麼」不等於能輸出特定機器人的連續控制訊號。常見解法一端是把 VLM 微調成直接迴歸動作的 VLA，另一端是讓模型呼叫高層技能或手寫控制 API；前者可能綁定 embodiment，後者則把真正的物理控制交給下游模組。

Show-Harness 值得收錄，因為它把問題重心放在**模型與機器人之間的 action interface**：動作對 VLM 必須有語意、對執行器又必須足夠細。這不是單純再加一個更大的模型，而是在問介面設計能否釋放既有模型的 embodied capability，並讓封閉前沿 VLM、小型開源 VLM 與人類示範共享同一操作語彙。

## 一句話理解

Show-Harness 用離散、可讀的微小語意動作當作 VLM 與不同機器人之間的中介語言，試圖在高層技能呼叫與 embodiment-specific 連續動作之間取得可移植性與控制粒度。

## Summary / Abstract 說了什麼

摘要把 Show-Harness 定義為一個 model-agnostic Embodied Harness。VLM 不直接輸出馬達命令，而是在緊湊的離散 action set 中選擇移動方向或夾爪動作；每個 embodiment 再由確定性的 interpreter 把該單位轉為小幅、有限界的本地機器人動作。可用下列簡化式理解：

$$
u_t \in \mathcal{U}_{\text{semantic}}, \qquad
\Delta \mathbf{x}_t = I_e(\nu_t).
$$

其中 $\nu_t$ 是 VLM 在時間 $t$ 選出的語意動作單位，$\mathcal{U}_{\text{semantic}}$ 是有限的離散動作集合，$I_e$ 是針對 embodiment $e$ 的確定性 interpreter，$\Delta \mathbf{x}_t$ 則是實際執行的小幅動作。這是閱讀用概念式，不是作者完整方法的重建。

系統會整理多視角影像與 proprioception（機器人自身姿態／狀態感測）為模型脈絡，每執行一個 action unit 就回傳 feedback，讓 VLM 在閉環中做細粒度決策、子任務推理與恢復。摘要另稱，同一介面可讓封閉前沿 VLM 零樣本控制機器人，也可用少量 GPU 時數調適約 2B 的開源 VLM。

作者也提出 GUMI（GUI Manipulation Interface），讓人與 agent 透過同一語意動作空間蒐集跨 embodiment 示範，不需要專用 teleoperation hardware。摘要自稱其泛化表現優於若干 agentic 與 VLA paradigms；本次沒有讀實驗，不能核對比較公平性、成功率或樣本量。

## Introduction 的問題設定

Introduction 先把兩類既有路徑放在光譜兩端。VLA 以 continuous action regression 把 VLM 拉向低層控制，但容易把廣泛語意知識壓進不透明、與 embodiment 綁定的 pixel-to-actuation mapping；hierarchical／programmatic 系統則讓 VLM 產生 subtask 或控制程式，實際物理執行多由下游 controller 或系統特定機制處理，語意意圖與每一步物理決策的連結較弱。

作者提出中間層的設計條件：action space 一方面要是 VLM 可自然推理的語意單位，另一方面又要細到每個決策都能落進物理世界。Show-Harness 因而把單一步進方向或夾爪操作做成離散單位，再由 embodiment interpreter 做有界 grounding；VLM 保留逐步選擇責任，但不用學每台機器人的原始控制座標。

Introduction 的貢獻清單還包括兩種使用模式與 GUMI：前沿閉源模型可不微調直接接入，小型模型可在相同空間微調；人與模型也可用相同介面收集示範。這些是作者在前言中的設計與成效宣稱，不等於本次已檢查其實作、實驗或開源狀態。

## 研究的第一性問題

- **基本問題**：如何把 foundation VLM 的語意與空間能力轉成細粒度機器人行動，而不必為每個 embodiment 重新學一套完全不同的低層映射？
- **約束**：介面既要能被通用 VLM 表達，也要能閉環、可執行、動作幅度有界，並涵蓋多視角觀測、proprioception 與錯誤恢復。
- **既有方法卡點**：直接連續動作回歸可能犧牲跨 embodiment 可移植性；只輸出高層技能則可能把關鍵物理決策藏在 downstream controller。
- **作者試圖移動的邊界**：把「模型能力不足」改寫成部分是「action interface 不適配」，以共享語意微動作連接不同模型、人與不同機器人。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出 model-agnostic Show-Harness，以離散語意 action units 讓 VLM 直接逐步操作機器人。
- 透過 embodiment-specific deterministic interpreter，把共享語意單位轉為有界的本地動作。
- 支援封閉前沿 VLM 的 zero-shot control，也能以數個 GPU-hours 調適小型開源 VLM。
- 在任務、embodiment 與環境間展現泛化，並優於作者選取的 agentic 與 VLA comparisons。
- 提出 GUMI，讓人與 agent 在同一 action space 中跨機器人蒐集示範。

### 我的保守判讀

- 這篇最有價值的假說是：**能力瓶頸不只在模型，也在介面**。若成立，介面標準化可能比為每台機器人重做 policy 更有槓桿。
- 所謂「VLM directly responsible」仍是相對說法。VLM 決定語意微動作，但 interpreter、低層控制、安全限制、感測整理與執行回饋仍共同決定物理結果。
- 離散微動作提升可解釋性與跨 embodiment 映射可能性，也可能增加 horizon、模型呼叫次數、延遲與誤差累積；Introduction 尚不足以判斷這些代價。
- 確定性 interpreter 是否真的輕量，取決於它要處理多少運動學、碰撞、接觸與控制穩定性。若大量 intelligence 被移入 interpreter，跨 embodiment 優勢就需重新核算。
- 前沿閉源 VLM 的更新可能帶來 capability gains，也帶來版本漂移、API latency、成本、資料治理與不可重現性。
- 摘要中的 outperform、robust generalization 與 low-cost 都需看任務難度、baseline budget、試驗數、失敗分類與實機安全資料；本次不能驗證。

## 可放進資料庫的筆記

1. **介面是能力乘數，不只是 plumbing。** 同一模型換 action representation，可能產生完全不同的可用能力與失敗型態。
2. **語意粒度是一個控制旋鈕。** 太粗會把物理決策藏進技能；太細則拉長 horizon、增加延遲與累積誤差。
3. **共享語彙不等於共享動力學。** 跨 embodiment 可共用 intent，但 grounding、可達性、接觸與安全界線仍需個別處理。
4. **「直接控制」要拆責任鏈。** 至少區分模型選擇、interpreter grounding、low-level control、安全 supervisor 與硬體執行。
5. **可讀 action space 也可成為資料格式。** 人、agent 與不同機器人若共享語意標記，示範資料可能更容易重用與稽核。
6. **模型升級與機器人升級可以解耦。** 若 harness 穩定，前沿 VLM 的能力提升可能直接傳導到機器人；但供應商漂移也會沿同一路徑傳入。
7. **閉環 feedback 是 embodied agent 的必要條件。** 單次長計畫難吸收接觸、偏差與未預期狀態；細步回饋提供恢復機會。
8. **評估介面要算全系統成本。** 除成功率外，還要看步數、推論延遲、API 成本、interpreter 複雜度、安全介入與跨機器人移植工時。

## 後續想追的問題

1. 語意 action set 的大小、座標系與步幅如何定義；哪些任務會因離散化而不可達或效率太低？
2. Interpreter 實際承擔多少 IK、collision avoidance、force control 與 safety filtering？
3. Zero-shot frontier VLM 與 fine-tuned 2B VLM 的觀測、提示、推論延遲與比較預算是否一致？
4. 長時序任務中的 action count、錯誤累積、recovery rate 與 API failure 如何統計？
5. GUMI 收集的跨 embodiment 示範，哪些欄位可以直接共享，哪些仍需重新 retarget 或人工校正？
