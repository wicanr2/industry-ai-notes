# PRM-as-a-Judge 1.5: A Toolkit for Robot Process Assessment

## 原文資訊

- 論文：PRM-as-a-Judge 1.5: A Toolkit for Robot Process Assessment
- 作者：Yuyang Liu、Yanqing Shen、Ruike Chen、Jifan Zhao、Yuxuan Tian、Yichi Zhang、Tianfeng Long、Zixuan Yin、Yipu Wang、Ziheng Qin、Wenxing Tan、Yang Shi、Mingyu Cao、Runze Xiao、Ziqi Wang、Zhixin Yin、Shiwei Chu、Yi-Fan Zhang、Yao Mu、Yuheng Ji、Yihao Wang、Jun Yan、Zhongyuan Wang、Pengwei Wang、Xiaolong Zheng
- arXiv ID：2608.14284v1
- 分類：cs.RO、cs.CV
- 發表 / 更新：2026-08-14 / 2026-08-14（v1）
- 連結：[abs](https://arxiv.org/abs/2608.14284v1) / [pdf](https://arxiv.org/pdf/2608.14284v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀工具細節、Evaluation、Key Findings、Conclusion 與附錄
- 擷取日期：2026-08-18

## 為什麼選這篇

近期 VLA、world-action model 與 embodied model 的比較經常壓縮成一個成功率，但相同的失敗可能代表完全不同的能力：有的 rollout 一開始就無法接近目標，有的已完成多數步驟才失手；相同的成功也可能一條流暢、一條充滿停滯與修正。這篇把評估單位從最終結果拉回整條執行歷程，對 Physical AI 的模型選型與失敗診斷都有直接價值。

它和今日第一篇的價值相互獨立：BICPO-VLA關心非同步 action handoff 的控制方法，PRM-as-a-Judge 1.5則關心如何從 rollout video 建立進度曲線，區分失敗端進展、退步後恢復，以及成功端執作品質。方法與評估各占一篇，不是為了湊滿兩篇而選相近模型。

## 一句話理解

這篇想把機器人 rollout 從「最後成功或失敗」的一個 bit，展開成能看見進展、停滯、退步與恢復的過程評估。

## Summary / Abstract 說了什麼

摘要認為，二元成功率與規則式 process score 無法充分描述 embodied model 的細粒度能力。作者提出 PRM-as-a-Judge 1.5：使用 process reward model（PRM）把 rollout video 轉成密集進度曲線，再從曲線衍生多項指標。

相較 1.0 版，摘要稱 1.5 新增三類指標，分別描述失敗 rollout 在失敗前達到多少進展、發生 drawdown 後能否恢復，以及成功 rollout 的執作品質。作者也表示，他們以現有 benchmark 的 rollout videos 評估多個 embodied models，並提出 RoboPulse++，用來檢查 PRM 本身是否能可靠辨認過程進展。

摘要另稱已釋出 benchmark、指標實作與視覺化工具。這些都是論文與摘要的自述；本次未讀 Evaluation、Key Findings 與附錄，因此沒有採用作者對各模型的排名或結論，也無法核對 PRM 的誤差、資料涵蓋與重現性。

## Introduction 的問題設定

Introduction 從 embodied model 走向更長、多任務環境談起：執行歷程變複雜後，失敗型態也變多，只問是否完成任務，無法回答模型在哪裡猶豫、何時倒退，或能否從不穩定狀態恢復。

作者用兩個直觀例子說明結果指標的資訊損失。第一，失敗 rollout 可能從未接近目標，也可能幾乎完成才失敗；第二，成功 rollout 可能平順有效率，也可能依靠大量遲疑、修正與恢復才勉強完成。若把兩者各自壓成相同的 0 或 1，就無法診斷能力與改進方向。

PRM-as-a-Judge 1.5 延續 1.0 的 OPD（Outcome–Process–Diagnosis）框架，把 rollout video 轉成 progress curve，計算過程指標並產生評估報告。Introduction 宣稱新增 conditioned metrics，將近成功的失敗、退步後恢復，以及以成功為條件的執作品質分開描述；另以 RoboPulse++ 評估 PRM 能否辨識 manipulation 過程中進度上升或下降的區間。

## 研究的第一性問題

- **基本問題**：機器人任務是時間序列；為何只用終點標籤評估整段執行，會丟失哪些對能力診斷重要的資訊？
- **約束**：過程評估本身不能成為不可檢驗的第二個黑箱；如果進度由 PRM 判斷，就必須另外量測 judge 的可靠性。
- **既有方法卡點**：成功率無法區分失敗距離與成功品質；人工規則式分數又可能昂貴、任務特定，且難以覆蓋複雜恢復行為。
- **作者試圖移動的邊界**：從 outcome-only leaderboard 移向 outcome、process 與 diagnosis 並存的評估，並把 evaluator 本身也納入 benchmark。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 以 PRM 從 rollout videos 建立密集 progress curves，支援過程層級的機器人能力分析。
- 擴充 OPD 指標系統，加入失敗端進展、退步後恢復與成功端執作品質。
- 對主流 embodied models 做大規模 rollout assessment，提供成功率之外的觀察。
- 提出 RoboPulse++ 檢驗 process judge，並釋出 benchmark、指標、視覺化與使用工具。

### 我的保守判讀

- 將失敗深度、恢復能力與成功品質分開，是比單一成功率更接近工程診斷的方向，也可能幫助資料回收與訓練 curriculum 排序。
- 但 progress curve 不是直接觀測的物理真值，而是 evaluator 的推定。PRM 的視覺盲點、任務先驗與尺度校準，可能被下游指標放大。
- 「進度」未必單調，也未必能由畫面唯一判定。例如暫時放下物體以換手、繞路避障或主動探索，短期看似倒退，長期可能是合理策略。
- 只依 rollout video 評估，可能看不到力矩、接觸力、關節安全裕度、控制頻率與隱性 system state；視覺進度高不代表物理執行安全。
- 本次未讀指標定義與 Evaluation，無法判斷不同任務間的尺度是否可比、PRM 的信心如何傳入最終指標，或 leaderboard 差異是否超過 judge uncertainty。

## 可放進資料庫的筆記

1. **結果相同不代表能力相同**：應區分「完全沒開始的失敗」與「接近完成的失敗」，也要區分流暢成功與反覆補救的成功。
2. **評估應保留時間結構**：將 rollout 壓成一個分數以前，先保留進度曲線、drawdown、恢復與停滯等可診斷訊號。
3. **judge 也必須被評估**：用 learned evaluator 取代人工規則，只是把測量問題移到另一層，不能免除 calibration 與 benchmark。
4. **進度不是天然單調**：機器人可能合理地暫時遠離局部目標；評估器需要辨認策略性退步與真正失控。
5. **過程指標可連回資料策略**：近成功失敗可能適合做 corrective data；早期崩潰可能反映感知、理解或初始化問題；恢復成功可作為 resilience 樣本。
6. **跨模型排名要帶 evaluator uncertainty**：若 PRM 對兩種 policy 風格的偏誤不同，細粒度排名可能比二元成功率更精緻，卻不一定更真實。
7. **Physical AI 評估需多通道**：影片進度最好與力／扭矩、安全事件、控制延遲、能耗及人工任務判定交叉驗證。

## 後續想追的問題

1. progress curve 的標註與訓練單位是 frame、片段還是成對比較？不同任務如何對齊尺度？
2. 三個新增 conditioned metrics 的正式定義為何，對短 rollout、非單調任務與多階段任務是否穩健？
3. RoboPulse++ 如何避免和 PRM 訓練資料、模型家族或視覺風格重疊？
4. 作者如何呈現 judge uncertainty；模型排名差異是否經過信賴區間或敏感度分析？
5. 若只看影片，哪些 failure mode 會系統性漏掉？能否加入 robot state、force/torque 與事件 log 做多模態過程評估？
