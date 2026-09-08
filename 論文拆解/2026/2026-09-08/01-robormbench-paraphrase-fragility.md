# Same Trajectory, Contradictory Rewards (ROBORMBENCH): Paraphrase Fragility in Vision Language Reward Models

## 原文資訊
- 論文：Same Trajectory, Contradictory Rewards (ROBORMBENCH): Paraphrase Fragility in Vision Language Reward Models
- 作者：Wonje Jeung、Sangyeon Yoon、Hyesoo Hong、Yoonjun Cho、Dongjae Jeon、Bumjun Kim、Jean Oh、Youngjae Yu、Albert No
- arXiv ID：2609.05401v1
- 分類：cs.RO、cs.CL
- 發表 / 更新：2026-09-04 / 2026-09-04（v1）
- 連結：[abs](https://arxiv.org/abs/2609.05401v1) / [pdf](https://arxiv.org/pdf/2609.05401v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、Methods、Experiments、Results 與附錄
- 擷取日期：2026-09-08

## 為什麼選這篇

VLM 被拿來當機器人 reward model 時，角色已不只是「描述畫面」，而是把軌跡與語言目標映射成會影響政策學習的分數。這篇抓住一個容易被單一標準指令測試漏掉的問題：任務語意沒變、軌跡也完全相同，只改寫指令，reward 是否仍一致？

這對 LLM／VLM 與 Robotics 的交會有直接價值。若模型偏好某種措辭，RL 或離線軌跡挑選就可能優化語言表面形式，而不是物理任務本身。論文把語言穩健性從一般問答的品質問題，推進到會改變機器人學習訊號的系統問題，值得獨立收錄。

## 一句話理解

機器人 reward model 必須對語意等價的任務描述保持一致，否則相同物理行為可能只因換句話說就同時被判成成功與失敗。

## Summary / Abstract 說了什麼

摘要把必要性稱為 **paraphrase invariance（改寫不變性）**：當軌跡 $\tau$ 固定，兩個指令 $x$ 與 $x'$ 的任務意義相同時，reward model $R$ 應滿足：

$$
x \equiv_{\mathrm{sem}} x' \quad\Longrightarrow\quad R(\tau,x) \approx R(\tau,x').
$$

這裡的 $x \equiv_{\mathrm{sem}} x'$ 表示兩句話在任務語意上等價；$\approx$ 不要求浮點數完全相同，而是至少不應跨越成功／失敗判定邊界。

作者提出 RoboRMBench：包含 2,390 條實機軌跡、ground-truth progress labels，以及 21,673 個經驗證的改寫，涵蓋詞彙替換、句法重組與 action-goal 視角改寫。摘要稱，多種封閉與開源 VLM 都有明顯不穩定，改寫差異越大通常越嚴重；增加模型規模或明示 reasoning 並未穩定消除問題，而受 trajectory-grounded supervision 訓練的專用 reward models 較穩定。

摘要另主張，這不只是分數抖動：措辭改寫可把同一行為的判斷從失敗翻成成功，並影響離線 best-of-$N$ 軌跡選擇。本次未讀實驗章，因此只把它記為作者報告的結果，不判斷效果量、模型覆蓋或統計穩健度。

## Introduction 的問題設定

Introduction 先說明語言作為機器人目標介面的擴展性：使用者可直接說明「把蘿蔔放入粉紅碗」，VLM reward model 再依影像軌跡估計任務進度。相較二元 success detector，連續進度分數還可能提供部分完成的密集訊號，減少手工 reward 與密集人類標註。

但 reward 不是被動評語。在 RL 中，它決定哪些軌跡會被強化；如果相同軌跡只因語意等價的措辭不同而拿到矛盾分數，政策會收到互相衝突的學習訊號，甚至朝措辭 artifact 而非目標行為優化。既有評估多只使用一個 canonical instruction，因而遮住這類失敗。

