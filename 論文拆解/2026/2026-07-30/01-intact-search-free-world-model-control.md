# INTACT: Isomorphic Intent-to-Action Learning for Search-Free World Models

## 原文資訊
- 論文：INTACT: Isomorphic Intent-to-Action Learning for Search-Free World Models
- 作者：Junhan Sun、Hao Zhao、Guofeng Zhang
- arXiv ID：2607.26056v1
- 分類：Robotics（cs.RO）
- 發表 / 更新：2026-07-28 / 2026-07-28（v1）
- 連結：[abs](https://arxiv.org/abs/2607.26056v1) / [pdf](https://arxiv.org/pdf/2607.26056v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Methods、Experiments、Results 與附錄
- 擷取日期：2026-07-30

## 為什麼選這篇

許多 latent world model 擅長回答「採取這個動作後，世界會怎麼變」，但機器人真正需要的反向問題是「想讓世界變成這樣，現在該採取什麼動作」。常見做法是在部署時用 CEM、MPPI 等方法反覆採樣、rollout 與評分；這使 world model 比較像昂貴的候選方案評分器，而不是可直接查詢的控制介面。

INTACT 值得收錄，是因為它把這個缺口定位為**表示學習與控制介面之間的不對稱**，並主張可從既有、帶動作標記但沒有 reward 的軌跡中，學出「意圖到動作」的條件分布。這與 Physical AI 的即時控制直接相關，也提供一個比「把模型再放大」更具體的問題：latent representation 是否保留了可被控制器直接讀出的可控差異？

## 一句話理解

INTACT 嘗試把只能向前預測的 latent world model，改造成能從「目前狀態到目標狀態的 latent 位移」直接提出動作的介面，以降低部署時的大量搜尋。

## Summary / Abstract 說了什麼

摘要把傳統 world model 的瓶頸描述為「forward map 容易、inverse control 昂貴」：模型知道動作會造成什麼變化，卻仍需在測試時搜尋哪個動作能造成想要的變化。

作者令 $z_t$ 表示時間 $t$ 的 latent state，將局部轉移的物理意圖寫成

$$
m_t^{\text{local}} = z_{t+1} - z_t,
$$

並將由未來目標形成的部署意圖寫成

$$
m_t^{\text{goal}} = \operatorname{sg}(z_g) - z_t.
$$

其中 $z_g$ 是目標影像的 latent 表示，$\operatorname{sg}(\cdot)$ 是 stop-gradient，意思是把目標端當固定錨點，不讓這條 loss 路徑反向改動它。直觀上，兩個式子都把「想發生的變化」表示成 latent 位移，但前者來自真的下一步，後者來自部署時可見、卻不必是下一步可達的遠期目標。

摘要主張，同一個 predictor 以共享參數解讀這兩類意圖，輸出條件動作分布；分布平均可直接作為不搜尋的 policy，仍可選擇採樣做多樣化或驗證。摘要也報告四個 LeWM 官方任務上的成功率、搜尋候選數與推論延遲改善。這些數字是**論文自稱**；本次沒有閱讀實驗章節，無法核對任務難度、baseline 公平性、統計穩健性或延遲量測範圍。

## Introduction 的問題設定

Introduction 先指出訓練與部署的不對稱：訓練時，action 參與塑造 latent dynamics；部署時，規劃器卻常從隨機或高斯動作提案開始，經過多輪 rollout、目標評分與 refit 後，提案才逐漸具有任務方向。也就是說，forward predictor 把 action 與 latent change 聯繫起來，卻沒有把這個關係校準成可直接反查的 inverse interface。

作者的核心觀察是：離線軌跡即使沒有 reward、順序也不構成完整任務示範，每筆 action-labelled transition 仍同時揭露「在某狀態下發生了什麼 motion intent」及「哪個 action 實現了它」。因此，作者聯合訓練條件動作模型

$$
\pi_\eta(a_t \mid z_t, m_t),
$$

其中 $a_t$ 是動作、$z_t$ 是目前 latent state、$m_t$ 是想實現的 latent motion intent，而 $\eta$ 是模型參數。作者不是要求 local intent 與 goal intent 在 latent 空間逐點相等，而是要求它們若對應到相同的 expert action law，就由同一個條件動作 operator 以一致方式解讀。

Introduction 進一步把這種關係稱為 state-conditional action quotient：在固定狀態 $z$ 下，如果兩個端點條件 $y$ 與 $y'$ 引出相同的專家動作分布，就視為控制上等價：

$$
y \sim_z y' \Longleftrightarrow p_E^*(a \mid z,y)=p_E^*(a \mid z,y').
$$

