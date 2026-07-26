# FORGE-plus: Force-Budgeted Recovery for Contact-Rich Assembly with a Frozen LLM Supervisor

## 原文資訊
- 論文：FORGE-plus: Force-Budgeted Recovery for Contact-Rich Assembly with a Frozen LLM Supervisor
- 作者：Kyupaeck Jeff Rah；Midum Oh
- arXiv ID：2607.21227v1
- 分類：Robotics (cs.RO)
- 發表 / 更新：2026-07-23 / 2026-07-23
- 連結：[abs](https://arxiv.org/abs/2607.21227) / [pdf](https://arxiv.org/pdf/2607.21227)
- 本次閱讀範圍：Summary/Abstract + Introduction
- 擷取日期：2026-07-26

## 為什麼選這篇

這篇很切中「LLM + Robotics」交會，但它不是把 LLM 包裝成萬能控制器，而是把 LLM 放在一個受限、可檢查的位置：事前根據物件文字描述設定 force ceiling，失敗後根據簡化的力覺 / 接觸 signature 從固定 recovery menu 裡挑一個動作。這比「讓 LLM 直接控制機器人」保守很多，也更像可以落地的系統分工。

它值得放進資料庫的原因，是它把語言模型的角色縮小成「語意層 supervisor」，而把安全約束留給低階控制迴路。對 contact-rich assembly 這類物理接觸問題來說，真正危險的不是規劃錯一句話，而是力控制超過零件承受範圍。論文的 Introduction 很明確地把問題放在「誰設定力上限」與「失敗時如何恢復但不加大力道」這兩個工程缺口。

我也把它視為近期 robot foundation / VLA 熱潮的一個反向提醒：不是所有機器人智慧都要端到端；有些關鍵能力可能是把 LLM 放在慢速語意決策層，讓 fast control loop 負責硬約束。這種分層思想對工業場景、維修、裝配與安全認證都更有參考價值。

## 一句話理解

這篇研究想問：在接觸式裝配裡，能不能讓凍結的文字 LLM 幫忙設定「不要弄壞物件」的力上限與失敗恢復策略，同時把真正的力安全交給低階控制器硬性執行？

## Summary / Abstract 說了什麼

摘要說，force-conditioned reinforcement learning 可以在給定 force ceiling 的情況下做 tight-clearance assembly，但部署時仍有兩個現實問題：每個物件適合的力上限不同，而且插入失敗後要能恢復，不能只是繼續加力。

作者提出兩層框架。上層是一個 frozen、text-only LLM：在執行前根據物件指定每個物件的 force ceiling；失敗時則讀取壓縮過的 textual force signatures，從固定 action menu 裡選 recovery maneuver。下層 controller 會強制執行 force ceiling，recovery policy 也不能提高這個上限。摘要中特別強調，hidden breaking-force threshold 只有 evaluator 知道，LLM 不會直接控制力，這是避免評估變成「模型偷看答案」的重要設計。

摘要的重點不是 LLM 變成機器人控制器，而是 LLM 被限制在兩個語意判斷點：物件脆弱程度的先驗估計，以及接觸失敗類型的策略選擇。真正的安全仍由控制器與約束決定。

## Introduction 的問題設定

Introduction 先把背景接到 FORGE / IndustReal / AutoMate 這一類接觸式裝配系統：force-conditioned policy 已能在模擬中處理 insertion，並且可以在速度與溫和程度之間取捨。可是它留下兩個未解問題。

第一個問題是「誰設定 force ceiling？」如果系統只為成功率自動調高力道，在鋼製螺栓上可能合理，但遇到尼龍卡扣就可能把零件弄壞。也就是說，力上限不是單一任務參數，而是 per-object safety budget。這個 budget 很自然地需要來自「這是什麼物件」的語意資訊。

第二個問題是「失敗後怎麼恢復？」Introduction 指出，有些失敗類型在影像上看起來差不多，但在 force trace 裡差異明顯；例如卡住、錯牙、毛邊等問題，視覺不一定能分辨，力覺訊號反而更直接。若 recovery 的直覺做法是「壓更大力」，在脆弱物件上就正好是破壞性動作。

作者因此提出 FORGE-plus：凍結 LLM 讀物件 identity 設定 $F_{max}$，失敗後讀 compact force/contact signature 選 fixed recovery menu；而且 fast control loop 會硬性 clamp 力道。可以用一個簡化式理解：

$$F_{cmd}(t) = \min(F_{policy}(t), F_{max})$$

白話說，策略想施多少力不重要，真正送到機器人的命令力不能超過事前設定的上限。這個設計讓 LLM 的語意判斷不會直接變成未受控的物理輸出。

## 研究的第一性問題

- **基本問題**：接觸式裝配需要足夠力道完成插入，但不同物件的破壞門檻不同；系統如何在不知道真實 breaking force 的情況下，安全地設定與遵守力預算？
- **約束**：LLM 不能直接控制力；hidden breaking force 不能被模型看到；recovery 不能提高 force ceiling；低階控制要能即時硬性限制物理輸出。
- **既有方法卡點**：只以成功率調參可能偏向加大力道；視覺式 failure reasoner 可能看不出接觸錯誤；端到端策略若缺少硬約束，安全性很難說清楚。
- **作者試圖移動的邊界**：把 LLM 從「控制器」改成「受限語意 supervisor」，用語言先驗與力覺摘要補上 per-object safety budget 與 recovery 選擇。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出一個兩層框架：凍結文字 LLM 負責 force ceiling 與 recovery menu selection，低階 controller 負責執行與安全限制。
- 強調 LLM 不直接控制力，且 hidden breaking-force threshold 不被 learned / LLM component 觀察，降低評估循環性。
- 把接觸失敗的關鍵資訊從影像轉向 compact force/contact signature，讓 recovery 更貼近物理互動本身。

### 我的保守判讀

- 這篇的價值可能在「系統邊界設計」多於模型能力本身：它示範了如何把 LLM 接進機器人控制堆疊，但不讓 LLM 成為安全瓶頸。
- 若物件描述很粗略、材料未知、或真實破壞模式複雜，LLM 設定的 $F_{max}$ 可能仍不可靠；真正可部署還需要校準、保守係數與失敗監測。
- fixed recovery menu 讓問題可控，但也限制泛化；如果 failure mode 超出 menu，LLM 的選擇能力未必有意義。
- 本次沒有讀 experiments / results，因此不能判斷它在硬體、模擬或不同材料上的實際成功率與安全裕度。

## 可放進資料庫的筆記

1. **LLM 作 supervisor，不作 actuator**：讓 LLM 做慢速語意決策，物理輸出交給有硬約束的控制層。
2. **安全不是 prompt 出來的，是 clamp 出來的**：對機器人而言，安全性要落在控制迴路與不可越界的變數上。
3. **force trace 是另一種語言**：接觸式任務的失敗類型，有時更適合用力覺 signature 而不是影像描述來表徵。
4. **per-object budget 比 global policy 更重要**：同一個動作在不同材料 / 物件上可能安全性完全不同。
5. **固定 action menu 是一種工程化降維**：限制 LLM 可選行動，犧牲自由度換取可分析性。
6. **評估要避免語意模型偷看物理答案**：hidden threshold 不給模型，是這類安全評估的必要邊界。
7. **端到端不是唯一方向**：Physical AI 堆疊中，分層、約束、介面設計仍可能比更大模型更關鍵。

## 後續想追的問題

1. LLM 設定 force ceiling 時，是根據物件名稱、材料描述，還是更結構化的屬性？
2. compact force/contact signature 具體包含哪些特徵？是否足以區分不同 failure mode？
3. 固定 recovery menu 有多大？是否能涵蓋真實裝配中的長尾錯誤？
4. 實驗是否包含真實硬體，還是主要在模擬？sim-to-real 的安全 margin 如何設計？
5. 如果 LLM 設定的 $F_{max}$ 過低導致任務失敗，系統是否有保守調整機制，還是直接放棄？
