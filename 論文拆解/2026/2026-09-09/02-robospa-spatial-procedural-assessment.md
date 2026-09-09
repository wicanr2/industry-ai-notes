# RoboSPA: Can VLA Models Go Beyond Simple Scenes and Short-Horizon Tasks?

## 原文資訊
- 論文：RoboSPA: Can VLA Models Go Beyond Simple Scenes and Short-Horizon Tasks?
- 作者：Zhenxuan Fan、Bo Zhang、Yutong Lin、Yuqian Yuan、Juekai Lin、Liang Liang、Zhuoyi Huang、Wenqiao Zhang、Juncheng Li、Siliang Tang、Jun Xiao、Yueting Zhuang
- arXiv ID：2609.05324v1
- 分類：cs.RO、cs.AI、cs.CV
- 發表 / 更新：2026-09-04 / 2026-09-04（v1）
- 連結：[abs](https://arxiv.org/abs/2609.05324v1) / [pdf](https://arxiv.org/pdf/2609.05324v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（官方 arXiv PDF 擷取；arXiv HTML 尚未提供）；未讀 Related Work、資料集細節、實驗、結果與附錄
- 擷取日期：2026-09-09

## 為什麼選這篇

VLA benchmark 若只問「預先定義場景中的任務最後有沒有成功」，很難知道模型究竟敗在語言 grounding、細緻空間關係、低階控制、程序記憶，還是長時序誤差累積。RoboSPA 嘗試把空間與程序複雜度變成可控制的測試軸，這比再報一個整體 success rate 更有診斷價值。

這篇與今日另一篇形成互補，但不是重複題目：neuro-symbolic procedural reasoning 提出一種長時序系統分工；RoboSPA 則問 benchmark 要如何讓能力隨難度退化的形狀可被觀察。方法主張與測量基礎設施是兩個不同層次，因此本日保留第二篇。

## 一句話理解

RoboSPA 想把 VLA 的「複雜任務會失敗」改寫成可分層、可逐步定位的空間 grounding 與程序規劃測試。

## Summary / Abstract 說了什麼

摘要提出 RoboSPA（Robot Spatial-Procedural Assessment），聚焦兩個核心維度：**Fine-Grained Spatial Reasoning** 與 **Long-Horizon Procedural Planning**。資料涵蓋 10 個 task categories、56 個 base tasks；每個 base task 有 5 個難度等級，因此形成：

$$
56\ \text{base tasks} \times 5\ \text{levels} = 280\ \text{task variants}.
$$

這裡的層級設計重點不是數量本身，而是同一類能力可隨 spatial ambiguity 或 procedural complexity 增加而接受壓力測試。摘要另稱資料跨多種 embodiments 與場景，共收集 527K trajectories，並提供不只二元 success rate 的 diagnostic metrics。

作者在摘要中報告，代表性 VLA 仍受困於複雜空間關係、精準低階執行與需要記憶的規劃。這是論文自稱的實驗發現；本次沒有閱讀實驗章，因此不評估模型選擇、難度校準、統計顯著性或 sim-to-real 代表性。

## Introduction 的問題設定

Introduction 把現況定位為：VLA 透過大規模預訓練與多模態對齊，已在結構化、短時序操作中展現能力，但真實任務要求的不只是簡單場景中的短指令跟隨。作者列出三個挑戰：

1. **細粒度目標消歧**：模型要依細微空間線索，從視覺相似候選中找出目標，而不只是認類別或顏色。
2. **時間延伸的任務執行**：多步驟任務含時間限制與誤差累積，前一步偏差會改變後續狀態。
3. **可擴張的 embodied reasoning 測試**：候選數、action horizon 與環境多樣性增加時，grounding 與 planning failure 會被放大。

作者認為既有資料與 benchmark 有四個缺口：很少顯式測細粒度空間推理；長時序與 step-level diagnosis 不足；缺乏受控的 multi-level difficulty；資料規模與 task／embodiment／scene coverage 有限。RoboSPA 因此以 fine-grained spatial reasoning、long-horizon procedural planning、multi-level hierarchical evaluation 作為設計原則。

Introduction 描述 56 個 base tasks、10 類能力、5 個難度、280 個 variants、5 種 embodiments、527K trajectories 與 997 小時影片，並強調每個 task 支援 step-level evaluation。它也報告 hardest tasks 上所有受測模型平均成功率低於 25%，部分任務降到 0%；由於這些數字來自 Introduction 對後文結果的預告，而本次未讀實驗細節，以下不把它們當成已獨立驗證的結論。

## 研究的第一性問題

- **基本問題**：如何知道 VLA 的失敗源自哪一種 embodied capability，而不是只看到最終任務失敗？
- **約束**：空間難度、步驟長度、場景變化與 embodiment 差異會同時變動；若沒有受控設計，很難把性能下降歸因到單一能力。
- **既有方法卡點**：整體 success rate 把 target selection、step execution、memory 與 planning 混成一個數；短時序任務也可能高估模型在真實長程序中的可靠性。
- **作者試圖移動的邊界**：從靜態 benchmark 排名，移到可觀察「難度增加時，模型在哪一層開始崩解」的 diagnostic assessment。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 建立以細粒度空間推理與長時序程序規劃為主軸的大型 VLA 資料集與 benchmark。
- 將每個 base task 系統化擴展成五個難度等級，以觀察複雜度增加時的性能退化。
- 涵蓋 10 類能力、56 個 base tasks、280 個 variants、5 種 embodiments、527K trajectories 與 997 小時影片。
- 除最終成功率外，提供 step-level progress 與更細緻的 diagnostic evaluation。
- 報告現有代表性 VLA 在 target grounding、低階 manipulation、長時序 tracking 與 memory-based reasoning 上仍有困難。

### 我的保守判讀

- 最具價值的主張是 **difficulty curve 比單點分數更有資訊**。若每級真的只增加預期因素，就能區分模型的能力邊界與退化斜率。
- 難度分級的有效性是整個 benchmark 的核心假設。若 level 同時改變候選數、視角、物理精度與步驟長度，就仍可能無法定位因果來源。
- Step-level metric 能縮小診斷範圍，但 step 定義、部分完成規則與自動評估可靠度會直接影響結論；需讀後續章節確認。
- 527K trajectories 看似龐大，卻不能單憑數量判斷狀態覆蓋、失敗樣本比例或跨 embodiment 多樣性。資料生成方式也會決定 benchmark 是否存在模板捷徑。
- Introduction 報告的低成功率證明「這套題很難」，但難並不自動代表有效。還要確認人類／oracle 上限、任務可解性、控制介面公平性，以及失敗是否真由所標示能力造成。
- 本次從 PDF 擷取 Introduction，官方 HTML 尚未提供；內容可讀，但雙欄 PDF 的文字順序需要人工重組，因此對細節採保守表述。

## 可放進資料庫的筆記

1. **Benchmark 的第一產品是診斷，不是排行榜。** 若只能說模型 A 高於模型 B，對系統改進幫助有限。
2. **複雜度應被設計成軸。** 候選數、空間歧義、action horizon、記憶負擔可各自形成 difficulty curve。
3. **最終成功率是多種能力的乘積。** 任一步的 grounding、控制或記憶失敗，都可能把整體分數歸零。
4. **Step-level progress 能區分完全不會與做到一半。** 但必須先定義可重現的步驟邊界與完成條件。
5. **長時序測試要觀察誤差如何累積。** 單一步驟準確率相近的模型，可能有完全不同的 sequence reliability。
6. **受控難度比任務數量更重要。** 大資料不等於能解釋性能下降的原因。
7. **跨 embodiment 評估需要介面公平性。** embodiment diversity 若伴隨不同 action spaces 或觀測品質，必須分開記帳。
8. **困難 benchmark 也需要效度檢查。** 人類上限、oracle、捷徑分析與標籤可靠性缺一不可。

## 後續想追的問題

1. 五個難度等級究竟控制哪些變項；是否能做到單因子或近似單因子遞增？
2. 527K trajectories 如何生成與分割；train/test 之間如何防止 scene、object 與模板洩漏？
3. Step-level progress、spatial reasoning 與 procedural planning 的 metrics 如何定義與自動判定？
4. 五種 embodiments 是否共享 observation/action interface；跨 embodiment 比較如何校準？
5. Hardest-level 低成功率主要來自 perception、language grounding、action execution 還是 memory，消融證據是否支持作者的診斷？