作者因此固定視覺軌跡，只改變目標描述，並提出兩個診斷量：**Score Crossing Rate（SCR）** 看同一軌跡的一組改寫是否同時產生 failure-level 與 success-level 分數；**Flip Rate（FR）** 看改寫相對原指令是否翻轉二元判斷。另以 Mean Error（ME）對照 ground truth，避免把「平均較準」誤當成「改寫較穩」。

## 研究的第一性問題

- **基本問題**：reward model 到底在評估物理軌跡對任務目標的進展，還是在回應指令的表面形式？
- **約束**：自然語言必然有多種等價表達；reward 會進入政策優化閉環；等價改寫本身也需要可靠驗證，不能把語意改變混成 robustness 測試。
- **既有方法卡點**：單一 canonical instruction 的平均誤差會漏掉條件內矛盾；更大的通用模型或更多 reasoning token 也不必然帶來不變性。
- **作者試圖移動的邊界**：從「reward 預測準不準」移到「在語意等價變換下，reward 是否仍代表同一個物理目標」。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 定義並系統化測量 VLM robot reward models 的 paraphrase fragility。
- 建立固定軌跡、只改寫指令的 RoboRMBench，並提供多種改寫型態與語意等價篩選。
- 以 SCR、FR 與 ME 分離判斷翻轉、相對原句翻轉與平均預測誤差。
- 報告專用 trajectory-grounded reward models 比若干更大的通用 VLM 穩定，且較低 SCR 與較佳離線軌跡選擇相關。

### 我的保守判讀

- 最重要的不是又多一個 benchmark，而是提出 **counterfactual interface test**：物理輸入與任務意義不變，只替換語言介面，檢查下游決策是否改變。
- 「語意等價」本身是測試的地基。若驗證程序放過細微的目標、順序或視角差異，測到的可能部分是合理敏感性；需讀方法與資料才能判斷。
- 低 SCR 不是充分條件。永遠輸出同一個錯誤分數也很穩，因此必須與 ME、校準及政策結果一起看。
- 離線 best-of-$N$ 是一種後果展示，但還不能直接代表 online RL 中長期探索與回饋迴圈的影響。
- 專用模型較穩定的觀察，若經全文驗證，支持「任務對齊 supervision 比通用規模更關鍵」；目前不宜外推到所有 VLM 與所有機器人任務。

## 可放進資料庫的筆記

1. **介面不變性是 Physical AI 的安全屬性。** 語言只是目標介面，不應偷偷改寫物理成功條件。
2. **平均準確率不能取代條件內一致性。** 同樣的平均誤差，可能隱藏完全不同的決策翻轉率。
3. **穩定但錯誤與不穩定但偶爾正確是兩種問題。** Robustness、accuracy、calibration 應分開記帳。
4. **Benchmark 最乾淨的設計，是一次只改一個因子。** 固定軌跡並改寫語言，才較能定位語言脆弱性。
5. **Reasoning 不自然等於 invariance。** 產生更多推理文字，仍可能放大措辭依賴。
6. **Reward model 的錯誤會被優化器放大。** 它不是終端報告，而是學習閉環中的控制訊號。
7. **專用 supervision 可能比通用能力更接近系統需求。** 模型規模不是所有可靠性屬性的代理指標。
8. **改寫測試可延伸到其他介面。** 同義語句、單位表達、物件別名與多語言轉述都可作為等價變換測試。

## 後續想追的問題

1. 21,673 個 paraphrases 如何驗證語意等價；人類一致性與拒絕率如何？
2. SCR／FR 的成功門檻如何設定，結果對門檻與 reward calibration 是否敏感？
3. 哪些模型、prompt 格式與 trajectory representation 被比較，是否公平控制輸入資訊？
4. 不穩定主要來自語言 encoder、視覺—語言交互，還是 scalar reward head？
5. 在 online RL 中，paraphrase fragility 是否會累積成可測量的 sample efficiency 或 policy bias？
