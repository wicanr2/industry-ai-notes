# Do Robotic World Models Really Follow Actions? Diagnosing and Aligning Action-Conditioned Generation for Policy Learning

## 原文資訊

- 論文：Do Robotic World Models Really Follow Actions? Diagnosing and Aligning Action-Conditioned Generation for Policy Learning
- 作者：Sixiang Chen、Jiaming Liu、Jixian Wu、Yichen Guo、Tinghao Wang、Siyuan Qian、Hao Chen、Jiajun Cao、Jian Tang、Shanghang Zhang
- arXiv ID：2608.24885v1
- 分類：cs.RO、cs.CV
- 發表 / 更新：2026-08-25 / 2026-08-25（v1）
- 連結：[abs](https://arxiv.org/abs/2608.24885v1) / [pdf](https://arxiv.org/pdf/2608.24885v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML 取得成功）；未讀 Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-27

## 為什麼選這篇

機器人 world model 的吸引力，在於用生成的未來取代部分昂貴的真機互動；但只要它被拿來評估或改善 policy，就不能只問影片看起來是否合理，還要問生成結果是否真的服從輸入動作。這篇把一個容易被畫質遮蔽的系統問題直接拉到檯面：模型可能生成很像「成功示範」的未來，卻沒有忠實模擬 policy 實際下達的動作。

它與近期 VLA／world-action model 筆記的差異，在於研究焦點不是再提高一般生成品質，而是檢驗反事實與 off-expert 動作下的可控制性。這是 world model 能否成為 policy-facing simulator 的前置資格，也能連到更一般的生成式 AI 評估問題：輸出合理，不等於輸出忠實回應條件。

## 一句話理解

如果機器人 world model 只會生成「看起來像專家會做的事」，而不會忠實反映任意可行動作的後果，它就還不是可放心拿來訓練 policy 的模擬器。

## Summary / Abstract 說了什麼

論文把 action-conditioned world model（AC-WM）視為一個條件生成器：給定目前觀察、任務指令與一段機器人動作，生成未來的視覺觀察。概念上可寫成：

$$
\hat I_{1:H} \sim p_\theta(I_{1:H}\mid o_0,c,a_{1:H}),
$$

其中 $o_0$ 是目前觀察、$c$ 是語言指令、$a_{1:H}$ 是未來 $H$ 步動作，$\hat I_{1:H}$ 是模型生成的未來影像。真正要檢驗的不是 $\hat I$ 是否單獨看起來逼真，而是它是否隨 $a_{1:H}$ 改變而產生正確、可辨識的後果。

作者提出 **WorldEcho**，將測試範圍從示範內動作擴展到更廣的 off-expert 動作分布，同時看兩類訊號：視覺完整性，以及生成影片中的末端執行器軌跡是否與對應真值在 $SE(3)$ 對齊。$SE(3)$ 是三維剛體位姿的空間，可把末端執行器的三維平移與旋轉一起表示；因此這裡不只是比較像素，而是比較「手實際被生成到哪裡、姿態是否相符」。

摘要自稱，現有模型對專家動作尚可，但面對多樣 off-expert 軌跡時，可能忽略動作條件，或生成視覺上已失效的 rollout。作者再提出 **WorldSync**，從三個方向改善：擴大動作後果的資料覆蓋、讓中間表示更貼近動作引起的機器人動態，以及用介入式配對監督對齊「改變動作後，預測結果應如何改變」。摘要也宣稱它改善 WorldEcho 指標，並提升迭代式 policy improvement 的可靠性與成功率；這些結果本次沒有讀實驗章節，不能獨立確認。

## Introduction 的問題設定

Introduction 先建立一條因果鏈：VLA 與 WAM 經大規模預訓練後仍常需特定任務的線上 post-training；真實環境互動昂貴，因此 AC-WM 被用作 learned simulator，供 policy 評估與產生合成經驗。這條路徑暗含一個關鍵假設：world model 不只會生成合理未來，也能對任意有效動作給出準確反應。

作者認為既有評估多集中於感知／語意品質、與參考行為的相似度或下游可執行性，較少對廣泛的連續數值動作逐一建立 action-specific ground truth。這在 policy improvement 特別危險，因為 policy 的探索、失敗與更新自然會離開專家示範所覆蓋的 state-action distribution。

WorldEcho 因而安排五種 action query：示範動作作為 in-distribution 基準，再加上 Cross-State Replay、Local Perturbation、Policy Rollout、Feasible-Space Sampling 四種逐漸遠離專家先驗的查詢。Introduction 自稱診斷出兩種失敗：一是畫面仍合理、但生成的未來過度樂觀且未遵循指定動作；二是機器手臂扭曲、夾爪消失等視覺完整性崩壞。

接著 WorldSync 對應三個可能根因：用更廣的資料覆蓋動作後果；用 Action-Forcing Expert 讓中間視覺表示可解碼出未來機器人狀態；再用同一觀察、不同動作的 paired trajectories，約束模型預測的差異應貼近真實未來的差異。這使問題不只是「單次 rollout 對不對」，而是「對動作做介入時，模型是否產生方向正確的變化」。

## 研究的第一性問題

### 基本問題

模擬器的最低條件是反映控制輸入的後果。若改變動作而生成結果幾乎不變，world model 即使畫質很好，也缺乏作為控制環境的因果敏感度。

### 約束

- 真機資料昂貴，尤其是失敗、探索與偏離專家軌跡的資料。
- off-expert 動作既可能合理，也可能導致碰撞或失敗；評估不能把「不像專家」直接當成生成錯誤。
- 像素品質與動作忠實度是不同維度：高畫質可與錯誤控制反應同時存在。
- policy 更新會改變資料分布，因此只在 expert demonstrations 上通過測試不夠。

### 既有方法卡點

資料與 benchmark 都容易被專家分布主導，模型於是可能學到「在這個場景通常會發生什麼」，而不是「這一串數值動作會造成什麼」。只看影片品質或最終 policy 成績，也難以區分模型究竟學到動作因果，還是只提供有用的視覺增強與先驗。

### 作者試圖移動的邊界

作者把評估單位從合理影片，移向跨廣泛 action queries 的條件忠實度；再把訓練目標從各 rollout 的重建，推進到對 action intervention 的差分對齊。若這個方向成立，world model 的可信度將更接近「能接受 policy 查詢的模擬器」，而不只是條件式影片生成器。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- WorldEcho 以一個示範內與四個 off-expert 類別測試 action following。
- 評估同時涵蓋視覺完整性與末端執行器在 $SE(3)$ 的軌跡對齊。
- 診斷出「看似合理但忽略動作」與「視覺崩壞」兩類典型失敗。
- WorldSync 從資料覆蓋、表示 grounding、介入效果對齊三個軸改善 action-conditioned generation。
- 作者宣稱在 RoboTwin 與真機任務改善模擬可靠性及下游 policy improvement。

### 我的保守判讀

- 最有價值的部分可能是把 **plausibility 與 controllability 分開評估**。這個問題設定即使不依賴特定模型，也可成為後續 benchmark 的檢查框架。
- $SE(3)$ 軌跡比純像素指標接近控制語意，但仍未必涵蓋接觸力、物體狀態、遮擋下的真實位姿或長期任務後果。
- 模擬器產生的 off-expert ground truth 是否覆蓋真實世界的接觸與失敗模式，是可能的外部效度限制。
- WorldSync 的三項設計各自貢獻多少、是否依賴大量 simulator access、計算成本與資料配比，本次閱讀範圍無法判斷。
- 摘要中的成功率提升不能直接當成跨 embodiment、跨任務的普遍結論；仍需閱讀實驗設定、baseline、公平性與失敗案例。

## 可放進資料庫的筆記

- **合理性不等於條件忠實度**：生成結果看起來自然，仍可能沒有遵循輸入控制。
- **policy-facing simulator 要測反事實敏感度**：同一觀察換一個動作，未來應以可預期方式改變。
- **專家分布會隱藏控制失真**：模型可能靠場景先驗猜出「通常的成功未來」，卻沒學到動作後果。
- **off-expert 不是邊角案例**：只要 policy 會探索與更新，偏離 expert support 就是部署中的常態。
- **評估需拆開兩個失敗軸**：畫面是否完整，以及運動是否符合指令；兩者不可互相代理。
- **差分監督可能比單點重建更接近因果問題**：要求模型對介入的變化量與真值變化量一致。
- **生成預算也有有效產出率**：不忠實 rollout 需要過濾與重採樣，會把名義上的低成本模擬變成高浪費流程。
- **下游進步不是機制證據**：policy 變好不必然證明 world model 學到正確動態，仍需直接診斷。

## 後續想追的問題

1. WorldEcho 的五類動作如何取樣，怎麼確保 off-expert 動作仍屬物理可行而非任意雜訊？
2. $SE(3)$ 軌跡從生成影片抽取時會引入多少 pose-estimation 誤差，這些誤差如何校準？
3. WorldSync 三個軸的 ablation 是否顯示互補，或主要效果其實來自增加模擬資料？
4. 對接觸豐富、物體被遮擋或長時程任務，action following 的指標是否仍足夠？
5. policy improvement 的提升是否能跨 model family、embodiment 與真實場景重現？
