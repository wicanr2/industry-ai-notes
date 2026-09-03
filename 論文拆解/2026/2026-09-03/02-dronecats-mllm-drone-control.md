# Evaluating Multimodal LLMs as Generalist Vision-Language-Action Agents for Drone Control: Commanding, Approaching, Tracking and Searching

## 原文資訊

- 論文：Evaluating Multimodal LLMs as Generalist Vision-Language-Action Agents for Drone Control: Commanding, Approaching, Tracking and Searching
- 作者：Jaewoo Park、Minyoung Lee、Sukmin Seo、Moonbin Yim、Hyunwook Yoon、Dohoon Ryu、Daehee Kim、Myungseo Song、Jihyuk Byun、Seunggyu Chang、Taeho Kil、Jiseob Kim、Bado Lee、Geewook Kim
- arXiv ID：2609.01404v1
- 分類：cs.RO、cs.AI
- 發表 / 更新：2026-09-01 / 2026-09-01
- 連結：[abs](https://arxiv.org/abs/2609.01404v1) / [pdf](https://arxiv.org/pdf/2609.01404v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）
- 擷取日期：2026-09-03

## 為什麼選這篇

這篇直接測試 MLLM 能否進入無人機的 perception-action loop：模型只看單眼第一人稱 RGB 影像，動作空間由 prompt 宣告，還要自行搜索、接近或追蹤目標，並判斷何時完成。相較把模型限制成 pixel pointing 或 semantic grounding 的系統，它刻意把較多決策責任還給模型，因此適合觀察 LLM／MLLM 轉成 Physical AI agent 時最先失效的介面。

它與同日 EmbodiedSkills 的價值不同：EmbodiedSkills 問 runtime 如何約束、驗證並恢復 VLA skill；DroneCATS 問在較少外部鷹架下，模型本身能否長時間遵守動作協定，尤其能否正確發出終止宣告。後者把「知道何時完成」從 benchmark 外部 oracle 改成 agent 自己的責任，能揭露只看導航距離容易掩蓋的失敗。

## 一句話理解

DroneCATS 把可交換的 MLLM 直接放進無人機閉環，發現真正拉開模型差距的未必是飛向目標，而是能否持續遵守動作協定並在正確時刻宣告完成。

## Summary / Abstract 說了什麼

作者提出 DroneCATS-Agent 與 DroneCATS benchmark，把 MLLM 當成主要自變項：架構其他部分保持不變，只替換模型。模型可用四類能力完成任務，包括接近可見目標、追蹤移動目標、搜索初始視野外目標，以及指揮多架無人機。action space 只在 prompt 中宣告，不做 fine-tuning，也不用 function-calling schema；模型可 yaw 搜索、在不確定時 deliberation，並自行宣告 arrival。

摘要自稱，frontier 與小至 2B 的 open model 都在評估範圍內；即使最簡單的 embodied setting 也尚未解決。值得注意的現象是：某些小型開放模型進入成功半徑的可靠度甚至高於 frontier model，卻因太早宣告抵達或始終不宣告而失去 episode。多機指揮又放大 protocol failure，小模型可能對不同視角盲目複製同一座標。

作者據此將缺口定位成 action protocol discipline，而不只是 spatial perception 或 navigation。本次只能確認摘要與 Introduction 的主張；未讀 benchmark 細節和實驗章，不能核定「小模型導航更好」是否對不同地圖、採樣、延遲與重跑具有穩健性。

## Introduction 的問題設定

Introduction 從 perception 與 embodiment 的差異開始：看懂影像不夠，agent 必須根據 observation 自選下一個物理動作，再處理由該動作產生的新 observation。無人機讓這件事特別明顯，因為 camera pose 本身就是 action，誤差會沿閉環累積，而不是在樣本平均後消失。

作者回顧幾種系統取向：外部 detector、圖上候選點、pixel pointing、LiDAR planner 或輸出前 verifier，都會把一部分責任移出 MLLM。這些方法能讓系統運作，卻不容易回答「模型本身哪一種具身能力最先成為瓶頸」，因為既有研究常改變系統、固定模型。DroneCATS 反過來固定 agent architecture、改變 model。

DroneCATS-Agent 只給 high-level goal，並把三個較難的自主決定交給模型：視野中沒有目標時原地 yaw 搜索、場景歧義時花一步 deliberation，以及自行宣告 arrival。特別是 termination：既有系統可能用模型看不到的真實距離閾值停止；這篇要求模型提交「已到達」的 claim，再由 verifier 評分。作者認為，若停止仍由外部 oracle 代勞，就還不能稱為完整自主。

benchmark 另外用「目標是否移動」與「初始畫面是否可見」形成四種單機情境，並加入同一 context 同時指揮四架無人機辨別相似候選的設定。Introduction 自稱，最佳模型在最簡單的初始可見目標情境也只成功 20 次中的 13 次；目標初始不可見時，成功率再下降超過三分之一。小型模型的尖銳失敗則在「已飛進範圍，卻未正確結束」。

## 研究的第一性問題

### 基本問題

一個模型若能在空間上接近正確目標，卻不能可靠地遵守 action protocol 或宣告完成，應算具備 embodied autonomy 嗎？

### 約束

- 模型只有 egocentric monocular RGB；連移動深度也由模型估計，缺少直接 depth sensor。
- camera pose 隨動作改變，錯誤 observation-action loop 會改寫下一步輸入。
- action space 由自然語言 prompt 宣告，而非較硬的 function schema。
- arrival 既是語意判斷，也是 episode termination protocol；錯誤會把物理上已接近的軌跡判成失敗。
- 多機情境要求在同一 context 中維持不同視角、目標與座標的綁定。

### 既有方法卡點

當外部 detector、planner、verifier 或真實距離 oracle 接管困難步驟，系統成功率無法清楚顯示 MLLM 的自主邊界。另一方面，若 benchmark 只看是否曾經穿過目標半徑，也會掩蓋 agent 不知道自己已完成的問題。

### 作者試圖移動的邊界

作者試圖把模型評估從靜態空間 grounding 推向持續的 protocol adherence：搜索、移動、等待與停止都成為模型動作，且成功必須由模型主動宣告。這讓「會飛」和「能完成一段可委派任務」成為兩個可分辨的能力。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出模型可交換的 DroneCATS-Agent，四種 action 都以 prompt 宣告，不需微調或 function schema。
- 用統一閉環協定評估 approaching、tracking、searching 與 self-declared arrival。
- 建立單機任務與 $N=4$ 多機 commanding 評估，涵蓋九個模型、兩張地圖及多種 episode。
- 將小模型的主要缺口定位為終止宣告與 action protocol adherence，而非純 navigation。
- 提供重複飛行的 variance audit 與按模型整理的 failure taxonomy；具體做法仍待讀全文確認。

### 我的保守判讀

- 將「抵達」改為 agent 的 claim，是很好的測量拆解：物理軌跡品質與任務協定完成度不應混成一個距離分數。
- 但 prompt-only action interface 同時測量視覺空間能力、自然語言 instruction following、輸出解析穩定性與 termination policy。所謂 protocol gap 未必全是具身推理問題，也可能部分是介面設計問題。
- 外部 verifier 雖不替模型決定何時停止，仍決定 claim 是否成立。它使用哪些資訊、容錯半徑與失敗定義，會顯著塑造排名。
- 小模型「進入半徑更可靠」是有趣線索，不宜在未讀實驗後外推成小模型普遍更會導航；可能受採樣策略、速度、保守程度、地圖或 episode 數影響。
- benchmark 刻意減少鷹架，有助於能力診斷，但部署系統未必應移除鷹架。測出模型缺口和設計可靠產品是兩個不同目標。
- 本次未讀方法與實驗，不知道 action parameterization、控制頻率、影像更新、模型 latency、解析失敗處理及多次重跑的完整統計。

## 可放進資料庫的筆記

1. **到達不等於完成**：agent 必須辨識、宣告並依協定終止，物理上曾接近目標只是一個中間事件。
2. **把模型設為自變項**：固定 agent scaffold、只替換 backbone，較能定位模型差異；固定模型、改整套系統回答的是另一個問題。
3. **鷹架既提高可靠性，也遮蔽能力邊界**：外部 planner／verifier 對產品可能必要，但做 benchmark 時要明確標示它替模型拿走了什麼責任。
4. **終止動作是一等公民**：stop／done 不應被視為附帶格式，它是長時程 agent 的核心 control decision。
5. **Protocol adherence 與 perception 要分開量**：可同時記錄 closest distance、進入成功區、宣告時點與最終 episode success，避免單一分數誤診。
6. **具身錯誤會改寫後續輸入**：camera pose 隨 action 變化，使錯誤不像靜態 QA 那樣只影響一次答案。
7. **多 agent 的難點是綁定，不只是擴充 context**：同一座標被複製到不同視角，顯示 entity-view-action binding 可能先於高階協作失效。
8. **Benchmark 與部署目的不同**：能力評估可故意少給鷹架；實際產品則應把測出的 protocol weakness 交給 runtime、schema 或 safety layer 補強。

## 後續想追的問題

1. 四種 action 的參數與輸出 parser 如何定義；若改用 typed function call，終止錯誤會下降多少？
2. arrival verifier 使用真實位置、視覺資訊還是其他訊號，成功半徑與錯誤宣告如何計分？
3. 小模型進入成功半徑較頻繁的現象，在重跑、不同地圖與 sampling temperature 下是否穩定？
4. 模型 latency 是否納入真實或模擬控制迴路；frontier API 與 2B onboard model 的比較如何處理控制頻率差異？
5. 多機失敗究竟源自長 context、視角混淆、coordinate binding，還是模型沒有可分離的 per-drone memory？
