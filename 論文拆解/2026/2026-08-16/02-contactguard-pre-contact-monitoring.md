# ContactGuard: Pre-Contact Execution Monitoring with Action-Conditioned Latent World Models

## 原文資訊

- 論文：ContactGuard: Pre-Contact Execution Monitoring with Action-Conditioned Latent World Models
- 作者：Gehan Zheng、Matthew Johnson-Roberson、Weiming Zhi
- arXiv ID：2608.13438v1
- 分類：cs.RO、cs.AI、cs.CV
- 發表 / 更新：2026-08-13 / 2026-08-13
- 連結：[abs](https://arxiv.org/abs/2608.13438v1) / [pdf](https://arxiv.org/pdf/2608.13438v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-16

## 為什麼選這篇

ContactGuard 關心的不是讓 robot policy 再多會一個技能，而是把安全判斷提前到 physical contact 之前。對接觸式 manipulation 而言，夾爪推偏物體、夾到邊緣或過早閉合後，場景已被改變；「偵測到已失敗」和「在接觸前阻止失敗」是兩個不同的系統能力。

這篇也提供一個有工程辨識度的 world-model 使用方式：不要求生成逼真的未來影像，也不侵入原本 policy，而是預測 action-conditioned future latent，再用小型 probe 判斷該 action chunk 是否應被中止。它和今日另一篇 FIRE-VLA 的價值不同：前者處理訓練期 unresolved failures；本篇處理部署期、接觸前的 execution monitoring。

## 一句話理解

ContactGuard 在機器人真正接觸物體前，先用 planned action chunk 推演未來 latent；若推演後的狀態像失敗，就提前 abort，而不是等物體已被推壞才反應。

## Summary / Abstract 說了什麼

作者針對 chunked visuomotor policy：policy 一次提出一段 action，而其中可能包含即將發生的 gripper closure 或 contact。ContactGuard 取目前多視角 observation 與同一段 planned actions，用 latent world model 預測短期後果，不進行 pixel-level video reconstruction。

Introduction 用一個簡化門檻描述中止規則：

$$
\text{abort if }P(\mathrm{fail}\mid \hat{\mathbf z}_{t+h})>\tau,
$$

其中 $\hat{\mathbf z}_{t+h}$ 是根據目前 observation 與 planned actions 預測的未來 latent，$h$ 是預測 horizon，$\tau$ 是中止門檻。直觀上，系統不是問「現在看起來是否失敗」，而是問「照這段動作走下去，接觸後的表示是否像失敗」。

**論文自稱：**latent world model 先用未標註 robot trajectories 學習 action-conditioned next-latent prediction；之後凍結 encoder 與 predictor，只用少量標註 pre-contact clips 訓練 lightweight failure probe。部署時，它掃描 action chunk 中的 imminent contact event，在接觸前固定 anchor、向前 rollout，再決定是否 abort。

摘要宣稱，ContactGuard 在真實 contact-rich manipulation tasks 上，比直接判斷與 corrupted-action ablations 更準，並可作為 live robot 的 pre-contact abort signal，不需修改底層 policy。本次未讀實驗章節，因此未核對任務數量、錯誤率、latency 與 false-abort 成本。

## Introduction 的問題設定

Introduction 從接觸的不可逆性切入：wrist camera 靠近物體有利於觀察接觸細節，但當畫面終於足以確認 miss、slip 或錯位時，gripper 可能已經推動物體。這使 conventional post-hoc detector 太晚。chunked policy 則提供自然的預測單位：若 action chunk 中含有明確接觸事件，monitor 可以在執行前先評估其後果。

作者接著縮小 world model 的任務。監控不必生成 photorealistic frame，只要保留與成功或失敗有關的 outcome information。ContactGuard 因此採 joint-embedding prediction：將 multi-view observations 壓成 latent，直接學習 latent 在 action 條件下如何變化，以避開 pixel generation 的成本與多解性。

系統定位是 policy-decoupled predictive verifier。原 policy 被視為 black-box proposer；monitor 只消費目前 observation 與 policy 已提出的具體 action chunk，不需讀取 policy internals 或共同訓練。這讓「提出動作」與「核准即將接觸的動作」成為兩個可分離模組。

## 研究的第一性問題

- **基本問題：**能否在 physical contact 發生前，從目前 observation 與即將執行的 action 預測這次接觸是否會失敗？
- **約束：**判斷必須早於 contact、latency 足以支援 online abort；不應依賴昂貴像素級影片生成，也不應要求重訓或修改原 policy。
- **既有方法卡點：**只看目前畫面可能尚未出現失敗證據；等接觸後再偵測，物體與場景已被擾動；只看 raw action 又缺少 action 與 scene geometry 的交互後果。
- **作者試圖移動的邊界：**將 latent world model 從 planner 或 representation learner，轉成可旁掛於既有 policy 的 predictive verifier。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出 chunked visuomotor policy 的 pre-contact execution monitoring 問題。
- 以未標註 robot trajectories 訓練 action-conditioned multi-view latent predictor，再以少量標註資料訓練 failure probe。
- 用 policy 自己提出的 action chunk 預測 post-contact latent，並在 contact 前做 abort 決策。
- 宣稱 predicted future latent 提供 current latent 或 raw planned actions 所沒有的 failure information。
- 不修改底層 policy、不做 candidate action search，也不生成 pixel-level future video。

### 我的保守判讀

- 「policy-decoupled」有利於模組化，但 monitor 的訓練分布仍可能和特定 policy、camera setup、action chunking 強耦合；能否跨 policy 並非由介面解耦自動保證。
- 提前 abort 的價值取決於 precision-recall 與代價函數。漏報可能造成碰撞，誤報則可能讓 robot 在可恢復情境頻繁停機；只說分類較準仍不足以決定部署門檻。
- latent prediction 避開影像生成成本，不代表 online latency 已符合控制頻率。本次未讀方法與實驗，不能判斷運算預算。
- 以 gripper closure 作為 anchor 對抓取很自然，但推、插、旋、持續接觸等任務的 contact event 未必有單一清楚時點。
- monitor 目前只做 abort，不做 recovery 或 action correction；它把失敗從物理後果改成安全停機，但未完成閉迴路復原。

## 可放進資料庫的筆記

1. **偵測時間本身是安全變數：**相同準確率的 detector，若一個在接觸前、另一個在接觸後，系統價值完全不同。
2. **world model 不一定要生成世界：**若決策只需要 outcome-relevant state，latent prediction 可能比 photorealistic video 更合適。
3. **proposal 與 verification 可分離：**policy 提出 action，旁路 verifier 根據同一 action 的預測後果決定是否放行。
4. **current-state classifier 有資訊上限：**某些風險只在「狀態 × 即將執行的動作」組合中可見，不能只看目前畫面。
5. **大量無標註 dynamics、小量 outcome labels：**先學通用 latent transition，再用小 probe 接上部署判斷，是 Physical AI 的常見資料效率分工。
6. **安全門檻要用成本校準：**$\tau$ 不只是分類閾值，而應反映誤停機、漏報、物體損傷與人工介入的相對成本。
7. **abort 不是 recovery：**預測式防護層能阻止災難，但完整 autonomy 還需要重規劃、重定位或人機交接。
8. **介面解耦不等於分布解耦：**black-box policy integration 容易，不代表 monitor 對 unseen policy actions 自然泛化。

## 後續想追的問題

1. monitor 從 anchor 到 abort 的端到端 latency，與原 policy control frequency 的關係為何？
2. false positive、false negative 如何定義與權衡；不同 $\tau$ 下的 safety/availability 曲線為何？
3. corrupted-action ablation 排除了哪些捷徑，能否證明 predictor 真正在利用 action-conditioned dynamics？
4. 更換底層 policy、相機視角、gripper 或物體材質後，需要多少資料重新校準？
5. abort 後的恢復策略是什麼；monitor 能否進一步排序 candidate actions 或提供 correction direction？
