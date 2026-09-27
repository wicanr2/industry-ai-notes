# Rolling-WAM: World Action Models with Rolling Imagination

## 原文資訊

- 論文：Rolling-WAM: World Action Models with Rolling Imagination
- 作者：Yinghua Zhou、Junjie Ye、Yiqi Zhao、Hao Dong、Celina Shiyu Wang、Ruohai Ge、Tingyi Yang、Basile Van Hoorick、Gaurav Sukhatme、Vitor Guizilini、Yue Wang
- arXiv ID：2609.30247v1
- 分類：cs.RO、cs.AI、cs.CV
- 發表 / 更新：2026-09-24 / 2026-09-24（v1）
- 連結：[abs](https://arxiv.org/abs/2609.30247v1) / [pdf](https://arxiv.org/pdf/2609.30247v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML，讀至 Related Work 前）
- 擷取日期：2026-09-27

## 為什麼選這篇

World Action Model 的吸引力，是讓動作生成能參考「環境接下來可能長什麼樣」；它的部署代價，則是每次重規劃都要對未來影片與動作做昂貴的聯合去噪。Rolling-WAM 直接處理這個 Physical AI 的時間約束：預測若來不及在控制週期內更新，再好的想像也可能降低反應性。

這篇的獨立價值在於它沒有只做模型縮小或刪掉視覺未來，而是重新安排計算的時間結構：近期動作必須完整，遠期計畫可以暫時保持粗糙，並在後續觀察到來時逐步修正。這提供一個可重用的系統觀念——不是所有 horizon 都需要同時達到相同精度。

## 一句話理解

Rolling-WAM 把原本每次重規劃都從頭完成的整段 video-action 去噪，改成跨控制週期滾動接力：先把最近的動作算清楚，較遠未來則保留並逐步精煉。

## Summary / Abstract 說了什麼

World Action Model（WAM）同時預測未來視覺與機器人動作，讓動作能利用預期的場景演化。但標準做法在每個 replanning cycle 都從純雜訊重建完整 horizon，即使 receding-horizon control 最後只執行最前面一小段，也會把未執行尾端丟棄。

Rolling-WAM 維持一個由多個 video-action chunks 組成的滑動視窗。最近的 chunk 位於較低雜訊、在本輪完成去噪後立即執行；越遠的 chunk 保留越高雜訊，只做部分精煉。執行完第一段後，視窗前移，保留的未來預測在新相機觀察條件下繼續去噪，尾端再加入新的純雜訊 chunk。

Abstract 自稱，這種安排在 LIBERO、RoboTwin 與真實 Unitree G1 任務上維持具競爭力的操作表現，並相對標準 joint WAM 帶來 4.5 倍 steady-state replanning speedup。這些數字來自 Abstract；本次未閱讀實驗章，未獨立核對比較條件。

## Introduction 的問題設定

Introduction 先肯定 WAM 的功能價值：聯合預測動作與未來觀察，能讓 policy 不只反應當前畫面，也預期場景如何隨操作改變。但在動態環境中，機器人仍需高頻 closed-loop replanning，才能根據最新觀察修正誤差。

問題在於，標準 joint denoising 每一輪都處理完整 video-action sequence，且從純雜訊重新開始。控制只消耗近期動作，卻支付整段未來的完整推論成本；未執行部分雖曾幫助近期決策，之後仍被丟棄。於是模型的 predictive context 與即時反應性互相拉扯。

作者把突破口放在跨週期重用：未執行的預測不是成品，也不是廢料，而是可在新觀察下繼續修正的中間狀態。Rolling-WAM 因而讓近程計畫具體、遠程計畫暫定；每個 chunk 隨時間靠近執行點，也逐步累積完整去噪步數。

Introduction 最後將主張收斂成一個計算排程問題：在保留 explicit visual imagination 的前提下，把原本集中在單輪的 sequential denoising steps 分散至連續多輪，降低 steady-state 每次產生下一個可執行 chunk 的等待時間。

## 研究的第一性問題

- **基本問題**：閉迴路控制只需要立刻可執行的近期動作，為何每次都要同步完成整段遠期預測？
- **約束**：未來視覺能提供動作生成脈絡，但反覆生成會增加延遲；新觀察到來後，舊未來又可能失準。
- **既有方法卡點**：每輪從純雜訊重算完整 horizon，浪費未執行尾端已投入的計算，也延後下一次控制更新。
- **作者試圖移動的邊界**：把 future prediction 從「每輪一次性產品」改成「跨輪保存、接受新觀察修正的漸進狀態」。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出跨 replanning cycles 分配聯合 video-action 去噪的 rolling formulation。
- 用分層雜訊的滑動視窗，同時產生完整近期 chunk 與部分精煉的遠期 chunks。
- 在新觀察到來後保留並更新未來預測，而非每輪全部丟棄重算。
- 在模擬與真實人形機器人任務中降低 steady-state 重規劃延遲，同時維持具競爭力的任務表現。

### 我的保守判讀

- 核心創意更像「計算的期限感知排程」而非單純更快的生成模型：近期資訊有硬 deadline，遠期資訊只需逐步成熟。
- 保留舊預測能省計算，也會帶入 path dependence；若早期粗略未來嚴重偏離，新觀察是否能在有限更新步數內糾正，是重要風險。
- 所謂 speedup 可能依賴 GPU 能否平行處理較長滑動視窗、chunk 數量與每輪步數設定；不能直接視為所有硬體與控制頻率下的固定收益。
- 成功率與 4.5 倍 speedup 尚未由本次閱讀核對實驗 protocol、baseline tuning 與端到端 wall-clock 定義。

## 可放進資料庫的筆記

1. **不同時間距離需要不同完成度**：近期決策追求可執行，遠期規劃先保留方向即可。
2. **未完成計算也可以是狀態資產**：中間去噪結果不必丟棄，可帶入下一輪並接受新證據修正。
3. **Receding horizon 的浪費要顯式入帳**：若每輪只執行前綴，就應衡量尾端預測被丟棄的比例。
4. **即時 AI 的問題不只 FLOPs，而是 sequential critical path**：把總計算攤開，可能比單純縮小模型更直接改善反應時間。
5. **保存預測同時保存偏誤**：任何 cache／rolling state 都要配套漂移偵測與重置條件。
6. **世界模型的產品價值取決於控制週期**：預測品質必須和更新頻率、感測延遲與安全反應期限一起評估。
7. **計算排程可以成為模型架構的一部分**：training noise profile 若與 deployment rolling schedule 對齊，排程不再只是推論端技巧。

## 後續想追的問題

1. 4.5 倍 speedup 的 latency 邊界包含哪些前後處理與 GPU 同步成本？
2. 突發環境變化時，保留的遠期 chunks 多快能被新觀察改寫？是否有整窗重置機制？
3. 滑動視窗變長後，記憶體用量、吞吐與單輪 latency 如何交換？
4. 相較 action-only rolling diffusion，explicit future video 究竟在哪些任務提供可測的額外收益？
5. 真機安全控制是否獨立於 WAM 運行，推論暫停或預測漂移時如何 fallback？
