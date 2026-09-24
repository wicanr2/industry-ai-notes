# RoboFollow: Unveiling the Instruction Following Mirage in Embodied Agents

## 原文資訊

- 論文：RoboFollow: Unveiling the Instruction Following Mirage in Embodied Agents
- 作者：Chang Guo、Yukun Xie、Bohan Tan、Zheng Chang、Zhaokai Yin、Qianli Ma、Yingqiao Wang、Chao Liang、Zhipeng Zhang
- arXiv ID：2609.25636v1
- 分類：cs.RO
- 發表 / 更新：2026-09-22 / 2026-09-22（v1）
- 連結：[abs](https://arxiv.org/abs/2609.25636v1) / [pdf](https://arxiv.org/pdf/2609.25636v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML 與 PDF 文字版，讀至 Related Work 前）
- 擷取日期：2026-09-24

## 為什麼選這篇

這篇直指 VLA／WAM 評估的一個結構性盲點：機器人完成任務，不代表它真的依照語言行動。如果場景裡本來就只有一個看似合理的操作，模型可以忽略指令，仍拿到很高的 task success。這使「語言條件控制」可能只是資料集設計造成的表象。

它值得收錄，不只因為提出新 benchmark，而是把評估問題重新寫成一個可檢驗的因果問題：拿掉語言之後，視覺是否已足以決定答案？若是，成功率就不能單獨證明 language grounding。這個問題同時連到 Physical AI 的可靠性與 LLM／VLM 語意能力如何真正進入控制迴路。

## 一句話理解

RoboFollow 透過讓同一場景存在多個可行任務，迫使機器人必須真的讀懂語言，並把「理解錯意圖」與「動作執行失敗」分開計分。

## Summary / Abstract 說了什麼

論文把既有高成功率可能掩蓋的現象稱為 instruction-following mirage。核心來源是 **低場景熵（low scene entropy）**：給定初始場景後，任務幾乎已被唯一決定，因此語言沒有提供必要資訊。

Introduction 用條件熵描述這件事：

$$
H_{\text{scene}} = H_{\text{train}}(T\mid S)
= -\sum_s p(s)\sum_t p(t\mid s)\log_2 p(t\mid s).
$$

其中 $S$ 是不含指令與目標的初始場景規格，$T$ 是任務標籤，$p(t\mid s)$ 表示在場景 $s$ 中各任務出現的比例。白話說，$H_{\text{scene}}$ 越高，同一畫面可能對應的合理任務越多；模型若要選對，就越不能只靠視覺捷徑。

RoboFollow 的設計有三部分：讓每個訓練場景支援多個運動學上不同的任務分支；用 L0–L3 逐步改變版面與語意組合；再把評分拆成 Intent 與 Execution，嘗試隔離「選錯要做什麼」和「知道要做什麼但沒做好」。Abstract 自稱，九種 VLA／WAM policy 即使在 L0 表現強，也未穩定延伸到 L1–L3；幾種補強方式也未關閉差距。

## Introduction 的問題設定

Introduction 先區分兩個常被混在一起的命題：一是 robot manipulation competence，二是 instruction following。完成動作可能來自語言理解，也可能只是場景中的慣常行為太明顯；部署時兩者不能等價，因為「物理上成功、語意上錯誤」仍是失敗。

接著，作者指出標準 success rate 同時混合視覺辨識、語言 grounding、規劃與低階控制，難以定位失敗來源；而許多 benchmark 的初始觀察本身已透露主要行為，更降低語言的必要性。於是 benchmark 的設計原則不是增加任務長度，而是增加受控歧義：同一或近似場景必須容納多個可行分支。

最後，Introduction 把診斷拆成四類場景、四層測試與兩階段分數。這個順序很重要：先讓語言成為必要資訊，再問模型在視覺變化、語意重組與兩者共同變化時是否仍遵循指令，最後才判斷錯誤發生在意圖還是執行。

## 研究的第一性問題

- **基本問題**：如何證明 language-conditioned robot policy 的輸出真的由語言條件所決定，而不是由視覺共現或固定任務先驗決定？
- **約束**：robot success 是多個能力的乘積；如果同時提高動作難度，語言理解與控制誤差會重新糾纏。
- **既有方法卡點**：單一成功率只觀察最後結果，且低歧義場景允許模型繞過語言。
- **作者試圖移動的邊界**：從「能否完成任務」移向「在多個物理可行選項中，是否因為指令而選中正確意圖」。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 建立語言不可省略的高場景熵 benchmark，降低視覺捷徑。
- 以 L0–L3 分離分布內執行、版面變化、語意重組，以及視覺與語意共同泛化。
- 以 Intent／Execution 分數降低語意理解與運動控制的混淆。
- 對多種 VLA／WAM 與補強策略進行系統性診斷，指出語言 grounding 仍是瓶頸。

### 我的保守判讀

- 最有價值的貢獻可能是「語言必要性」這個 benchmark 建構準則，而不是某個單一排行榜結果；它可遷移到導航、人形機器人與 agent tool use。
- 場景熵是有用的資料集診斷量，但高熵不自動代表語言內容豐富，也不保證任務分支在難度、資料量與視覺線索上完全平衡。
- Intent／Execution 的拆分是否真的乾淨，取決於 intent 判定點、物件與動作簡化方式。這需要讀方法與標註規則才能確認。
- Abstract 的模型比較與 mitigation 結論尚未由本次閱讀獨立核對；不能據此斷言所有現代 VLA 都不理解語言。

## 可放進資料庫的筆記

1. **結果成功不等於條件生效**：條件式模型要驗證的是輸出是否依賴條件，而不只是最終答案正確。
2. **先問資訊是否必要**：若環境本身已唯一決定行為，benchmark 無法證明額外模態被使用。
3. **用受控歧義移除捷徑**：讓同一觀察對應多個可行答案，比單純增加場景雜訊更能測 grounding。
4. **把失敗鏈拆開計分**：意圖選擇與物理執行應各有觀測點，否則改善低階控制會被誤認為改善理解。
5. **等價指令看一致性、不同指令看可分性**：兩者合起來才是較完整的 instruction-following 測試。
6. **資料集條件熵是設計量，不是能力分數**：它衡量場景是否允許捷徑，不直接衡量模型理解程度。
7. **部署安全要防語意錯而動作成功**：Physical AI 最危險的錯誤未必是機器人停住，也可能是流暢地做錯事。

## 後續想追的問題

1. L0–L3 的每層任務如何控制資料量、動作難度與視覺差異？
2. Intent Score 的判定規則是否會受低階軌跡偏差污染？
3. scene entropy 與模型對語言擾動的敏感度之間是否呈單調關係？
4. 九種 policy 是否使用相同資料與微調預算，WAM 與 VLA 的比較是否公平？
5. 若加入反事實指令或拒絕執行選項，能否更直接測出語意服從與安全邊界？
