# Towards Neuro-Symbolic Procedural Reasoning for Long-Horizon Vision-Language-Action Manipulation

## 原文資訊
- 論文：Towards Neuro-Symbolic Procedural Reasoning for Long-Horizon Vision-Language-Action Manipulation
- 作者：Vivek Chavan、Yahuan Shi、Oliver Heimann、Kevin Haninger、Jörg Krüger
- arXiv ID：2609.05369v1
- 分類：cs.RO、cs.CV
- 發表 / 更新：2026-09-04 / 2026-09-04（v1）
- 連結：[abs](https://arxiv.org/abs/2609.05369v1) / [pdf](https://arxiv.org/pdf/2609.05369v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀後續架構、實驗、結果與附錄
- 擷取日期：2026-09-09

## 為什麼選這篇

VLA 模型常把感知、語言理解與連續控制包進同一個政策，但長時序操作還需要另一種能力：記住做到哪一步、遵守前置依賴、遇到條件分支時選對後續動作，並確認機器人或協作者真的改變了環境。這篇沒有把所有問題都交給單一端到端模型，而是把明確的程序結構重新放回系統。

它對 LLM／VLM 與 Robotics 的交會有直接價值，因為它問的是「語意模型與符號程序各自應負責什麼」。作者用 task graph 約束合法轉移，用 event memory 保存程序狀態，再讓 VLA 執行連續控制。這種分工可能比單純增加模型規模更接近長時序實體任務的可靠性問題，因此值得收錄。

## 一句話理解

長時序 VLA 不只要會做動作，還要有一個可持續更新、可驗證且受程序依賴約束的任務狀態。

## Summary / Abstract 說了什麼

摘要把長時序操作的脆弱性拆成幾個需求：持續保存任務狀態、理解動作依賴、處理條件分支、把語言可靠地落到物件與目的地，以及驗證預期狀態轉移是否真的發生。

作者提出一個 neuro-symbolic framework，把學得的 VLA 控制與顯式 task graph、multimodal procedural memory 結合。可用簡化狀態表示理解：

$$
s_t = (g_t, M_t, o_t), \qquad a_t \in \mathcal{A}(g_t, M_t).
$$

其中 $g_t$ 是 task graph 中目前的程序節點，$M_t$ 是已完成動作、文字脈絡與相關視覺證據構成的記憶，$o_t$ 是當下觀測；$\mathcal{A}(g_t,M_t)$ 則是依賴與分支條件允許的下一步集合。這不是論文正式方程，而是我根據摘要整理的概念式：核心不是讓政策在所有動作中自由猜，而是先用程序狀態縮小合法選項。

摘要也加入人類示範的 gaze 或 saliency guidance，作為空間與時間提示。初始研究為隔離政策學習效果，直接在 robot-view teleoperation videos 上標註 pseudo-gaze，而沒有處理跨視角 gaze transfer。作者選擇 workspace clearing 與 surgical-instrument handling 兩類長時序任務，並自稱評估物件／目的地選擇、子任務完成、程序進度、步驟順序、完整任務成功，以及程序或執行錯誤。

## Introduction 的問題設定

Introduction 先承認 VLA 已能把視覺—語言 backbone 的語意知識轉成連續機器人控制，並點名 OpenVLA 與 $\pi_{0.5}$ 的廣泛操作能力；接著把缺口放在長程序，而不是單一短技能。長程序要求進度能跨步驟持續存在、依賴關係不可被跳過、條件分支要被解析，物件與目的地也必須持續正確 grounded。若場景中還有人類或另一個 embodied agent，外部事件也可能改變下一步。

作者提出的高層循環是 **observe–ground–remember–choose–execute–verify**：固定基座與腕部相機持續觀察並驗證轉移，task graph 與 event memory 負責高層選擇，fine-tuned VLA 負責控制；stable global view 中的 sparse procedural saliency 則提示與當前程序相關的證據。

Introduction 自稱三項貢獻：具有多種 executor role 的 graph-and-memory architecture；同時支援外顯視覺提示與內化 attention regularization 的共享 saliency interface；以及兩者可處理觀察到的空間選擇失敗的初步證據。本次沒有閱讀實驗章，所以不判斷「處理」的效果量、比較公平性或泛化範圍。

## 研究的第一性問題

- **基本問題**：長時序機器人任務的控制政策，如何知道現在位於哪個程序狀態，以及哪些下一步仍合法？
- **約束**：環境狀態只能經由不完美感知取得；動作可能失敗；人類或其他 agent 會改變場景；同一語言目標可能包含順序、分支與空間指涉。
- **既有方法卡點**：短技能成功不代表能保存跨步驟進度；完全端到端的 action generation 可能沒有可檢查的依賴約束，也容易把「已下達動作」誤當成「狀態已改變」。
- **作者試圖移動的邊界**：從一次性 language-conditioned control，移到由 graph、memory、perception verification 與 VLA executor 共同維持的程序閉環。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 以 task graph 明確表示動作依賴、合法轉移與條件分支。
- 以 event memory 保存 active step、完成紀錄、文字脈絡與任務相關視覺證據。
- 用持續的固定視角與腕部視角感知驗證狀態轉移，而不是只按計畫向前走。
- 將示範衍生的 saliency 與 VLA fine-tuning／inference 結合，協助物件與目的地 grounding。
- 在兩種含順序與分支的長時序操作領域提供初步證據。

### 我的保守判讀

- 真正值得注意的是 **控制權分層**：graph 決定哪些步驟合理，memory 記錄程序證據，VLA 處理高維連續控制。這比「神經加符號」標籤本身更具可重用性。
- verification 必須能區分「動作命令已送出」與「物理世界已達到預期狀態」。但 Introduction 尚不足以判斷其 failure detector 是否可靠，或錯誤驗證會不會把整個程序鎖死。
- 手工或半手工 task graph 可能換來可靠性，也可能形成 authoring bottleneck。任務變動時，graph、branch condition 與 visual evidence schema 的維護成本仍待全文確認。
- pseudo-gaze 是刻意簡化的初始設計，有助隔離 saliency 的作用，卻不能直接證明自然人類視線可跨人、跨視角、跨任務穩定轉移。
- 摘要列出多種評估面向，但本次未讀數據與 baselines；目前只能說架構主張合理，不能據此認定已解決長時序 VLA。

## 可放進資料庫的筆記

1. **長時序能力不是短技能成功率的線性延伸。** 它多了程序狀態、依賴、分支與錯誤累積。
2. **計畫狀態與世界狀態必須分帳。** 執行過某一步，不等於該步的預期效果已發生。
3. **記憶應保存可決策的事件，而不只是更多影像 token。** active step、completed actions 與 evidence 可比無界歷史更可控。
4. **符號結構可以作為 action-space constraint。** 它不必取代 VLA，而是限制高層合法轉移。
5. **可靠控制需要 execute–verify 閉環。** 沒有驗證的長程序，本質上是 open-loop plan playback。
6. **多 agent 場景需要事件歸因。** 人類、機器人與其他 agent 都可能觸發狀態轉移，記憶不能只記本機器人的命令。
7. **Saliency 是程序介面，不只是可視化。** 若提示能指定當前步驟應看的證據，它可連接高層程序與低層感知。
8. **模組化的代價是介面設計。** graph、memory、grounding、executor 與 verifier 之間的資料契約會成為新瓶頸。

## 後續想追的問題

1. Task graph 與 branch conditions 是人工建立、由語言模型生成，還是可從示範學得？其維護成本多高？
2. Event memory 的寫入、更新與衝突處理規則是什麼；錯誤事件能否回滾？
3. Transition verifier 如何處理遮擋、部分完成與延遲效果，誤判率如何影響完整任務？
4. Saliency guidance 的外顯 RGB prompt 與 attention regularization，各自需要多少額外標註並帶來什麼差異？
5. 改善來自程序約束、記憶、雙視角驗證還是 pseudo-gaze；是否有足夠消融將它們分開？
