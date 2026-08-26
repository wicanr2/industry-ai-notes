# CounterAlign: Counterfactual Supervision for Vision-Language-Action Models

## 原文資訊

- 論文：CounterAlign: Counterfactual Supervision for Vision-Language-Action Models
- 作者：Haru Kondoh、Kei Ota、Asako Kanezaki、Yueh-Hua Wu
- arXiv ID：2608.21740v1
- 分類：cs.RO（Robotics）
- 發表 / 更新：2026-08-22 / 2026-08-22（v1）
- 連結：[abs](https://arxiv.org/abs/2608.21740v1) / [pdf](https://arxiv.org/pdf/2608.21740v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML 取得成功）；未讀 Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-26

## 為什麼選這篇

VLA 的常見敘事是「更多機器人示範、更多參數」，但機器人資料受硬體、安全與 embodiment 限制，不像文字或影像資料容易擴張。這篇把問題轉成：既然每條成功示範很昂貴，能不能從同一條示範抽出比行為克隆更多的監督？這個問題同時落在 VLA、offline RL 與機器人資料效率的交界。

它值得記錄的地方，不只是提出一個 relabeling 技巧，而是把「成功動作配上不相符指令」視為反事實負例，再正面處理負例可能有歧義的問題。這提供一個可重用的資料觀：缺少失敗軌跡時，先檢查既有正例是否能透過語意重組產生有資訊量、但必須校正標籤雜訊的對照訊號。

## 一句話理解

CounterAlign 試圖把成功示範重新配對成反事實指令—動作樣本，讓 VLA 在不增加機器人 rollouts 與人工獎勵標註的前提下，學到哪些動作雖然可執行、卻不符合當前指令。

## Summary / Abstract 說了什麼

行為克隆只告訴策略「專家做了什麼」，沒有明確指出哪些動作與指令不一致。作者將專家動作與不相符的替代指令配對，合成 counterfactual instruction–observation–action tuples，並用 adversarial discriminator 學一個以指令為條件的 reward，再把它用於 offline RL。

Introduction 進一步說明，並非所有錯配都能直接標成負例：不同指令可能共享相同或部分有效的動作片段。作者因此引入 non-negative positive-unlabeled（nnPU）learning，把部分重新配對樣本視為「未標記混合資料」，而不是武斷地全部當成錯誤。

可用一個很簡化的資料關係理解：原始正例是 $(o, i, a^+)$，其中 $o$ 是觀察、$i$ 是指令、$a^+$ 是專家動作；將動作改配另一條指令 $i'$ 後得到 $(o, i', a^+)$。這個樣本提供「可能不一致」的訊號，但 $i' \neq i$ 不保證 $a^+$ 一定錯，因此需要處理標籤不確定性，而不能把 relabeling 當成完美負例生成器。

摘要自稱，在 LIBERO-PRO 的位置與任務擾動測試及 TX-G2 真機實驗中優於比較基線。不過本次未讀實驗章節，因此不判定提升幅度、統計穩健性或比較是否公平。

## Introduction 的問題設定

1. **背景**：VLA 多以大量專家示範和 behavior cloning 擴張，但實體機器人資料昂貴且 embodiment-specific。
2. **缺口**：BC 只有正向監督；即使策略能模仿訓練分布，也可能在改寫指令、物體位置或場景變動時脆弱。
3. **既有補法的成本**：online RL 需要 reward、rollouts 與模擬器／真機時間；offline RL 雖不再互動，仍依賴可信 reward 與有足夠行為覆蓋的資料。
4. **核心主張**：成功示範本身可透過指令、動作與聯合 relabeling 轉成 corrective supervision；與其先蒐集失敗，不如先增加每條成功示範的監督密度。
5. **作者宣稱的貢獻**：反事實 relabeling、處理錯配歧義的 nnPU discriminator，以及結合該 reward 的 VLA offline RL 訓練。

## 研究的第一性問題

- **基本問題**：只觀察「正確做法」時，策略如何學會辨認「動作本身合理，但不適合這個指令」？
- **約束**：不能假設可廉價取得失敗軌跡、人工 reward label、額外真機 rollouts 或無限模擬器互動。
- **既有方法卡點**：BC 沒有反例；offline RL 需要 reward 與足夠資料支持；粗糙錯配又會把其實共享動作的指令誤標為負例。
- **作者試圖移動的邊界**：將資料效率從「每條示範訓練幾次」推進到「每條示範可產生多少語意對照與糾錯訊號」。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 不新增 rollouts、人工註記或 reward labels，便能從成功示範產生反事實監督。
- nnPU objective 可處理重新配對樣本不一定為負例的歧義。
- 結合 adversarial discriminator 與 offline RL 後，可提升位置／任務擾動下的 robustness，並轉移到真機。

### 我的保守判讀

- 最有價值的概念是「正例資料可被重新組合成帶不確定性的對照訊號」，這比單純把資料增廣等同於多樣性更精確。
- 方法能學到多細的指令—動作對齊，會受原始指令集合的語意覆蓋與動作重疊程度約束；若指令彼此太相似或資料只有單一技能，錯配可能不夠有辨識力。
- discriminator 產生的 reward 仍可能學到資料捷徑。Introduction 說明了歧義處理，但本次閱讀不足以判斷 reward calibration、離線分布外動作與 adversarial training 穩定性。
- 「不增加資料」不等於沒有新增成本：relabeling 規則、相似度約束、額外 discriminator 與 offline RL 都增加訓練和驗證複雜度。
- 摘要中的 benchmark 與真機結果只能暫記為作者報告，需讀實驗設計、樣本數、方差與 baseline 設定後才能評估證據強度。

## 可放進資料庫的筆記

1. **資料量不等於監督密度**：同一條示範可同時提供模仿訊號、語意錯配對照與 reward-learning 訊號。
2. **反事實負例不是天然真負例**：重組資料後，首先要問標籤是否確定，而不是直接擴大資料集。
3. **正例不足可以有兩種意思**：樣本數少，或每個正例沒有被轉成足夠多的可區分關係。
4. **VLA 的 robustness 是對齊問題**：場景偏移之外，也要檢查指令、觀察與動作三者是否被共同約束。
5. **offline RL 的瓶頸常在 reward 與 support**：沒有線上互動，不代表自動得到可信改善方向。
6. **語意近鄰比隨機錯配更有資訊**：太容易的負例可能只教會模型辨認表面差異；真正重要的是容易混淆的 near-miss。
7. **便宜的合成監督要附帶雜訊模型**：生成更多標籤若沒有不確定性處理，可能把規模轉成系統性偏誤。

## 後續想追的問題

1. 指令 relabeling、動作 relabeling與 jointly relabeled samples 的生成規則各是什麼？相似度門檻如何選？
2. nnPU 中正類先驗如何估計，對 reward calibration 與訓練穩定性有多敏感？
3. 改善來自更好的 semantic alignment、offline RL 本身，還是額外模型容量與訓練計算？
4. LIBERO-PRO 與真機實驗的任務數、seeds、信賴區間、失敗型態及 baseline 是否使用相同資料預算？
5. 當指令不同但前幾個 action chunks 合法地共享時，方法如何避免把長時程任務的共同前綴誤當成負例？