白話說，兩個遠期目標在門口前可能都需要先做同一個動作；控制上的等價不要求兩個目標影像在 Euclidean latent space 很接近。作者以此反對單純用 latent $L_2$ 距離硬把目標與下一狀態拉在一起，因為那可能丟掉速度、接觸或障礙等對控制有用的差異。

## 研究的第一性問題

- **基本問題**：如何讓 learned world representation 不只可預測未來，也可被直接反查成可執行動作？
- **約束**：只使用 action-labelled、reward-free 軌跡；遠期目標在部署前可見，但通常不是一步可達的真實 successor。
- **既有方法卡點**：forward model 沒有自然定義 inverse action semantics，因而需用大量 candidate search 數值反解；若只在 frozen representation 上加控制 head，已被 encoder 丟掉的可控資訊也無法復原。
- **作者試圖移動的邊界**：把 latent space 從「可 rollout、可評分」推向「可直接用 intent 查詢 action distribution」，同時保留搜尋作為選配驗證而非必要控制路徑。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 以同一個共享 action likelihood，聯繫真實 transition 的 local intent 與部署時的 goal intent，而不要求兩類 latent endpoint 逐點對齊。
- 用 attached physical successor 與 stop-gradient future goal 處理兩種端點在可達性與梯度上的不對稱。
- 支援 zero-search Direct control，也可用以 Direct plan 為中心的局部 CEM 做驗證。
- 以 action-family diagnostics 說明 family-level 對應比單一 action point estimate 更能解釋 closed-loop success。

### 我的保守判讀

- 最有價值的概念不是「完全消滅 planning」，而是把昂貴搜尋由**必要的 inverse solver**降為**選配的 verifier**；這可能是實際系統更合理的目標。
- 「相同 goal displacement 可直接讀成 action」仍高度依賴訓練資料是否覆蓋可達的 intent family。遇到真正超出 demonstration support 的目標，條件平均可能產生不可執行或多模態平均化的動作。
- Introduction 很長且提出多個新名詞；其中哪些是不可替代的理論結構、哪些是既有 inverse dynamics / goal-conditioned imitation 的重新組合，需讀 related work、ablation 與完整實驗才能判斷。
- 摘要的速度與成功率數字看起來強，但作者也明確說它不是 end-to-end VLA latency benchmark。本次未讀實驗，因此不能把 planner-side 延遲直接外推到真實機器人整體控制頻率。
- 目前證據範圍看來集中於官方 LeWM 四任務；跨 embodiment、長時程、接觸豐富或含不可逆狀態的控制是否成立，仍是未回答問題。

## 可放進資料庫的筆記

1. **Forward competence 不等於 inverse usability**：模型能準確預測 action effect，不代表能低成本找到達成 goal 的 action。
2. **表示空間也是 API 設計**：好的 latent 不只壓縮資訊，還應讓下游所需關係可直接讀出；否則部署成本會轉移到搜尋器。
3. **把搜尋降級成 verifier**：先由 learned policy 給 coherent proposal，再以小規模 planning 檢查，比從隨機候選開始更符合高頻控制需求。
4. **控制等價不等於幾何接近**：在固定狀態下，只要兩個目標需要相同的下一動作，它們可暫時屬於同一 action-equivalence class。
5. **梯度路徑應反映資料語義**：真實 successor 可塑造 representation；遠期 goal 並非一步後真值，適合作固定 anchor，而不是假裝兩者完全同質。
6. **Family-level metric 可能比 point estimate 更重要**：多模態動作問題中，保留可行動作族群的結構，可能比準確回歸單一示範動作更接近控制需求。
7. **缺 reward 不等於缺控制監督**：action-labelled transition 本身就包含局部「變化—動作」配對，只是需要適當的條件化方式提取。

## 後續想追的問題

1. Full INTACT 相對於 goal-conditioned behavior cloning、inverse dynamics 與各自組合的 ablation，真正不可替代的增益有多大？
2. 條件動作分布如何處理同一 intent 的多模態可行解；直接取 mean 是否可能形成無效動作？
3. 所謂 action-family kNN / CKA 與 success 的相關性，是否在跨任務、跨 seed 與排除 epoch 影響後仍穩健？
4. 對未見目標、不可達目標或需要先遠離目標再接近的 long-horizon 任務，raw goal displacement 如何避免誤導？
5. planner-side 2.9–5.5 ms 之外，encoder、感知、通訊與 robot actuation 加總後的 end-to-end latency 是多少？
