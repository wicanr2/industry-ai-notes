# What Matters for Latent Actions in Robot Learning

## 原文資訊

- 論文：What Matters for Latent Actions in Robot Learning
- 作者：Xizhou Bu、Qingda Hu、Lei Zhou、Lingfeng Zhang、Yingbo Tang、Zihao Liu、Xinyi Tao、Zhiqiang Ma、Qingqiu Huang、Chufeng Tang、Hongbo Wang、Jing Zhang、Jiayi Ma、Hangjun Ye、Wei Li、Xiaoshuai Hao
- arXiv ID：2608.19613v1
- 分類：cs.RO、cs.CV
- 發表 / 更新：2026-08-20 / 2026-08-20（v1）
- 連結：[abs](https://arxiv.org/abs/2608.19613v1) / [pdf](https://arxiv.org/pdf/2608.19613v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、Problem Formulation、Methodology、Experiments、Limitations 與其他章節
- 擷取日期：2026-08-23

## 為什麼選這篇

機器人 action data 遠少於網路影像與影片，是 embodied foundation model 難以直接複製 LLM scaling 路徑的核心瓶頸。Latent Action Model（LAM）希望從沒有實體動作標註的連續影格中，抽出能代表狀態轉移的潛在動作，再用它預訓練 VLM / policy。這篇不是再提出單一新架構，而是把分散的 LAM 選擇放進共同實驗框架，問哪些因素真的影響下游操作。

它與今日另一篇 EXIMO 的價值不同：EXIMO 處理新任務適應期如何產生成功資料；本篇處理更上游的問題——能否把大量無標註影片轉成有用的 action prior。兩者分別對應「互動資料生成」與「無標註影片表示」，具有獨立價值，因此保留為第二篇，而不是為了湊滿上限。

## 一句話理解

這篇試圖用統一比較釐清：從連續影片學到的 latent action，究竟該怎麼建模、正則化、接入 VLM 與實體動作學習，才真的能改善機器人操作。

## Summary / Abstract 說了什麼

摘要將 latent action 定義為實體動作的緊湊替代表示，使 robot learning 能利用大規模無標註影片。作者指出，既有研究常在不同設定中各自測試建模、loss、正則化或整合策略，因此很難比較真正關鍵的設計因素。

論文自稱把代表性 LAM 統一到 autoencoding 框架，系統性調查三個維度中的 41 種設計選擇：

1. latent action 的建模範式；
2. 學習目標與正則化；
3. latent action 接入實體動作預測的策略。

此外，作者比較四種 latent action 品質代理指標，看它們能否預測下游操作表現。摘要宣稱，以 latent action 微調 VLM backbone 能形成更好的下游 policy 初始化，並在三個 benchmark 與真機任務驗證。由於本筆記未讀實驗章節，這些仍只記為論文自稱。

## Introduction 的問題設定

Introduction 從資料不對稱出發：VLA 繼承 VLM，world action model 繼承 video generation model，但網路影像／影片規模比 robot action data 大數個數量級。現有 embodied foundation model 因此多先使用 VLM 或影片模型，再用相對少量的機器人動作資料適應；action representation 本身仍缺少可擴展的資料來源。

LAM 的基本做法，是從相鄰影格學一個低維 latent action。以 Introduction 介紹的 LAPO 類框架為例，inverse dynamics model 從當前與下一影格推得 latent action，forward dynamics model 再用當前影格與 latent action 重建下一影格。這讓模型不需實體 action label，也能從影片學狀態轉移表示。

但 Introduction 指出兩層問題。第一，方法層面有多種建模、正則化與整合設計，常被分開提出且評估條件不一致。第二，評估層面若每次都完整跑完預訓練、VLM 微調、下游 policy 學習，成本很高；因此大家使用 probe 或 reconstruction 等 proxy，但 proxy 是否真能排序下游性能並不清楚。

作者因此設計一個共同比較，並在 Introduction 直接列出若干結論宣稱，例如原始 LAPO 仍是強基線、簡單的語意特徵差分也具競爭力、32 維 latent action 在其比較中整體最好、forward dynamics reconstruction 指標較可靠但只適合粗篩，以及擴大 latent-action pretraining 能改善下游表現。這些都來自 Introduction 的結果摘要，本筆記未讀其證據與適用範圍。

## 研究的第一性問題

- **基本問題**：沒有實體動作標註的影片，能否提供足以改善下游控制的「狀態如何改變」表示？
- **約束**：影片中的變化混合了主體動作、相機移動、物件運動與環境擾動；latent action 可能只記住下一影格，而非可控制的因果變化；不同 embodiment 的 action space 又不一致。
- **既有方法卡點**：每篇方法改不同元件、benchmark 與訓練流程，難以判斷增益來自核心設計、超參數或實驗條件；便宜 proxy 也可能無法可靠預測昂貴的下游結果。
- **作者試圖移動的邊界**：建立統一設計空間與比較基準，找出可重用的工程規則，並判斷哪些低成本指標只適合淘汰差模型、哪些足以做精細排序。

可以用一個簡化式理解標準 LAM：

$$
z_t = \mathrm{IDM}(o_t, o_{t+1}), \qquad \hat{o}_{t+1}=\mathrm{FDM}(o_t,z_t)
$$

其中 $o_t$ 是當前影格，$o_{t+1}$ 是下一影格，$z_t$ 是從兩者推得的 latent action，$\hat{o}_{t+1}$ 是模型重建的下一影格。直觀上，$z_t$ 應壓縮「什麼變化讓現在走到下一刻」；但只要資訊瓶頸不夠好，它也可能偷記下一影格的外觀，未必對控制有用。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 在共同 autoencoding 框架下比較 41 種 LAM 設計選擇。
- 橫跨建模範式、學習／正則化與下游整合三個維度，並提供實務設計指引。
- 比較四種 proxy，主張 forward dynamics reconstruction 類指標較適合粗粒度篩選，但不足以可靠找出最佳模型。
- 主張 latent action 微調 VLM backbone 可提供較強的下游初始化，且擴大預訓練帶來一致改善。

### 我的保守判讀

- 統一比較可能比第 42 種新 LAM 更有價值，因為它嘗試把研究問題從「誰的架構名字更新」拉回「哪個設計變數真正有因果影響」。
- Introduction 已列出多個具體最佳設定，但「32 維最好」很可能依賴影像編碼器、控制頻率、機器人自由度、資料集與訓練 budget；不能把單一維度當成跨場景常數。
- 從影片推得的變化不等於可由機器人控制的 action。相機運動、遮擋與他者動作仍可能進入 latent，尤其網路影片與機器人視角不同時更明顯。
- proxy 只能粗篩是一項重要警訊：表示表示學習的內在指標與真實控制效用之間仍有缺口，最終仍需昂貴下游驗證。
- 摘要與 Introduction 同時涵蓋模擬 benchmark 與真機驗證，但未讀實驗前，無法判斷資料規模、跨 embodiment 廣度、基線公平性及提升幅度。

## 可放進資料庫的筆記

1. **感知資料多，不等於 action supervision 多**：Physical AI 的 scaling 瓶頸是如何把影片規模轉成可控、可執行的表示。
2. **latent action 是代理變數，不是實體真值**：它壓縮影格轉移，但是否對應可控制因果因素，必須由下游任務檢驗。
3. **統一比較先於架構創新**：當研究碎片化時，共同 pipeline、相同資料與相同 budget 才能辨識真正重要的設計。
4. **防止 future-frame shortcut**：inverse model 看得到下一影格，資訊瓶頸與正則化的目的之一，是避免 latent 直接複製未來外觀。
5. **proxy 應分成淘汰器與排序器**：能排除明顯失敗的指標，不代表能選出第一名；兩種用途需要不同驗證門檻。
6. **mid-training 是資料轉譯層**：LAM 可先替影片產生 latent-action 標註，再用來調整 VLM backbone，最後才接少量實體 action data。
7. **跨 embodiment 的共同層可能是轉移結構**：實體 action 維度不同，但相鄰狀態中的某些語意變化可共享；真正可共享多少仍需明確量測。
8. **最佳超參數不是普遍定律**：維度、正則強度與整合策略應記成研究範圍內的經驗規則，而非 Physical AI 常數。

## 後續想追的問題

1. 41 種設計是否在相同資料、算力、backbone 與調參預算下公平比較？
2. 四種 proxy 與下游成功率的相關性有多穩定，跨 benchmark 是否改變排序？
3. 32 維結論對控制頻率、自由度、單／雙臂與不同影像表示是否敏感？
4. latent action 如何區分機器人可控變化、相機運動與環境中他者造成的變化？
5. 所謂 scaling improvement 的橫軸是影片數、訓練步數、模型規模還是多者共同增加，成本效益如何？
