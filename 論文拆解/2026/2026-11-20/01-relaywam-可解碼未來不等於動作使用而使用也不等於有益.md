# RelayWAM：可解碼未來不等於動作使用，而使用也不等於有益

> **問題**：未來預測只在訓練出現時，如何確認動作頭真的讀到了它學出的資訊？
> **方法**：在影片與動作 Transformer 之間加入依任務、機器人狀態、動作步與去噪時間取用特徵的 transition tokens；部署不生成未來影格。
> **判讀**：因子消融與表徵擦除比只報成功率更接近機制，但動作改變仍非「正確使用」；殘差未來、線性探針與真機分母各有限定。

## 原文與實際閱讀範圍

- **論文**：Making Future-Predictive Representations Actionable，方法名 RelayWAM。
- **作者**：Fangchuan Wang、Hao Zhang、Qiyan Zhao、Huanqi Zhao、Guanting Ye、Xu-Yao Zhang、Yuqing Gao。
- **版本／日期**：`2611.22994v1`，2026-11-17 16:10:09 UTC 提交；2026-11-20（Asia/Taipei）擷取。無版本摘要頁本次只列 v1，未見 withdrawn／撤稿註記；這不等於保證日後不撤稿或已同儕審查。
- **來源**：[版本摘要](https://arxiv.org/abs/2611.22994v1)｜[目前摘要與版本歷史](https://arxiv.org/abs/2611.22994)｜[官方 HTML](https://arxiv.org/html/2611.22994v1)｜[PDF](https://arxiv.org/pdf/2611.22994v1)。下文的章節、表格皆指此版本。
- **實讀**：官方 HTML 摘要、§1–6、附錄 A–E、Tables 1–6，以及 Figures 1–6 的圖說。方法、訓練／推論、模擬主表／因子消融、真機設置、探針與擦除協定均已讀；未逐像素讀圖、看影片、審程式或重跑，未聲稱閱讀 PDF。沒有獨立 limitations 章節，以下限制由實讀方法與評估範圍整理。
- **與既有材料關係**：11-19 僅列候選，今日首次新增方法筆記；不回填或升格昨日閱讀範圍。所有效能都是作者報告，非本筆記實測。

## 一、缺口不是「有沒有預測能力」，而是「哪條路徑在用」

未來影格預測與控制共用視覺 backbone，並不保證兩者需要同樣資訊。影片預測可能利用背景與全局外觀，動作目標則只需要夾爪、物體和相對位姿。作者先以 Fast-WAM 比較 action-only 與 action+future 訓練，再問三層問題：

1. **寫入**：線性探針能否從深層特徵讀出未來變化？
2. **讀取**：動作 loss 敏感的方向，是否也包含這些可解碼變化？
3. **介入**：只擦掉動作端讀取的未來相關特徵，輸出的 action chunk 是否特別改變？

這比把 attention 熱圖叫作推理證明更謹慎。作者以 activation×gradient 衡量 token 對各 loss 的一階敏感度；它是局部近似，不是移除任意大特徵後的全局有限擾動保證。Fast-WAM 深層的兩種 loss 關注和梯度方向逐漸分歧，構成新增接口的動機，不是對所有 WAM 的普遍定理。

## 二、任務與方法：把訓練過的視覺特徵轉成當步可讀的接口

### 輸入、輸出與骨幹

輸入為當前影像、語言指令及本體狀態；輸出為多步連續動作 chunk。Wan2.2-5B Video DiT 與 Action DiT 形成 30 層的 Mixture-of-Transformers，總 backbone 為 6.02B 參數。影片 tokens 不讀動作；動作 attention 原本讀當前影格的 keys/values 與自身動作 tokens。

這裡沒有用 LLM 在部署產生自然語言規劃，也沒有在線生成多個未來再打分。語言是控制條件，模型主要是影片／動作 flow-matching 系統。

### 真正改動：跨深度 relay，而非跨實際時間的長期記憶

在零起算的第 14–29 層附加 transition layers，每個動作步有一個 transition token。先讓當前動作特徵、前一深度的 transition token、動作步／層／flow time 編碼組成 query；再讀語言及逐本體維度的狀態 tokens，最後讀同層當前影格特徵。資訊以跨層共享權重的 Transformer 更新，注入同層動作 attention 的額外 keys/values。

用原文 Eq. (7) 表示核心更新：

$$
T_l=\operatorname{TransBlock}_l\bigl(T_{l-1}+g_l(\tau)R_l\bigr),\qquad T_{13}=0.
$$

- $l$ 是網路深度，$T_l$ 是每個未來動作步各一列的中介 tokens；**不是已觀測到的真實未來**。
- $R_l$ 是按當前動作估計、任務與本體狀態，自視覺特徵讀出的內容。
- $\tau\in[0,1]$ 是 flow-matching 的去噪時間，不是牆鐘時間或機器人運動時間；$g_l(\tau)\in(0,1)$ 是 sigmoid 純量 gate。
- $\operatorname{TransBlock}_l$ 在動作步之間做 self-attention 與前饋運算；多層共用主要權重，但各層保留部分 normalization、scale、bias。

新增 34.96M 參數。小參數增幅不等於同樣小的延遲：去噪時仍須重算接口，而其反向梯度也會改變視覺表徵。此法不是只在凍結模型外面裝一個讀取器。

### 訓練資料與目標

作者保留原本的聯合目標，不對 transition tokens 額外加 loss：

$$
\mathcal L=\mathcal L_{\mathrm{action}}+\lambda_{\mathrm{future}}\mathcal L_{\mathrm{future}}.
$$

$\mathcal L_{\mathrm{action}}$ 是動作生成的訓練損失，$\mathcal L_{\mathrm{future}}$ 是未來預測輔助損失，$\lambda_{\mathrm{future}}$ 為其權重。動作梯度經由接口讀取路徑回到 Video DiT，因此「讀取改善」與「寫入表徵被重新塑造」會一起發生。實讀文字未明列權重值、完整兩項 loss 展開式、action chunk 長度與執行前綴長度，不自行補值，也不把它寫成可直接重現的完整配方。

模擬聯合訓練 LIBERO 四個 suites；受控變體使用相同 backbone、資料、動作目標與優化配置：20,000 steps、8 張 A100-80GB、AdamW、固定學習率 $10^{-4}$、global batch 128。這個學習率表示每次參數更新的尺度設定，不是性能或收斂保證。真機另收 80 段 demonstrations，各比較模型訓練 10 epochs。

### 推論與控制迴圈

每次根據當前觀測規劃 chunk 時，Video DiT 跑一次，cache 當前視覺 keys/values 與條件 tokens。動作去噪的每一步，因動作估計與 flow time 變化，從零重新累積 transition tokens；不生成未來影格。

**一次 chunk 內的 cache 不等於整段任務的最新資訊。** 實讀協定未列控制頻率、感測到生效延遲與 chunk 執行／重規劃細節，不能推成已處理過期命令、即時避障或安全停止。附錄擦除實驗用 10 個去噪 steps，亦不據此假定全部主榜部署都用同一時序。

## 三、實驗究竟支持哪一個命題？

### 成功率主表：有效，但不是全面超越

- **LIBERO（Table 2）**：四 suites 各 10 任務，每任務 50 rollouts，指標為任務成功率。RelayWAM 平均 98.2%，Fast-WAM 97.6%；OpenWAM-α 99.3%。同分布已接近飽和，本文不是最高分。
- **LIBERO-Plus（Table 1）**：背景、相機、語言、照明、布局、機器人初態、感測噪聲七種擾動，依官方 protocol 零樣本評估。作者正文報 RelayWAM 整體 72.03%、Fast-WAM 51.50%；表格四捨五入為 72.0 與 51.5。Total 是全部評估 episodes 的整體成功，不自行改算成七欄未加權平均。相機欄 47.0 仍低於 OpenVLA-OFT 56.4，機器人欄 61.6 低於 OpenWAM-α 76.1。
- **LIBERO-PRO（Table 3）**：環境、語言、物件、位置與任務泛化。RelayWAM 平均 44.7%，Fast-WAM 40.7%，但 π0.5 為 53.2%。RelayWAM 的位置僅 1.4%、跨任務 18.8%；語言從 Fast-WAM 95.1% 降到 93.9%。平均改善不能掩蓋脆弱軸。

外部基線包含 VLA、部署聯合生成 future/action，以及不生成 future 的 FFI 模型；訓練資料、預訓練及推論計算未全部等化，不把跨論文榜單視為單一模組的因果證據。實讀表格亦未提供完整的訓練 seeds／跨 seed 誤差，不能聲稱穩定顯著勝出。

### 最有價值的消融是二乘二，而不是完整模型對舊模型

Table 4 的 LIBERO-Plus：

- A0：無 future supervision、無 transition，46.3%。
- A1：有 future、無 transition，51.5%。
- B0：無 future、有 transition，56.4%。
- B1：兩者都有，72.0%。

依表格顯示精度，未來監督在原接口增加 5.2 個百分點，在 transition 接口增加 15.6 個百分點；差上差為 **10.4 個百分點**（本筆記計算）。這支持兩因素有互補性，並提醒：**接口即使沒讀過未來監督，也有收益**，不能把 B1 的全部優勢都稱為預測知識轉移。

因為接口也改變梯度流，尚未分開「更會讀同一個 backbone」與「backbone 因新路徑學得更好」。可補凍結／交換 backbone 的因子實驗，以及等參數 generic adapter。相同 steps 也不代表相同總 FLOPs；本文未提供此處所需的端到端成本等化。

### 真機：室內假樹採蘋果，而非果園部署

§5.1、§5.4 與 Figure 5 圖說：Piper 手臂、室內人工蘋果樹，Fixed／未見位置且含葉遮擋的 OOD／再加彩色環境光的 Light，**各 20 次**。Light 下作者報 RelayWAM 70%、Fast-WAM 15%、DM0.5 75%，按分母可換為 14/20、3/20、15/20（本筆記換算）。未讀圖內 Fixed／OOD 詳細柱高，不補造數字。

作者主張 RelayWAM 無大規模 embodied pretraining 即接近 DM0.5，但它仍有大型影片模型預訓練；相同 80 段真機 demonstrations 不代表預訓練資料／算力等同。這只驗證單一操作族與少量試次的擾動魯棒性，未提供果園天候、果實損傷、接觸力、跨日維護或完整班次證據。

## 四、表徵介入：比相關性強，但不能跳到正確因果內容

### 可解碼的未來，如何定義？

附錄 A 以目前／未來 latent 的 pooling 差值作為目標：

$$
\Delta z=\operatorname{Pool}(z_{t+1})-\operatorname{Pool}(z_t),\qquad
R^2=1-\frac{\sum_n\|\Delta z_n-f(x_n)\|^2}{\sum_n\|\Delta z_n-\overline{\Delta z}\|^2}.
$$

$z_t,z_{t+1}$ 為現在與未來影格的 latent，$\operatorname{Pool}$ 為池化，$x_n$ 是第 $n$ 個樣本的層級池化視覺特徵，$f$ 是 ridge 線性探針，橫線是目標樣本平均。$R^2$ 衡量相對於均值預測的平方誤差改善，可為負數，不是任務成功機率；也未保證線性探針讀出所有非線性資訊。

800 個 windows 取自 100 episodes，5-fold 按 episode 切開，避免把同一 trajectory 的鄰近窗口分到 train/test。主分析的 flow time 固定，另在兩個時間取子集檢查趨勢。這個拆分比逐影格隨機分割可靠，但仍受單一 benchmark、線性目標與抽樣範圍限制。

### 擦除的是「扣掉動作／狀態可解釋部分的未來」

附錄 D 的目標是：

$$
r=\Delta z-W^*[a;s].
$$

$r$ 是殘差未來，$a$ 為真值 action chunk，$s$ 為本體狀態，$[a;s]$ 為串接，$W^*$ 是在訓練 episodes 擬合的線性最小平方係數。這是診斷時可使用真值的離線構造，部署不需拿到真值動作。

作者用 iterative nullspace projection 找出承載殘差的方向，四層滑窗介入動作端收到的視覺 keys/values，不改 Video DiT 前向；比較相同 rank、共變異數匹配的隨機擦除。100 個獨立 episodes、10-step 去噪，報 action shift 相對於換噪聲的變動，以及對真值 chunk 的平方誤差比；95% 信賴區間來自 1,000 次配對 bootstrap。**這個區間是對該 episode 抽樣下的統計不確定性，不是任意部署的 95% 安全保證。**

Figure 2 圖說稱 RelayWAM 中深層的動作改變較明顯；Table 6 則提供 Fast-WAM 的細項。仍要保留三個邊界：

1. 扣掉與真值動作／本體狀態線性相關部分，可能同時拿走最直接與控制有關的未來成分。Fast-WAM 對殘差不敏感，不能推出它完全不用任何未來資訊。
2. 對擦除敏感代表依賴該介面方向，不自動代表讀到的內容正確、必要或改善完整任務。需要真假內容替換及介入後 rollout，而不只比較 action chunk 變化。
3. 作者稱 Fast-WAM 與隨機擦除近似；但 Table 6 不處處相等，例如 18–21 層 action shift 為 0.44 對 0.25，26–29 層為 1.06 對 0.90。表中未列各格區間，不能擅自斷言等效或統計無差異。

## 五、第一性原理：最低需要的是決策充分狀態，而非最好看的未來

- **最小必要狀態**：需能分辨當前階段、物體／夾爪關係、本體可達性，以及候選動作後果。若單張影像不能辨識遮擋、接觸或速度，額外中介 tokens 無法保證補回從未觀測的資訊；本文未做上述狀態可觀測性的獨立驗證。
- **資料與技術限制**：future loss 若主要獎勵背景可預測性，其高可解碼度可能與操作無關。任務／狀態 query 提供選擇性讀取；動作 loss 回傳讓表徵轉向控制，但效果仍受 demonstrations 和影片預訓練覆蓋限制。
- **物理限制**：更好的表徵接口沒有新增觸覺量測、力限制或獨立安全屏障。真機看得準與抓得安全應分開驗收。
- **有效條件與失效原因**：當 backbone 已含有與任務相關但原動作接口難以利用的訊息，relay 才有機會放大收益；若失敗源是未見動力學、錯誤指令、不可達或時序過期，改 attention 讀法不必然解決。LIBERO-PRO 的低位置／跨任務結果正提醒這個外推邊界。

可重用模型是 **可解碼 → 可讀取 → 內容特異性 → 正確行動 → 完整任務** 的證據階梯。本文新增了較清楚的可讀取介入與二乘二設計，但後兩層仍不能由 action shift 自動推出。

## 六、下一步只問三件事

1. **凍結／交換視覺 backbone，配等參數一般 adapter**：收益主要來自更會讀、反向重新寫，還是單純多一條運算路徑？固定預算後互補性是否保留？
2. **做事實內容介入**：相同任務與狀態，替換為同事實、異事實、時間錯位的 predictive cues，分報送達、決策改變與完整成功；能否排除「只是對擾動敏感」？
3. **按真機分母與時間驗收**：加多 seed、跨日及更多操作，報接觸損傷、延遲尾部與完整任務成功；在噪聲／照明改善以外，位置泛化及過期 chunk 失敗是否仍存在？

## 對讀，不宣稱已整合

- [IMEP：記憶敏感不等於使用了事實](../2026-10-21/01-imep-記憶敏感不等於使用了事實.md)：把「會變」往內容特異性再推一步。
- [ThinkWorld：預測後果不等於辨識可執行動作](../2026-10-30/01-thinkworld-預測後果不等於辨識可執行動作.md)：對照訓練支架與部署直接讀取路徑。
- [HiFOR：未來檢索不等於動作後果驗證](../2026-11-01/01-hifor-未來檢索不等於動作後果驗證.md)：RelayWAM 不在部署生成未來；兩者不能因都叫 predictive 就歸成同一接口。

[返回當日索引](./README.md)｜[研究導覽](../../../研究導覽.md)
