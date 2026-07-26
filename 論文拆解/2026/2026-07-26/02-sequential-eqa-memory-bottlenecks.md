# Beyond Episodic Evaluation: Memory Architectural Bottlenecks in Sequential Embodied Question Answering

## 原文資訊
- 論文：Beyond Episodic Evaluation: Memory Architectural Bottlenecks in Sequential Embodied Question Answering
- 作者：Zikui Cai；Kaushal Janga；Tan Dat Dao；Seungjae Lee；Shivin Dass；Mingyo Seo；Kaiyu Yue；Mintong Kang；Nandhu Pillai；Monte Hoover；Aadi Palnitkar；Ruchit Rawal；Ruijie Zheng；Bo Li；Yuke Zhu；Roberto Martín-Martín；Tom Goldstein；Furong Huang
- arXiv ID：2607.21571v1
- 分類：Robotics (cs.RO)
- 發表 / 更新：2026-07-23 / 2026-07-23
- 連結：[abs](https://arxiv.org/abs/2607.21571) / [pdf](https://arxiv.org/pdf/2607.21571)
- 本次閱讀範圍：Summary/Abstract + Introduction
- 擷取日期：2026-07-26

## 為什麼選這篇

這篇聚焦 Embodied Question Answering（EQA）的評估假設：很多 benchmark 把每個問題當成獨立 episode，回答完就重置 agent 狀態；但真實機器人不會每問一個問題就失憶。它需要在同一個場景中連續運作，累積、保留、選擇性重用先前看到的資訊。

我選它，是因為它把 LLM/VLM for robotics 的一個核心問題從「單題答對率」移到「長時間記憶架構」。在 embodied AI 裡，語言理解與視覺 grounding 只是起點；若 agent 每次都重新探索環境，系統成本會很高，也不符合連續部署的需求。這跟近期 LLM agent memory、robot world model、persistent scene representation 都有連接。

它也提醒我們：把 episodic benchmark 成績視為真實機器人能力，可能會高估系統成熟度。連續任務的記憶不是把歷史 context 全塞回去就好，而是需要決定保存什麼、忘記什麼、如何檢索、如何避免舊資訊干擾新問題。

## 一句話理解

這篇研究想檢驗：當 embodied QA agent 不再每題重置，而是在同一場景中連續回答多個問題時，現有記憶架構會在哪些地方變成瓶頸？

## Summary / Abstract 說了什麼

摘要指出，EQA 傳統上採 episodic formulation：agent 每次獨立解任務，episode 之間重置 internal state。可是現實世界的機器人需要連續運作，並且把先前互動取得的資訊保留下來、在後續問題中重用。

作者研究不同 memory architectures 在 sequential evaluation 下的表現：多個問題在同一場景中依序回答，memory 會跨 query 保留。摘要的核心立場是，單純保存 experience 不一定會一致改善表現；不同記憶表示、更新方式與檢索策略可能會暴露架構瓶頸。也就是說，從 episodic 到 sequential，不只是 benchmark 設定改一下，而是會改變 agent 設計的壓力點。

摘要把問題放在「持續性 embodied agent」而非單次 EQA 任務。這和 LLM agent 的長期記憶問題類似，但多了物理空間、導航、觀測成本與場景變化等限制。

## Introduction 的問題設定

Introduction 先定義 EQA：agent 在部分可觀測 3D 環境中收到自然語言問題，例如「廚房檯面上的杯子是什麼顏色？」它需要移動、收集視覺觀測、判斷證據是否足夠，最後回答。早期 EQA 依賴主動感知、定位、建圖與避障等模組；近年 LLM / VLM 提升了語言 grounding 與不完整場景推理能力。

問題在於，大多數評估仍採 episodic 設定。每一題都是獨立任務，agent 的 internal state 在 episode 間被清空。Introduction 認為，這與真實部署越來越不一致：家用助理、搜救、倉儲物流等場景裡，機器人會長時間存在於同一環境，不應該每次問題都從零探索。

可以用一個簡化狀態式理解 sequential EQA：

$$M_t = \mathrm{Update}(M_{t-1}, o_t, a_t, q_t)$$

其中 $M_t$ 是第 $t$ 次互動後的記憶狀態，$o_t$ 是觀測，$a_t$ 是行動，$q_t$ 是問題。episodic evaluation 等於每題都把 $M_{t-1}$ 重設成空；sequential evaluation 則要求系統處理記憶累積的好處與副作用。

Introduction 的關鍵缺口是：我們還不清楚哪些 memory architecture 真正支援 sequential EQA。保留完整軌跡可能成本高、檢索難，也可能引入過期或無關資訊；壓縮成 scene graph 或語意摘要則可能丟掉之後問題需要的細節。

## 研究的第一性問題

- **基本問題**：如果 embodied agent 要長時間在同一環境回答多個自然語言問題，它應該如何保存與使用過去觀測？
- **約束**：環境是部分可觀測的；每次探索有時間與行動成本；記憶容量、檢索成本與資訊新鮮度都有限；舊資訊可能幫助也可能干擾。
- **既有方法卡點**：episodic benchmark 會遮蔽記憶架構問題；單純把 experience 保留下來不代表能有效回答後續問題；LLM/VLM 的語言推理能力不能自動解決空間記憶管理。
- **作者試圖移動的邊界**：把 EQA 評估從單題 reset 轉向 sequential protocol，讓 memory representation / update / retrieval 成為可觀察的系統瓶頸。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 指出 episodic EQA 與真實連續機器人部署之間的落差。
- 提出或使用 sequential evaluation protocol，在同一場景中連續回答多個問題並跨 query 保留 memory。
- 比較不同 memory architecture 在 sequential EQA 下的行為，強調單純保留 experience 不一定帶來一致收益。
- 把記憶架構視為 embodied QA 的核心瓶頸，而不是附屬工程細節。

### 我的保守判讀

- 這篇的價值在於評估 framing：它把「agent 是否會使用過去經驗」變成主要問題，而不是只看單題 QA 表現。
- 真正難點可能不是記憶容量，而是記憶選擇：哪些空間 / 物件 / 屬性值得保存，何時需要重新確認，何時該忘記。
- sequential EQA 會更接近真實機器人，但也更難控制變因；問題順序、場景密度、問題關聯性都會影響結果。
- 本次沒有讀實驗章節，因此不能判斷哪些 memory architecture 表現最好，也不能引用具體數字或結論強度。

## 可放進資料庫的筆記

1. **Episodic benchmark 可能低估記憶問題**：每題 reset 會讓 agent 不必處理長期狀態管理。
2. **Embodied memory 不只是 LLM context**：它包含空間位置、物件屬性、觀測時間、行動成本與不確定性。
3. **保存經驗不等於可用記憶**：若沒有好的檢索、壓縮與更新機制，更多歷史可能只是噪音。
4. **Sequential evaluation 改變能力排序**：在單題強的系統，不一定在連續場景中穩定。
5. **記憶架構是 Physical AI 的控制面**：它決定 agent 如何把過去觀測轉成未來行動節省。
6. **場景知識有時需要重新驗證**：長期記憶不能假設環境永遠不變。
7. **問答只是表面任務，底層是世界狀態維護**：EQA 可以被看成 embodied world model 的可觀測切面。

## 後續想追的問題

1. 論文比較了哪些 memory representation：raw trajectory、semantic map、scene graph、LLM summary，還是 hybrid memory？
2. sequential protocol 如何控制問題順序？問題之間是否有刻意設計的資訊依賴？
3. 單純保存更多 experience 何時會傷害表現？是 retrieval 失敗、context overload，還是舊資訊污染？
4. 是否有 real-robot validation？若有，與模擬或 benchmark 結果是否一致？
5. 這種 sequential EQA 評估能否延伸到 language-conditioned manipulation 或 mobile manipulation？
