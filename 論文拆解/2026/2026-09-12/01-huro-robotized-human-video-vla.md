# HuRo: Robotizing Human Videos for Scalable VLA Pretraining

## 原文資訊
- 論文：HuRo: Robotizing Human Videos for Scalable VLA Pretraining
- 作者：Jinho Jeong、Se June Joo、Jaehyun Kang、Dongyun Kim、Yena Kim、Hanjung Kim、Seon Joo Kim
- arXiv ID：2609.10706v1
- 分類：cs.RO、cs.CV、cs.LG
- 發表 / 更新：2026-09-09 / 2026-09-09（v1）
- 連結：[abs](https://arxiv.org/abs/2609.10706v1) / [pdf](https://arxiv.org/pdf/2609.10706v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、方法、實驗、結果與附錄
- 擷取日期：2026-09-12

## 為什麼選這篇

VLA 的資料規模受限於實機示範：機器人資料要用特定硬體、場景與操作流程收集，成本高，行為與視覺分布也窄；人類影片則大量存在，卻缺少機器人的外觀、狀態與可直接執行的 action。HuRo 直接處理這個 Physical AI 的資料瓶頸，問題不是「如何讓模型看更多影片」而已，而是如何把人類影片轉成可供 VLA 預訓練的 observation–action episode。

這篇值得放入資料庫，因為它把 human-to-robot transfer 拆成兩個必須同時對齊的面向：**視覺 embodiment** 與 **動作 embodiment**。Introduction 指出，過去的大規模路線常只保留人類視覺再恢復動作，或把 robotization 用於視覺／輔助目標；HuRo 則主張在異質影片上共同轉換觀測與動作，形成可擴張的 VLA 預訓練資料。這是「資料量」與「資料是否像目標控制介面」之間的核心取捨。

## 一句話理解

HuRo 試圖把大量異質人類操作影片轉成同時具有機器人外觀、狀態與動作的 VLA episode，讓 human-video scale 真正進入 robot policy 的 observation–action 預訓練。

## Summary / Abstract 說了什麼

摘要將 human-to-robot embodiment gap 分成 observation 與 action alignment。作者提出 robotization pipeline：移除人手、疊加渲染的機器人外觀，並把人手運動 retarget 成機器人動作；當不同來源缺少部分標註時，管線也會估計中間訊號，最後轉成共同資料格式。

可用下式做閱讀上的簡化：

$$
(x_t^{H}, m_t^{H}, \ell) \xrightarrow{R_e}
(\tilde{x}_t^{R}, s_t^{R}, a_t^{R}, \ell),
$$

其中 $x_t^{H}$ 是時間 $t$ 的人類影片影像、$m_t^{H}$ 是可取得或估計的人手運動、$\ell$ 是語言指令，$R_e$ 是針對目標 embodiment $e$ 的 robotization，輸出 robot-aligned 影像 $\tilde{x}_t^{R}$、機器人狀態 $s_t^{R}$ 與動作 $a_t^{R}$。這是理解資料轉換責任鏈的概念式，不是作者完整方法的重建。

作者以五個人類影片來源建立約 63 萬個 robotized episodes、1.42 億個 processed frames。摘要自稱，隨預訓練資料增加，四個實機 manipulation tasks 的整體完成率由 51.5% 升至 80.3%，空間與視覺 shift 下的 OOD 完成率由 34.9% 升至 72.2%；也稱 visual robotization 有助 OOD robustness，而帶 retargeted actions 的 end-to-end pretraining 優於 visual-only transfer。這些數字只來自摘要，本次沒有讀實驗設計，不能核對資料切分、統計不確定性與 baseline 公平性。

## Introduction 的問題設定

Introduction 先建立 scaling premise：VLA policy 能力通常隨預訓練資料增加，但 real-robot data 供應有限；相較之下，人類影片更容易蒐集，且涵蓋更多物體、場景、視角與行為。真正的障礙不是影片不存在，而是人與機器人的 observation/action distributions 不相容。

作者接著區分既有工作的適用範圍。Joint observation–action robotization 多出現在 task-matched setting，資料是為下游任務特別蒐集或轉換，不等於可跨異質來源做一般預訓練。大規模工作則常在 human-centric observation 上加入恢復的 action supervision，或主要將 visual robotization 用於表示學習。因而留下的問題是：能否把不同標註程度的人類影片，規模化地轉為 observation 與 action 都對齊機器人的 VLA 資料。

HuRo 的回答是把 visual robot overlay 與 motion retargeting 放進同一管線，並估計來源缺少的必要訊號。Introduction 的貢獻宣稱聚焦三點：資料可跨五個來源擴張、下游表現隨 robotized pretraining scale 上升、以及 observation 與 action 的共同對齊比只做視覺轉移更重要。

## 研究的第一性問題

- **基本問題**：大量人類影片要具備什麼最低結構，才能成為可學習機器人控制、而不只是視覺表徵的預訓練資料？
- **約束**：來源異質、標註層級不同；人手與機器人的幾何、自由度、外觀、狀態與可執行動作不一致；轉換還必須能擴張到大量 frames。
- **既有方法卡點**：task-matched robotization 難擴張；human-centric observation 與 robot action 混搭可能保留視覺 domain gap；visual-only transfer 又沒有直接提供控制監督。
- **作者試圖移動的邊界**：把 robotized human video 從特定任務的資料增強，推向可規模化的通用 VLA observation–action pretraining source。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 建立能處理異質標註來源的 human-video robotization pipeline，同時轉換 observation 與 action。
- 建立約 63 萬 episodes、1.42 億 frames 的 HuRo dataset，規模較先前 robotized-video pretraining 資料大一個數量級以上。
- 預訓練效益會隨 HuRo 子集規模增加，並延伸到 in-distribution 與 OOD manipulation evaluation。
- Visual robotization 提升 OOD robustness；retargeted action supervision 帶來超過 visual-only transfer 的效益。

### 我的保守判讀

- 關鍵貢獻可能不是單一生成或 retargeting 技術，而是把**視覺、狀態、動作、語言與缺失訊號估計**組成可擴張資料生產線。
- Robotization 會降低某些 domain gaps，也可能製造新的合成痕跡。模型學到的是物理可重用結構，還是 overlay／retargeting pipeline 的偏差，需看跨來源與跨 embodiment ablation。
- 「63 萬 episodes」不是 63 萬次獨立實機經驗；資料量應連同來源多樣性、重複片段、估計訊號誤差與有效 action coverage 一起判讀。
- Motion retargeting 將人類動作翻成機器人 action，但人手可達性、接觸力、遮擋與物體動力學不一定可由影像恢復。錯誤監督是否會隨規模一起放大，是重要風險。
- 摘要中的 scaling trend 很有吸引力，但本次無法判斷曲線是否仍在上升、是否受 downstream finetuning data 主導，或對未見任務與不同硬體是否成立。
- 這條路線不會消除 real-robot data；較合理的理解是先用便宜的轉換資料學廣泛 priors，再用昂貴實機資料校正可執行性與接觸細節。

## 可放進資料庫的筆記

1. **資料規模之前先問資料介面。** 影片再多，若沒有對應 policy 所需的 observation、state 與 action，規模不會自動變成控制能力。
2. **Embodiment gap 至少有兩層。** 視覺像不像機器人，與動作能不能由機器人執行，是不同的 alignment 問題。
3. **合成資料管線本身就是感測器。** Robotization 對真實行為做有偏估計；應像校準感測器一樣追蹤誤差、覆蓋率與失敗模式。
4. **缺失標註不是免費補齊。** 每個 inferred intermediate signal 都會在資料譜系中加入不確定性，需保留 confidence 與來源欄位。
5. **Scale 要用有效多樣性衡量。** Episode／frame 數之外，還要看物體、技能、接觸、視角、場景與 action distribution 的獨立覆蓋。
6. **預訓練與實機校正是互補層。** Human video 適合擴大先驗，real-robot data 仍負責校準 dynamics、safety 與 hardware-specific residuals。
7. **共同 observation–action 格式可能形成資料網路效應。** 若多來源都能映射到同一介面，新資料的邊際整合成本可能下降；但格式也可能把單一 embodiment 偏差固化。
8. **OOD 表現要追溯 OOD 的來源。** 視覺、空間、物體、動力學與 embodiment shift 不應合成一個泛化分數。

## 後續想追的問題

1. 五個來源各提供哪些原生標註；缺失的手部姿態、相機、物體或 action 訊號如何估計，誤差如何傳遞？
2. Visual overlay 的比例與品質如何控制，為何少量 overlay 可能優於完全不 overlay？
3. Retargeted action 是否經過可達性、碰撞、接觸與時間尺度檢查，無效片段如何過濾？
4. Scaling curve 對獨立影片數、frames、task diversity 與 downstream robot demonstrations 是否能分離？
5. 同一資料管線換到不同手臂、夾爪、雙臂或 humanoid embodiment 時，需要重做哪些元件？
