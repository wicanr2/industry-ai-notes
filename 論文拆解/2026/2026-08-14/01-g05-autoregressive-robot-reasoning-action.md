# G0.5: One Autoregressive Stream for Robot Reasoning and Action

## 原文資訊
- 論文：G0.5: One Autoregressive Stream for Robot Reasoning and Action
- 作者：Yicheng Liu、Zibin Dong、Baijun Ye、Tianyuan Yuan、Tao Jiang、Anqi Yang、Shicheng Cao、Haonan Liu、Yue Sun、Zihan Guo、Xiao Liu、Dong Ke、Changxun Pan、Chenru Wu、Tailai Cheng、Xiaoshu Ren、Xinlei Zhang、Jianning Cui、Zijie Zhao、Haoyu Zhang、Kaiming Xu、Haodong Yang、Bowen Zhang、Jiahui Niu、Shaoting Zhu、Shiduo Zhang、Hang Zhao
- arXiv ID：2608.11739v1
- 分類：Robotics（cs.RO）、Artificial Intelligence（cs.AI）
- 發表 / 更新：2026-08-12 / 2026-08-12
- 連結：[abs](https://arxiv.org/abs/2608.11739v1) / [pdf](https://arxiv.org/pdf/2608.11739v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-14

## 為什麼選這篇

這篇直接處理 VLM 與機器人動作之間的架構分工。近期 VLA 常把預訓練 VLM 當作條件編碼器，再交由獨立的 flow-matching 或 diffusion action expert 產生連續動作。這雖然有利於高頻控制，卻也讓語言推理、提示調整與動作生成分屬不同參數和目標；G0.5 反過來嘗試讓同一個 autoregressive decoder 同時輸出推理與動作 token。

它值得收錄，不只因為摘要報告多組 benchmark 數字，而是它把一個重要取捨說得很清楚：統一生成介面能否保留 VLM 的語言能力，同時透過動作壓縮克服 autoregressive control 的延遲與序列長度成本？這對 LLM + Robotics 的模型邊界很有代表性。不過本次沒有閱讀方法與實驗，無法獨立核對比較公平性、控制頻率或真實機器人結果。

## 一句話理解

G0.5 用學習式跨機器人動作 tokenizer 壓縮控制序列，讓單一自回歸模型可以在同一 token stream 中推理、記憶並產生機器人動作。

## Summary / Abstract 說了什麼

摘要認為主流 VLA 的 VLM-as-encoder 架構，把 VLM 降成情境編碼器，真正決定動作的是另外訓練的 action expert。G0.5 改用單一 transformer decoder，在同一目標下生成 reasoning token 與 action token。

為了讓這條路可擴展，作者提出三個組件：第一，學習式 cross-embodiment action tokenizer，把不同自由度、形態與控制頻率的動作映射到共享詞彙；第二，把任務分解、物件定位與 action hint 等 chain-of-thought 資訊和動作 token 串在同一生成流；第三，以視覺記憶模組把數秒歷史送進 vision encoder。摘要自稱，這個統一介面讓提示可直接改變動作粒度、任務時間跨度與 OOD 場景處理方式，並在七種評估情境優於列出的基準。

摘要中的百分比屬於作者報告，例如真實機器人 fine-tuning、BEHAVIOR、DROID、LIBERO、RoboTwin 2.0 與 SimplerEnv-Bridge；本次未讀實驗設定，因此不把它們視為已完成獨立驗證的結論。

## Introduction 的問題設定

Introduction 先回顧早期 autoregressive VLA：把連續動作離散化後，直接當作語言詞彙的一部分生成。它保留 VLM 作為 actor 的角色，但控制頻率、動作 horizon 與自由度增加時，每個時間步需要的 token 迅速膨脹，造成延遲與運算成本。

因此領域轉向 VLM-as-encoder：VLM 提供 hidden state 或 KV cache，再由 flow-matching / diffusion expert 生成 action chunk。作者承認這提高動作效率，但主張它形成「壓縮的條件瓶頸」：chain-of-thought、in-context learning 與 prompt steering 不再直接改變下一個動作 token，而必須透過另一個 action model。

G0.5 的策略不是否定自回歸介面，而是壓縮其最昂貴的部分。學習式 VQ action codec 將 action chunk 變成較少的離散 code，並只預測活躍自由度，避免為不動的關節付出 token 成本。接著，模型把可選的 Subtask、BBox、Trace、ActionHint 與 action code 序列化到同一生成段，讓推理和動作共享 decoder、context 與 next-token objective。

Introduction 也較謹慎地把 prompt-driven behavior control 稱作初步質性跡象，並說系統性研究留待未來；這比把它直接當成已證實能力更合理。

## 研究的第一性問題

- **基本問題**：機器人的語言推理與動作生成，應由同一生成模型直接耦合，還是由 VLM 與專用 action expert 分工？
- **約束**：實體控制需要高頻、低延遲、連續且跨 embodiment 的動作；直接逐維逐時刻生成 token 會使序列過長。
- **既有方法卡點**：傳統 autoregressive VLA 太慢；VLM-as-encoder 雖有效率，卻可能削弱語言提示與推理對動作分布的直接影響。
- **作者試圖移動的邊界**：用可學習動作壓縮與 active-DoF tokenization，把「統一推理—動作生成」從低頻概念展示推向 foundation-model 規模。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出 reasoning 與 action 共用權重、context 及訓練目標的預訓練 autoregressive VLA。
- 建立可跨形態、自由度與控制頻率的學習式 action codec。
- 把任務分解、grounding、sub-goal 與 action code 放進原生的交錯生成流。
- 以多組模擬、真實機器人及跨環境設定，主張統一介面能兼顧控制表現與語言遵循。

### 我的保守判讀

- 最核心的研究價值是把「誰才是 actor」變成可比較的架構問題，而不是只把 VLA 視為更大的 end-to-end model。
- 共享 token stream 不自動保證 faithful reasoning；文字 rationale 可能只是與動作共同預測的中介序列，是否真正因果影響控制仍需 intervention 或消融。
- action codec 的壓縮率、重建誤差、控制延遲與不同 embodiment 的 token 分配，是判斷 autoregressive 路線是否實用的關鍵，本次閱讀範圍無法核對。
- 摘要跨很多 benchmark，但不同模型的資料、post-training epoch、參數量與 action horizon 是否對齊，需要讀實驗細節。
- prompt steering 目前被 Introduction 定位為小規模質性 probe；不宜延伸成普遍可靠的自然語言控制能力。

## 可放進資料庫的筆記

1. **VLM 在系統中的位置比模型名稱更重要**：同樣稱為 VLA，VLM 可能是 actor，也可能只是 condition encoder。
2. **統一目標與模組化效率存在結構性取捨**：共用 decoder 有利於能力直接傳遞，專用 action expert 則更容易滿足高頻連續控制。
3. **tokenization 是控制架構，不只是資料前處理**：動作如何離散、壓縮與分組，直接決定延遲、跨 embodiment 共用性及可生成 horizon。
4. **只為 active DoF 付費**：稀疏動作結構可轉成可變長 token budget，避免對靜止關節固定 padding。
5. **reasoning 與 action 同流不等於 reasoning 有效**：仍需遮蔽、替換或反事實 intervention，判斷 rationale 是否改變物理決策。
6. **prompt steerability 要拆成粒度**：語意遵循、空間修飾、速度副詞、長程分解與 OOD recovery 是不同能力，不能用少數案例概括。
7. **共享 action vocabulary 是跨 embodiment 的中介層**：真正問題是共享 code 是否保留機器人特有動力學，而不是詞彙是否形式上相同。
8. **benchmark 廣度與比較可歸因性分開看**：任務多能顯示覆蓋面，但不能替代資料、算力、訓練輪數與延遲的對齊比較。

## 後續想追的問題

1. action codec 的 codebook、殘差輪次與 active-DoF 判斷如何運作，壓縮率和控制誤差是多少？
2. reasoning token 被遮蔽、替換或打亂時，動作成功率與軌跡會如何改變？
3. 與 flow-matching expert 比較時，端到端 latency、控制頻率、參數量和 post-training 資料是否對齊？
4. cross-embodiment vocabulary 是否對低階動力學差異產生 negative transfer？
5. prompt-driven behavior 的評估能否從質性案例擴展為可重複、具安全邊界的測試？
