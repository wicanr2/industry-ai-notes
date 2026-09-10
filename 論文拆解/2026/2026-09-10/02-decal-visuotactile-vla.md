# DeCAL: Towards Physically-Grounded Dexterous Vision-Language-Action Models via Contact-Aware Latent Co-Imagination

## 原文資訊
- 論文：DeCAL: Towards Physically-Grounded Dexterous Vision-Language-Action Models via Contact-Aware Latent Co-Imagination
- 作者：Yankai Fu、Ning Chen、Junkai Zhao、Heng Zhang、Guocai Yao、Pengwei Wang、Zhongyuan Wang、Shanghang Zhang
- arXiv ID：2609.09119v1
- 分類：cs.RO、cs.AI
- 發表 / 更新：2026-09-08 / 2026-09-08（v1）
- 連結：[abs](https://arxiv.org/abs/2609.09119v1) / [pdf](https://arxiv.org/pdf/2609.09119v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、系統與方法細節、實驗、結果、限制章與附錄
- 擷取日期：2026-09-10

## 為什麼選這篇

視覺對接觸豐富的靈巧操作有結構性盲點：手指與物體互相遮擋時，影像未必能告訴政策接觸是否建立、力量如何變化、是否滑動或物體是否變形。觸覺不是再加一組 token 就自然有用；它只在特定接觸階段特別關鍵，而且其時間變化本身就是物理互動的訊號。

DeCAL 把這個問題放進 VLA：以理解、想像與動作三種專門 expert 分工，再用 contact-aware gating 決定何時注入觸覺，並聯合預測未來視覺與觸覺 latent。它與今日的 TANGO 有獨立價值：TANGO 處理全身導航的時變幾何，DeCAL 處理近接觸操作的部分可觀測性與多感官動態。

## 一句話理解

靈巧操作若只「看」世界，很容易在真正接觸時失明；DeCAL 嘗試讓 VLA 依接觸狀態選擇性地使用觸覺，並預想視覺與觸覺接下來如何共同變化。

## Summary / Abstract 說了什麼

摘要把現有 tactile manipulation 的不足概括為兩點：多模態常以同質方式融合，沒有依接觸狀態調整觸覺影響；政策多為 reactive，沒有顯式建模未來接觸轉移。

DeCAL 使用 Mixture-of-Transformers（MoT）架構，讓 understanding、imagination 與 action generation 各有專門 expert，並透過共享資訊協作。Adaptive Visuo-Tactile Fusion 以 contact-aware gate 動態調節觸覺；Visuo-Tactile Latent Co-Imagination 則聯合建模未來視覺與觸覺動態。

可用概念式表達 gating：

$$
\tilde{\mathbf{h}}_t
= \mathbf{h}^{VL}_t + g_t\,\mathbf{h}^{T}_t,
\qquad 0 \le g_t \le 1.
$$

$\mathbf{h}^{VL}_t$ 是視覺—語言表徵，$\mathbf{h}^{T}_t$ 是觸覺表徵，$g_t$ 是隨接觸狀態改變的權重。這不是 Introduction 給出的正式公式，而是對「不是每一刻都同等依賴觸覺」的簡化理解。

摘要自稱平均 task success rate 為 71%、progress success rate 為 83.4%，且對未見情境有泛化；Introduction 另稱比最強 baseline 高逾 15 個百分點、每個 action chunk 平均 inference latency 為 0.27 秒。這些皆是作者對後文實驗的摘要，本次沒有讀實驗設計，因此不把數字當成已獨立驗證的效果。

## Introduction 的問題設定

Introduction 先從 dexterous manipulation 的條件出發：多指手操作包含細緻、接觸密集的互動，視覺會受到自遮擋，且難單獨觀察 contact state、force variation、slip 與 deformation。觸覺能補上物理互動訊號，但既有做法常把它視為輔助輸入，以固定或同質融合方式加入。

作者認為另一個缺口是 future interaction modeling。接觸不是靜態分類，而是隨動作演化的轉移；若政策只對當下訊號反應，可能難以處理即將滑落、力逐步累積或接觸點改變。DeCAL 因而把三種能力拆給 collaborative experts：理解當下多模態狀態、想像未來視觸 latent、生成動作，並用 joint attention 做方向性的知識共享。

Introduction 列出的三項貢獻是：統一 understanding、generation 與 action 的 dexterous Vision-Tactile-Language-Action framework；提出 adaptive fusion 與 latent co-imagination；以及以多項真實世界實驗展示效果與泛化。由於本次未讀方法與實驗章，尚不能判斷 gate 是否真的對應接觸、latent prediction 是否提供因果有用的物理知識，或提升主要來自模型容量與感測器配置。

## 研究的第一性問題

- **基本問題**：當視覺在接觸時被遮擋或變得含糊，機器人如何取得足夠狀態，並預測下一個接觸轉移以生成穩定動作？
- **約束**：視覺與觸覺的資訊密度、頻率與噪聲不同；觸覺只在接觸建立後出現；多指操作具有高維動作與複雜動力學。
- **既有方法卡點**：固定融合可能在無接觸時注入噪聲，也可能在關鍵接觸時低估觸覺；純 reactive policy 難表示互動如何演化。
- **作者試圖移動的邊界**：從 vision-centric、同質融合的 VLA，移到依接觸狀態調度觸覺，且用未來視觸 latent 輔助動作的世界模型式政策。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出統一理解、想像與動作生成的 dexterous Vision-Tactile-Language-Action framework。
- 以 MoT 為不同能力配置專門 expert，並允許跨 expert 資訊流動。
- 用 contact-aware gating 動態控制 tactile interaction，而非固定融合。
- 聯合想像未來 visual 與 tactile latent，以隱式學習物理互動知識。
- 在多種真實世界接觸任務上報告領先結果、泛化與即時推論能力。

### 我的保守判讀

- 這篇最有價值的假設是 **感官權重應由互動狀態決定**。視覺與觸覺不是永遠等價，而是在接近、接觸、施力與滑動等階段輪流成為主要證據。
- Latent co-imagination 是否真的代表物理世界知識，需要看未來預測目標、時間範圍、反事實能力與消融。準確預測 training distribution 的 latent，不必然等於能支援控制。
- MoT 的專門化可能改善干擾，也可能只是增加參數與訓練自由度；公平比較需控制 backbone、資料、sensor access 與推論成本。
- 觸覺硬體是能力的一部分，也是部署限制。感測器校準、磨耗、跨手指差異與跨硬體 transfer 都可能影響外部效度。
- 摘要中的成功率與延遲缺乏本次閱讀所需的 denominator、trial 數、方差與 action-chunk 定義；不能直接與其他平台數字橫比。
- 論文另有獨立 Limitations 章，但依本任務閱讀邊界未讀，因此這裡只列從摘要與 Introduction 可推得的限制，不能代表作者完整自我限制。

## 可放進資料庫的筆記

1. **多模態融合應先問「何時需要」，再問「如何融合」。** 固定權重容易忽略感官的條件性價值。
2. **觸覺是事件驅動的資訊。** 無接觸時可能近乎空白；接觸後則能成為判斷力、滑動與形變的主要證據。
3. **部分可觀測性會隨任務階段改變。** 接近物體時視覺較強，遮擋與施力後觸覺的重要性上升。
4. **世界模型可建模跨感官未來。** 對操作而言，要想像的不只是下一張影像，也包括下一個接觸狀態。
5. **預測 latent 的價值要由控制反事實檢驗。** 若改變動作，模型是否能預測不同接觸後果，比單一路徑重建更關鍵。
6. **專門 expert 是能力分工假說。** 理解、想像與控制的表徵需求可能不同，但介面與資訊流才決定分工是否成立。
7. **感測器配置屬於模型假設。** 跨平台評估不能只比較 policy，也要比較可觀測訊號與校準成本。
8. **進度指標補足二元成功率，但需明確定義。** 83.4% progress success 的意義取決於階段切分與部分完成規則。

## 後續想追的問題

1. Contact-aware gate 的監督訊號從何而來；它是否學到真實接觸階段，還是只與動作時間相關？
2. Visual、raw tactile image、force 與 deformation map 各自貢獻多少；感測器故障時能否退化運作？
3. Co-imagination 預測多遠的未來、使用何種 latent target，對 action generation 的因果貢獻如何驗證？
4. Baseline 是否享有相同的多視角影像、觸覺訊號、資料量、backbone 與參數預算？
5. 未見情境包含新物體、新材質、新任務還是新接觸動態；跨硬體與跨觸覺感測器能否轉移？
