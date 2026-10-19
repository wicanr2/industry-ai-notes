# REKI：記憶要保存分辨動作所需的過去

> **問題**：同一個當前畫面，可能對應「正在前進」或「剛從那裡退回」；無記憶策略如何避免在兩個姿態間反覆切換？
> **方法**：在 action expert 內保留每幀的 register keys／values，讓動作讀取近期歷史，而不重跑舊畫面的 VLM。
> **判讀**：移除同一組權重的歷史輸入，振盪比例明顯上升，是比跨模型排行榜更接近機制的證據；但短期穩定不等於長期記憶或物理安全。

## 原文、版本與閱讀邊界

- **題名**：REKI: Registering Knowledge in VLAs。
- **作者**：Juliette Marrie、Paul Pacaud、Adrien Ramanana Rahary、Shizhe Chen、Moritz Böhle；Kyutai／Inria／École nationale des ponts et chaussées。
- **版本**：[arXiv:2610.22178v1](https://arxiv.org/abs/2610.22178v1)；[官方 PDF](https://arxiv.org/pdf/2610.22178v1)／[官方 HTML](https://arxiv.org/html/2610.22178v1)。類別 cs.RO、cs.CV、cs.LG。
- **首次提交／本次版本日期**：2026-10-15 16:34:06 UTC；**擷取與閱讀日期**：2026-10-19（Asia/Taipei）。未帶版本的官方摘要頁本次只列 v1，未見 withdrawn／retracted 標記；這是本次查核狀態，非永久保證。
- **實讀範圍**：官方 32 頁 PDF 以 `pdftotext -layout` 抽取，讀摘要、主文 §1–8（方法、資料／訓練、實驗、真機與討論），附錄 A／A.1、C／C.1／C.2、D 開頭評估口徑、D.1、D.4、Table 8／9／10、E.1／E.2／Table 11。附錄 B 的完整資料清理與 sampling 細節、D 的逐任務完整表及 D.2／D.3 說明未逐項讀完；圖像只讀抽取文字與圖說，未做逐圖視覺審查。未審碼、未重跑。
- 主文沒有獨立 limitations 章；§8 的長期記憶未驗證是作者承認的邊界，其他部署失效分析會另標為筆記推論。
- [作者列出的程式碼入口](https://github.com/kyutai-labs/reki)僅記錄 provenance；本次未驗證其中每個資料流程或權重能否重現。

## 為什麼選這篇：把過去放在哪裡，決定誰付成本

近期筆記依次檢查了時間介面、下一次觀測的細節、候選排序和隱藏環境辨識。REKI 補上另一種不可辨識性：**環境沒有改變，當前畫面卻無法唯一指出任務階段或剛才的動作方向。**

舊方法可把歷史影像全部送進 VLM，但重複編碼與更長序列會增加成本；recurrent state 則往往要求訓練逐步展開；外接記憶模組又多一組介面。REKI 的可研究處不是發明「機器人應該有記憶」，而是用既有 expert attention 消費歷史，讓訓練仍可平行、舊畫面只編碼一次。

作者把 2.4B 模型、公開資料配方、工程優化與記憶一起提出。這幾項必須分開：排行榜好看不能單獨歸功於 register memory；記憶是否有用，要看同模型消融。

## 方法：讓記憶不依賴尚未生成的動作

### 1. 任務與輸入輸出

決策步 $t$ 的輸入為 $c_t=(z_t,o_t,s_t)$：$z_t$ 是語言及 embodiment／控制模式／頻率等 prompt，$o_t$ 是多視角影像，$s_t$ 是當前機器人狀態。輸出 $A_t\in\mathbb{R}^{H\times d_a}$ 是含 $H$ 個步驟、每步 $d_a$ 維的 action chunk；不同資料源保留自己的 joint／end-effector 控制慣例，而非假設所有機器人共用一個動作語意。

Qwen3.5-2B 把當前指令與影像編碼，10 層、寬度 768 的 flow-matching expert 透過 cross-attention 讀取其最終 hidden states。當前 state 經 layout-specific 投影進 adaptive normalisation，與 flow time 一起調節動作 token。過去 state 不作為歷史輸入。

### 2. Register 的寫入與讀取

每幀加入 **32 個可學習 register tokens**。它們讀當前 VLM context，並在 expert 的 self-attention 讀先前及當前 registers；**不讀 action tokens，也跳過依賴 state／flow time 的 adaptive normalisation**。動作 token 則可讀目前動作及歷史／當前 registers。

這個方向性是快取成立的條件：若 memory 會隨每輪 noisy actions 或 flow time 改變，就無法只算一次、供其他去噪步驟重用。這裡的 memory 不是文字摘要，也不是把過去實際執行命令原樣存入；它是由觀測／指令及更早 registers 得到的特徵。

預設 $K=3$ 是包含當前幀在內的窗口，故保留 $K-1$ 幀歷史。一般訓練相隔 1 秒；真機配方改為相隔 2 秒。**三幀不等於三秒固定保存期限**，更不等於已學會長任務記憶。

### 3. 資料與目標：記憶由未來動作 loss 學到什麼該留下

預訓練使用公開 robot manipulation 資料（含 OXE、DROID、AgiBot、RoboMIND 等）、EgoDex／EgoVerse／Xperience 人類第一視角資料，以及空間理解相關 vision–language 資料；沒有 proprietary pretraining data 是作者對此配方的陳述，不等於完全沒有資料清理／算力成本。預訓練為 32 張 H100、200k steps；附錄 Table 3 列 5,632 GPU-hours。

動作依資料集分位數正規化，padding 維度不計 loss；人類資料採相機座標下的雙手動作，沒有 proprioceptive state。這些設計讓異質資料可混訓，但未證明跨 embodiment 的因果遷移。

對一個示範 chunk $A$，加入高斯噪聲 $\epsilon\sim\mathcal N(0,I)$，構造 $A^\tau=(1-\tau)A+\tau\epsilon$，其中 $\tau=0$ 是乾淨動作、$\tau=1$ 是噪聲。expert $v_\theta$ 學的是速度 $\epsilon-A$：

$$
\ell_{\rm fm}=\mathbb E_{\tau,\epsilon}\left[\left\|v_\theta(A^\tau,\tau\mid c)-(\epsilon-A)\right\|_2^2\right].
$$

$\theta$ 是模型參數，$c$ 是允許讀到的 context；平方誤差以有效時間步與維度平均，避免高自由度 embodiment 自動占較大權重。這是示範動作重建目標，不是安全或任務完成的直接保證。

一個訓練窗口的每幀都有自己的 chunk loss，再對 $K$ 幀平均；較晚幀的 loss 可以經 attention 回傳到較早 registers，讓壓縮保留對後續動作有用的資訊。每幀取八組獨立 flow-time／noise draws，共用一次 encoder／register 計算。另以權重 0.1 的 cross-entropy 訓練已標註 subtask 與視語言答案；vision–language 樣本占 10%。訓練窗口作單次 batched pass，不用逐幀 recurrent unroll；這不表示整個記憶機制沒有額外 token／attention 成本。

### 4. 推論與控制迴圈

每次新觀測先做一次 VLM encoding，從高斯噪聲開始，以 **10 個 Euler steps** 從 $\tau=1$ 積分到 0。當前 registers 在第一步與動作一起計算，其 keys／values 供餘下九步重用，也跨 chunk 保留；新幀進來後淘汰最舊 cache。

值得注意的 train–test 差異：訓練窗口相互獨立，但推論時舊 registers 本身已讀過更舊 registers，資訊可能超過窗口間接存留。作者沒有因此證明可靠長期記憶；較舊污染也可能被間接帶入，後者是本筆記的待驗證推論。

相對單幀 VLA，真正改動是**跨 chunk 的 attention support／KV 持續性**，不是新世界模型、顯式 planner 或安全控制器。

## 實驗：先看同模型移除歷史，再看排行榜

以下數字皆為作者報告，本次未獨立重跑；百分比與 task score 不混用。

### 記憶消融最接近本篇機制

Figure 5 的記法 $3\to1$ 表示「以三幀 finetune、評估只給當前幀」，不是三步 action 縮成一步。

- **LIBERO-Plus**：$3\to3$ 成功率 90.4%，$1\to1$ 88.9%；$3\to1$ 也是 88.9%。
- **RoboTwin Clean**：同三種設定為 73.4%、67.9%、67.2%。這是記憶消融設定，不要直接與主榜另一次 Clean+Rand finetuning 的結果混算。
- **RoboCasa365**：依序 38.4%、33.0%、34.9%。只保留一幀歷史的 $3\to2$ 甚至達 39.3%，說明更多歷史不是單調更好。
- **振盪**：RoboTwin 50 任務、各 20 matched seeds；定義為忽略微小動作後，手臂在至少三個連續 chunks 反向運動。$3\to3$ 為 4.1%，同權重移除歷史的 $3\to1$ 為 14.8%，$1\to1$ 為 18.6%；一幀歷史 $3\to2$ 為 4.6%。判準先在 16 任務設定，再檢查其他 34 任務。

**筆記判讀**：同權重去掉歷史會惡化，支持「推論確實消費過去」，不只是訓練窗口讓樣本變多。作者將現象解釋為 perceptual aliasing：A 姿態像是應前往 B，B 又像是應返回 A；短歷史可解除方向歧義。但這還不是對所有振盪成因的唯一識別，也不等於記憶能修復所有錯誤。在無記憶模型會振盪的 seeds 上，有記憶版本仍只在 45% 成功。

### 主榜與訓練配方不能歸因給單一模組

LIBERO-Plus 對 40 任務施加七類擾動，Overall 是 10,030 個 perturbed episodes 的 pooled success，不是七欄等權平均。REKI 90.4%，作者列 InternVLA-A1.5 84.8%；Clean2Rand 是在 clean 訓練後對六種條件取平均，REKI 65.8%、ABot-M0 55.7%、Qwen-RobotManip 68.5%。RoboCasa365 的 38.4% 與其 unseen composite 14.1% 也不是同一項能力。

這些 baseline 大多引用已發表數字；資料、額外 video supervision、模型大小及 training compute 不齊，不能叫受控架構勝負。Table 8 更提醒：LIBERO-Plus 關閉色彩／crop augmentation 後 Overall 從 90.4 降至 85.7；RoboCasa365 關閉 mirroring 後 38.4 降至 33.5。**記憶、公開資料清理與 augmentation 都要分帳。**

### 真機：讀 partial credit，不改稱完整成功率

UR5／WSG50、固定 RGB 相機，15 Hz action loop；五任務各 50 個示範、各 10 個評估 episodes。與 $\pi_{0.5}$ 共同以 3,000 steps／global batch 360 finetune，但 chunk 長度為 REKI 30 steps、$\pi_{0.5}$ 50 steps，並非控制介面全同。

Figure 8 平均 **task score**：REKI 63.5%、無記憶 54.6%、$\pi_{0.5}$ 39.1%，包含抓取／放置 partial credit 及順序錯誤扣分；不能讀成完整成功率。短任務有無記憶分數不變，較長任務提升 12–17.5 個百分點。每任務十次、單一場景／手臂，本文所讀部分未提供讓此小樣本可外推部署可靠性的區間或測試。

### 成本：同一版本的不同計時要保留差異

§6.3 跨模型測試列 compiled REKI **21.8 ms／chunk**：H100、batch 1、兩張 256×256 影像、10 個動作及十次 Euler，包含 preprocessing 與 host／device transfers；三次重複、各 320 chunks 的中位數。這不是相機曝光到實體動作完成的反應時間，更不是 UR5 的端到端閉迴路頻率。

附錄 A.1 的記憶窗口微基準則另列 **K=1：22.6 ms、K=3：22.8 ms**，每次 200 chunks、兩次 interleaved repetitions；cache 每個過去幀約 2 MiB，K=3 約 4 MiB。主文另一段提讀 cache 增加 0.1 ms；這些是不同量測，不把 21.8／22.8 拼成同一次實驗的總量與分項。作者的「幾乎無成本」較適合解讀為該測試下的**增量小**，不是任意視窗、平台或感測配置都免費。K=32 只做 latency 測量，不是長期任務表現驗證。

## 第一性原理：最小狀態要能區分下一個動作，不必重播所有過去

1. **最小必要狀態**：若當前觀測已充分，歷史可能無益；若兩個歷史導致同一畫面卻應採不同動作，策略至少要保留能拆開兩者的資訊。REKI 針對的是動作方向／局部任務階段，不是完整環境重建。
2. **資料限制**：動作 loss 只會鼓勵保留對訓練示範有用的過去。沒有出現在訓練中的延遲依賴、關鍵事件或安全訊號，不會因為加 registers 自動被保存。
3. **計算限制**：依賴圖切乾淨才可快取；讓 registers 讀 noisy action 可能增加表達力，但會破壞跨 Euler-step 重用。這是效率／資訊的一個研究權衡，不是通用最優設計。
4. **物理限制**：短期平滑與少振盪不會阻止外物闖入、接觸力超限或錯誤夾取。低延遲、記憶、獨立安全護欄分屬不同層。
5. **可能失效（筆記推論）**：若指令中途改變卻保留舊 cache、相機切換、長遮擋、觀測間隔不符訓練，或需記住很久前的事件，歷史可能不足甚至誤導。本文未用這些設定逐一排除。

## 可複用研究問題與後續驗證

- **歷史必要性測試**：固定權重、當前影像及種子，交換／清空／打亂歷史；能否同時改變選擇方向、任務成功與振盪，而不只是讓 latent 看起來有時間結構？
- **記憶期限測試**：令關鍵事件到決策的時間逐漸變長，並測 instruction change 後是否需要 reset；把窗口幀數、實際秒數及間接累積資訊分開。
- **部署成本測試**：相同硬體與控制頻率下，將 cache reset、相機傳輸、排程、動作執行及 safety intervention 加入，增量記憶成本與端到端尾延遲還剩多少？

## 與庫內筆記的接點

- [Chronos Policy：時間介面](../2026-10-14/01-chronos-policy-把時間還給控制介面.md)：記住幀不代表知道其物理時間；REKI 的固定間隔訓練不能直接替代時間標記。
- [FoveaVLA：下一輪觀測](../2026-10-16/01-foveavla-把下一次觀測變成策略輸出.md)：一個改善下一次看什麼，一個保留剛才看過什麼，兩者都需檢查是否保留控制所需資訊。
- [T2-z：環境可辨識性](../2026-10-18/01-t2z-環境適配先問互動能否辨識.md)：隱藏物理參數與隱藏任務階段是不同歧義；不能把短期記憶成功當成已辨識環境動力學。

**資料庫摘要**：REKI 將近期視語言 context 壓縮到 action expert registers，靠 attention 單向性實現跨幀／跨 flow-step 快取；同權重移除歷史的振盪消融支持局部歷史的介入價值。保留三個邊界：主榜混合配方非純記憶收益、真機 task score 非完整成功率、短窗口低增量成本非長期記憶／安全保證。
