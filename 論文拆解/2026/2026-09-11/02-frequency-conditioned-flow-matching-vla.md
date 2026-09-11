# Frequency-Conditioned Flow Matching for Vision-Language-Action Models

## 原文資訊
- 論文：Frequency-Conditioned Flow Matching for Vision-Language-Action Models
- 作者：Haochen Niu、Shengye Dong、Hao Liu、Peiwen Lin、Wang Chuang
- arXiv ID：2609.10405v1
- 分類：cs.RO
- 發表 / 更新：2026-09-09 / 2026-09-09（v1）
- 連結：[abs](https://arxiv.org/abs/2609.10405v1) / [pdf](https://arxiv.org/pdf/2609.10405v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、方法、實驗、結果與附錄
- 擷取日期：2026-09-11

## 為什麼選這篇

許多 VLA 一次生成一段 action chunk。這段軌跡不是一串互不相關的數字：慢速的整體移動與快速的局部修正分布在不同時間頻率，而且能量可能高度不均。若仍把整段動作當成普通 temporal coordinates，用同一套 source noise、loss scale 與 guidance rule 處理所有分量，模型就必須自己從資料中隱式學回這個結構。

FreqFM 的獨立價值在於，它不是新增語言或視覺 backbone，而是重新檢查 **Flow Matching action expert 的座標與尺度假設**。它把頻率從軌跡的隱含性質升為生成管線的 conditioning dimension，連動 source distribution、training objective 與 inference guidance。這和今日另一篇 Show-Harness 的系統介面問題不同：一篇處理 VLM 到機器人的語意控制介面，這篇處理 action generator 內部如何尊重軌跡統計，因此不是為湊數收錄。

## 一句話理解

FreqFM 先把動作軌跡轉到頻率空間，再讓 Flow Matching 的起點分布、訓練權重與推論 guidance 分別按各頻帶的真實尺度校準。

## Summary / Abstract 說了什麼

對長度為 $H$、動作維度為 $D$ 的 action chunk $\mathbf{A}\in\mathbb{R}^{H\times D}$，FreqFM 沿時間軸套用離散餘弦轉換（DCT）：

$$
\widehat{\mathbf{A}} = \mathbf{C}\mathbf{A},
$$

其中 $\mathbf{C}\in\mathbb{R}^{H\times H}$ 是固定的 DCT basis，$\widehat{\mathbf{A}}$ 的低頻係數描述較慢的全局趨勢，高頻係數描述較快的局部修正。這個式子只是用來說明座標轉換；本次未讀方法章的完整定義。

Introduction 稱，在作者的 real-robot data（horizon 30）中，不同頻帶能量相差超過七個數量級，且超過 99.9% 集中於最低三個頻帶。可用每一頻帶的經驗 power 表示：

$$
P_{k,d}=\mathbb{E}\left[\widehat{A}_{k,d}^{\,2}\right],
$$

其中 $k$ 是頻率索引、$d$ 是動作自由度，$P_{k,d}$ 表示該頻率與自由度的平均平方能量。數值越大，代表資料在那個分量上的典型尺度越大。

摘要指出 FreqFM 做三件事：在 DCT coordinates 中建構 spectrum-matched source distribution；依頻率平衡訓練 objective；再以對應的 reference transport scale 約束每個頻帶的 classifier-free guidance residual。作者稱此設計不改 VLA backbone，可插入既有 Flow Matching action expert。

摘要自稱在 LIBERO、LIBERO-Plus 與 VLA-Arena 均改善表現，其中 LIBERO-Plus 增加 9.3 points，並在六個 real-robot tasks 展示效果。本次未讀實驗，因此不把這些數字解讀成跨設定的普遍增益。

## Introduction 的問題設定

Introduction 先指出 Flow Matching VLA 透過 learned conditional velocity field，把簡單 source distribution 的樣本運送成多步 action chunk。問題在於 action trajectory 具有強烈 temporal correlation：低頻與高頻不只語意不同，能量尺度也可能相差多個數量級。既有 action expert 多在時間座標中生成動作，頻率選擇性操作在該座標下通常對應密集的跨時間步耦合；換到 frequency coordinates 後，則可用較緊湊的 per-frequency parameterization 表達。

作者的核心問題是：能否把 frequency 從「模型或許會隱式學到的資料性質」，提升為 Flow Matching 全管線的顯式 modeling dimension？FreqFM 因而用 DCT 暴露頻率，再對三個位置做 conditioning：

1. **Source distribution**：估計每個頻率、每個自由度的 power spectrum，以它塑造 source variance，降低 source 與 target covariance 的失配。
2. **Training objective**：先依 power spectral density（PSD）正規化不同頻率的尺度，再用 likelihood-based multi-task objective 學習 frequency-resolved weights。
3. **Inference guidance**：把 classifier-free guidance 增量換算成各頻帶 reference transport scale 的單位，再限制於 per-frequency budget ball，避免用同一原始尺度裁切所有頻率。

作者將它描述成可插入既有 action expert 的調整，不需更換 VLA backbone。前言也提前陳述 benchmark 與實機改善，但本次沒有越界閱讀其實驗證據。

## 研究的第一性問題

- **基本問題**：當動作軌跡各頻帶的統計尺度極不均勻時，生成模型應否仍在時間座標中用近似同質的方式處理所有分量？
- **約束**：必須保留 action chunk 的時間結構、能與既有 Flow Matching VLA 相容，且不能讓低能量高頻訊號被 loss scale 或 guidance 規則淹沒。
- **既有方法卡點**：時間座標隱藏頻帶結構；模型需以 dense cross-timestep coupling 間接學會頻率選擇性，source covariance 與 target trajectory 也可能嚴重失配。
- **作者試圖移動的邊界**：從單一 action-space geometry，移到按頻率校準 source、objective 與 guidance 的 structured generation pipeline。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出 frequency-conditioned Flow Matching framework，把 action frequency 納入生成全流程。
- 使用 DCT 與資料估計的 power spectrum，建立 spectrum-matched source distribution。
- 透過 PSD normalization 與 frequency-resolved weighting 平衡訓練訊號。
- 按 reference transport scale 限制各頻帶的 classifier-free guidance residual。
- 不改 VLA backbone 即可整合，並在三個模擬 benchmarks 與六個實機任務呈現改善。

### 我的保守判讀

- 這篇最值得保留的洞見是：**表示座標會決定哪些結構容易被模型學到**。在時間座標中很複雜的耦合，可能在固定頻率 basis 中變成簡單的尺度校準。
- DCT 是固定、全局且線性的 basis；它適合平滑、相關的有限長軌跡，但突發接觸、非平穩 phase transition 或 event-aligned correction 未必能被少數頻帶乾淨表示。
- 99.9% 能量集中於低頻，不表示低能量高頻不重要。抓取接觸、抑震或避碰可能依賴幅度小但任務關鍵的局部修正；真正價值反而可能在不讓它們被尺度失衡吞掉。
- Spectrum matching 使用 corpus statistics。若 task、robot、控制頻率或 horizon 改變，power spectrum 是否可轉移，仍需看跨 embodiment 與 distribution shift 實驗。
- 「不改 backbone」降低整合成本，但 source、loss 與 guidance 三處同時改動後，增益來自哪一項、是否互相依賴，需靠消融才能判斷。
- 9.3-point gain 與六個實機任務來自摘要；尚未核對 baseline tuning、trial count、variance、failure cases 或額外計算成本。

## 可放進資料庫的筆記

1. **資料座標不是中性的。** 選 temporal、frequency、latent 或 geometric coordinates，會改變模型需要學習的耦合複雜度。
2. **能量占比不等於任務重要性。** 高頻雖低能量，可能承載接觸、修正與安全所需的稀疏訊號。
3. **生成管線的尺度要一致。** Source variance、loss weighting 與 inference guidance 若各用不同尺度觀，可能互相抵消或放大偏差。
4. **Action chunk 是結構化訊號，不是扁平向量。** 時間相鄰性、頻率與自由度之間都有可利用的先驗。
5. **固定 basis 是廉價 inductive bias。** 不一定需要改大 backbone；先把已知訊號結構顯式化，可能降低學習負擔。
6. **Corpus statistics 也是部署契約。** Sampling rate、horizon、robot dynamics 或任務分布改變時，頻譜估計可能需要重做。
7. **正規化同時改變注意力分配。** 移除大能量頻帶的數值優勢，等於讓 optimizer 有機會看見低能量分量，但也可能放大噪聲。
8. **評估應按頻帶與事件拆解。** 除 task success 外，可看低頻 trajectory error、高頻 correction、接觸時刻誤差與 guidance clipping 次數。

## 後續想追的問題

1. DCT 的正規化、boundary condition 與不同 action dimensions 如何處理；rotation 等非歐式量是否直接轉換？
2. Power spectrum 是全資料集、每任務、每 embodiment 還是動態條件估計？遇到 distribution shift 時如何更新？
3. Source matching、PSD-normalized objective 與 per-frequency guidance 各自貢獻多少，三者是否存在必要交互作用？
4. 高頻改善是否真的對應接觸與局部修正，還是整體收益主要來自低頻 trajectory shaping？
5. 9.3-point 結果的 variance、seed 數、baseline tuning、公平計算預算與六個實機任務 trial 數為何？
