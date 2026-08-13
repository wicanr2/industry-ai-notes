# Lost in Reconstruction: Aligning Action Representations with Language in Vision-Language-Action Models

## 原文資訊

- 論文：Lost in Reconstruction: Aligning Action Representations with Language in Vision-Language-Action Models
- 作者：Li Wenjie、Yash Jangir、Ignacy Stepka、Yash Agarwal、Marion Kipsang、Yonatan Bisk
- arXiv ID：2608.10484v1
- 分類：cs.RO、cs.AI、cs.CL
- 發表 / 更新：2026-08-11 / 2026-08-11（v1）
- 連結：[abs](https://arxiv.org/abs/2608.10484v1) / [pdf](https://arxiv.org/pdf/2608.10484v1)
- 本次閱讀範圍：Summary/Abstract + Introduction；未讀 Diagnostics、Method、Experiments、Results、Related Work 與附錄
- 擷取日期：2026-08-13

## 為什麼選這篇

VLA 的語言對齊通常集中在「看見哪個物體、抵達哪個狀態」，但機器人真正執行的是 action representation。這篇把問題往介面下游推一步：如果 action tokenizer 只追求數值重建，即使軌跡重建誤差很小，也可能把「推、拉、放、掃」等動詞所代表的運動差異壓掉。這是 LLM／VLM 語意如何穿過 token interface 進入 physical control 的直接交會問題。

它和今日另一篇 FACT 的價值不同。FACT 關注失敗軌跡如何提供後果監督；本篇關注連續動作壓縮成離散 token 時保留了哪些語意。後者提供一個可重用的 representation-design 問題：下游需要的資訊，是否在前置壓縮目標中已經不可逆地消失？

## 一句話理解

只把動作軌跡「重建得像」還不夠；VLA 的 action token 還應保留語言中對動作方式有意義的差異。

## Summary / Abstract 說了什麼

摘要的起點是：動詞不只描述行動結果，也描述行動如何完成。可是 VLA 的 action representation 往往以 raw action space 的 L1／L2 reconstruction loss 最佳化；數值上接近，不代表語言意義上相近。

作者以 BridgeV2 分析，聲稱動作軌跡含有超越視覺狀態變化的 verb-grounding information，而只做重建的離散 tokenizer 會系統性侵蝕這些資訊。提出的 SALT（Semantically ALigned action Tokenizer）在 VQ-VAE 式 tokenizer 上加入輔助目標：讓 frozen vision-language model 從量化後的 action latent 回復 episode instruction，藉此迫使 token 保留與語言相關的結構。

**論文自稱**：在 SimplerEnv 中，以 SALT 訓練的政策平均成功率為 71.9%，相較 reconstruction-only VQ-VAE 的 42.7% 與 FAST 的 31.2%；並形成 verb-specialized codes，且維持 reconstruction fidelity。這些數字只來自摘要與 Introduction，本筆記未讀實驗章節，不能判定比較設定、變異或泛化範圍。

## Introduction 的問題設定

Introduction 從 embodied language grounding 出發：動詞意義同時連結動作目標、移動軌跡、接觸模式與夾爪時序。理想的 action representation 不只要支援精確執行，也要保留語言認為重要的差異。然而既有 VLA 多在 Euclidean control space 定義 action objective，再期待下游政策自行學會語言與動作的關係。

作者指出，VLM 已先把 vision 與 language 對齊，但把 VLM 變成 VLA 的 action interface 受到較少關注。既有語言條件機器人研究常把語言當作目標條件，例如辨識物體顏色、形狀、位置或期望終態；這些資訊很大一部分能從影像接地，因而研究也偏重 language–vision alignment。問題是，動作「如何做」未必能只由首尾影像推回來。

離散 action token 特別關鍵，因為它可沿用 VLM 的 autoregressive next-token 介面。Introduction 列出 per-dimension bins、以重建為主的 VQ-VAE tokenizer，以及 FAST 的頻率轉換與壓縮。共同風險是 tokenizer 通常先於 VLA 獨立訓練，action vocabulary 在語言進入 pipeline 前就固定，沒有目標要求它保留語言有意義的區分。

作者以 BridgeV2 的真實遙操作軌跡與自然語言指令建立三項主張：動作軌跡提供視覺終態以外的動詞資訊；離散化與更強壓縮會減少 verb–action information，且下游政策未必補得回來；加入 instruction-generation 監督的 SALT 能改善語意結構與閉迴路成功率。

## 研究的第一性問題

- **基本問題**：將連續控制訊號壓成有限 action tokens 時，應保留哪一種相似性？
- **約束**：tokenizer 既要壓縮並準確重建，又要服務語言條件控制；控制空間的 Euclidean 距離不等於語意距離。
- **既有方法卡點**：前置 tokenizer 只看 action reconstruction，可能在下游語言 supervision 出現之前，就丟掉動詞所需的 motion structure。
- **作者試圖移動的邊界**：讓 action vocabulary 在建立時就接受 language-aware objective，而不是把所有跨模態對齊責任留給後續 policy。

可把問題簡化為兩個同時存在的目標。令軌跡為 $a$、量化 token 為 $z=Q(E(a))$、重建器為 $D$、語言指令為 $\ell$：

$$\mathcal{L}=\mathcal{L}_{\text{recon}}(a,D(z))+\lambda\,\mathcal{L}_{\text{lang}}(\ell,G(z))$$

$\lambda$ 控制語言保真與動作重建的權衡，$G$ 是從 action latent 回復指令的語言解碼介面。白話說，好的 token 不只要能還原馬達數值，也要讓模型辨識這段運動在語言上「做了什麼」。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 動作軌跡含有視覺起訖狀態無法完全取代的動詞資訊。
- reconstruction-only 離散 tokenization 會侵蝕 verb grounding，壓縮越強時損失越明顯。
- SALT 以 frozen VLM 的 instruction-generation objective 對齊量化 action latent 與語言。
- 作者宣稱 SALT 保持重建 fidelity、形成動詞專門化 code，並提高 SimplerEnv 閉迴路成功率。

### 我的保守判讀

- 這篇最強的概念訊號是「representation bottleneck 先於 policy learning」：若資訊已被 tokenizer 壓掉，更大的下游模型也不一定能恢復。
- 讓 latent 可預測 instruction，不必然等於學到真正可組合的動詞語意；模型也可能利用資料集中的物體、場景或任務共現捷徑。
- BridgeV2 受單一機器人平台、7-DoF 控制與資料語彙限制；verb-specialized code 是否跨 embodiment、語言表述與接觸型態可轉移，摘要與 Introduction 無法回答。
- 71.9%、42.7%、31.2% 是作者報告值；尚未確認 action vocabulary 大小、政策容量、訓練成本與各基線調參是否可比。
- 語言對齊也可能過度合併數值不同但同動詞的軌跡，傷害精細控制；需要看 $\lambda$、code usage 與安全邊界的消融。

## 可放進資料庫的筆記

1. **低重建誤差不等於任務充分表示**：representation 應以未來使用方式評估，不只看輸入還原能力。
2. **動詞同時包含 goal 與 manner**：首尾影像多半呈現結果，完整軌跡才呈現接觸、方向、速度與夾爪時序。
3. **tokenizer 是語意政策的一部分**：即使它獨立預訓練，也會決定下游模型能看到哪些控制差異。
4. **先壓縮、後對齊可能太晚**：不可逆資訊損失不能期待由更大的 VLM 自動補回。
5. **語言可作為控制表示的 regularizer**：自然語言不只輸入任務，也能規範 action latent 的群聚結構。
6. **多目標表示需要檢查 trade-off**：語意接近、精確重建、codebook 利用率與即時控制可能彼此衝突。
7. **跨 embodiment 的關鍵或是語意等價類**：若 action token 真能以動詞結構組織，值得測試它能否連接不同機器人的低階座標系。
8. **探針結果要防資料捷徑**：能從 action latent 預測動詞，仍需排除物體、場景或任務頻率等混雜因子。

## 後續想追的問題

1. 作者如何拆分「視覺終態資訊」與「motion dynamics 的獨特資訊」，互資訊估計是否穩健？
2. SALT 的 frozen VLM 能看到哪些輸入；如何避免從場景或物體捷徑回復 instruction？
3. reconstruction fidelity、language alignment 與閉迴路成功率之間的消融關係為何？
4. SimplerEnv 的任務、policy backbone、codebook 容量與 FAST／VQ-VAE 基線是否公平對齊？
5. SALT 是否能跨 robot embodiment、同義動詞、未見組合與精細 contact-rich manipulation 泛化？
