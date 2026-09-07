# R2S-Eval: Robot Evaluation with Real-to-Sim Calibration via Vision-Language Models

## 原文資訊
- 論文：R2S-Eval: Robot Evaluation with Real-to-Sim Calibration via Vision-Language Models
- 作者：Yidi Wang、Feixiang Ruan、Ruoqu Chen、Jie Yin、Yang Yu、Mengdi Xu、Kaifeng Zhang
- arXiv ID：2609.03276v1
- 分類：cs.RO
- 發表 / 更新：2026-09-03 / 2026-09-03（v1）
- 連結：[abs](https://arxiv.org/abs/2609.03276v1) / [pdf](https://arxiv.org/pdf/2609.03276v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Methods、Experiments、Results 與附錄
- 擷取日期：2026-09-07

## 為什麼選這篇

Robot foundation models 與 VLA 的進展會把瓶頸推向評估：候選政策越多、硬體 rollout 越昂貴，單靠人工重設場景與計算成功率就越難支撐快速迭代。這篇不是再提出一個控制模型，而是重做「如何形成可信的政策排序」這個基礎設施問題。

它同時連接三個值得追蹤的方向：以 real-to-sim 降低實機重複操作、以完整 rollout video 保留行為品質、以 VLM 進行 pairwise preference 判讀。這個組合很有潛力，也有明顯風險：模擬校準誤差與 VLM judge 偏差可能串接成新的代理指標。正因為如此，它適合作為 Physical AI 評估治理的筆記，而不只是自動化測試工具。

## 一句話理解

R2S-Eval 想用校準後的模擬器產生接近實機的 rollout，再讓 VLM 比較完整行為影片，將昂貴且粗糙的實機成功次數轉成可擴展的政策偏好排序。

## Summary / Abstract 說了什麼

摘要指出傳統實機評估有三個問題：需要反覆重設與監看硬體，重複評估可能得到不同政策排名，而且 binary success rate 無法描述動作品質、修正行為或失敗前進度。人類看機器人表現時，通常會比較完整過程，而不只看最後成功與否。

R2S-Eval 因此先建立與真實評估場景校準的 simulator，產生候選政策的 rollout videos；再由 VLM 對影片配對進行 execution-quality preference 判斷，最後聚合成政策排名。作者也提出一套 validation protocol，檢查排序是否穩定、是否與人類偏好一致、是否減少實機操作，以及是否揭露成功率以外的行為差異。

可把整體主張概念化為：

$$
\text{real calibration}\rightarrow \{v_{i,k}\}\rightarrow
P(i\succ j\mid v_{i,k},v_{j,l})\rightarrow \operatorname{rank}(\pi_1,\ldots,\pi_n),
$$

其中 $v_{i,k}$ 是政策 $\pi_i$ 的第 $k$ 段模擬 rollout 影片，$P(i\succ j)$ 是 VLM 對政策 $i$ 的行為優於政策 $j$ 的偏好判斷。這是依摘要與 Introduction 做的流程化表示，不是論文原式。

**論文自稱**：摘要表示模擬與真實實驗顯示 R2S-Eval 能形成可靠、穩定的政策結論，與人類偏好一致，減少重複硬體操作，並辨認 binary success 未捕捉的行為品質差異。本次未讀實驗章節，無法核對校準程度、judge 設定、樣本數與排名不確定性。

## Introduction 的問題設定

Introduction 先把評估定位成模型改進迴路的一部分：好的評估不只報分，也要暴露優勢、失敗模式，並回頭指引資料蒐集與訓練。現行流程通常把 generalist policy 針對下游任務微調，再部署到人工配置的實體場景，重複執行並按成功率排名。

作者認為這個流程可用，但不容易規模化。每次 trial 都需要場景設定、機器人執行、物體復位與硬體監控；物體位置、接觸、感知或機器人狀態的小變化，又可能讓排名不穩定。成功率還把過程壓成一個 bit：同樣成功的兩段動作可能一段平順、一段充滿危險修正；同樣失敗也可能有完全不同的任務進度。

若改看 rollout video，人類可以對完整行為作相對比較，但實機影片依然昂貴，人工比較也增加標註負擔。因此作者把問題拆成兩個：如何有效取得與真實世界一致的行為影片，以及如何自動判斷影片品質並反映人類偏好。R2S-Eval 分別以 real-to-sim calibration 與 VLM preference evaluation 回答。

## 研究的第一性問題

- **基本問題**：如何在有限實機預算下，可靠地比較多個機器人政策的完整行為品質？
- **約束**：實機 rollout 昂貴且有磨損／安全成本；場景難完全重現；成功率資訊過粗；人工影片標註也不便宜。
- **既有方法卡點**：增加實機 trial 能降低抽樣不穩定，卻線性增加操作負擔；只換成模擬成功率，又可能失去 sim-to-real 與行為品質資訊。
- **作者試圖移動的邊界**：把實機從主要樣本產生器改為校準與驗證錨點，把大部分比較移到校準模擬 rollout 與 VLM pairwise judging。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 將 manipulation policy evaluation 重新表述為完整 rollout 行為的偏好估計，而非只計算 binary success。
- 提出 real-to-sim calibration、模擬閉環 rollout、VLM pairwise preference 與 ranking aggregation 的整體 pipeline。
- 提出多軸 validation protocol，涵蓋可靠性、穩定性、人類一致性、硬體人力與行為資訊量。
- 摘要宣稱模擬與真實設定下可得到穩定且與人類一致的政策結論。

### 我的保守判讀

- 這是一個 **evaluation stack**，不是單一評分器。任何一層——場景校準、政策模擬適配、影片呈現、VLM prompt、偏好聚合——都可能改變最終排名。
- Pairwise preference 能增加資訊密度，但不是自動等於客觀品質；VLM 可能偏好看起來平順、語意容易描述的行為，而漏掉接觸力、安全裕度或硬體負荷。
- Real-to-sim 可減少重複實機試驗，但不能消除 reality gap。若不同政策受模擬誤差影響不對稱，排名可能穩定卻穩定地錯。
- 「與人類偏好一致」仍需追問人類標註者、rubric、任務風險與一致性。偏好適合補足成功率，不宜在未驗證前取代安全及物理量測。

## 可放進資料庫的筆記

1. **Physical AI 的擴展瓶頸不只在資料與模型，也在可重複評估。**
2. **成功率是結果壓縮，不是完整行為品質。** 它會丟掉路徑、修正、效率與失敗進度。
3. **Real-to-sim 的角色可以是評估代理，而不只訓練資料來源。**
4. **自動 judge 應與生成 rollout 的系統分層驗證。** 不然 simulator bias 與 judge bias 會被一個總分掩蓋。
5. **穩定排名不等於正確排名。** 需要實機錨點、人類一致性與跨場景敏感度共同檢查。
6. **Pairwise comparison 往往比絕對分數容易，但比較圖如何聚合仍會影響全域排序。**
7. **評估成本應拆成實機時間、人力復位、設備風險、模擬建模與 judge inference。**
8. **VLM 看得到的品質與機器人真正承受的物理品質不是同一集合。** 力矩、碰撞裕度與熱負荷可能不在影片中。

## 後續想追的問題

1. Real-to-sim calibration 需要多少實機資料、人工建模與每任務調整？
2. 候選政策是否需要用模擬資料再適配；這會不會改變原本要評估的政策？
3. VLM judge 使用何種 rubric、prompt 與影片採樣方式，對順序及視角是否敏感？
4. Pairwise preferences 如何聚合，是否報告排名信賴區間與循環偏好？
5. 哪些真實失敗無法由視覺影片判斷，必須保留力覺、安全或硬體 telemetry？
