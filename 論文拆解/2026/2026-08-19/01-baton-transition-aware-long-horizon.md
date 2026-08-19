# Don't Drop the BATON: Long-Horizon Robot Manipulation via Agentic Subtask Exploration and Transition-aware Memory

## 原文資訊

- 論文：Don't Drop the BATON: Long-Horizon Robot Manipulation via Agentic Subtask Exploration and Transition-aware Memory
- 作者：Bingxin Xu、Yuzhang Shang、Emilio Ferrara
- arXiv ID：2608.16889v1
- 分類：cs.RO、cs.AI、cs.CV
- 發表 / 更新：2026-08-17 / 2026-08-17（v1）
- 連結：[abs](https://arxiv.org/abs/2608.16889v1) / [pdf](https://arxiv.org/pdf/2608.16889v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、Methods、Experiments、Conclusion 與附錄
- 擷取日期：2026-08-19

## 為什麼選這篇

長時程機器人操作的難點，未必是缺少單一技能，而是單一技能能否在前後狀態互相牽制時被可靠地串起來。這篇位於 LLM agents 與 VLA robotics 的直接交會：LLM coding agent 負責任務分解、程式化編排與語言記憶，凍結的 VLA 處理接觸豐富的局部操作。

它值得收錄的原因，是把「子任務交界」從隱含副作用提升成可檢查的介面。作者不只處理某一步失敗，也問：前一步雖然成功，是否留下後一步可繼承的狀態？這對任何由 agent 編排實體技能的系統都有可重用價值。

## 一句話理解

BATON 把長任務拆成可分別探索的短子任務，並用語言化的轉移條件管理 VLA 何時接手、下一段從何種狀態開始，以及當前策略是否替下一段留下可用結果。

## Summary / Abstract 說了什麼

摘要認為，凍結 VLA、由 LLM agent 編排的既有做法在長時程會遇到兩個問題。第一，若每個階段平均需要 $T$ 次探索、一共有 $K$ 個階段，整體任務探索成本近似

$$
C_{\text{whole}} \approx T^K,
$$

也就是每增加一個階段，成功組合的搜尋成本可能乘上去；而失敗的整段 episode 也不容易指出是哪一階段造成。BATON 改以子任務為探索單位，作者將成本描述為

$$
C_{\text{subtask}} \approx K T,
$$

其中 $T$ 是解決單一階段所需的平均探索次數，$K$ 是階段數。直觀上，它把「同時猜中整條鏈」改成「逐段練好再組合」。這是摘要中的尺度主張，不代表本次已查驗實際成本曲線。

第二，既有 VLA primitive 常有輸出結果，卻沒有明確的進入條件；局部成功可能留下後續技能無法使用的物理狀態。作者提出 transition-aware memory：verifier agent 檢查何時可呼叫 VLA；handoff transition 恢復下一子任務所需的進入狀態；lookahead transition 則讓後續需求反過來影響當前策略選擇。

摘要另宣稱 BATON 不更新模型參數，並在 RoboMemArena 上相較當時最佳方法提升 task success 11.6%、cumulative success 14.9%。本次未讀實驗章節，因此不判斷基準、樣本數、成本對齊與統計穩健性。

## Introduction 的問題設定

Introduction 先把長時程操作描述為組合問題：VLA 或 world-action model 可能已能執行開抽屜、抓取、放置等局部技能，但把它們串成上千步任務後，誤差會累積，而且上一技能的執行方式會決定下一技能看到的初始狀態。於是「每段都局部成功」不保證整體成功，任務可能死在段與段之間。

作者沿用 coding agent 的分工：LLM agent 用感知與控制 primitive 寫程式、從執行回饋修訂，解析運動負責自由空間移動，凍結 VLA 只在接觸豐富區段被呼叫。好處是無須微調、語言記憶可讀且可重用；但原本依完整任務反覆試錯的 test-time exploration，一旦任務變長就成本過高、錯誤歸因也變模糊。

BATON 的核心設定是「轉移本身也是一級物件」。它把 transition 分成三類：子任務內的 invocation transition、前後子任務間的 handoff transition，以及由後續需求約束當前策略的 lookahead transition。這些條件以語言寫成、在執行時檢查，並與連接的軌跡共同存入記憶。

Introduction 宣稱兩項主要機制：以階層式子任務探索讓成本隨新子任務與邊界近似加總；以 transition-aware memory 建立可檢查的 invocation、handoff、lookahead 條件。作者並把 BATON 定位為第一個以 frozen VLA 完成端到端長時程操作的 coding agent；這仍是作者的優先權宣稱，本次未做完整文獻比對。

## 研究的第一性問題

- **基本問題**：一組局部可靠的實體技能，如何組合成長時程任務，而不讓誤差與狀態殘留在技能邊界累積？
- **約束**：不微調 VLA；探索發生在測試期，真機 episode、planner token 與失敗成本都有限；每個技能的輸出狀態還會改變下一技能的可行性。
- **既有方法卡點**：以完整任務為單位試錯，使搜尋組合快速膨脹、失敗難歸因；技能介面只描述「做什麼」，沒有清楚描述「何時可開始」與「結束後要留下什麼」。
- **作者試圖移動的邊界**：從重播一條長軌跡，移向組合已驗證子任務與可檢查的 handoff contract。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 以子任務取代完整任務作為 test-time exploration 單位，將探索成本由乘法式改寫為加法式。
- 讓錯誤可歸因到特定階段，而不是只得到整段失敗訊號。
- 以 invocation、handoff、lookahead 三種 transition-aware memory 管理局部技能組合。
- 不更新參數；摘要宣稱在 RoboMemArena 改善兩種長時程成功指標。

### 我的保守判讀

- 最有價值的部分可能不是特定 agent 數量，而是「技能介面必須同時有 entry condition、exit state 與下游相容性」這個系統觀點。
- $T^K$ 對 $KT$ 是作者用來說明搜索尺度的近似。若子任務彼此強耦合、每段的狀態分布會隨前段改變，獨立探索未必能完全消除組合成本。
- 語言記憶較可讀，不等於條件已被形式驗證。自然語言 contract 的歧義、verifier 誤判及視覺遮蔽，都可能把風險延後到執行期。
- 「恢復 entry state」在柔性物體、液體、不可逆接觸或環境改變下可能很困難；需要看 benchmark 是否涵蓋這些不可逆性。
- 本次未讀實驗，無法判斷 11.6% 與 14.9% 是百分點還是相對提升、真機成本是否對齊，也無法檢查失敗歸因的準確率。

## 可放進資料庫的筆記

1. **局部成功不是可組合成功**：一個技能的完成條件，應包含後續技能可接受的終端狀態。
2. **把邊界做成資料結構**：若 invocation、handoff、lookahead 只藏在 prompt 或程式流程中，就難以重用、稽核與測試。
3. **探索單位決定信用分配**：以子任務為 episode 單位，可縮短從失敗到責任位置的距離。
4. **下游需求要能回傳上游**：前一步不該只求本地完成，也要選擇下一步可繼承的完成方式。
5. **凍結模型後，改進空間轉向 orchestration**：不更新權重不代表系統不學習；可把經驗寫進外部記憶與轉移規則。
6. **可讀記憶與可靠驗證是兩回事**：語言化能幫助稽核，但還需要可觀測、可測試的物理 predicate。
7. **長時程 benchmark 應測邊界品質**：除了最終成功率，也應測 entry-condition violation、handoff recovery 與錯誤歸因。

## 後續想追的問題

1. BATON 如何把自然語言 handoff contract 轉成可執行 verifier；誤判與漏判率如何衡量？
2. 子任務獨立探索在多強的跨段耦合下仍保持近似加法成本？
3. 記憶中的策略、entry condition 與粗軌跡如何更新，是否會累積互相衝突的規則？
4. RoboMemArena 的千步任務包含哪些不可逆狀態與接觸失敗；成功率提升是否伴隨更多 token 或真機時間？
5. lookahead 只看下一個子任務，還是能處理更遠的延遲約束與全局資源分配？
