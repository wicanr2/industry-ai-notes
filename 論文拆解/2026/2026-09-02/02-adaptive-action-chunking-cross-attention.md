# Knowing When to Stop: Adaptive Action Chunking via Internal Cross-Attention Dynamics in VLAs

## 原文資訊

- 論文：Knowing When to Stop: Adaptive Action Chunking via Internal Cross-Attention Dynamics in VLAs
- 作者：Runze Xu、Xiaolong Shan、Shuang Dai、Yu Wang、Jincheng Yu
- arXiv ID：2609.00908v1
- 分類：cs.RO
- 發表 / 更新：2026-09-01 / 2026-09-01
- 連結：[abs](https://arxiv.org/abs/2609.00908v1) / [pdf](https://arxiv.org/pdf/2609.00908v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）
- 擷取日期：2026-09-02

## 為什麼選這篇

現代 Vision-Language-Action（VLA）模型常一次預測一段未來動作，再只執行其中前幾步。這能降低每一步重新推論的成本，但也引入一個實際控制問題：同一個固定 action chunk 長度，很難同時適合快速接近物體與精細接觸操作。

這篇的獨立價值在於，它沒有再訓練一個外部 horizon selector，而是嘗試從 VLA 已經算出的內部 cross-attention 找出「當前觀察還能支撐多遠的未來動作」。若這個訊號可靠，模型內部狀態就不只是可解釋性圖表，也能成為閉環控制的停止條件。它與今日另一篇 VerNav 都關心條件式計算，但層級不同：VerNav 決定何時啟動生成式語意證據；本篇決定一批連續動作應執行到哪裡便重新觀察。

## 一句話理解

這篇想讓 VLA 用自身 cross-attention 的分散程度判斷「目前這張觀察最多還能可靠支撐幾步動作」，再動態截短 action chunk。

## Summary / Abstract 說了什麼

VLA 的 action expert 常透過 diffusion 或 flow matching，一次產生連續的未來動作序列。設模型預測的時間窗為 $H_p$（prediction horizon），真正不重新觀察而連續執行的步數為 $H_e$（execution horizon），通常有

$$
1 \leq H_e \leq H_p.
$$

$H_e$ 太短，模型必須頻繁重新推論，可能增加成本並造成動作震盪；$H_e$ 太長，後段動作會逐漸脫離最新觀察，降低對環境變化的反應能力。固定 $H_e$ 因而是在效率與準確性間做靜態折衷。

作者觀察 action query 對 VLM tokens 的 cross-attention：越靠近預測序列後段，注意力分布越分散，entropy 逐漸升高並進入平台。若某個 action query 對 context tokens 的正規化注意力為 $a_1,\dots,a_m$，可用一般熵概念表示其分散程度：

$$
H(a)=-\sum_{j=1}^{m} a_j\log a_j.
$$

高熵表示注意力沒有集中在少數感知或語言線索上。論文將持續的高熵平台視為當前觀察對更遠未來動作 grounding 變弱、預測風險升高的線上訊號，並據此在 inference 時截短 action chunk。方法使用政策原本就計算的 attention weights，論文自稱幾乎不增加額外成本，也不需額外訓練。

摘要報告在 $\pi_{0.5}$ 與 X-VLA、RoboTwin 2.0、LIBERO 及三個真實操作任務上，相較固定 horizon 與 adaptive chunking baselines 改善平均任務成功率，同時維持有效率的閉環控制。這些都是摘要中的作者報告；本次沒有閱讀實驗章，未核對各資料集、任務與基準的細節。

## Introduction 的問題設定

Introduction 先說明 VLA 常由 VLM backbone 處理高層語意與感知，再由 action expert 產生細粒度連續控制。相較每次只預測一個動作，action chunking 能降低反覆 replanning 所造成的誤差累積與 temporal interference，也較能表示示範軌跡中的節奏。

但 chunking 把問題從「每一步預測準不準」改成「要相信這次預測到第幾步」。固定 horizon 無法反映任務階段差異：快速接近階段可以一次走較遠，接觸、插入或抓取前後則需要更頻繁地看新觀察。手動調參或靜態 heuristic 難以跨任務泛化。

作者把 action expert 內部的 cross-attention 當作候選訊號。Introduction 自稱，早期 action tokens 只關注少量感知與語言特徵，後期 tokens 的注意力逐漸擴散；當 entropy 持續高檔並飽和時，離線 action error 也較高。基於這個關聯，作者提出 training-free truncation：在 inference 監控 entropy 的平台狀態，動態決定 $H_e$，讓感知與動作形成較細緻的閉環。

## 研究的第一性問題

### 基本問題

一個由當前觀察產生的未來動作序列，究竟可以開迴路執行多久，才應重新感知與規劃？

### 約束

- 頻繁重新推論提高計算與延遲成本，還可能導致動作在相近決策間來回擺動。
- 長時間開迴路執行會忽略新觀察，特別不利於接觸豐富或環境有變化的階段。
- 最佳 horizon 不只因任務不同，也會在同一任務的不同階段改變。
- 若使用外部 selector 或新增訓練，會增加部署複雜度與模型相依性。

### 既有方法卡點

固定 horizon 把動態控制問題壓成單一超參數；手動 heuristic 又很難知道模型何時失去對當前觀察的 grounding。兩者都沒有直接使用政策自身對未來動作的內部資訊狀態。

### 作者試圖移動的邊界

作者試圖讓既有 attention 計算承擔第二種角色：它不只參與產生動作，也提供何時停止執行這批動作的內部風險訊號。這把 action chunk 邊界從外部固定設定，改為由每次推論的內部動態決定。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 描述 flow-based VLA 中 action-to-VLM attention 隨預測 horizon 擴散的現象。
- 指出 sustained high-entropy saturation 與較高的離線 action error 相關，可作為 grounding 下降的經驗指標。
- 提出不需額外訓練或架構修改的 dynamic truncation 機制。
- 在模擬與真實任務上，相較所評估的固定與自適應 baselines 改善平均成功率，且新增延遲很低。

### 我的保守判讀

- 最值得注意的是「用模型已有內部訊號控制閉環頻率」，而不是 attention entropy 必然具有普遍因果意義。相關性可能依模型架構、layer、head、denoising step 或訓練資料而變。
- 高 attention entropy 不一定代表錯誤或不確定；某些需要整合多個物體、長指令或全域場景的正確決策，本來就可能分散注意力。
- 論文觀察聚焦於有明確 action-to-VLM cross-attention 的 action expert。對共同 self-attention、不同 tokenization 或沒有可直接讀取權重的架構，是否可移植仍未知。
- 「training-free」降低導入門檻，但 plateau detection 仍可能有窗口、門檻、layer aggregation 等超參數；其跨任務穩健性需讀方法與 ablation 才能判斷。
- 摘要提到平均成功率，平均值可能掩蓋特定高精度、長時程或分布外任務的退化。本次沒有讀實驗與 limitations，不能判定方法何時失效。

## 可放進資料庫的筆記

1. **Action chunk 是觀察信用期限**：$H_e$ 可理解為模型願意讓目前觀察支撐多少步未來行動。
2. **閉環頻率應隨任務階段變動**：接近、搬運與精細接觸需要不同的重新感知節奏。
3. **內部訊號可以成為控制介面**：attention、uncertainty 或 latent dynamics 不只供解釋，也可能驅動重新規劃時機。
4. **相關指標不等於因果保證**：attention entropy 與誤差相關，不能直接推成 entropy 造成誤差或能完整代表信心。
5. **Training-free 不等於 parameter-free**：不更新模型權重，仍可能需要門檻、平滑窗口與 aggregation 規則。
6. **效率與反應性不是單一固定折衷**：若能在線辨識風險，系統可以在安全狀態長執行、在精細狀態短執行。
7. **部署價值取決於可讀取性**：方法是否實用，取決於推論框架能否低成本暴露所需 attention weights。
8. **停止條件是 Physical AI 的核心能力**：不只要預測做什麼，也要知道一段預測何時不再值得信任。

## 後續想追的問題

1. entropy 從哪些 layers、heads 與 denoising steps 聚合？plateau 如何定義？
2. attention entropy 與 action error 的關聯在不同模型、任務階段與分布外場景是否穩定？
3. 動態 $H_e$ 的分布為何，成功率提升來自避免長 chunk，還是減少過度頻繁 replanning？
4. 若正確動作必須同時整合很多 tokens，高熵是否會造成過早截斷？
5. 方法能否擴充為共同考慮外部視覺變化、接觸訊號與政策內部 entropy 的多訊號停止規則？
