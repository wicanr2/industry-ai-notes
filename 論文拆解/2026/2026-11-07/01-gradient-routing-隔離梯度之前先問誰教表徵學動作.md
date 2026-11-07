# 隔離梯度之前，先問誰教表徵學動作

> 問題不只是 action expert 是否應回訓 VLM，而是切斷這條路後，還剩哪一種動作監督。
>
> 本文用動作 token 監督 × 梯度路由的因子比較，拆開以往綁在一起的訓練配方；離線軌跡接近，不代表閉迴路效果相同。
> 最有用的結論是條件式選擇，不是「coupling 永遠較好」；進度、碰撞、語言能力保留仍須分帳。

## 原文、版本與實際閱讀範圍

- **論文**：Should the Action Expert Train the VLM? Action-Token Supervision and Gradient Routing in Mixture-of-Transformer VLAs。
- **作者**：Asher James Hancock、Boyi Li、Yuxiao Chen、Shuhan Tan、Wenhao Ding、Thomas Tian、Yan Wang、Boris Ivanovic、Marco Pavone；NVIDIA／Princeton／Stanford。
- **版本與日期**：[arXiv:2611.05249v1](https://arxiv.org/abs/2611.05249v1)，2026-11-03 17:35:27 UTC 提交；[無版本頁／更新與撤稿狀態](https://arxiv.org/abs/2611.05249)。2026-11-07 擷取時僅見 v1，未見 withdrawn／retracted 標記。
- **原件**：[23 頁 PDF](https://arxiv.org/pdf/2611.05249v1)／[HTML](https://arxiv.org/html/2611.05249v1)／[作者專案入口](https://mot-vla-gradient-routing.github.io/)（僅留入口，本次未審專案程式碼）。
- **實讀**：2026-11-07 Asia/Taipei 09:00 後，以 `pdftotext -layout` 讀摘要、§1–5、附錄 A–E 的文字與表格（方法、輸入／目標、訓練配額、機械臂介面、評分規則、安全表及限制），並以 HTML 核對方法介面。Figure 3／5 僅讀文字層與圖說，不以抽取後的柱狀排序報精確數字；其他圖也未做視覺／影片核驗。未追讀參考文獻、審碼、重跑或驗證作者資料。
- **閱讀紀錄更正邊界**：前兩日僅列本篇為摘要候選；今天新增獨立方法筆記，不回寫舊索引為已讀全文。

## 一、研究問題：被保護的表徵，也可能失去學控制的訊號

VLA 把大 VLM 當視覺／語言表徵產生器，小型連續動作 expert 逐層讀它的 key/value（K/V）表徵。切斷 expert 到 VLM 的反向梯度，可能減少新 expert 破壞既有語意能力的風險，但同時不再告訴 VLM「控制究竟需要保留什麼」。

既有 insulation 配方常另有兩種訓練：一般視覺問答（VQA）及離散動作 token 預測。前者教語意，不直接教未來控制；後者雖然和連續 expert 用不同輸出形式，卻監督相同未來動作。因此，直接拿兩套知名模型比排名，無法知道差異來自梯度、token 監督、資料，還是訓練順序。

**本文真正改動**是固定架構與配方內條件，分別開關 action-token cross-entropy（CE，交叉熵）及 expert-to-VLM 梯度，再重做訓練順序與領域對照。它是訓練配方研究，不是新的推論排程器、安全控制器或新動作解碼器。依據：§1–3。

## 二、任務、輸入輸出與部署流程

### 駕駛：兩條訓練訊號，一條連續部署路徑

- **輸入**：視覺觀測、語言脈絡及自車歷史軌跡。評估固定四個相機、每相機四個時間影格，以及 16 個歷史 waypoint。
- **架構**：Qwen3-VL-2B-Instruct 加 non-causal flow-matching expert。expert 讀對應層 VLM K/V；VLM 不讀 expert 的連續動作輸入。
- **輸出**：未來 6.4 秒、10 Hz 的 64 組加速度／曲率控制量；經離散 unicycle dynamics 從當前自車狀態積分為位置／朝向 waypoint，交給低階控制。
- **訓練**：有標註時先預測場景理由，再預測未來軌跡起始 token；tokens-on 才對其後 128 個未來控制值 token 算 CE。連續 expert 同時學相同未來軌跡。
- **推論**：VLM 產生理由並在未來軌跡起始 token 停止；expert 讀這時的 K/V，由高斯噪聲開始做 10 次 Euler flow 積分；不解碼離散未來動作 tokens，也不使用 classifier-free guidance。

因此，**動作 token 是訓練支架，不是部署再多走一次離散動作鏈**。四個條件的部署資訊路徑相同；固定參數時 stop-gradient 也不改 forward 值。不同的是訓練後學到的表徵與參數。依據：§3、A.1–A.2、B。

### 操作：同一研究設計，但不能假設實作完全相同

π0.5 重實作以 PaliGemma-3B 配 flow expert，輸入外部／左腕 RGB、七個關節與夾爪；預測 16 步 chunk、32 維 padding 中八個有效維度，關節用 delta、夾爪用絕對值。MolmoAct2 由 Molmo2-ER 初始化，加新 expert；預測 15 步 chunk，關節與夾爪都是絕對值。兩者模擬評估均一次執行八步開迴路動作，再更新觀測。

兩個操作模型 tokens-off 是**移除 FAST 動作 postfix／targets**，不完全等於駕駛的「保留 teacher-forced 值但遮 CE」。π0.5 用每例有效 target 數正規化 CE，MolmoAct2 保留原實作的 token 權重與 global-batch 正規化；不能把跨領域效果當成完全相同的 intervention。依據：A.3、C。

## 三、目標函數：別讓關閉一個 loss 偷偷放大另一個

以作者駕駛實作的符號重述（原式 1–3）：

$$
\mathcal L=\mathcal L_{\mathrm{CE}}+\mathcal L_{\mathrm{flow}},\qquad
\mathcal L_{\mathrm{CE}}^{(p)}=
\frac{\sum_{i\in O}\ell_i+p\sum_{i\in F}\ell_i}{|O|+|F|}.
$$

其中 $\ell_i$ 是位置 $i$ 的 next-token CE；$O$ 是其他有監督的位置，包含語意答案、理由與結構標記；$F$ 是未來動作值位置；$p\in\{0,1\}$ 決定是否監督未來動作 tokens。分母始終用遮罩前的位置數，所以關掉動作 CE **不會順便把剩下語意 CE 放大**。這是駕駛對照的重要公平性控制，不直接套到上述兩個操作實作。

$$
a_t=ta+(1-t)\epsilon,\qquad
\mathcal L_{\mathrm{flow}}=
\mathbb E\left[\left\|v_\phi(a_t,t;\widetilde H_\theta)-(a-\epsilon)\right\|_2^2\right].
$$

$a$ 是連續目標控制序列，$\epsilon\sim\mathcal N(0,I)$ 是同維高斯噪聲，$t$ 是噪聲到目標的插值時間，$v_\phi$ 是 expert 預測的向量場；$\phi$、$\theta$ 分別是 expert 與 VLM 參數，$H_\theta$ 是 VLM 的 K/V 表徵。本文駕駛取樣 $b\sim\mathrm{Beta}(1.5,1.0)$，令 $t=0.999(1-b)$。白話說，expert 學如何把部分帶噪控制推向真實控制，不是透過在線環境 reward 學安全駕駛。

- **Coupled**：$\widetilde H_\theta=H_\theta$，flow loss 同時更新 expert 與 VLM。
- **Insulated**：$\widetilde H_\theta=\operatorname{sg}(H_\theta)$，$\operatorname{sg}$ 原值傳遞、反向梯度為零；VLM 仍可被 CE 更新，**不等於整個 VLM 冷凍**。

未來值仍 teacher-forced，會不會洩漏答案？作者將 expert 可讀 K/V 截至未來軌跡起始標記，排除未來值及結尾標記。因此不能把結果直接解讀為 expert 偷看標準答案。本次核對的是論文描述，未審實際 attention mask 程式。

## 四、資料、訓練順序與比較分母

### 駕駛

三種 schedule 都跑 300k optimizer steps：從頭共同訓練、expert 先熱身 100k 再共同訓練 200k、VLM 先熱身 100k 再共同訓練 200k。共同階段約 48.5% 是帶軌跡 batches、51.5% 是視覺語言 batches；相同 schedule／tokens 設定內，兩種 routing 對照配對資料抽樣、初始化與 optimizer。

**總 steps 相同不代表各元件學習機會相同**。Table 6 的預期 expert updates 分別約 145.5k／197k／97k。VLM-first 的 tokens-off 熱身只用視覺語言資料，tokens-on 卻也見軌跡資料；跨 tokens 設定在此階段不是純 loss 開關。最乾淨的主對照是同一 history、同一 tokens 設定內比較 routing；跨 history 不應宣稱等元件更新／等 FLOPs 因果比較。

A.2 記每次駕駛訓練使用 64 張 H100，平均約 15,000 GPU-hours；本筆記不另推訓練成本或完整資料規模。公開 Physical AI Autonomous Vehicles 的 Golden／OOD 是本文評估集，不能將評估 scene 數誤寫為完整訓練集大小。

### 操作

- π0.5：400k steps，預期一半 VQA、一半 robot；robot 內為 90% DROID、10% PolaRiS。VQA 由 VQAv2、COCO 與 Visual Genome 任務組成。
- MolmoAct2：300k steps，90% robot、10% multimodal；以可取得來源重建公開配方，部分缺失來源的權重在群組內重分配。再各做 1k steps 的 DROID／PolaRiS adaptation，保持該條件的 FAST／routing 設定。
- 主基線是各模型家族內的四個 factorial 條件，不是直接擊敗官方大模型。Table 4 另列的 CoVeR π0.5 40.0% 與 released MolmoAct2 32.9% 是**脈絡參考列**，預訓練資料／schedule／評估或 adaptation 不全相同。

## 五、實驗究竟支持什麼？

### 1. 離線軌跡：兩種動作監督有部分替代性，但尚非內部機制證明

Public Golden 1,434 scenes、OOD 273 scenes；主要 ADE 是**第一個樣本**未來 waypoint 對標準軌跡的平均歐氏距離，單位公尺。另列 minADE 是六個候選用 ground truth 選最好的 oracle 指標，不是部署選軌跡能力。

作者報 concurrent training 在無動作 token 監督時，coupling 相對 insulation 的 ADE 約降 26%（Golden）／24%（OOD）；有動作 token 時 routing 差小。跨三種 schedule 仍見「tokens-off 對 isolation 更敏感」。本筆記採 §4.1 的近似降幅，不由 Figure 3 的抽取文字自行配柱算差。

**判讀**：與兩種訊號部分替代的假說一致；未直接量測哪種空間／動作特徵被保存，不能說已揭開表徵機制。

### 2. 閉迴路駕駛：進度變好，不代表每一種安全也變好

AlpaSim 用相同 827 scenes，每 scene 五次隨機 rollout，先在 scene 內平均。Table 3 的 route progress：

- concurrent、tokens-on：insulated 0.600 → coupled 0.703。
- concurrent、tokens-off：0.425 → 0.601。
- VLM-first、tokens-on：0.648 → 0.646，不能寫 coupling 全面提高。

尤其要一起讀 Tables 11–13：concurrent、tokens-on 的 at-fault collision 是 0.087 → 0.090，wrong-lane 是 0.201 → 0.230；expert-first、tokens-on 的 at-fault collision 是 0.061 → 0.097；VLM-first、tokens-on 的 off-road or at-fault collision 是 0.203 → 0.282。這些是同表的觀測值，未附相應多 seed 顯著性證明，不把小差異直接判為穩健劣化；但足以阻止「進度較高即安全較佳」的敘述。

AlpaSim 會在安全事件後終止／截短，且偏離 ground-truth 4 公尺即 censor。此閉迴路結果也不是無限制真實道路安全證據。

### 3. 操作：累積 rubric 進度不是完整任務成功率

三個 PolaRiS 模擬任務為 BlockStackKitchen、FoodBussing、PanClean；每條件每任務 50 回、配對初始狀態、450-step horizon，不因成功提前停。Table 4 的等權平均 normalized task progress：

- π0.5、FAST-on：19.5% → 30.7%；FAST-off：10.3% → 32.9%。
- MolmoAct2、FAST-on：22.0% → 24.3%；FAST-off：14.5% → 36.5%。

criterion 一旦達成就保留分數，故進度只增不減；後來掉落／破壞狀態未必扣掉先前分數。尤其 **PanClean 的 rubric 到「海綿置於平底鍋、張開夾爪」為止，並不另評擦洗運動**。所以分數不能轉述成擦鍋成功，更不能等同交還完整清潔工作。Figure 4 的 MoveLatteCup 只是定性例，不在三任務主平均。

### 4. 語言診斷：沒有一致隔離優勢，不等於證明不會遺忘

固定 Lingo-Judge 比生成理由與參考理由，score >0.5 算 pass。Table 2 裡 routing 優劣隨設定變動；這只測駕駛理由診斷，不是廣泛 VLM 知識、視覺推理、語言能力保留測試。

開迴路 ADE／理由 pass 的 95% intervals 來自 10,000 次 paired clip-cluster bootstrap：整個 clip 重抽且各條件用相同抽樣，避免把同 clip 例子當完全獨立。此區間只反映**固定 checkpoint 在測試 clips 上的敏感性**；各條件只有一個 training run，不能涵蓋初始化／訓練 seed 變異，亦不可替操作分數或所有安全差異背書。

## 六、第一性原理：forward 資訊路徑與 backward 學習路徑必須分開畫

**最小必要狀態**：不必保留整段語言解碼過程才能談控制；但 expert 所讀的 K/V 必須攜帶當前幾何、歷史運動與任務所需訊息。一般語意可用，不保證這些精度被保留。

**方法有效條件**：連續 loss 反映的目標確實對任務有用、梯度能穿過條件介面，且共同訓練不至於損害必要的通用能力。若有足夠且匹配的離散動作監督，切斷一條 backward 路不一定切斷所有控制學習；若連 token 動作監督也拿掉，VLM 可能只被語意 loss 教導，與 expert 需要的表徵失配。

**可能失效**：新 expert 噪聲梯度、狹窄或錯誤示範、proxy token 壓縮失真、CE／flow 權重與 normalization 變動、真機接觸／延遲分布與模擬不同，都可能使這個結論反轉。本文沒有真機、未做廣泛能力 retention 或多 seed；不把「部分替代」當成所有 embodiment 的定律。

可複用研究模型是：**先列每個 loss 教誰、各介面讓誰讀什麼、關閉一個訊號後還剩誰教必要狀態；再談能力、安全與成本。** 本文未提供真機單次推論延遲／端到端吞吐比較，不因有小 expert 就外推實時部署收益。

## 七、與既有研究路徑的關係與下一步

對讀 [ThinkWorld 的訓練支架](../2026-10-30/01-thinkworld-預測後果不等於辨識可執行動作.md)與 [HiFOR 的部署檢索](../2026-11-01/01-hifor-未來檢索不等於動作後果驗證.md)：今天增加的是**訓練支架與 expert 梯度是否互相補位**，不是再提出一個部署讀取未來表徵的方法。也不同於 [ARP 的慢語意／快視覺](../2026-11-06/01-arp-快迴路要學會使用過期語意而非只快取.md)；共享 K/V 介面不表示二者已整合或可直接轉用配方。

1. **補表徵與能力證據**：固定資料及 loss 尺度，多 seed 做 token × routing；加入可控幾何／動作特徵診斷與一般 VLM retention。若 action 特徵未改善但 progress 變好，需重想「表徵對齊」解釋。
2. **補公平預算**：除總 steps，另匹配 expert／VLM updates、tokens 與 FLOPs；將 VLM-first tokens-off 的 warm-up 資料也配齊，再測訓練順序是否仍改變 ranking。
3. **補任務與物理證據**：真機同初始狀態測完成後保持、擦洗品質、人工介入與碰撞；分開 full success、累積進度及安全，確認 simulation 的改善能否轉為合格交付。
