# FIRE-VLA: Failure-Informed Self-Evolution for Vision-Language-Action Models in Autonomous Driving

## 原文資訊

- 論文：FIRE-VLA: Failure-Informed Self-Evolution for Vision-Language-Action Models in Autonomous Driving
- 作者：Hao Dou
- arXiv ID：2608.13395v1
- 分類：cs.RO
- 發表 / 更新：2026-08-13 / 2026-08-13
- 連結：[abs](https://arxiv.org/abs/2608.13395v1) / [pdf](https://arxiv.org/pdf/2608.13395v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-16

## 為什麼選這篇

這篇位於 VLA、autonomous driving 與 reinforcement-learning post-training 的交會。它沒有把所有失敗 rollout 都當成同一種訓練訊號，而是鎖定一個具體缺口：同一 prompt 的整組軌跡都很差、reward 又彼此接近時，相對排序只能告訴模型「哪個比較不差」，未必提供離開失敗區域的方向。

它值得收錄的地方，在於把「失敗樣本」從被動的低分資料改成下一輪 policy 的路由條件，並以同尺度、凍結的 round-start model 配合隱藏未來軌跡提供 privileged supervision。這是 robot/VLA self-improvement 很實際的設計題：如何補充 corrective information，同時避免依賴更大的外部 teacher。

## 一句話理解

當一組 VLA rollout 全部失敗、相對 reward 無法指出逃生方向時，FIRE-VLA 讓同一模型的凍結副本看見未來軌跡，針對這些 unresolved failures 提供下一輪修正訊號。

## Summary / Abstract 說了什麼

GRPO（Group Relative Policy Optimization）會對同一輸入取一組 rollout，利用組內 reward 差異更新 policy。若第 $i$ 個 rollout 的 reward 是 $r_i$，可把相對優勢直觀寫成：

$$
A_i \propto r_i-\operatorname{mean}(r_1,\ldots,r_G),
$$

其中 $G$ 是 rollout 數，$A_i$ 表示第 $i$ 條軌跡相對於組內平均的好壞。問題是：若所有 $r_i$ 都低且相近，這個訊號仍能排序失敗，卻未必說明成功區域在哪裡。作者稱這類群組為 unresolved failure groups。

**論文自稱：**FIRE-VLA 以低 reward、低 diversity 作為路由條件，讓這些群組接受 privileged self-distillation；一般 GRPO 則仍對所有群組持續生效。teacher 是每輪開始時凍結的同尺度模型，只有 teacher 能看到 hidden future trajectory；supervision 沿著 student 已生成的 prefix，只施加在 trajectory-answer tokens。每輪更新後的新 policy 再成為下一輪 teacher 的起點。

摘要報告：在同一 Qwen2.5-VL-3B SFT checkpoint、相同 student rollout 與 policy update 數量下，FIRE-VLA 的單次採樣規劃表現與標準 GRPO 相近；四次隨機 rollout 的平均 L2 error 從 1.848 降到 1.500 公尺，持續性失敗比例從 13.03% 降到 11.20%。作者同時說明，平均誤差改善主要來自少數嚴重失敗變少，而不是一般軌跡全面改善。本次未讀實驗章節，未核對統計不確定性與評估細節。

## Introduction 的問題設定

Introduction 先把 SFT 與 on-policy RL 分工：SFT 提供駕駛先驗與結構化 action format；RL 則從現行 policy 自己採樣、被評分的 trajectory 中改善。GRPO 在一組結果有好有壞時能產生有效對比，但 unresolved failure group 缺的是「離開失敗區域的 corrective information」，而不是作者聲稱 GRPO objective 消失或 gradient 必然為零。

既有 failure refinement 或 privileged distillation 可以補這種訊號，但作者追問：能否不用更大的外部 teacher，而讓同一 VLA 根據自己的失敗分布教下一輪自己？FIRE-VLA 因此把兩種學習訊號疊合：GRPO 保留一般相對學習；只有低 reward、低 diversity 的群組被導向 privileged self-distillation。

設計的關鍵邊界有三個：teacher 與 student 參數規模相同；teacher 的特權是看得到 future trajectory，而非容量更大；teacher 沿 student 的 on-policy prefix 產生 supervision，減少直接拿離線理想答案取代模型實際狀態分布的落差。更新 policy 後，下一輪觸發路由的失敗分布也會跟著改變。

## 研究的第一性問題

- **基本問題：**相對 reward 只提供組內排序時，如何為「整組都失敗」的 VLA rollout 補上能離開失敗區域的方向？
- **約束：**不能增加大型外部 teacher；student 的 rollout 數與更新預算要能和基線公平比較；corrective signal 也要貼近 student 實際生成的 prefix。
- **既有方法卡點：**低分且低差異的群組缺少成功參照；只繼續相對排序，可能反覆在同一失敗區域挑「比較不差」的軌跡。
- **作者試圖移動的邊界：**把 privileged information 用在特定失敗群組，而非全面取代 on-policy RL，讓 policy 自身的失敗分布決定何處需要額外教學。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 將 unresolved failure group 定義為相對 reward 可排序、卻缺乏逃離失敗區域指引的 post-training 情境。
- 提出以低 reward、低 diversity 路由的 failure-informed self-distillation，同時保留所有群組的 GRPO 更新。
- 使用同尺度 round-start teacher；差異只在 teacher 可見 hidden future trajectory。
- 在配對評估與相同訓練預算下，宣稱主要減少嚴重尾端失敗，而非犧牲一般規劃表現換取平均值改善。

### 我的保守判讀

- 把 tail failure 與 ordinary-case improvement 分開報告是優點；但 1.848 到 1.500 公尺的意義仍取決於 L2 定義、時間尺度、場景難度與置信區間，本次無法核對。
- teacher 看見真實未來軌跡是一種強 privileged information。部署時不需要它，不代表訓練資料取得成本可以忽略；真實車隊如何獲得可靠 future trajectory 仍是外部約束。
- 低 reward、低 diversity 的門檻可能決定方法是否真的鎖定 unresolved failure，而不是把雜訊、reward misspecification 或探索不足混在一起。
- 同尺度自蒸餾降低「大 teacher」依賴，但不保證避免 confirmation bias；teacher 仍來自相同模型族與上一輪參數。
- 目前證據範圍是 nuScenes 上的 driving trajectory prediction。是否能移植到一般 manipulation VLA，要看 action representation、reward 與 privileged future 的可取得性。

## 可放進資料庫的筆記

1. **相對排序不等於修正方向：**一組答案全錯時，知道哪個比較不錯，仍可能不知道正確區域在哪裡。
2. **先分類失敗的資訊缺口：**失敗可能缺 reward contrast、缺 causal diagnosis、缺探索，或缺成功參照；不同缺口不應共用同一補救法。
3. **把 teacher capacity 與 teacher information 分開：**teacher 不一定要更大，也可以只是暫時擁有 student 部署時看不到的訊息。
4. **失敗路由比全面蒸餾更精準：**只在相對學習訊號不足的區域引入 privileged supervision，可保留 on-policy learning 的主體。
5. **沿 student prefix 教學：**corrective target 若不接在 student 實際到達的狀態上，可能形成新的 distribution mismatch。
6. **平均改善要追來源：**平均誤差下降可能來自全面進步，也可能只來自尾端災難減少；對 safety-critical Physical AI，後者本身可能更重要。
7. **自我演化是移動中的資料選擇器：**policy 改變後，觸發額外 supervision 的失敗分布也應重新計算，而非固定一批 hard cases。

## 後續想追的問題

1. low-reward、low-diversity 路由門檻如何設定，對 false routing 是否敏感？
2. privileged future trajectory 的來源與訓練成本為何；是否含測試時不可得或可能洩漏的資訊？
3. 四 rollout 評估中的平均 L2 與 persistent failure 如何定義，是否有 confidence interval 與逐場景配對檢定？
4. GRPO 與 self-distillation 的梯度是否可能互相衝突；answer-token-only supervision 如何權衡？
5. 若 teacher 和 student 共享盲點，跨輪 self-distillation 會改善還是固化錯誤？
