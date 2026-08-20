# MANIGUARD: A Benchmark and Data Suite for Specification-Grounded Safety Evaluation and Improvement of Robotic Manipulation

## 原文資訊

- 論文：MANIGUARD: A Benchmark and Data Suite for Specification-Grounded Safety Evaluation and Improvement of Robotic Manipulation
- 作者：Yiyan Peng、Philip Wang、Simon Sinong Zhan、Yiqi Lyu、Zhenyang Ni、Jixin Yan、Fiorelli Wong、Ruochen Jiao、Hang Yin、Xinyu Cao、Huajie Shao、Manling Li、Ruohan Zhang、Qi Zhu
- arXiv ID：2608.17386v1
- 分類：cs.RO
- 發表 / 更新：2026-08-18 / 2026-08-18（v1）
- 連結：[abs](https://arxiv.org/abs/2608.17386v1) / [pdf](https://arxiv.org/pdf/2608.17386v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、Benchmark Details、Experiments、Conclusion 與附錄
- 擷取日期：2026-08-20

## 為什麼選這篇

VLA／foundation-model robot policy 常以 task success 作為主要指標，但「把杯子移到指定位置」與「過程中沒有傾倒、碰撞或違反操作順序」是兩個不同問題。ManiGuard 把 safety specification 與 task success 正交化，直接處理 Physical AI 從能力展示走向可部署系統時的評估缺口。

它的另一個價值是不用 LLM/VLM judge 來判斷安全，而是把有限軌跡線性時序邏輯（LTL$_f$）規格編譯成 automaton，以模擬器狀態中的物理 predicate 做逐步監控。這讓安全判斷的來源較可重現，也能把 benchmark、資料標註與 fine-tuning 接到同一套規格。論文是否真的涵蓋足夠多的現實風險仍需讀全文，但這種「成功與安全分帳」的評估架構有明確獨立價值。

## 一句話理解

ManiGuard 要把機器人「有沒有完成任務」與「執行過程是否符合明示安全規格」分開量測，並用同一套形式監控器產生可供安全調整的資料。

## Summary / Abstract 說了什麼

摘要介紹 ManiGuard framework，包含 ManiGuard-Bench 與配對的 safety-annotated trajectory pipeline。benchmark 把六類 contact-rich household tasks 組成 200 個固定 base tasks，依 skill $\times$ constraint taxonomy 編排；每個 base task 再配一個 in-distribution 與四個只改變單一軸的 OOD 條件，形成 1,000 個固定 scenarios，而 safety specification 保持不變。

每條 rollout 都由以 LTL$_f$ 為基礎的 automaton monitor，對 physics-grounded predicates 做 runtime checking。LTL$_f$ 是在**有限長軌跡**上解讀的線性時序邏輯；若狀態序列為 $\tau=(s_0,\ldots,s_T)$、安全規格為 $\varphi$，監控問題可簡寫為：

$$
\tau \models \varphi \; ?
$$

意思是判斷整段有限執行軌跡是否滿足規格 $\varphi$。例如「直到杯子放穩前不得鬆手」不只是檢查最後畫面，而要檢查事件順序與每一步狀態。

摘要稱資料管線結合自動 motion planning 與 human teleoperation，並由同一 monitor 逐步標註；作者釋出 8,000 條安全標註示範。摘要另報告超過 23,000 次 rollout 的結果：成功 rollout 中仍有 6–21% 違規；fine-tuning 後 safe task completion 從接近零提高到 7.5–29.8%，engaged-and-safe behavior 從 16–40% 提高到 51–72%；但已開始行動的 rollout 仍有 21–42% 違規。這些都是論文自述，本次未讀實驗章節。

## Introduction 的問題設定

Introduction 先區分一般 adversarial vulnerability 與本文關心的 physical safety failure：後者不需攻擊者，robot policy 在一般指令與普通場景下，也可能於完成任務途中傾倒、碰撞、潑灑或違反順序。由於真實世界的失敗代價高，而且 safety-critical scenarios 很多，作者認為不能主要靠大規模真機事故來學安全，因此需要能呈現接觸後果的 physics-based simulation。

作者指出，既有 manipulation benchmark 多量測成功與泛化，卻沒有定義並監控執行過程的安全；embodied-agent safety benchmark 則常停在危害辨識或看似安全的 planning，沒有進入 contact-rich trajectory-level execution。形式規格與 runtime checking 原本能提供明確機制，但在 manipulation safety benchmark 中仍少見，且既有工作通常缺少與同一規格配對的訓練資料。

ManiGuard 因而刻意讓 safety 與 task success 正交：policy 可以成功但不安全、失敗但安全，或兩者兼具。每個 task 的 LTL$_f$ 規格由 simulator state 的 physics-grounded predicates 構成，再編譯成 deterministic finite automaton（DFA），產生逐步、分類式的違規診斷，不依賴 learned classifier 或 LLM/VLM judge。

Introduction 宣稱三項主要貢獻：可重現的 specification-grounded benchmark；由同一 monitor 篩選與標註的資料生成管線；以及對 zero-shot／fine-tuned VLA 的系統性失敗模式評估，包含 OOD 與實體 Franka 測試。

## 研究的第一性問題

- **基本問題**：任務成功只描述終點或目標是否達成，不能證明執行路徑安全；如何把安全變成可獨立檢查、可重現的 trajectory-level property？
- **約束**：不能主要依賴昂貴且不可逆的真機失敗；安全判斷也不宜建立在另一個不透明 learned judge 上。規格必須跨 ID／OOD 條件維持語義一致。
- **既有方法卡點**：成功率會把「成功但危險」藏起來；總體 violation rate 又可能獎勵完全不行動的 policy；只有 benchmark 而沒有對齊規格的資料，也難以支援改善。
- **作者試圖移動的邊界**：從 outcome-only evaluation 移向「任務結果、是否投入行動、過程是否滿足形式規格」三者分開記帳，並讓評估規格同時成為資料標註介面。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 以 skill $\times$ constraint taxonomy 建立 200 個 base tasks、1,000 個固定 ID／OOD scenarios，安全規格獨立於成功條件。
- 使用 LTL$_f$、DFA 與 physics-grounded predicates 做逐軌跡 runtime checking，不依賴 learned judge。
- 釋出由 automated planner 與 teleoperation 產生、經同一 monitor 標註的 8,000 條 demonstrations。
- Introduction 宣稱，現有 VLA 即使完成任務仍有顯著違規；fine-tuning 能改善但沒有封閉安全缺口，且更多同類示範仍不足。

### 我的保守判讀

- 「成功、安全、engagement 分開」比單一 safe-success 分數更不容易被不作為作弊，是很重要的評估設計。
- 形式監控器的可重現性優於 LLM judge，但它只會抓到規格與 predicate 已表達的風險。未被建模的力、材料損傷、人類舒適度或罕見 hazard 不會因用了 LTL$_f$ 就自動被涵蓋。
- simulation predicate 通常比真機狀態乾淨；即使作者提到 physical Franka，仍需看感測誤差、狀態估計與 sim-to-real mismatch 如何影響監控判決。
- 以同一規格標註資料與評估，可提高一致性，也可能讓 policy 過度貼合已知規格族。是否能轉移到新 constraint composition，需要全文證據。
- 摘要數字不能單獨證明 fine-tuning 方法優越；本次未讀實驗，無法檢查 baseline、policy exposure、置信區間與 scenario weighting。

## 可放進資料庫的筆記

1. **成功與安全必須分帳**：達成終點不代表路徑合法；對 Physical AI，trajectory property 與 task outcome 應是兩組指標。
2. **安全率可能被不作為灌高**：若 policy 幾乎不動，它看似少違規；應同時報 engagement-conditioned violation 與 safe task completion。
3. **規格要跨 perturbation 固定**：只改物體外觀、指令措辭、位置或背景，而保持 $\varphi$ 不變，才能把感知泛化與安全定義混淆降到較低。
4. **形式化不等於完整**：monitor 的可信度來自判斷可重現，不代表規格涵蓋所有現實危害。
5. **評估介面可以同時成為資料介面**：同一 runtime monitor 若能標註 planner 與 teleoperation 軌跡，可讓 benchmark、資料篩選與 fine-tuning 對準同一 safety contract。
6. **錯誤應有事件順序**：接觸豐富任務的危險常是「太早放手」「先後順序錯誤」，不能只靠末態 classifier 判斷。
7. **更多同類安全示範未必足夠**：若剩餘失敗源自觀測偏移、長時程信用分配或規格組合，單純擴增同分布 demonstrations 可能快速遇到上限。
8. **sim-to-real 是證據梯度，不是等號**：模擬能低成本暴露問題，但正式部署仍需處理 predicate 可觀測性與現實中未建模的危害。

## 後續想追的問題

1. 六個 task families 與兩類 constraints 實際涵蓋哪些危害；有多少安全規格可組合或遷移到新任務？
2. physics-grounded predicates 在真機上如何取得，誤判與漏判率是多少？
3. benchmark 如何定義 engagement，如何避免不同 policy 的動作頻率造成指標不可比？
4. fine-tuning 的改善來自較安全的行為、較少探索，還是更常不行動；各指標的 trade-off 如何？
5. OOD 與 sim-to-real 結果是否支持規格本身可移植，或只支持少數固定 task template？
