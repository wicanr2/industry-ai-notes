# Evolve Vision-Language-Action Model into an Agent with On-the-fly Tool-use

## 原文資訊

- 論文：Evolve Vision-Language-Action Model into an Agent with On-the-fly Tool-use
- 作者：Yi Ding、Yanzhao Yu、Xili Dai、Xianbiao Qi、Peiwen Sun、Xueqian Wang、Xiangyu Yue、Jianan Wang
- arXiv ID：2608.14047v1
- 分類：cs.RO、cs.AI、cs.CV
- 發表 / 更新：2026-08-14 / 2026-08-14
- 連結：[abs](https://arxiv.org/abs/2608.14047v1) / [pdf](https://arxiv.org/pdf/2608.14047v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-17

## 為什麼選這篇

這篇把 LLM agent 常見的 tool use 問題帶進 VLA 控制：不是讓機器人只在「模組式規劃器」與「端到端連續控制」之間二選一，而是探索端到端 VLA 能否在需要時注入現成工具，同時保留原本的精細動作生成能力。

它和今日另一篇 Reflex 的價值不同。Reflex 處理動態環境中的預測與延遲；ART 則處理能力擴充的介面與 action solution space。後者關係到機器人 foundation model 如何避免每遇到新感知條件、空間推理需求或 embodiment 就全面再訓練，因此有獨立的架構與資料策略價值。

## 一句話理解

ART 試圖讓端到端 VLA 保留連續動作的精細度，又能在必要時像 agent 一樣呼叫外部工具，把新能力以較模組化的方式接進來。

## Summary / Abstract 說了什麼

摘要將 ART（Agentic Robot with Tool-use）描述為 tool-injection framework，可調整 VLA 使用現成模組，涵蓋低階視覺、高階 affordance 與 embodiment enhancement。作者的核心直覺是：相較於直接在完整連續 action space 中求解，適時呼叫工具能縮小當下的解空間，因此可能提高跨任務一般化並降低資料依賴。

**論文自稱：**作者建立 30K tool-use trajectories 與 action demonstrations，設計 long-trajectory tool-use reasoning 的訓練流程；摘要報告，ART 在模擬與真實任務上比主流基線高 20% success rate，例如新視角下的暗處 pick-and-place。摘要也主張模組化工具可帶來較有效率的訓練、輕量部署及新工具擴充。

這裡的「action solution space 變小」應保守理解：工具相當於把某些複雜子問題壓縮成可選的高階操作，但整體系統仍需決定何時呼叫、參數如何給、輸出是否可信，以及何時回到連續控制。它是搜尋與介面的重構，不代表困難自然消失。

## Introduction 的問題設定

Introduction 將 VLA 路線分成 modular 與 end-to-end。模組式方法把動作執行、目標辨識等能力封裝成工具 API，能力彼此解耦，但固定工具集與 action functions 可能限制輸出形式；端到端方法則用大規模多任務資料訓練單一模型，能產生精細連續動作，但遇到新場景或新任務時，後訓練昂貴，能力耦合也可能造成 catastrophic forgetting。

作者因此提出一個混合問題：能否保留端到端 VLA 的精細動作，又快速整合外部工具？ART 的回答是以 fine-tuning 做 tool injection。Introduction 說明的資料生成流程包含 task design、reasoning generation 與 tool-trajectory synthesis：先把既有 VLA 資料改造成必須使用工具的任務，再由 base VLA 產生工具推理，最後合成完整軌跡。

為避免新工具資料破壞原 action policy，作者在 Introduction 中描述兩階段 LoRA fine-tuning：原 VLA 權重凍結，工具推理使用專屬 LoRA；工具使用完畢、回到 action generation 時遮蔽 LoRA 輸出。這是一個明確的能力隔離假設：新增的 tool reasoning 透過 adapter 學習，原始動作生成則盡量走回既有模型路徑。

## 研究的第一性問題

- **基本問題：**如何擴充 VLA 的感知、推理與 embodiment 能力，而不為每個新情境重新學完整的連續控制 policy？
- **約束：**工具集有邊界，端到端 action 又容易與新資料耦合；系統必須在工具選擇、長鏈調用與精細動作之間保持一致。
- **既有方法卡點：**純 modular 方法可能受限於預定義 API；純 end-to-end 方法的新增能力成本高，且可能 catastrophic forgetting。
- **作者試圖移動的邊界：**把工具當成可注入 VLA 的能力介面，以 adapter 隔離 tool reasoning 與原始 action generation，建立 modularity 與 end-to-end control 之間的中間層。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出可把多模態工具注入 VLA 的 ART framework，保留原 action generation，同時加入工具推理。
- 提出從既有 VLA dataset 合成 tool-use data 的三步流程，減少重新收集 action data 的需求。
- 以專屬 LoRA 學工具推理，並在 action generation 時遮蔽其輸出，以降低 catastrophic forgetting。
- 宣稱 30K 軌跡即可改善新場景、物件與動作指令下的 robustness，並在模擬與真實環境取得較高成功率。

### 我的保守判讀

- 工具化是否真的降低「資料依賴」，要比較 30K 軌跡之外的 base VLA 預訓練成本、工具開發成本與合成資料生成成本；摘要只給局部資料量。
- base VLA 參與 reasoning generation，可能把既有盲點帶進合成 tool trajectories。需要核對資料驗證、錯誤過濾與 teacher dependence。
- 在 action generation 階段遮蔽 LoRA 有利於能力隔離，但也可能切斷工具輸出與低階控制需要的深度融合；何種工具適合這種邊界仍未知。
- 「高 20% success rate」缺少本次閱讀範圍內的分母、絕對成功率、任務平均方式與不確定性，不能直接外推為普遍優勢。
- off-the-shelf tool 的延遲、失效、輸出校準與安全權限會成為新的系統風險；Introduction 的架構主張尚不足以證明可安全擴充任意工具。

## 可放進資料庫的筆記

1. **工具是 action-space abstraction：**它把部分連續或高維問題封裝成較少的離散決策，但會新增選擇、參數化與驗證責任。
2. **模組化與端到端不是二元選擇：**可用 adapter、router 或 execution boundary 形成不同程度的能力耦合。
3. **能力注入要同時設計能力退出：**何時啟用 LoRA 很重要，何時停用並回到原 policy 同樣重要。
4. **資料重用可以靠反事實加難：**把既有任務改造成必須用工具的情境，是擴充 agent trajectory 的一種方式；但合成品質需要獨立檢查。
5. **保留原能力不等於新舊能力已整合：**避免 forgetting 只是一條底線，工具結果是否能可靠影響連續控制仍需另測。
6. **工具介面會成為 foundation model 的擴充槽：**若介面穩定，新感知器、affordance estimator 或 embodiment adapter 可少改核心 policy。
7. **Physical AI 的 tool use 代價更具體：**文字 agent 呼叫失敗常是錯答；robot tool chain 的延遲或誤判可能直接造成動作風險。

## 後續想追的問題

1. ART 的工具集合、call schema 與控制流程為何；工具是否可在 action chunk 執行中途介入？
2. 30K 軌跡的任務分布、base dataset 比例與品質過濾方式為何，reasoning 是否由同一 VLA 自我生成？
3. 20% 是絕對百分點或相對改善；各任務、各工具與不同 base VLA 的效果是否一致？
4. LoRA 遮蔽如何實作，工具輸出以何種 representation 傳回原 action generator？
5. 遇到工具超時、錯誤輸出、互相衝突或未見工具時，系統如何偵測、回退與維持安全？
