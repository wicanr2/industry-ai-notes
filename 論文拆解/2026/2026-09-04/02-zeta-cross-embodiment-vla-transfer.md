# ZETA: A Controlled Study of Zero-Shot Cross-Embodiment VLA Transfer for Tabletop Manipulation

## 原文資訊

- 論文：ZETA: A Controlled Study of Zero-Shot Cross-Embodiment VLA Transfer for Tabletop Manipulation
- 作者：Mi Yan、Wenhao Zhang、Zhiqi Zhang、Yu Peng、Tangxinyu Wang、Lingfei Zhai、Jiayi Su、Shengliang Deng、Lin Peng、Yaowei Liu、Yuxing Chen、Zhiyuan Wei、Jilong Wang、Jiayi Chen、Jiangran Lyu、Zhizheng Zhang、He Wang
- arXiv ID：2609.02546v1
- 分類：cs.RO
- 發表 / 更新：2026-09-02 / 2026-09-02
- 連結：[abs](https://arxiv.org/abs/2609.02546v1) / [pdf](https://arxiv.org/pdf/2609.02546v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、方法、實驗、結果與附錄
- 擷取日期：2026-09-04

## 為什麼選這篇

VLA 若每換一種手臂或夾爪都要重新收集大量任務示範，就很難成為跨硬體的 foundation model。ZETA 聚焦的不是單一模型排行榜，而是先把「zero-shot cross-embodiment」定義清楚，再控制 task、scene、camera、data budget 與 protocol，分離 robot embodiment 本身造成的落差。

這篇對 LLM + Robotics / Embodied AI 資料庫有獨立價值：它將跨 embodiment 能力拆成 representation、source diversity、auxiliary objective 與 target exposure 四個可操作變數，並提醒「目標機器人完全沒出現在訓練中」與「預訓練看過、下游沒看過」不是相同難度。這是資料治理與 benchmark 命名問題，也直接影響模型部署宣稱是否可比較。

## 一句話理解

ZETA 想把 VLA 的跨機器人泛化從模糊的 zero-shot 標籤，改寫成可控制、可分解，且必須揭露 target embodiment 是否曾在 pretraining 出現的評估問題。

## Summary / Abstract 說了什麼

作者區分兩種 protocol：

- **strict zero-shot transfer**：target embodiment 在所有訓練資料中都沒有出現。
- **pretrain-exposed zero-shot transfer**：target embodiment 只在 pretraining 出現，沒有 target-task post-training demonstration。

論文建立涵蓋模擬與真實世界驗證、共 14 個 held-out target embodiments 的受控 benchmark，研究四項因素：state-action representation、pretraining embodiment diversity、auxiliary co-training objective，以及 target-embodiment exposure。

摘要宣稱，在其 stationary tabletop manipulation 與 two-finger gripper 範圍內，local end-effector（EEF）state-action representation、source embodiment diversity、auxiliary co-training，分別帶來約 15、18、7 個百分點的跨 embodiment 改善；pretraining 中只加入 5% target-embodiment data，平均 target progress 增加 13.4 個百分點。

這些數字是論文摘要的結果陳述。本次沒有閱讀實驗章，因此不判斷它們的 variance、樣本獨立性、baseline 公平性或統計顯著性。較可信的初步訊息是：target exposure 即使很少，也可能實質改變任務難度，不能繼續用同一個 zero-shot 名稱包住兩種設定。

## Introduction 的問題設定

Introduction 將 cross-embodiment transfer 的實務動機定為：硬體持續演化，而每個新平台重新收集 task-specific demonstrations 成本很高。現有研究有兩個主要混淆。

第一，zero-shot 的用法不一致。有些研究讓 target robot 完全缺席所有訓練；另一些則容許它在 pretraining 出現，只排除下游任務資料。作者把前者對應到新設計、完全沒有歷史資料的 robot，把後者對應到已有公開資料但沒有私有 downstream data 的 robot。

第二，既有比較常同時改變 embodiment、task、environment、camera、data quantity 與 evaluation protocol，因此觀察到 transfer failure 時，難以歸因給 embodiment mismatch。作者把範圍收斂到 stationary tabletop manipulation 與 two-finger grippers，並將 shift 分成 appearance-only、gripper-only、arm-only、full-embodiment。

Introduction 接著列出四個研究問題：何種 state-action representation 較支持 strict transfer；固定不同 data budget 控制時，source embodiment 數量有何效果；co-training 是否超越 imitation learning；少量 target exposure 會把難度改變多少。作者宣稱，前三題在 strict zero-shot 下測試，第四題才比較 strict 與 pretrain-exposed。

## 研究的第一性問題

- **基本問題**：VLA 能否把從多個 source robots 學到的視覺、語言與動作關係，零示範移到未見 target hardware？
- **約束**：不同 robot 的幾何外觀、關節結構、夾爪與 action coordinate 可能都不同；只要 task 或 camera 也一起變，就難以定位失敗來源。
- **既有方法卡點**：zero-shot 定義含混，且 source diversity 常與總資料量一起增加，讓「多樣性」和「更多資料」混為一談。
- **作者試圖移動的邊界**：把 cross-embodiment 泛化拆成 protocol exposure、representation invariance、source support coverage 與 auxiliary supervision 四項可測因素。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 定義並分開報告 strict 與 pretrain-exposed zero-shot transfer。
- 建立隔離 embodiment mismatch 的 benchmark，涵蓋四種 shift 類別。
- 受控比較 state-action representation、source diversity、co-training 與 target exposure。
- 在模擬與部分真實世界驗證中，得到偏好 local EEF frame、多 source embodiments 與 auxiliary co-training 的實務建議。

### 我的保守判讀

- 定義澄清可能比單一架構增益更耐用：5% target exposure 若真能顯著改變表現，benchmark 必須把 exposure provenance 視為一級欄位。
- local EEF frame 可能提供較強的 embodiment-relative inductive bias，但它不等於普遍 embodiment invariance；涉及 mobile base、dexterous hand、whole-body control 或不同 action frequency 時，合適座標系可能不同。
- 作者主動把研究限制在 stationary tabletop、two-finger gripper，這有助因果辨識，但不能把約 15／18／7 個百分點直接外推到 humanoid 或 long-horizon tasks。
- 「512 source 優於 single source」仍需讀方法與實驗，確認固定的是 trajectory budget、樣本品質、task coverage 還是 optimization steps，以及 procedurally generated Franka-style pool 的形狀多樣性是否代表真實硬體多樣性。
- 目前只能記錄作者的 real-world validation 宣稱，尚不能評估 sim-to-real gap 與硬體數量是否足以支持廣泛結論。

## 可放進資料庫的筆記

1. **Zero-shot 要附 exposure ledger**：至少揭露 target embodiment 是否進過 pretraining、post-training 或 task demonstration。
2. **跨 embodiment 先找相對座標**：local EEF frame 是把動作表示綁到操作末端，而不是特定 robot 全域幾何的一種方式。
3. **多樣性增益必須控制資料預算**：source robots 變多時，同時固定總 trajectories 才較能分辨 coverage 與 scale。
4. **Shift taxonomy 有助除錯**：appearance、gripper、arm、full embodiment 不應只合成一個成功率。
5. **少量 target exposure 可能改變問題類別**：它不只是多一點資料，而可能把 extrapolation 轉成 interpolation。
6. **受控窄 benchmark 與廣泛 deployment claim 要分開**：窄範圍有助定位機制，不代表已解決一般跨硬體遷移。
7. **跨 embodiment 能力是資料—表示—目標函數的聯合產物**：不宜只歸因於 VLA backbone 大小。

## 後續想追的問題

1. 14 個 target embodiments 中，模擬與真實機器人的分配、硬體差異幅度各是什麼？
2. local EEF representation 如何處理 action horizon、控制頻率、gripper command 與不可對應的自由度？
3. 固定 640K trajectories 時，多 embodiment 是否犧牲每個 embodiment 的 task coverage？
4. auxiliary co-training 的任務是什麼，增益來自語義、幾何，還是 optimization regularization？
5. 失敗是否集中在 gripper-only、arm-only 或 full-embodiment shift，且真實世界趨勢有多穩定？
