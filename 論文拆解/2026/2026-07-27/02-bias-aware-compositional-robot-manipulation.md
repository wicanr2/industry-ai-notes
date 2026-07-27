# Scale Up Strategically: Learning Compositional Generalization via Bias-Aware Evaluation and Data Collection for Robotic Manipulation

## 原文資訊
- 論文：Scale Up Strategically: Learning Compositional Generalization via Bias-Aware Evaluation and Data Collection for Robotic Manipulation
- 作者：Yu Qi；Zhang Ye；Xinyi Xu；Yuxuan Lu；Amitoj Sandhu；Boce Hu；Haojie Huang；Jonathan Tremblay；Lawson L.S. Wong
- arXiv ID：2607.21582v1
- 分類：Robotics (cs.RO)；Computer Vision and Pattern Recognition (cs.CV)
- 發表 / 更新：2026-07-23 / 2026-07-23
- 連結：[abs](https://arxiv.org/abs/2607.21582) / [pdf](https://arxiv.org/pdf/2607.21582)
- 本次閱讀範圍：Summary/Abstract + Introduction
- 擷取日期：2026-07-27

## 為什麼選這篇

這篇切進 VLA / robot foundation policy 的一個實用痛點：模型看似能聽懂自然語言指令，但實際可能只是抓住最顯眼、最常和成功動作共現的因素，例如顏色或物件類型，而不是完整 grounding 指令中的動詞、大小、空間關係等語意成分。

我選它，是因為它把「更多資料」這個常見解法改寫成「更有針對性的資料」。在機器人操作裡，語言指令是由多個 instruction factors 組成，例如 color、verb、object、size、spatial attribute。若 policy 對某些 factors under-grounded，單純等比例擴充資料未必有效，甚至可能繼續強化 shortcut。

這篇和 LLM + Robotics 的交會點在於：它不是單純討論視覺泛化，而是問 robot policy 到底有沒有把語言拆成可組合的行動約束。這對 language-conditioned manipulation 很重要，因為真實使用者的命令往往是新組合，而不是訓練集中看過的完整句型。

## 一句話理解

這篇研究想衡量 robot policy 在語言指令中偏好依賴哪些語意因素，並用這個診斷結果重新分配資料收集預算，讓 compositional generalization 更有效率。

## Summary / Abstract 說了什麼

摘要指出，compositional generalization 是機器人遵循多樣指令的關鍵，但 pretrained policies 可能會走 shortcut：它們依賴顯著 cue，而不是真正 grounding language。作者提出一個 diagnostic framework，把失敗定位到 individual instruction factors，也就是可重用的語意組件，例如 color、verb、object、size、spatial attribute。

論文形式化 instruction factor bias：fine-tuned policies 過度依賴 dominant factors 作為捷徑，同時低度 grounding 其他因素。作者提出兩個指標：Factor Dominance Rate（FDR）與 Factor Dominance Hierarchy（FDH）。可以把 FDR 粗略理解為成對比較中「factor A 相對 factor B 更支配 policy 判斷」的比例；FDH 則把多組 FDR 聚合成整體排序。

若用簡化符號表示，令 $f_i, f_j$ 是兩個指令因素，$D(f_i, f_j)$ 表示在控制其他條件後 policy 更跟隨 $f_i$ 而非 $f_j$ 的案例數，則可把成對偏置想成：

$$\mathrm{FDR}(f_i, f_j) \approx \frac{D(f_i, f_j)}{D(f_i, f_j)+D(f_j, f_i)}$$

這不是我從方法章重建的正式定義，而是根據摘要與 Introduction 對 FDR 用途的保守理解：它用來描述兩個語意因素誰更容易主導 policy 行為。

摘要宣稱，六個 foundation policies 的評估呈現一致排序：color $\geq$ object $\geq$ spatial $\geq$ verb $\geq$ size；其中 color 最 dominant，verb 與 size 最 under-grounded。作者進一步說，bias-aware data collection 能把有限 demonstration budget 重新分配給 under-grounded factors，在 simulation 與 real robot 上用一半 demonstrations 勝過 baseline。

## Introduction 的問題設定

Introduction 先承認資料規模化是 modern robot learning 的主要泛化配方，但指出更多資料不一定讓 policy 真正 follow language。一般 robot policy 可能不是解析了句子，而是依附於最能預測正確動作的 cue。作者舉例說，policy 可能忽略 action verb，而依賴 object-type-action 關係這類 shortcut。

既有研究已觀察到 robot foundation policies 會偏向 visually salient cues，而不是完整 grounding instruction。但 Introduction 認為，既有分析通常太粗，只報 aggregate success rates，或從 dataset diversity、language perturbation、visual robustness 等角度看失敗；這能告訴我們 policy 是否失敗，卻不能指出「指令中的哪個部分」被忽略。

作者因此把分析單位降到 instruction factors：例如顏色、動詞、物件、大小、空間屬性。這些因素是可重用、相對獨立的語意成分，也是 compositional instruction 的積木。若 policy 在 out-of-distribution setting 中對不同因素泛化不均，就形成 instruction factor bias。

Introduction 接著說，指令空間會隨 factor 數量組合爆炸，真機資料不可能窮舉所有組合。因此 practical value 不只是診斷，而是把診斷轉成資料收集策略：把固定 demonstration budget 重新配置到 FDH 排名較低、較 under-grounded 的因素上。作者自稱這種 model-agnostic 策略在多數 simulation 與 real-robot settings 優於 baseline，真機上甚至用一半 demonstrations 達到更強表現。

## 研究的第一性問題

- **基本問題**：language-conditioned robot policy 到底有沒有理解一條指令中的多個語意約束，還是只靠少數 dominant cue 做動作選擇？
- **約束**：指令因素組合會爆炸；真機 demonstration 昂貴；aggregate success rate 不足以定位失敗來源；不同 policy 可能有不同 shortcut。
- **既有方法卡點**：資料擴大常被當成通用解法，但如果資料分布本身強化 dominant factors，policy 可能繼續忽略動詞、大小或空間因素。
- **作者試圖移動的邊界**：把 robot language grounding 的評估從整句成功率，移到 factor-level bias 診斷，並用診斷結果指導資料收集。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 定義 instruction factor bias，指出它是 pretrained robot policies 在 compositional language generalization 上的系統性失敗模式。
- 提出 FDR 與 FDH，量化不同指令因素之間的 dominance 關係。
- 在六個 foundation policies 上發現相對一致的 factor hierarchy：color 最 dominant，verb 與 size 較 under-grounded。
- 提出 bias-aware data collection strategy，把有限資料預算分配給較弱因素，摘要宣稱能更有效提升泛化。

### 我的保守判讀

- 這篇的價值在於把「模型沒聽懂」拆成可操作的診斷單位。若指令因素能被定位，資料補洞才有方向。
- Factor-level 評估很適合 language-conditioned manipulation，但也可能低估自然語言的複雜性：真實指令不一定能乾淨分解成五類因素。
- Color dominance 可能一方面反映視覺 cue 顯著，另一方面也反映資料集與任務設計的偏差；這需要讀實驗設計才能判斷。
- 本次沒有讀方法與實驗章節，因此不能確認 FDR / FDH 的正式計算、benchmark 建構方式、六個 policy 的涵蓋性或真機結果的穩健程度。

## 可放進資料庫的筆記

1. **Compositional generalization 需要 factor-level 診斷**：整句成功率太粗，無法知道 policy 忽略了哪個語意因素。
2. **Shortcut 不是只有視覺問題，也是語言 grounding 問題**：模型可能用物件或顏色代替動詞理解。
3. **資料擴張要看 under-grounded factor**：固定預算下，補弱因素可能比平均加資料更有效。
4. **指令因素是 robot language interface 的基本單位**：color、verb、object、size、spatial attribute 會共同約束動作。
5. **Dominance hierarchy 可作為資料收集儀表板**：排序不是最終答案，而是指出下一批資料應該補哪裡。
6. **VLA 評估不能只看任務成功**：要追問成功是否來自語言理解，還是訓練分布 shortcut。
7. **真機資料昂貴時，診斷比暴力 scaling 更重要**：知道哪裡缺，才有可能用少量示範改善泛化。

## 後續想追的問題

- FDR 與 FDH 的正式定義如何處理多因素互動，而不只是 pairwise dominance？
- 五類 instruction factors 是否足夠涵蓋真實人類指令，尤其是時間順序、否定、條件與工具使用？
- 六個 foundation policies 的架構差異是否會影響 factor hierarchy？
- Bias-aware data collection 是否會犧牲其他未測因素的泛化？
- 真機上「用一半 demonstrations」的比較基準是什麼，是否控制了任務難度與資料品質？
