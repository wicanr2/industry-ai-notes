# Do Better Imagined Rollouts Mean Better Robot Control? A Controlled Study of World-Model Evaluation Under Feedback

## 原文資訊

- 論文：Do Better Imagined Rollouts Mean Better Robot Control? A Controlled Study of World-Model Evaluation Under Feedback
- 作者：Dharini Raghavan、Amritpal Singh
- arXiv ID：2609.02811v1
- 分類：cs.RO
- 發表 / 更新：2026-09-02 / 2026-09-02
- 連結：[abs](https://arxiv.org/abs/2609.02811v1) / [pdf](https://arxiv.org/pdf/2609.02811v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Methods、Experiments、Results 與附錄
- 擷取日期：2026-09-04

## 為什麼選這篇

Physical AI 常用 world model 的長 rollout 誤差判斷模型好壞，但機器人真正運作時通常會持續取得感測、校正狀態並重算控制。這篇論文直接問一個容易被忽略的評估問題：離線想像得比較準，是否真的代表閉迴路控制得比較好？

它沒有直接處理大型視覺 world model，而是刻意退回差動輪機器人與狀態估測器，以控制變因分離 prediction horizon、measurement update 與 feedback。這個簡化有範圍限制，卻能提供一個可重用的評估觀念：模型指標應模擬部署時的資訊回饋節奏，而不是只比較最長、最難的無觀測 rollout。

## 一句話理解

評估用於閉迴路控制的 world model 時，重要的不只是假想軌跡能滾多遠，也包括 rollout 期間是否按照實際部署節奏接受感測校正。

## Summary / Abstract 說了什麼

作者在有里程計偏差、地標感測間歇出現的差動輪路徑追蹤任務中，比較六種狀態估測器、24 種感測條件，以及三種評估：固定軌跡 replay、20 步無量測 rollout、實際閉迴路追蹤。

摘要以 Spearman 等級相關係數衡量「離線指標對模型排序」與閉迴路排序的一致程度。若 $r_i$ 與 $s_i$ 是第 $i$ 個模型在兩種評估中的名次，且沒有同名次，則

$$
\rho = 1 - \frac{6\sum_i (r_i-s_i)^2}{n(n^2-1)}.
$$

$\rho$ 越接近 1，代表兩套指標對模型優劣的排序越一致。論文摘要報告：replay position RMSE 與 closed-loop cross-track RMSE 的 $\rho=0.923$，高於 20 步無量測 rollout 的 $\rho=0.774$；前者在 24 個條件中有 5 次沒有選到閉迴路最佳估測器，後者有 18 次。

作者也把 rollout horizon 與量測更新間隔拆開。固定 $H=20$ 時，每步更新量測的排序相關為 $\rho=0.916$，完全不更新時降到 $\rho=0.774$。摘要據此主張：長 horizon 並不必然是問題；缺少與部署一致的校正節奏，才可能讓 rollout 排名偏離閉迴路表現。

摘要另稱，讓 recurrent estimator 在訓練中看更長的感測中斷，對部分 EKF-anchored 模型與綜合退化條件有幫助，但效果無法一致延伸到所有中斷型態或架構。以上數字皆是論文自稱；本次沒有閱讀結果章核驗其統計設計與不確定性。

## Introduction 的問題設定

Introduction 先指出，prediction model 已介入狀態估測、規劃、候選控制評分，甚至直接產生控制命令；但慣用的 state prediction error、reconstruction error 或 multi-step rollout error，通常是在離線環境衡量 fidelity。

真正的機器人系統則形成 feedback loop：控制器依目前估測決定動作，機器人移動，感測器帶回新量測，狀態再校正，接著重算控制。誤差的影響因此不只取決於大小，也取決於何時發生、如何改變控制，以及何時被新觀測修正。長時間無觀測 rollout 測到的，其實是「沒有外部校正時的狀態傳播能力」，不必然等於正常閉迴路部署。

作者認為，在大型 visual world model 上直接拆解這件事很困難，因為 representation error、learned dynamics、action conditioning、observation frequency、policy 與 replanning 同時改變。因此論文使用簡化且可控的移動機器人設定，把 estimator 當作小型 predictive model，在相同模型上對照有量測校正與無觀測 rollout。

Introduction 宣稱三個主要結論：指標應符合預定系統的 sensing schedule；horizon 與 update interval 必須聯合描述；針對較長 observation gap 訓練，不保證普遍提升閉迴路穩健性。

## 研究的第一性問題

- **基本問題**：離線 prediction metric 是否能正確排序真正放進 feedback loop 後的模型？
- **約束**：閉迴路中，模型誤差會改變動作，動作又改變下一次觀測與軌跡，不能把 prediction 與 control 完全切開。
- **既有方法卡點**：只固定 rollout horizon，卻不說量測何時回來，會把部署中的重要資訊結構拿掉。
- **作者試圖移動的邊界**：把 world-model evaluation 從單一「預測多準」指標，移向「在什麼 horizon、量測更新節奏與 feedback 結構下預測多準」。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 以受控 testbed 比較 replay、measurement-free rollout 與 closed-loop tracking。
- 分離 rollout horizon 和 measurement-update interval 對模型排序一致性的影響。
- 顯示 observation-free rollout 可能比含部署式校正的評估更容易選錯 estimator。
- 檢查延長訓練 sensing outage 是否提升閉迴路 robustness，並得到條件相依而非普遍正向的結果。

### 我的保守判讀

- 最有價值的是問題定義，而不是把特定相關係數直接外推到大型 VLA 或視覺 world model。
- 差動輪、已知地標與 state estimator 的設定刻意簡化了語義感知、影像生成、接觸動力學與 policy adaptation；它證明評估設計可能失真，但尚未證明同樣的排序差距會出現在大型模型。
- Spearman $\rho$ 描述排序一致性，不能單獨回答差異是否具統計穩健性，也不能說明控制失敗的嚴重程度；要讀結果與附錄才能判斷。
- 若部署真的需要長時間無感測自主推演，measurement-free rollout 仍是合理壓力測試。論文較像要求「與使用情境對齊」，而不是否定長 rollout。

## 可放進資料庫的筆記

1. **部署同構評估**：評估時應重現部署中的 observation、correction、replanning 節奏。
2. **horizon 不等於 feedback gap**：想像 20 步，與 20 步完全收不到量測，是兩個不同實驗變數。
3. **排序比平均誤差更接近選型問題**：若目的是挑模型，應檢查 offline metric 是否選到 closed-loop 最佳者。
4. **誤差結構比誤差量級多一層**：同樣 RMSE 的誤差，可能因方向、時點與控制器敏感度而造成不同後果。
5. **簡化 testbed 可做機制辨識**：先在可控系統拆變因，再到大模型驗證，比直接在複雜 benchmark 猜原因更可靠。
6. **robust training 要和 estimator 結構一起看**：增加 sensing blackout 並非架構無關的通用增益。
7. **評估報告最少要附兩軸**：prediction horizon 與 measurement-update schedule，不宜只報前者。

## 後續想追的問題

1. 結果章是否提供相關係數的信賴區間、顯著性與對初始條件的敏感度？
2. 哪些 error direction 或 temporal pattern 對 controller 最具破壞性？
3. 將 replay metric 換成 policy-aware 或 task-weighted error，是否比單純 position RMSE 更穩定？
4. 在視覺 world model、接觸式 manipulation 與 VLA replanning 中，update interval 的效應是否仍成立？
5. 如何設計同時涵蓋正常 feedback 與感測失效壓力測試的評估矩陣？
