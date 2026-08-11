# AtlasVLA: Persistent World-Ego State Modeling for Vision-Language-Action Models

## 原文資訊
- 論文：AtlasVLA: Persistent World-Ego State Modeling for Vision-Language-Action Models
- 作者：Guiyu Zhao、Longteng Guo、Yanghong Mei、Zilin Zhu、Yu Zhang、Bin Cao、Mingming Yu、Xingjian He、Jie Jiang、Jing Liu
- arXiv ID：2608.06729v1
- 分類：cs.RO、cs.CV
- 發表 / 更新：2026-08-07 / 2026-08-07（v1）
- 連結：[abs](https://arxiv.org/abs/2608.06729v1) / [pdf](https://arxiv.org/pdf/2608.06729v1)
- 本次閱讀範圍：Summary/Abstract + Introduction；未讀 Related Work、方法、實驗、結果與結論等其他章節
- 擷取日期：2026-08-11

## 為什麼選這篇

這篇直接處理長時域 VLA 的核心限制：當機器人只有腕部相機時，視野會跟著手臂移動，物體一離開畫面就可能從模型的有效狀態中消失；多步任務還會產生「做到哪裡」的進度遺忘。這不是單純擴大模型就必然消失的問題，而是部分可觀測環境中，系統是否維持跨時間狀態的架構問題。

AtlasVLA 把空間世界記憶與自身／任務進度記憶分開，值得與純粹擴長 context window 的路線對照。它也和前一篇形成獨立互補：前一篇問單次決策在網路深度中如何形成；這篇問跨時間、跨視野的狀態如何持續存在。摘要聲稱的 benchmark 與實機成績本次未讀實驗章節核驗，因此以下只把它們列為作者自稱。

## 一句話理解

AtlasVLA 試圖讓腕部相機驅動的 VLA 不再只對當下畫面反射式出手，而是持續更新「外部世界在哪裡」與「自己做到哪裡」兩種狀態，再依此產生動作。

## Summary / Abstract 說了什麼

摘要把現有 VLA 描述為反應式系統：從當下觀察直接映射到動作。在單一腕部相機下，這會遇到兩種遺忘。第一是 perception forgetting，物件離開視野後，模型失去空間線索；第二是 task-progress forgetting，多步操作中可能重複、跳過或忘記已完成的子步驟。

作者提出雙記憶架構。4D Persistent World State Memory 把短暫 2D 觀察提升為持續更新、以 voxel hash 組織的空間狀態；Ego-Working State Memory 則追蹤歷史自身狀態與任務進度。兩者共同作為 diffusion transformer 的條件，用來生成動作。

摘要自稱，AtlasVLA 只用腕部相機，在 LIBERO、RLBench 與實機評估中取得 state-of-the-art 表現；相較多視角基線，在 LIBERO-Long 與實機長時域任務的絕對成功率分別提高 9.4 與 17.5 個百分點。這些數字未在本次有限閱讀中檢查實驗設定、基線公平性、樣本量或不確定性。

## Introduction 的問題設定

Introduction 先肯定 VLA 已能把多模態感知連到低階機器人控制，但認為目前主流仍是「即時觀察 → 動作」的反射式範式。作者把單腕部相機視為壓力測試：相機隨末端執行器移動，當前 FoV 並不等於真實世界狀態，因此瞬時畫面不足以支持部分可觀測、長時域操作。

第一個缺口是空間持續性。當盒子或工具離開視野，若系統沒有 persistent internal state，就無法保留其位置與周遭結構。第二個缺口是時間持續性。多步任務需要知道已完成什麼、下一步是什麼；若沒有歷史自身狀態與進度表示，錯誤會隨步驟累積。

作者把理想迴路寫成：

\[
o_t \rightarrow s_t \leftarrow s_{t-1}, \qquad a_t \sim \pi(o_t, s_t),
\]

其中 \(o_t\) 是時間 \(t\) 的局部觀察，\(s_t\) 是持續更新的隱藏狀態，\(a_t\) 是動作。白話來說，系統不應只根據現在看到什麼行動，而要先把新觀察併入先前狀態，再依更新後的狀態決策。

AtlasVLA 進一步把 \(s_t\) 拆成世界狀態 \(W_t\) 與自身工作狀態 \(E_t\)：

\[
s_t = (W_t, E_t).
\]

依 Introduction 的描述，\(W_t\) 透過深度估計與空間反投影，把腕部影像提升到持續更新的 4D latent space，保留全域工作區資訊；\(E_t\) 則以高階語意方式表示歷史 ego state 與任務進度。作者最後以兩種狀態共同條件化逐步 diffusion transformer 來產生動作。

## 研究的第一性問題

- **基本問題**：在部分可觀測環境中，機器人如何從短暫局部觀察維持足以支持長時域控制的狀態？
- **約束**：只使用腕部相機時，視野窄且持續移動；多步操作又要求同時維持空間配置與任務進度。
- **既有方法卡點**：反應式 VLA 把當下畫面近似成世界狀態，忽略畫面外物件；單純保留歷史影像也未必能形成可更新、可定位的空間記憶或明確進度。
- **作者試圖移動的邊界**：把 VLA 從 memoryless observation-to-action mapping，移向 local observation、state update、persistent state、future action 的循環。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 明確辨識 wrist-only VLA 的兩個主要瓶頸：空間部分可觀測與時間任務進度遺忘。
- 提出由 Persistent World State Memory 與 Ego-Working State Memory 組成的雙記憶架構。
- 以持續世界—自身狀態條件化動作生成，從反應式控制轉向主動長時域推理。
- 只靠腕部相機，在三類評估中優於多視角基線。

### 我的保守判讀

- 「世界記憶」與「工作記憶」分工是合理的系統抽象：一個回答外界在哪裡，一個回答代理人做到哪裡。它比把所有歷史都塞進同一序列更容易診斷。
- Persistent state 不是天然真實。深度估計、相機位姿、物件移動與遮擋都可能讓舊資訊污染新狀態；持久化同時會把瞬時感知錯誤變成跨時間錯誤。
- 4D latent space 的「4D」如何定義、更新與遺忘，需要讀方法章節才能精確判斷；本次不據 Introduction 補推實作細節。
- 摘要以 SOTA 與絕對成功率提升描述成果，但本次無法判斷基線感測配置、資料規模、任務切分與統計穩定性。
- wrist-only 是有價值的嚴格設定，但不等於所有實際系統都應排除固定相機；工程上仍可能以多感測器換取可觀測性與安全冗餘。

## 可放進資料庫的筆記

1. **部分可觀測不是單純的視覺能力問題，而是狀態估計問題**：當前 FoV 不等於世界，模型必須維持跨時間信念。
2. **長時域操作至少有兩種記憶**：世界的空間記憶與代理人的任務進度記憶，兩者失效模式不同。
3. **持久記憶同時放大正確資訊與錯誤資訊**：設計 memory 時也要設計更新、衝突解析、置信度與遺忘。
4. **context 長度不等於 persistent world state**：歷史 token 能保存資料，但未必提供幾何一致、可定位且可增量更新的結構。
5. **wrist-only 可作為架構壓力測試**：它刻意拿掉外部全域視角，迫使系統暴露對記憶與狀態更新的依賴。
6. **長時域成功率要拆成錯誤鏈**：感知漂移、世界狀態污染、進度遺忘、動作生成失準，可能有不同修復方式。
7. **反應式與 stateful 並非二選一**：短時快速反射可與較慢的世界—任務狀態更新形成分層控制。
8. **對照基線時要對齊感測預算**：單視角優於多視角若要成立，需確認訓練資料、模型容量與外部估計器也公平。

## 後續想追的問題

1. 4D Persistent World State 如何處理動態物件、位姿誤差、遮擋與過期資訊？
2. Ego-Working State 是由監督訊號、語意 token 還是隱式 latent state 學得？任務中斷後能否恢復？
3. 各記憶模組的消融是否能分別對應空間遺忘與進度遺忘，而非只提升總成功率？
4. 與多視角基線相比，訓練資料、額外深度估計器、計算量與延遲是否對等？
5. persistent memory 累積錯誤時，系統是否有不確定性、重定位或主動重新觀察機制？
