# HAM-VLN: Harnessing Hierarchical Agentic Memory for Zero-Shot Vision-and-Language Navigation

## 原文資訊
- 論文：HAM-VLN: Harnessing Hierarchical Agentic Memory for Zero-Shot Vision-and-Language Navigation
- 作者：An Liu、Bingxi Liu、Hongyu Ding、Yixuan Jiang、Yaran Chen、Fulin Tang、Cong Leng、Hong Zhang、Jian Cheng
- arXiv ID：2607.29600v1
- 分類：Robotics（cs.RO）
- 發表 / 更新：2026-07-31 / 2026-07-31
- 連結：[abs](https://arxiv.org/abs/2607.29600v1) / [pdf](https://arxiv.org/pdf/2607.29600v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Methods、Experiments、Results 與附錄
- 擷取日期：2026-08-04

## 為什麼選這篇

這篇是「MLLM agent + Embodied AI」很直接的交會研究：機器人用多模態大型語言模型理解觀測並選擇導航動作，但長程任務不能無限把影像與歷史塞回 context。HAM-VLN 因此把問題落在 agent memory 如何與空間、失敗經驗及當前子目標結合。

它與一般 LLM memory 論文的差異，在於記憶不是聊天紀錄的摘要，而是帶有深度定位、拓撲關係與導航進度的 world graph；而且作者主張用同一次決策呼叫同時寫入記憶，不額外增加 LLM call。這對 embodied agent 的成本、延遲與可恢復性都有獨立價值，因此與今日 WCM 的「critic state representation」形成互補，而不是為湊數選同類變體。

## 一句話理解

HAM-VLN 讓導航 MLLM 在做決策的同一次呼叫中，將地點、物體、任務進度與失敗反思寫進深度定位的世界圖，再按相關性、近期性與顯著性取回有限歷史。

## Summary / Abstract 說了什麼

摘要把 zero-shot VLN 的瓶頸描述為長程記憶與推理成本。若持續保留原始影像串流，context 會一路成長；若建立 dense map，儲存與語意對齊也會隨空間擴張。兩者都可能讓真正有用的地標、已走過分支與失敗線索被大量細節淹沒。

HAM-VLN 建立 persistent、depth-grounded world graph。最近的 waypoint 以 bounded window 原樣保留；較舊記憶則依 relevance、recency、salience 排序，並加入一跳拓撲鄰居。模型在選下一步行動時，同時記錄房間類型、物件、進度與失敗註記，因此作者主張不需額外 LLM call 維護記憶。摘要報告 context length 減少超過 65%，並列出 R2R、RxR 與 HM3D-v2 ObjectNav 的 success rate；本次未讀實驗，無法核對 token 計算方式、比較基準與失敗分布。

## Introduction 的問題設定

Introduction 將 VLN 定義為：機器人在未見環境中依自然語言指令移動，並在正確位置或物體旁停止。training-free 路線讓 MLLM 在每個 waypoint 理解當下觀測並選動作，但每次呼叫只能根據被放入 context 的資訊推理；長程導航後期還需要知道已走路線、指令完成度與失敗分支，因而形成 memory bottleneck。

作者比較兩種常見歷史表示。Dense semantic map 以 pixel / voxel 對齊的 tensor 儲存空間，尺寸隨映射面積增加，而且地圖表徵與導航決策分開建立；raw visual history 則保留過去 panorama，造成 context 持續增長，也不會自然把 dead end 標成應避免分支。共同問題不是「沒有歷史」，而是 MLLM 沒有參與決定什麼值得留下。

HAM-VLN 將記憶寫入耦合到決策：最近 $K$ 個 waypoint 留在 working memory，舊經驗進入 depth-grounded world graph；其中 $K$ 是固定保留的最近節點數，用來限制 context 上界。檢索則綜合相關性、近期性與顯著性，並擴展拓撲鄰居，使被喚回的地點仍帶有空間關係。Introduction 將其描述為 working、episodic、semantic、reflection 等不同視角的階層式記憶。

## 研究的第一性問題

- **基本問題**：長程導航 agent 如何保留足夠的空間與任務歷史，同時不讓 context、地圖與推理成本無界成長？
- **約束**：歷史資訊同時包含影像、地點拓撲、物體語意、指令進度與失敗經驗；記憶寫入本身也可能增加模型呼叫與錯誤累積。
- **既有方法卡點**：dense map 儲存全面但與決策語意脫節；raw history 忠實卻冗長，且不會標記何者值得重用或避免。
- **作者試圖移動的邊界**：從被動保存觀測，改成 agent 在決策當下主動寫入、分層保存並按子目標檢索的空間化記憶。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 以地點與物體構成 depth-grounded world graph，儲存量隨已發現實體而非完整映射面積成長。
- 把 working、episodic、semantic 與 reflection memory 接到 VLN 決策流程。
- 同一次 MLLM 呼叫完成動作選擇與記憶寫入，不額外增加模型呼叫。
- 在三個導航設定中以 training-free 方式改善 success metric，並顯著縮短 context。

### 我的保守判讀

- 核心價值在於 decision-coupled memory：寫什麼不是獨立 summarizer 決定，而是和當下決策、子目標與失敗訊號一起形成。
- 但讓同一模型同時行動與寫記憶，也可能把一次判斷錯誤固化進 world graph；是否有修訂、去重或置信度機制，需要讀方法。
- 「無額外 LLM calls」不等於沒有額外成本。輸出記憶欄位、graph retrieval、depth grounding 與較長 prompt 都可能增加 latency。
- context 減少 65% 以上要核對基準：相對 full raw history 很合理，但與更強的摘要、cache 或 learned memory baseline 是否公平尚未知。
- Training-free 成績顯示部署便利性，但可能依賴特定閉源 MLLM、prompt 與視覺能力；跨模型穩健性不能由 Introduction 判斷。

## 可放進資料庫的筆記

1. **Embodied memory 必須同時有語意與位置**：只記得「看過桌子」不夠，還要知道桌子在哪個房間、與哪些路徑相連。
2. **記憶寫入應靠近決策時刻**：模型剛做完判斷時，最能記錄當時子目標、信念與失敗理由。
3. **bounded working memory + retrieved long-term memory**：固定保留近期細節，再按需取回舊經驗，是控制 context 的通用結構。
4. **失敗不是普通 observation**：dead end 若只存成影像，很難避免重犯；轉成 reflection / branch-to-avoid 才能直接影響後續政策。
5. **檢索分數需要多軸**：relevance 回答「對現在有沒有用」，recency 防止狀態過期，salience 保留少見但關鍵事件。
6. **拓撲鄰居是 retrieval 的結構先驗**：取回一個地點時一併帶回相鄰節點，可避免單筆語意記憶失去空間脈絡。
7. **LLM call 數不是完整成本指標**：還要看輸入 token、輸出 token、graph 操作、depth 模組與每 waypoint latency。
8. **主動記憶也會主動累積偏誤**：agent-authored memory 需要可修訂、可追溯及不確定性標記。

## 後續想追的問題

1. world graph 的節點合併、位置誤差與 loop closure 如何處理？
2. relevance、recency、salience 的分數由規則、encoder 還是 MLLM 產生，權重是否跨任務穩定？
3. 同一次呼叫如何約束 action 與 memory record 的輸出格式，格式錯誤如何恢復？
4. 與 raw history、dense map、文字摘要及其他 agent memory 的 token、延遲和成功率是否在同一預算下比較？
5. 若早期房間分類或 failure note 寫錯，系統能否更正舊記憶，還是錯誤會持續影響檢索？
