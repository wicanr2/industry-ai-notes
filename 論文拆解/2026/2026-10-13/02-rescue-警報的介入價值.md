# RESCUE：警報準，不代表照警報介入有價值

> 研究問題：VLA 的失敗監測器即使辨識準確，停止、重設或恢復真的降低完成任務的代價嗎？
> 方法核心：從同一個可還原機器人—政策狀態，分岔比較不同介入，再把警報放進完成成本模型。
> 本筆記判讀：可恢復性與介入價值是兩個不同量；本文的負結果限定於宣告的介入、deadline、成本及模擬 workload，不是「機器人不該有護欄」。

## 來源與實際閱讀範圍

- 原題：*RESCUE: Is This Alarm Worth Acting On? Counterfactual Evaluation of VLA Runtime Monitors*。
- 作者：David Ahmedt-Aristizabal、Abdelwahed Khamis、Mohammad Ali Armin、Lars Petersson（CSIRO）。
- 版本：**arXiv:2610.13516v1**；首次提交 2026-10-09 12:38:35 UTC；擷取與筆記日期 2026-10-13（Asia/Taipei）。
- [arXiv 版本頁](https://arxiv.org/abs/2610.13516v1)｜[原文 HTML](https://arxiv.org/html/2610.13516v1)｜[原文 PDF](https://arxiv.org/pdf/2610.13516v1)。
- **實讀**：官方 HTML 摘要、§I–II 導論／相關工作、§III-A–C 方法與公式、§IV-A–E 實驗及 robustness controls、表 I／II、§V 限制、§VI 結論；PDF 已下載並以 `pdftotext -layout` 核對方法文字。PDF 圖中字型抽取有亂碼，因此圖表論述以 HTML 的文字／caption 為準。未追讀引用論文、未執行分支重播或獨立重現結果。
- 官方版本頁本次未見 withdrawn／retracted 標記；庫內未重複。以下數值是**作者報告**，不是本筆記重現。

## 1. 缺口：辨識、來得及救、值得救不能混在一起

監測器常用 AUROC 衡量失敗與成功的排序能力，或用含時間的指標判斷警報早晚。但「很可能失敗」仍缺兩個條件：現有介入能否挽救，以及介入代價是否小於繼續執行。

同一狀態在不同恢復控制器、噪音與剩餘時間下，可能有不同結果。本文不是提出更準的新 failure detector，而是改變**評估單位**：從 detector 移向「monitor × intervention × workload」。相對 CheckVLA 的固定修復與不可逆時點，作者比較沿軌跡各 checkpoint 的介入成功率，另加入誤警報、失敗盛行率與 reset-and-retry 成本。

## 2. 方法：完整狀態分支，而非只看同一張影像

### 任務與輸入輸出

輸入為普通執行的 trunk trajectory、action chunk 邊界保存的完整可還原 simulator／policy state、可用介入集合、後續隨機執行模型與原任務剩餘預算。輸出是每個 state–intervention pair 的成功機率與完成成本、最後達恢復標準的 checkpoint，以及警報規則相對不介入的成本差。

既有政策為 OpenVLA-OFT 與 $\pi_{0.5}$（pi-zero-point-five 視覺—語言—動作政策）。本文未提出新的 VLA 訓練目標，也未訓練新的 detector 方法；SAFE-style MLP／LSTM heads 是評估用監測器實作，不等同 RESCUE 本身的新政策。本文未在方法主文逐列所有序列化 state 欄位，本筆記不補成已確認的實作清單。

### 核心量與限制

原文式 (1) 可寫為：

$$
Q^{\mathrm{succ}}_{\xi,B}(s_t,a)
=\Pr_{\xi}[\text{在 }B(t)\text{ 內成功}\mid s_t,a,\pi].
$$

$s_t$ 是 checkpoint $t$ 的完整機器人—政策狀態；$a$ 是介入；$\pi$ 是原政策；$\xi$ 是後續隨機性／執行模型；$B(t)$ 是剩餘步數。白話是「從這個狀態做這個動作，在剩下時間內完成的機率」，不是該狀態天生的安全分數。

若可用介入集合為 $\mathcal A$、要求成功機率至少 $\tau$，則原文式 (3)–(4) 定義：

$$
V(s_t)=\max_{a\in\mathcal A}Q^{\mathrm{succ}}_{\xi,B}(s_t,a),
\qquad H=\max\{t\in\mathcal T:V(s_t)\geq\tau\}.
$$

$V$ 是集合內最佳成功機率；$\mathcal T$ 是保存的 checkpoint 集合；$H$ 是最後達標時點；$\tau$ 為恢復門檻。沒有達標 checkpoint 時 $H$ 未定義。可恢復性不必隨時間單調下降，所以不能把 $H$ 說成精確的物理不可逆邊界，也不能保證所有更早時點都可救。

### 分支、估計與 replay validity

1. 正常執行並在 action chunk 邊界存狀態：OpenVLA-OFT 每八步、pi-zero-point-five 每十步。
2. 在新 process 還原 checkpoint，對 `Continue`／`Recover` 用不同 seeds 跑到成功或原剩餘 budget 用完。
3. 每個 state–intervention pair 先跑四個分支；恢復門檻附近擴到 16。用成功次數與 branch 長度估計成功率及成本。
4. 確定性條件先做 replay-fidelity check；還原後必須重現 trunk continuation，否則反事實比較沒有共同起點。

少量樣本不用原始成功比例直接判定可恢復。原文式 (5) 使用 Jeffreys prior 的 Beta posterior 下分位數：

$$
\widehat Q^{\mathrm{succ}}
=\operatorname{Quantile}_{0.25}
\left[\operatorname{Beta}\left(k+\tfrac12,K-k+\tfrac12\right)\right].
$$

$K$ 是分支數、$k$ 是成功次數；Beta 是成功機率的後驗分布；取第 25 百分位，讓少量有利 rollouts 不輕易通過門檻。**這不是 95% 頻率學派信賴下界，也不是安全認證**；對介入取最大值後亦不能當多重比較校正的聯合保證。

### 介入到底做什麼

`Continue` 直接恢復原政策。`Recover` 是固定 open-loop 腳本：凍結八步；若上一 gripper command 為正則下降六步、釋放四步；再縮回八步、穩定四步，總計 30 或 20 步；腳本期間 policy server 不動，必須回到原政策後才計成功。這不是學會的最優恢復政策，也不是轉交更強模型。

分支對六個手臂連續動作維度使用標準差 0.05 的擾動，不擾動 gripper 或恢復腳本；pi-zero-point-five 另保留自身 sampling。主條件剩餘預算為 $B(t)=220-t$，$t$ 為已執行步數，不因介入重新給 220 步。

## 3. 決策價值：少浪費一段時間，不等於少付一次重試

Stop-and-reset 不做物理分支，而用普通 logs 解析計算。重設成本設為一單位，之後從相同 workload 重新嘗試，直到完成。原文式 (9) 的 break-even false-alarm rate 為：

$$
f^*=\frac{p}{1-p}
\frac{d\,c_t(T_f-t_d)}{\Delta+C_{\mathrm{never}}},
\qquad
\Delta=1+c_t(t_{\mathrm{fa}}-\bar T_{s,\mathrm{FA}}).
$$

$p$ 是失敗盛行率；$d$ 是失敗上發出警報的比例；$c_t$ 是每步成本；$T_f$ 是被偵測失敗的平均終止長度；$t_d$ 是其平均警報時間；$t_{\mathrm{fa}}$ 是成功軌跡誤報的平均時間；$\bar T_{s,\mathrm{FA}}$ 是**被誤報那些成功軌跡**原本完成的平均時間；$C_{\mathrm{never}}$ 是從不介入直到完成的期望成本。$\Delta$ 加上重新嘗試成本，構成誤報的額外代價。

$f^*$ 是此成本模型可容忍的誤報率；實際成功軌跡誤報率低於它，停止規則才划算。不是通用 2% 或 5% 門檻。分子來自提前停止失敗所省的時間，分母包含 reset 與替換嘗試；成功率越高、reset 越貴，誤報越難負擔。模型假設重試工作負載穩定，沒有估入所有真機傷害／接觸／停機成本。

## 4. 實驗：負結果的適用範圍比 headline 窄

### 資料、基線與量測

- MuJoCo 的 LIBERO-Spatial／LIBERO-Plus：1,562 trunk episodes、262 failures、23,430 snapshots、10,083 branched checkpoints、128,340 branches。**全部觀察失敗都是 220 步 timeout**。
- 主分析是兩個 strong-policy LIBERO-Plus cells，各 481 task variants；另外弱化 OpenVLA-OFT 與 vanilla cells 為控制。兩個政策在不同 perturbation tracks 失敗，不作跨政策排名。
- 監測器：steps-since-progress、action-jerk、pi-zero-point-five sampling disagreement、SAFE-style MLP／LSTM hidden-representation heads。Action-jerk 是動作一階差分的啟發式，並非物理三階位置導數。
- 門檻在 validation targeting 5% successful-episode false alarms，測試用實際誤報率；基線包括 never intervene、rate-matched random alarm 及固定步數 clock。成本把 median successful episode 設為 0.1 reset。
- 評估包含成功機率、recoverability horizon、episode／early AUROC、AUCPDT、相對 horizon 的警報時機及每完成任務的 excess cost。成本區間先以 1,000 次分層 episode bootstrap，另用 base-task resampling 檢查相依性。

### 三組值得保留的作者結果

1. **恢復能力依介入而變**：OpenVLA-OFT／LIBERO-Plus 的 66 次失敗中，在 0.5 門檻下，Continue 有可恢復 checkpoint 者 14 次，Recover 33 次，兩者聯集 34 次。但弱化政策條件下，固定腳本反而縮小可恢復集合；「恢復」這個名字不保證幫忙。
2. **實際誤報大於收支平衡**：steps-since-progress 在 OFT-LP 的 break-even 為 1.01%，held-out 實際為 7.25%；pi-zero-point-five-LP 為 0.45% 對 7.04%。前者每完成任務 excess cost 為 +0.0835 resets，episode bootstrap 95% 區間 [0.0294, 0.1392]，base-task resampling 改為 [0.0234, 0.2793]，均高於零。區間是此資料與抽樣方法下的不確定性，不是新任務部署保證。
3. **辨識指標不是決策價值**：相關 metrics／overlapping sets 的描述性 tally 為 detection／timing 61/75 通過，對 never intervene 的 decision value 0/15 通過。作者明說不是獨立統計檢驗。較高失敗率的弱化條件有 SAFE-style 改善案例，所以不是一律不介入的結論。

### 消融與驗證把哪個替代解釋排掉

- 3,000 次 seeded replays 重現 joint trajectories；但更強 zero-noise known-answer test 找到 sensor-noise observation channel mismatch，作者修正 branch runner 並重跑主要結果。單看 replay 通過數不夠。
- 20 個失敗固定每 checkpoint／介入 32 branches：有沒有任何合格 checkpoint 的 episode 標籤均不變，部分 horizon 仍變。較高採樣是敏感度參考，不是 ground truth。
- 改恢復門檻、噪音、時間價格與選 threshold 的目標；依成本選 threshold，八組配置有五組在 held-out 不發警報，唯一負 point estimate 的區間跨零。
- **長度混淆**：只數 action chunk boundaries 即達 episode AUROC 1.000；加入 early-exposure control 後，steps-since-progress AUROC 從 0.979 降至 0.637。全部失敗都 timeout 的資料，很容易讓「預測失敗」退化成「辨識跑很久」。
- Fresh-budget clock ablation 在 sensor-noise correction 前跑；作者只拿它說明 budget 敏感性，不把它當已修正主結果，本筆記亦如此。

## 5. 第一性原理與研究判讀

**最低必要狀態（本筆記推論）**不是單張 RGB，而是足以讓未來執行重現的 simulator／policy 狀態、觀察通道、隨機性和剩餘 budget。若 branch 恢復的是另一種觀察噪音，結果差異就混入起點差異，而非純介入效果。

方法有效條件是 snapshot fidelity、宣告清楚的 intervention repertoire、合理的 stochasticity 與部署成本。它回答的是「在此宣告範圍內哪個行動值得做」，不是算出所有可能恢復方法的可達集合。真機難以從完全相同狀態重跑，是移植此方法的主要物理限制。

**本筆記判讀**：對產業較可移植的是 audit workflow，而不是本文的誤報百分比。應記錄何時警報、觸發什麼動作、成功／損害是否改變、重新開始要多久。安全強制停止、法規限制與避免損害另有硬約束；本文的 timeout／時間成本模型不能用來取消它們。

限制另含：沒有硬體實驗；branch noise 與價格未由部署校準；只測兩政策與少量監測器／介入；輕量監測器分割非 base-task-disjoint；整體只有十個 base tasks，SAFE-style holdout 每 seed 三個，cluster intervals 仍可能樂觀。沒有顯著改善不等於已證明所有介入無效。

## 6. 後續驗證問題

1. 加入非-timeout 失敗、接觸損害和真實 reset 工時，重新估計成本後，監測器排名與最佳警報門檻是否改變？
2. 換 learned recovery／人工接手，在相同 checkpoints 上增加 repertoire，能否降低成本，而不只是提高可恢復數？
3. 使用全新 base-task holdout，再用部署資料校準 noise 與誤報率，哪些原有負結果仍成立？

與 [BT-Agent](./01-bt-agent-固定技能與反應式護欄.md) 對讀：本地 guard 的強制中斷能力是執行契約；選擇停止／恢復的效益是決策問題。兩層應各自驗證，不能只用 task success 或 AUROC 混成一個「安全」分數。
