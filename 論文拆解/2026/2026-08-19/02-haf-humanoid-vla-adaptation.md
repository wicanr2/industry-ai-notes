# HAF: Adapting Generalist VLAs to Humanoid Whole-Body Loco-manipulation via Hierarchical Action Flow and Spectral Latent RL

## 原文資訊

- 論文：HAF: Adapting Generalist VLAs to Humanoid Whole-Body Loco-manipulation via Hierarchical Action Flow and Spectral Latent RL
- 作者：Langzhe Gu、Chengkai Hou、Meng Li、Xinhua Wang、Jiaming Liu、Xinyuan Lv、Bowei Zhang、Shuanghao Bai、Guangrun Li、Jingyang He、Gaole Dai、Ziluo Ding、Zhiyuan Xu、Kuan Cheng、Jian Tang、Zhengping Che、Shanghang Zhang
- arXiv ID：2608.16837v1
- 分類：cs.RO、cs.AI
- 發表 / 更新：2026-08-17 / 2026-08-17（v1）
- 連結：[abs](https://arxiv.org/abs/2608.16837v1) / [pdf](https://arxiv.org/pdf/2608.16837v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、Methods、Experiments、Conclusion 與附錄
- 擷取日期：2026-08-19

## 為什麼選這篇

把通用 VLA 搬到人形機器人，不只是增加幾個 action dimension。移動、頭部朝向、腰部姿態與雙臂操作彼此牽制；底盤或雙腳的不穩定會迫使上半身補償，進而降低抓取精度。這篇直接處理 generalist VLA 到 humanoid whole-body loco-manipulation 的轉接問題，屬於 Physical AI 與 VLA 的高價值交會。

它和本日 BATON 的價值層次不同：BATON 處理長任務的子任務組合與交界，HAF 處理單一全身 action chunk 內部的運動學依賴，以及凍結 VLA 後如何用較小的 latent space 做部署期調整。因此第二篇不是為了湊數，而是補上 embodied control 的另一個尺度。

## 一句話理解

HAF 先按人形機器人的運動學依賴逐階段生成全身動作，再只在凍結 VLA 的低維頻譜噪聲空間做 offline-to-online RL，試圖兼顧全身協調與部署期調整成本。

## Summary / Abstract 說了什麼

摘要指出，標準單階段 flow-matching VLA 一次生成所有身體部位動作，未必能處理 locomotion、腰部姿態與雙臂操作的依賴。HAF-VLA 因而把 full-body action denoising 排成三個階段，並以 stage embedding 與跨階段 KV cache 保留前面階段的條件，使後續部位在已生成的基底上調整。

第二部分 HAF-Steer 不直接更新大型 VLA backbone，而是利用 flow matching 的可逆性，從示範 action chunk 回推出初始噪聲，再沿時間維度做離散餘弦轉換（DCT）並只保留前 8 個係數。若把時間序列記為 $x_t$，其低頻係數可概念性寫成

$$
X_k = \sum_{t=0}^{N-1} x_t \cos\!\left[\frac{\pi}{N}\left(t+\frac{1}{2}\right)k\right],
$$

其中 $N$ 是 chunk 長度、$k$ 是頻率索引；較小的 $k$ 表示隨時間變化較慢的模式。這裡的直觀意義是讓 RL 調整一小組平滑的時間模式，而不是直接搜尋完整高維動作或更新整個 VLA。公式用來解釋 Introduction 所述的 DCT 壓縮概念，不代表本次已閱讀方法章的正規化與實作細節。

摘要宣稱，HAF 在七個真實世界人形 loco-manipulation 任務上優於 vanilla single-stage VLA baselines，並改善全身協調與任務表現。本次未讀實驗，無法驗證任務難度、基線公平性與安全成本。

## Introduction 的問題設定

Introduction 將問題拆成兩層。第一層是生成結構：人形機器人的移動、身體姿態與操作不是可同時獨立取樣的平行輸出。既有 humanoid VLA 常依賴專用預訓練或大型 embodiment-specific dataset，轉移成本高；一般 flow-matching VLA 的一次性全身生成，則可能產生不一致的補償動作。

HAF-VLA 將生成順序設為 locomotion 與 head orientation、torso adjustment、最後 bimanual manipulation。前面階段的 clean action 重新編碼進跨階段 KV cache，作為後面生成的條件；活動 action set 是累積的，因此後段仍可修正前段維度，最後只執行完整 action chunk。作者的意圖不是把身體部位完全切開，而是用順序顯式表示依賴。

第二層是部署調整：offline behavior cloning 在 distribution shift 下可能退化，但直接對大型 VLA 做 online RL，運算昂貴且真機探索有安全風險。HAF-Steer 因此在凍結模型的 spectral latent noise 上學習 actor：先用 expert spectral samples 做 behavior cloning，再以混合 offline-online 的 Soft Actor-Critic（SAC）與 BC regularization 調整。

Introduction 宣稱 HAF 不必從頭訓練 humanoid-specific foundation model，並在兩種實體人形平台、七項家務 loco-manipulation 任務上驗證。這些結果仍是作者在 Introduction 的陳述，本次未讀實驗數據。

## 研究的第一性問題

- **基本問題**：如何讓通用 VLA 產生彼此協調的人形全身動作，並在部署偏移下調整，而不重訓整個 foundation model？
- **約束**：action space 高維且身體部位相依；真機 online RL 昂貴、有安全風險；純 offline imitation 又容易受 distribution shift 影響。
- **既有方法卡點**：一次生成全身動作忽略運動學先後依賴；直接在完整時間噪聲或大型 backbone 上最佳化，計算與探索成本過高；重複單一噪聲則可能失去時間表達力。
- **作者試圖移動的邊界**：把「為人形機器人重訓專用大模型」改成「重組通用 VLA 的生成流程，並只調整低維、時間平滑的 latent control」。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出 HAF，讓預訓練 flow-matching VLA 適配人形全身移動操作，避免從頭訓練 humanoid foundation model。
- 以 locomotion／頭部、軀幹、雙臂的階層 action flow 與跨階段 KV cache 改善動作一致性。
- 以 DCT 壓縮的 latent noise space 和混合 offline-online SAC，調整凍結 VLA。
- 在兩個人形平台、七個真實世界任務上宣稱改善任務表現、協調性與 distribution-shift robustness。

### 我的保守判讀

- 顯式生成順序是一個合理 inductive bias，但 locomotion → torso → arms 並非所有動作都適用；快速接觸、失衡恢復或雙臂反作用可能需要更緊密的雙向耦合。
- 只保留前 8 個 DCT 係數可降低搜尋維度，也可能濾掉碰撞回避、接觸修正或快速平衡所需的高頻控制成分。要看低階控制器是否另行吸收這些動態。
- 凍結 backbone 降低參數更新成本，不會自動消除 online exploration 的物理風險；安全仍取決於資料收集邊界、action shielding 與停止條件。
- 兩個平台與七個任務比單一示範更有說服力，但仍不足以直接證明對不同人形結構、負載、地面與接觸條件的廣泛可移植性。
- 本次未讀實驗，無法判定改善來自階層生成、latent RL、更多訓練步驟或其他工程設定，也無法檢查跌倒、碰撞與人工介入率。

## 可放進資料庫的筆記

1. **Embodiment adaptation 不只是換輸出頭**：新的身體結構會改變 action variable 之間的依賴，生成順序本身可能需要重設。
2. **階層生成不等於硬切模組**：讓後段透過 cache 讀取並修正前段，可在結構先驗與全局一致性之間折衷。
3. **先穩定支撐，再精細操作**：對人形系統而言，base 與 torso 的品質會設定手臂可達與補償負擔。
4. **可調參數空間可以比模型空間小很多**：部署期適配未必需要更新 foundation model，可搜尋其 latent input 或控制介面。
5. **頻譜壓縮是一種行動先驗**：保留低頻模式等於偏好時間平滑，但也應明確追蹤被丟棄的快速反應能力。
6. **Offline-to-online 是風險預算分配**：先用離線專家資料定位，再有限度上線調整；真正問題是如何界定可接受的探索邊界。
7. **成功率不足以衡量 humanoid adaptation**：還應報告跌倒、碰撞、姿態振盪、人工接管、能耗與跨平台校準成本。

## 後續想追的問題

1. 三階段生成的順序是否固定；遇到需要手臂先支撐再移動身體的任務如何處理？
2. 跨階段 KV cache 如何表示 clean action，後段修正前段時如何避免破壞已取得的穩定性？
3. 為何選前 8 個 DCT 係數；不同 chunk 長度、速度與接觸任務是否需要不同頻譜預算？
4. Online RL 的真機安全機制、資料量、人工介入與最壞失敗為何？
5. 消融實驗能否分辨階層 action flow、DCT latent space、BC warm start 與 SAC 各自的貢獻？
