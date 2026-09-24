# Grow the Harness, Not the Context: From Strategy-Free Scaffolds to Reusable Specialist Agents

## 原文資訊

- 論文：Grow the Harness, Not the Context: From Strategy-Free Scaffolds to Reusable Specialist Agents
- 作者：Laizhen Li、Jiarui Li、Juanjuan Zhao、Kejiang Ye、Ye Li、Cheng-zhong Xu、Xitong Gao
- arXiv ID：2609.26760v1
- 分類：cs.AI、cs.SE
- 發表 / 更新：2026-09-22 / 2026-09-22（v1）
- 連結：[abs](https://arxiv.org/abs/2609.26760v1) / [pdf](https://arxiv.org/pdf/2609.26760v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML，讀至 Related Work 前）
- 擷取日期：2026-09-24

## 為什麼選這篇

多數 LLM agent 把控制流程也塞進 context：每次任務都讓模型重新決定如何查詢、過濾、驗證、復原與停止。這篇反過來問：如果同一任務族的控制規律會反覆出現，能否把它編譯成持久程式碼，只把真正依賴語意的部分留給 LLM？

這不是單純的 prompt 壓縮，而是 agent 架構中「模型與 harness 如何分工」的問題。它對企業 agent、邊緣部署與長期運行系統都有獨立價值：模型能力不是唯一槓桿，能否把重複推理外移成可測試、可版本化、低邊際成本的控制程式，也可能決定可靠性與成本。

## 一句話理解

Growing Harness 從沒有預設解題 controller 的骨架開始，利用失敗軌跡逐步長出可重用程式碼，讓 LLM 專注處理每次任務才需要的語意判斷。

## Summary / Abstract 說了什麼

論文把 agent 視為三者組合：固定的 LLM、固定的工具介面，以及可學習的 executable harness。標準作法常讓 LLM 在每次 execution 中重建查詢修正、錯誤恢復、停止判斷等控制；Growing Harness 則讓這些可重複行為累積在共享程式中。

依 Abstract 與 Introduction，訓練從 **strategy-free scaffold** 開始：它只暴露任務入口、模型與工具介面，不內建 ReAct 類 controller。失敗 execution 產生 function-level trace，將問題定位到有限的 code surface；optimizer 對一個 failure window 共同修補，而 held-out success gate 會回滾傷害既有能力的更新。作者把這稱為 failure-guided program growth。

Abstract 自稱，在 BrowseComp-Plus 與 WebArena-Verified、三種 4B–120B deployment models 上，方法在六種設定中的五種取得最高平均成功率；相對 Tool-Calling agent，LLM calls 減少 76.0%–91.8%，線上推論成本減少 74.4%–98.6%。這些是論文報告值，本次沒有閱讀實驗章節或重新驗證。

## Introduction 的問題設定

Introduction 先從「重複任務族」切入，而不是一般化到所有 agent 工作。任務目標與觀察會變，但 refine query、filter observation、verify progress、recover error、decide when to stop 等控制結構常重複。若每次都交給 LLM，代價是更多 calls、更長 context，以及相同控制決策被反覆生成。

作者接著提出 harness growth：跨同分布任務，把可轉移的控制固化成 executable behavior。這和把經驗存成文字記憶不同；程式碼不必每次被檢索、放入 context、再由模型解釋，而能直接執行。核心主張因此是「結構化管理 context」：把重複控制留在 code，把 context 留給任務特定證據與語意推理。

Introduction 再列出三個困難：如何判斷哪些行為應成為 code、哪些仍需 LLM；如何在程式持續長大時，把每次最佳化限制在局部；如何避免修好新失敗卻破壞舊能力。對應解法分別是 code-first／LLM-assisted 分工、function-level trace-local edits，以及 success-first held-out gate rollback。

## 研究的第一性問題

- **基本問題**：反覆出現的 agent 控制，為什麼要每次付出模型推論成本重新生成，而不能成為持久可執行資產？
- **約束**：過度程式化會失去語意彈性；過度依賴 LLM 則成本高、context 膨脹，且小模型難以穩定重建控制。
- **既有方法卡點**：文字記憶仍需模型重新解讀；固定 workflow 有較強先驗；全程式最佳化會隨 harness 成長而擴大搜尋面，也容易產生 regression。
- **作者試圖移動的邊界**：從「學模型參數或 prompt」移到「學 agent 周圍的可執行控制結構」，並讓局部修補在回歸閘門下累積。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 將 agent learning 形式化為從 strategy-free scaffold 出發的 reusable program growth。
- 用 function-level execution DAG 與 bounded edit surface，把失敗連到局部程式修補。
- 用多失敗 window 鼓勵可重用修補，並以 held-out gate rollback 防止既有能力退化。
- 在兩個 agent benchmark 上同時改善成功率與線上呼叫／成本效率，尤其有利於較小 deployment model。

### 我的保守判讀

- 這篇最強的概念貢獻，是把 context management 從「塞什麼文字」提升為「哪些控制根本不該再進 context」。
- 「strategy-free」不等於零先驗：工具 schema、runtime、trace 粒度、可修改函式範圍、optimizer 與 gate 都構成強烈的系統先驗。
- 成本下降若只計 deployed-agent calls、不含離線 optimizer 與反覆驗證，適合描述攤提後的線上成本，不能直接解讀為總生命週期成本下降。
- 共享 harness 適合穩定、重複的任務分布；若環境快速漂移或任務彼此衝突，程式成長可能變成維護負債。
- 本次未讀方法與實驗，尚不能判斷 benchmark split、optimizer 成本、generated code 安全性及 regression gate 的統計穩健性。

## 可放進資料庫的筆記

1. **Context 是執行期記憶，不該承擔所有長期學習**：穩定控制可外移到 code、資料結構或狀態機。
2. **把模型留給語意不確定性**：解析、驗證、狀態更新與停止條件若可決定化，應優先程式化。
3. **失敗定位要先縮小可修改面**：trace-local repair 比每次重寫整個 agent 更容易測試與回滾。
4. **多個失敗共同修，較能找出共通規律**：只修單例容易把答案或偶然條件寫死。
5. **Agent 自我修改需要交易式更新**：候選修改應通過 held-out gate，失敗時連同程式與訓練狀態一起回滾。
6. **成功優先於省成本**：低成本不能補償能力退化，成本最佳化應放在 success-preserving 約束下。
7. **小模型可由外部控制結構補足部分缺口**：系統能力是 model × harness × tools × evaluation，而非只看參數量。
8. **離線成本要看攤提條件**：只有當同一 harness 被足夠多次重用，program growth 才可能形成經濟優勢。

## 後續想追的問題

1. 離線 optimizer calls、gate evaluation 與候選執行的總成本是多少，需重用幾次才回本？
2. function-level traces 如何避免敏感資料被帶入 code synthesis 或 generated code？
3. gate set 很小或分布偏窄時，rollback 能否真正防止隱性 regression？
4. 長期成長後的 harness 是否仍可讀、可除錯、可安全審查？
5. 面對工具 API 變更與任務分布漂移，哪些 code 應失效、重訓或降級回 LLM 判斷？
