# Towards Surgical World-Action Modeling: A Preliminary Joint Visual-Trajectory Forecasting for Surgical Motion Planning

## 原文資訊

- 論文：Towards Surgical World-Action Modeling: A Preliminary Joint Visual-Trajectory Forecasting for Surgical Motion Planning
- 作者：Weiliang Huang、Huanrong Liu、Bob Zhang、Qi Dou、Zhen Chen、Yun Gu、Guy Rosman、Qingbiao Li
- arXiv ID：2608.20284v1
- 分類：cs.CV、cs.RO
- 發表 / 更新：2026-08-20 / 2026-08-20（v1）
- 連結：[abs](https://arxiv.org/abs/2608.20284v1) / [pdf](https://arxiv.org/pdf/2608.20284v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Method、Experiments、Conclusion 與附錄
- 擷取日期：2026-08-24

## 為什麼選這篇

手術機器人的預測不能只問「器械接下來會到哪裡」，也不能只問「下一段影像看起來像不像真的」。器械—組織互動會同時改變軌跡、組織形變、遮擋與鏡頭可視性；幾何上接近示範的軌跡，仍可能導向不合理甚至不安全的視覺狀態。這篇因此嘗試把未來 visual state 與器械 trajectory 放進同一個 world-action forecasting 問題。

它是一篇明確標示為 preliminary 的工作，範圍和證據需要保守看待，但問題設定有獨立價值：Physical AI 的 world model 若只追求影像逼真，可能沒有量到控制真正關心的動作誤差；只預測軌跡，又可能漏掉環境被動作改變的後果。手術場景把這個評估缺口放大得很清楚。

## 一句話理解

這篇建立一個初步的手術 world-action baseline，從歷史內視鏡影像與器械軌跡共同預測未來視覺表示及二維器械軌跡，讓世界演化與動作幾何可以一起建模與評估。

## Summary / Abstract 說了什麼

摘要指出，既有工作通常把未來場景生成和器械軌跡預測分成兩項任務。scene-only 模型缺乏直接的軌跡層級檢查；trajectory-only 模型則沒有描述器械運動造成的視覺後果，也未檢查軌跡和場景演化是否一致。

作者提出初步的 joint visual-trajectory world-action model：將歷史影像與工具軌跡編碼為 latent representations，經 temporal-spatial encoder 後，分別由 visual-state head 與 trajectory head 預測。模型以 chunked autoregressive rollout，每次預測三步、重複五次，形成十五步未來。

摘要自稱 chunked rollout 在所有評估 horizon 優於一次直接預測，並列出第一段 PSNR 從 18.86 提高到 23.11 dB、ADE 從 45.77 降到 22.22 pixels；同時承認較長 horizon 仍有視覺退化與軌跡誤差累積。本筆記未讀實驗章節，無法判斷資料切分、baseline 公平性、變異程度與臨床意義，只將它們視為摘要中的初步結果。

其中，PSNR（峰值訊噪比）是像素重建品質指標，通常越高代表影像誤差越小；ADE（average displacement error）可簡寫為

$$
\mathrm{ADE}=\frac{1}{T}\sum_{t=1}^{T}\lVert \hat{p}_t-p_t\rVert_2,
$$

其中 $T$ 是預測步數，$\hat{p}_t$ 是預測器械位置，$p_t$ 是真實位置；ADE 越低，表示平均軌跡位置偏差越小。兩者分別量影像與軌跡，但都不直接等同於手術安全。

## Introduction 的問題設定

Introduction 從器械—組織互動出發：組織形變、遮擋、出血和視野變化，使「軌跡幾何接近」不足以保證未來狀態合理。反過來，影像看似連貫也可能藏有器械端點偏移、局部運動錯誤或自回歸漂移。

作者將既有評估缺口拆成兩邊。手術 trajectory prediction 常預測二維座標、機器人狀態或動作命令，卻不表達視覺後果；future video generation 則常用 FVD、PSNR、SSIM 等生成品質指標，未必證明器械運動在幾何上準確。這使模型難以支援 closed-loop planning 所需的 action-scene consistency。

論文因此提出 world-action formulation：future visual representation 表達手術場景如何變化，instrument trajectory 則提供明確的工具運動表示。作者在 Introduction 中自稱此 baseline 用共同歷史資訊同時預測兩者，並以 scheduled sampling 部分降低訓練時看真值、推論時看自身預測的落差；評估使用 SurgWMBench 的內視鏡影片與二維器械軌跡。

## 研究的第一性問題

- **基本問題**：一個供規劃使用的世界模型，最少要同時預測哪些狀態，才能描述「動作如何改變世界」而不只生成合理畫面？
- **約束**：手術場景有形變、遮擋與非剛性互動；長 horizon 自回歸會累積誤差；二維軌跡只是完整器械狀態的部分投影；安全要求高於一般影片品質。
- **既有方法卡點**：影像指標與軌跡指標各自只看一面，scene-only 與 trajectory-only 模型都缺少兩者一致性的直接表示。
- **作者試圖移動的邊界**：把未來視覺 latent 和器械軌跡當成共同預測目標，建立可同時量測世界演化與動作幾何的初步基線。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出同時預測未來 visual latent representations 與二維手術器械軌跡的 joint predictive model。
- 以每段三步、共十五步的 chunked autoregressive strategy 支援較長 horizon。
- 使用 scheduled sampling 部分處理 train–inference discrepancy。
- 在 SurgWMBench 做初步評估，摘要宣稱 joint visual-motion forecasting 可行，同時揭示長時程視覺與軌跡穩定性問題。

### 我的保守判讀

- 問題設定比模型複雜度更重要：它迫使 world model 評估同時面對「看起來合理」與「動作位置正確」兩項要求。
- 兩個 head 共享 encoder 不自動保證跨輸出一致；若沒有顯式 consistency objective，仍可能各自預測得不錯卻彼此矛盾。需讀方法才能確認。
- 二維器械軌跡容易量測，但無法完整描述深度、姿態、力、組織接觸與傷害風險，因此距離手術規劃仍有明顯表示缺口。
- PSNR 與 ADE 的改善不能直接換算成臨床安全；還需要任務成功、碰撞、組織損傷、不確定性校準與最壞情況等指標。
- 論文主動稱為 preliminary，且 Introduction 描述的是單一 benchmark 上的 baseline；不宜把結果外推為可部署的 surgical world model。
- chunked autoregression 仍使用自身預測回饋，長 horizon 漂移只是被延後或減輕，不代表已解決。

## 可放進資料庫的筆記

1. **世界模型要預測控制相關變數**：視覺逼真若無法對應器械幾何或接觸後果，對規劃的資訊價值有限。
2. **多輸出不等於跨模態一致**：共同 encoder、雙 head 與 consistency constraint 是不同層次，評估也要檢查兩個預測是否相容。
3. **生成指標與安全指標不可混用**：PSNR、SSIM、FVD 量視覺相似性，不直接量碰撞、組織損傷或規劃可行性。
4. **顯式軌跡讓錯誤更可診斷**：相較只看影片，座標序列可定位 endpoint deviation、局部漂移與 horizon-dependent error。
5. **自回歸長時程的核心是分布漂移**：模型推論時會看到自己造成的狀態；scheduled sampling 是處理 exposure bias 的一種方式，不是完整保證。
6. **表示的可量測性與充分性要分開**：二維軌跡便於標註和比較，但未必足以代表真正的手術狀態。
7. **preliminary baseline 的價值可在定義接口**：即使性能證據尚薄，也可能先把未來 benchmark 應共同量哪些輸出講清楚。

## 後續想追的問題

1. 兩個 prediction heads 之間是否有顯式 action-scene consistency loss，還是只共享 encoder？
2. SurgWMBench 的資料切分是否跨病人、手術類型與器械，十五步對應的實際時間長度是多少？
3. chunk size、scheduled sampling 與 joint training 各自帶來多少增益；是否和 one-shot baseline 使用相同容量與訓練預算？
4. 視覺 latent 如何解碼與評估，PSNR 的改善是否伴隨對控制真正有用的局部結構改善？
5. 如何把深度、姿態、接觸力、不確定性和安全 constraint 納入下一版 world-action representation？
