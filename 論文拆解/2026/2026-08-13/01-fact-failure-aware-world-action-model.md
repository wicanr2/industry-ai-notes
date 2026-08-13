# FACT: Failure-Aware Causal Training for World-Action Models

## 原文資訊

- 論文：FACT: Failure-Aware Causal Training for World-Action Models
- 作者：Quanquan Peng、Yutong Liang、Rui Yan、Nicklas Hansen、Xiaolong Wang
- arXiv ID：2608.10232v1
- 分類：cs.RO、cs.AI、cs.LG
- 發表 / 更新：2026-08-10 / 2026-08-10（v1）
- 連結：[abs](https://arxiv.org/abs/2608.10232v1) / [pdf](https://arxiv.org/pdf/2608.10232v1)
- 本次閱讀範圍：Summary/Abstract + Introduction；未讀 Related Work、Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-13

## 為什麼選這篇

World-action model（WAM）常把未來影像預測接到機器人政策上，但訓練資料多半由成功示範構成。這會留下重要盲點：模型學到「正確行動之後世界如何演化」，卻未必學到「錯誤行動會造成什麼後果」。FACT 直接把失敗軌跡轉成後果監督，切中 robot foundation model 從模仿成功案例走向辨識失敗因果的問題。

這篇也對實際資料工程有啟發。失敗 rollout 不必二選一地被丟棄，或被錯當成應模仿的動作；同一筆資料可以在不同目標上有不同標籤權限。這種「不模仿錯誤行動、但學習它的後果」的拆分，可延伸到自我改進式 VLA、機器人安全監控與候選動作評分。

## 一句話理解

FACT 要讓機器人政策不只知道好動作長什麼樣，也能從真實失敗中學會某個壞動作接下來會把世界帶到哪裡。

## Summary / Abstract 說了什麼

摘要指出，既有 WAM 會以影片模型預測未來，再由 inverse dynamics 還原動作，或把預測未來當成產生動作的條件；但未來預測多由成功示範監督，因此模型沒有充分理由呈現壞動作的後果。

FACT 採取 action-conditioned 介面：先產生／給定已執行動作，再預測未來影片與 task progress。失敗 rollout 的動作不進入 imitation loss，但實際失敗後的影像與較低進度仍作為有效監督。摘要並稱，學到的 progress predictor 可在推論時選擇性地為多個候選動作排序。

**論文自稱**：模擬與真實雙臂操作實驗中，FACT 優於多個基線；納入失敗資料後表現提升，且錯誤動作下「仍預測成功未來」的偏誤減少。這些是摘要層級的作者報告，本筆記沒有讀實驗章節核實比較條件或統計穩健性。

## Introduction 的問題設定

Introduction 先把 VLA 定位為「由影像與語言指令直接輸出動作」的通用政策，再把 WAM 定位為加入未來視覺預測、以時間動態與物理先驗輔助控制的路線。作者把既有方法分成兩類：一類先想像影片，再用第二階段 inverse dynamics 解碼動作；另一類用未來 frame／latent 輔助動作預測。前者可能有完整去噪與二階段解碼成本，後者則常只看到專家示範的合理未來。

核心缺口不是單純「失敗資料太少」，而是監督角色衝突：若直接模仿失敗動作，政策會被污染；若完全丟棄失敗 rollout，世界模型又學不到壞動作的真實後果。作者因此提出問題：能否只把失敗軌跡當作 consequence supervision，而不把它當 imitation target？

FACT 的回答是把「要模仿什麼」與「要預測什麼」分開。成功示範同時監督動作、未來影像與進度；失敗 rollout 遮蔽 action imitation loss，但保留未來與低進度監督。Introduction 宣稱的三項貢獻是：action-then-future 的因果序列、分離兩種學習角色的 teacher-forced action-conditioned mask，以及在模擬與真實環境驗證政策成功率、未來幻覺與進度評分能力。

## 研究的第一性問題

- **基本問題**：一個能採取行動的模型，若只看過成功後果，如何判斷候選動作是否會導向失敗？
- **約束**：失敗軌跡包含有價值的世界反應，但其中的動作不能直接當作正向模仿標籤。
- **既有方法卡點**：同一筆 trajectory 往往被整體視為「可訓練」或「不可訓練」，沒有依學習目標拆開其監督資格。
- **作者試圖移動的邊界**：把失敗資料從低品質 demonstration 改寫成高價值 causal consequence data，讓 policy 與 world predictor 能共享資料但接受不同 loss mask。

可用一個簡化觀念表示。令動作為 $a_t$、後續觀察為 $o_{t+1:t+H}$、任務進度為 $v$；FACT 想學的是：

$$p(o_{t+1:t+H}, v \mid o_t, \ell, a_t)$$

其中 $\ell$ 是語言任務。對失敗資料，$a_t$ 仍是預測後果的條件，卻不是政策應模仿的答案。白話說，錯誤動作可以拿來教「會發生什麼」，不必拿來教「應該做什麼」。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- action-then-future 排序讓未來預測明確依賴造成該未來的動作。
- 遮蔽失敗動作的 imitation loss，同時保留影像與 progress supervision，可避免污染政策。
- 失敗感知的 progress predictor 可選擇性地評分候選行動。
- 作者宣稱模擬與真實雙臂任務均有改善，並降低錯誤動作下的成功偏向未來幻覺。

### 我的保守判讀

- 最有價值的可能不是單一架構，而是「依目標拆分資料標籤權限」：同一段失敗軌跡對 policy 是負面樣本，對 dynamics model 卻是正確觀測。
- action conditioning 能加強因果方向，但僅憑架構不能保證模型真的學到可外推的因果模型；也可能只記住訓練失敗的視覺模式。
- progress value 的可靠性取決於進度標註方式、失敗涵蓋範圍與校準。摘要未足以判斷它在未見失敗、長時序或分布外情境是否可信。
- 候選動作排序若需要多次生成未來，可能增加控制延遲；Introduction 只說這是 optional，尚不能判斷效能成本。
- 摘要中的基線優勢、failure-data scaling 與 hallucination 降低仍需閱讀 Methods／Experiments 才能確認定義、公平性與顯著性。

## 可放進資料庫的筆記

1. **失敗不是壞資料，而是目標相依的資料**：同一樣本對 imitation 無效，對 consequence learning 可能非常有效。
2. **先拆監督角色，再擴資料量**：資料不足有時是假問題，真正問題是不同 loss 共用同一套標籤資格。
3. **世界模型必須回答反事實鄰域**：只會預測專家軌跡附近的成功未來，還不足以支援安全選擇。
4. **action-then-future 是因果介面的設計選擇**：未來預測若不明確條件化於動作，容易退化成任務成功的平均想像。
5. **負面 rollout 可形成自我改進迴路**：部署失敗能補足後果模型，再反過來改善候選動作篩選；但要防止資料偏向常見失敗。
6. **進度預測器同時是能力與風險點**：它能當 critic，卻也可能成為被 policy 利用或分布外失準的代理目標。
7. **評估要把動作成功與未來忠實度分開**：政策成功率提高，不必然代表預測未來更符合實際因果；兩者應獨立量測。

## 後續想追的問題

1. 失敗 rollout 如何取得、如何定義 failure，是否涵蓋接近成功與災難性失敗等不同難度？
2. teacher-forced action mask 的確切做法，如何避免 future branch 的梯度間接把壞動作寫回 policy？
3. 「success-biased future hallucination」的量測指標與對照組是否能分辨視覺品質和因果忠實度？
4. progress value 如何標註、校準；用它排序候選動作時增加多少推論延遲？
5. 對訓練中未出現的錯誤組合、長時序連鎖失敗與安全關鍵事件，是否仍能預測可信後果？
