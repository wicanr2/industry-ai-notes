# Learning to Act While Waiting: RL Finetuning of Generalist Robot Policies Under Inference Latency

## 原文資訊

- 論文：Learning to Act While Waiting: RL Finetuning of Generalist Robot Policies Under Inference Latency
- 作者：Brian Zhu、Momen Khalil、E Harrison、Emanuele Poggi、Philipp Schmitt、Bernd Kast、Philine Meister、Pranav Atreya、Qiyang Li、Finn Ferchau、Cesar Colmenero、Yash Shahapurkar、Gokul Narayanan、Melih Erdogan、Kai Wurm、Georg von Wichert、Oier Mees、Eugen Solowjow、Andrew Wagenmaker、Sergey Levine
- arXiv ID：2608.23831v2
- 分類：cs.RO、cs.LG
- 發表 / 更新：2026-08-24（v1）/ 2026-08-26（v2）
- 連結：[abs](https://arxiv.org/abs/2608.23831v2) / [pdf](https://arxiv.org/pdf/2608.23831v2)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML 取得成功）；未讀 Preliminaries、Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-27

## 為什麼選這篇

大型 VLA 的推論延遲常被當成部署工程問題：動作 chunk 做大一點、非同步算下一段、讓軌跡接得更順。但這篇提出更深一層的問題：當機器人在模型思考期間仍繼續移動，RL 所看到的狀態與動作真正被執行時的狀態不再對齊，延遲會改寫學習問題本身，而不只是讓控制看起來卡頓。

這篇的獨立價值在於連接三個層次：大型 foundation policy 的算力延遲、即時機器人控制、以及 RL 的 Markov 假設。它提醒我們，Physical AI 的模型規模不能只用離線 benchmark 評價；推論時間會進入環境動態，甚至讓原本合理的學習演算法失去成立條件。

## 一句話理解

VLA 在「思考」下一段動作時，機器人與環境不會停下來；要讓 RL 還能學，狀態必須包含等待期間已承諾的動作與較新的中途觀察。

## Summary / Abstract 說了什麼

摘要指出，現代 generalist robot policies（包括 VLA）模型很大，動作生成可能造成明顯延遲、停頓或不連續運動。若延遲沒有被納入學習狀態，它會改變有效環境動態，破壞標準 RL 仰賴的 Markov property。

Markov property 的直覺是：在目前狀態與動作已知後，下一狀態不應還需要更早的歷史才能預測。可簡寫為：

$$
P(s_{t+1}\mid s_{0:t},a_{0:t})=P(s_{t+1}\mid s_t,a_t).
$$

但非同步推論時，模型在較早的 $s_{t'}$ 開始計算；等動作可執行時，系統已經因先前 action chunk 移到另一個狀態。若 RL correction 只看舊狀態，它缺少等待期間已執行／已承諾動作所帶來的資訊，歷史因而重新變得重要。

作者提出 **ARLI（Asynchronous RL with Intermediate Information）**。它沿用「一邊執行目前動作、一邊計算下一段動作」的非同步策略，但透過兩項資訊讓 RL policy 更有反應性：把 committed/intermediate actions 納入 state augmentation，並在推論窗口中使用較新的 mid-inference observation。摘要自稱，ARLI 在模擬與真實操作任務中，能在標準 RL 失敗的延遲條件下有效微調，甚至匹配或超過理想化無延遲設定；本次未讀實驗章節，無法驗證效果幅度與比較條件。

## Introduction 的問題設定

Introduction 從 deployment-time improvement 出發：通用機器人 policy 可先由大規模、多任務資料訓練，再靠線上 RL 適應特定部署環境。但目前較好的結果仍多在受控實驗室條件；真實部署必須面對 inference latency。

作者用 Introduction 中引用的例子說明量級：在一般消費級 GPU 上，某些 VLA 單次 action generation 約需 100 毫秒，另一些開源模型可能超過 300 毫秒。這些數字是論文 Introduction 的陳述，本次未追讀其引用來源。對需要高反應性的操作而言，這不只是吞吐量問題：同步等待會造成停頓，非同步執行雖可隱藏延遲，卻必須在真正執行前就根據較舊觀察產生動作。

作者認為現有 latency 工作主要處理固定 policy 的部署，沒有充分處理 latency 如何影響 RL 的有效學習。若目前 action chunk 尚在執行，就開始計算下一段 action，模型無法提前知道執行新動作那一刻的實際環境狀態。把標準 RL 直接接上這個流程，會形成有效狀態的非 Markov 性。

ARLI 的兩個核心直覺都在補回缺失資訊。第一，把等待期間會執行的中間動作放進狀態，使 RL policy 更能預測新 action 開始時可能到達的狀態。第二，generalist policy 與較輕量的 RL correction 不一定要同時啟動；後者可延後到較新的中途觀察到手後再修正，因此比基礎 policy 更接近真正執行時的環境。

## 研究的第一性問題

### 基本問題

決策所需的時間不是系統外部成本。只要環境在計算期間持續變化，推論延遲就是 transition dynamics 的一部分；學習演算法的 state definition 必須把這段演化納入。

### 約束

- VLA 很大，forward pass 不可能永遠快於底層控制週期。
- 機器人不能在每次高階 policy 推論時安全地完全停住。
- action chunking 可攤平推論成本，但 chunk 交界仍會有等待與狀態落差。
- RL correction 必須夠低延遲，否則補充中途觀察也會再次過期。
- 線上真機 RL 的資料與失敗成本都高，不能只靠更多試誤消化錯誤狀態表示。

### 既有方法卡點

同步推論保持觀察—動作對齊，卻產生週期性停頓；非同步推論維持動作流，卻讓新 action 根據過期狀態生成。既有平滑 chunk 邊界或注入延遲的做法，未必處理「如何在這個非同步 regime 中做 online RL adaptation」。

### 作者試圖移動的邊界

作者不是要求大型 VLA 本體立刻完成全部反應，而是把控制拆成較慢的 generalist generation 與較晚、較快的 RL correction，並重新定義 correction 可見的狀態。這是在架構層面用資訊時序補償模型延遲，而不只是壓縮模型或提升硬體速度。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 指出直接結合 asynchronous inference 與 RL 會產生非 Markov 的有效狀態，使標準方法難以學習。
- ARLI 以 committed actions 的 state augmentation 補回對未來狀態的預測資訊。
- RL correction 使用較新的 mid-inference observation，提高推論窗口內的反應性。
- 作者宣稱在模擬與雙臂 UR5e 真機任務中，延遲條件下可比 naive asynchronous RL 與 synchronous inference 更有效。

### 我的保守判讀

- 這篇最重要的洞見不是單一演算法名稱，而是 **latency 改變 state sufficiency**。這對任何大型模型進入閉迴路控制都具有一般性。
- 將已承諾動作加入狀態很合理，但「近似恢復 Markov」能到什麼程度，仍取決於感測延遲、未建模接觸、執行器誤差與外界擾動。
- 架構假設似乎偏向 action-chunked、diffusion／flow 類 pretrained policy；對 autoregressive VLA、不同控制頻率或更長延遲是否可直接適用，本次無法判定。
- Introduction 報告的 100–300 毫秒只是特定模型與硬體的例子，不應當成所有 VLA 的固定延遲。
- 摘要宣稱可匹配甚至超越無延遲 RL 很醒目，但需要讀實驗確認 no-latency baseline、訓練預算、控制頻率與統計穩健性，現在不宜延伸成普遍結論。

## 可放進資料庫的筆記

- **延遲是動態，不只是效能指標**：閉迴路系統中，推論時間會改變 observation、action 與 next state 的對應。
- **state 是否充分取決於執行架構**：同一個感測畫面，在同步與非同步控制下可能代表不同的決策資訊。
- **非同步把等待變成 hidden transition**：若等待期間的動作沒有被 state 表示，RL 就必須依賴歷史補足缺口。
- **committed actions 是預測未來執行狀態的資訊**：已排程但尚未全部完成的控制，本身就是 state 的一部分。
- **快慢雙層 policy 可做時間上的分工**：慢模型提供通用能力，快 correction 用較新觀察修正即時偏差。
- **action chunking 同時是算力策略與控制假設**：chunk 長度會影響反應性、延遲攤提、狀態過期與修正空間。
- **Physical AI benchmark 應揭露 wall-clock 條件**：只比較成功率而不揭露硬體、推論延遲與控制頻率，可能高估部署能力。
- **模型壓縮不是唯一答案**：資訊時序與系統架構也能補償一部分大型模型延遲，但不能消除物理不確定性。

## 後續想追的問題

1. ARLI 的 RL correction 多快、模型多大，整體 wall-clock latency 與算力成本如何？
2. committed actions 與 mid-inference observation 的各自 ablation 效果為何？
3. 延遲變動、感測不同步或網路 jitter 下，state augmentation 是否仍足夠？
4. 方法對 action chunk 長度、控制頻率與接觸豐富任務有多敏感？
5. 「優於無延遲 RL」是否來自額外資訊、正則化效果、baseline 設定或統計波動？
