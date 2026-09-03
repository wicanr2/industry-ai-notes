# EmbodiedSkills: A Unified Framework for Orchestrating, Training, and Deploying VLA Agents

## 原文資訊

- 論文：EmbodiedSkills: A Unified Framework for Orchestrating, Training, and Deploying VLA Agents
- 作者：Wei Wang、Wenqiao Zhang、Yutong Lin、Yuqian Yuan、Tianwei Lin、Jinhao Mao、Zhenxuan Fan、Mingjian Gao、Yang Dai、Wentong Li、Zheqi Lv、Zheng Dong、Yingjie Niu、Jiaqi Zhu、Jun Xiao、Chao Li、Yueting Zhuang
- arXiv ID：2609.01281v1
- 分類：cs.RO、cs.AI
- 發表 / 更新：2026-09-01 / 2026-09-01
- 連結：[abs](https://arxiv.org/abs/2609.01281v1) / [pdf](https://arxiv.org/pdf/2609.01281v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）
- 擷取日期：2026-09-03

## 為什麼選這篇

VLA（Vision-Language-Action）模型常被描述成把影像與語言直接映射成機器人動作，但真實的長時程任務還包含另一層問題：模型提出的操作在當下是否可執行、執行結果是否真的完成子目標，以及失敗後如何恢復。這篇把焦點由單次 action prediction 移到 VLA agent 的閉環 runtime，正好位於 LLM／多模態模型與 Robotics 的交會。

值得注意的不是又加上一個 planner，而是把「模型提出動作」與「系統准許並驗證動作」分開。作者以具有型別、前置條件、輸出與事後驗證的 executable skill 作為共同介面，企圖讓規劃、低階 VLA、控制器與 verifier 在同一個可追蹤迴圈裡協作。這個問題也有直接的系統工程價值：實體 agent 的可靠性不能只依賴 prompt 要模型自律。

## 一句話理解

EmbodiedSkills 把 VLA 的技能選擇視為待審核的執行提案，由 runtime 在動作前檢查前置條件、動作後驗證結果，再依新狀態決定繼續、重規劃或恢復。

## Summary / Abstract 說了什麼

摘要將長時程具身任務拆成 perception、planning、execution、progress verification 與 recovery。作者主張，action prediction 或模型生成的 skill decision 本身都不保證操作在目前物理狀態有效，也不保證結果被確認。因此，EmbodiedSkills 用共享的 executable-skill interface 串起高階技能選擇、受界限約束的低階 VLA 執行與事後驗證。

這個介面固定後，低階 VLA policy 可被替換或調適，而不用改寫 agent loop；同一介面也會把規劃、執行、驗證與恢復事件記成結構化 trajectory，作為各元件的監督資料，並在有互動回饋時支援可選的線上調適。

摘要自稱以 Qwen3-VL 與 OpenPI/$\pi_{0.5}$ 在 RoboTwin 2.0、LIBERO 實作，並報告 task-adapted 低階 VLA policy 在 50 個 RoboTwin 2.0 任務平均成功率 86.20%、四個 LIBERO suites 平均 97.40%；但在四個需要記憶的 RMBench 任務，同一類 task-adapted execution 平均只有 12.5%。這些都是摘要中的作者報告，本次未讀方法與實驗章，不能據此判定整個 agent layer 的因果增益或比較公平性。

## Introduction 的問題設定

Introduction 先區分 **VLA policy** 與 **VLA agent**：前者從 observation 與 instruction 預測動作，後者還必須隨物理狀態演變，協調感知、規劃、執行、驗證和恢復。以「把容器放到盤子上」為例，系統不只要產生動作，還要找對物體、選子目標、判斷當前能不能執行、確認結果，並在接觸或感知失敗後恢復。

作者指出兩類既有方法各缺一半。端到端 VLA 將中間決策藏在 policy 內，失敗時難分辨是 grounding、subgoal、低階控制、進度驗證還是 recovery 出錯；LLM-based robot agent 雖可顯式輸出推理或 tool call，顯式並不等於可執行，仍可能使用過期 observation、漏掉必要參數、違反當前 task phase，或執行後未達成預期。prompt 可以引導選擇，卻不能像 runtime 一樣強制前置條件與事後驗證。

EmbodiedSkills 的回答是把每個 skill 定義成具有 typed inputs／outputs、明確 prerequisites、execution trace 與 verification signal 的合約。高階 policy 提出 structured operation，低階 VLA 只執行受界限限制的 action chunk，controller 落實命令；AgentLoop 則可依新狀態選擇重新觀察、修訂計畫、續做子目標、前進或 recovery。作者強調這不是固定的單向 pipeline，而是由演變中的 task state 決定下一個 transition。

Introduction 進一步主張，固定介面也能縮小 training-deployment gap：planner、VLA、verifier 可分別使用同一 trajectory schema 訓練或替換。這裡的核心不是要求單一模型吸收所有責任，而是讓 proposal、enforcement 與 evidence 留在可檢查的系統邊界上。

## 研究的第一性問題

### 基本問題

在會改變真實世界的 agent 中，「模型認為下一步應做什麼」是否應直接等同於「系統現在就執行什麼」？若不是，兩者中間需要什麼最小可執行合約？

### 約束

- 實體環境部分可觀察，先前產生的 observation 或 artifact 可能很快過期。
- 接觸式操作的失敗不一定能由 action token 本身辨識，必須取得執行後證據。
- 長時程任務需要在多個 phase 間合法轉移，局部合理的 skill 仍可能時序錯誤。
- 高階模型、低階 VLA、controller 與 verifier 的更新節奏不同，介面若耦合太深就難以替換。
- 記錄 trace 不等於 trace 足以歸因；感知與 verifier 也可能一起犯錯。

### 既有方法卡點

端到端 policy 的內隱決策讓失敗難診斷；純 agentic prompting 則把「建議」誤當成「執行保證」。兩者都缺少一個能在動作前後強制檢查、又能把錯誤留下結構化證據的 runtime 邊界。

### 作者試圖移動的邊界

作者試圖把 VLA 的研究單位由單一 policy 擴大成可訓練、可替換、可觀察的 agent system：policy 負責提出 skill，runtime 負責合法性，verifier 負責結果證據，trajectory 則把失敗送回後續學習。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出以 executable embodied skills 組織長時程 VLA agent 的閉環 AgentLoop。
- 用共享 skill contract 分離 policy proposal 與 runtime enforcement。
- 在執行前檢查 phase、必要輸入、artifact freshness、action validity 與合法狀態轉移，並在執行後回收 verifier 訊號。
- 以共同 trajectory schema 支援 planner、VLA、verifier 的元件級監督與可選線上調適。
- 實作 Qwen3-VL 與 OpenPI/$\pi_{0.5}$ 組合，並在多個 manipulation benchmark 報告低階 execution 結果。

### 我的保守判讀

- 最可重用的觀念是 **proposal 不等於 permission**。這比選用哪個 VLM／VLA 更接近安全關鍵 agent 的長期架構原則。
- typed skill contract 可提高可診斷性，但型別與 prerequisites 只能涵蓋設計者預先表達的風險；沒有被形式化的物理條件仍可能穿透檢查。
- post-action verifier 是閉環關鍵，也可能成為單點錯誤來源。若 verifier 誤認完成，系統會把失敗寫成成功 trajectory，反過來污染訓練。
- 摘要列出的高成功率明確屬於 task-adapted low-level policies；不能在未讀實驗前，把它直接歸因於 EmbodiedSkills agent layer。RMBench 的 12.5% 反而提醒：需要歷史狀態的任務仍很弱。
- 模組化介面可能犧牲部分端到端共同最佳化；是否值得，取決於可靠性、延遲與維護收益能否抵銷協調成本。
- 本次未讀方法與實驗，因此尚不能判斷 preflight rule 的覆蓋率、verification 的標註成本、recovery 實際觸發方式，以及完整 AgentLoop 相對低階 VLA baseline 的獨立增益。

## 可放進資料庫的筆記

1. **Proposal 不等於 permission**：生成模型提出的動作應先進入執行治理層，而不是直接連到 actuator。
2. **技能是合約，不只是文字名稱**：可執行 skill 至少應包含 typed inputs、prerequisites、允許的 state transition、輸出與驗證條件。
3. **閉環要同時有 preflight 與 postflight**：動作前排除不合法操作，動作後確認世界真的改變；只做其中一側都不完整。
4. **短 action chunk 是風險界限**：低階 policy 的執行窗口應有界，讓系統能重新觀察並阻止錯誤長時間開迴路累積。
5. **Runtime 是 Physical AI 的治理層**：prompt 屬於軟性引導，runtime 才能執行硬性限制與留下明確錯誤。
6. **Trajectory schema 是學習介面**：若規劃、執行、驗證與恢復共用事件格式，失敗資料才可能回流到不同元件。
7. **可診斷性也是模型能力的一部分**：長時程 agent 不只要成功率高，還要能辨認失敗發生在哪一層。
8. **記憶任務是系統壓力測試**：即使短子任務 execution 很強，依賴互動歷史的決策仍可能暴露 world state 與 memory 的缺口。

## 後續想追的問題

1. executable skill 的 prerequisites 與 state transition 由人工定義、模型產生，還是從資料學得？覆蓋不到的條件如何處理？
2. 完整 AgentLoop 相對相同 task-adapted VLA policy 的增益是多少，哪些 benchmark 真正測到 planning、verification 與 recovery？
3. verifier 的 false positive／false negative 如何量測，誤判會如何沿 trajectory 與線上訓練放大？
4. artifact freshness 在實際部署中如何表示；不同 sensor latency 與非同步 controller 是否會造成競態？
5. RMBench 平均 12.5% 的瓶頸位於記憶、規劃、skill selection、execution 還是驗證？
