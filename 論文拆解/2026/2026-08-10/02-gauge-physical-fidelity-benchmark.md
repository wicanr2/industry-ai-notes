# GAUGE: A Measurement-Grounded Benchmark for Physical Fidelity in Simulation Engines and Video World Models

## 原文資訊
- 論文：GAUGE: A Measurement-Grounded Benchmark for Physical Fidelity in Simulation Engines and Video World Models
- 作者：Shuai Wang、Yaxin Feng、Xuekun Jiang、Shihan Tian、Ningyu Yan、Xing Shen、Chaoyang Lyu、Hui Wang、Yunsong Zhou、Hanqing Wang、Jiangmiao Pang、Yang Xiang、Xing Gao、Chunhua Shen、Weinan Zhang
- arXiv ID：2608.05948v1
- 分類：cs.AI、cs.CV、cs.RO
- 發表 / 更新：2026-08-06 / 2026-08-06（v1）
- 連結：[abs](https://arxiv.org/abs/2608.05948v1) / [pdf](https://arxiv.org/pdf/2608.05948v1)
- 本次閱讀範圍：Summary/Abstract + Introduction；未讀 Related Work、方法、實驗、結果與附錄
- 擷取日期：2026-08-10

## 為什麼選這篇

Physical AI 依賴模擬器大量產生訓練資料、評估 policy，也愈來愈把生成式影片模型當成隱式 world model。然而「看起來合理」與「物理參數正確」是兩件事：畫面可以很流暢，碰撞後的動量、自由落體加速度或振盪週期仍可能是錯的。GAUGE 正面處理這個評估缺口。

它把數值 physics engine 和 generative video world model 放進同一個以真實量測為基礎的診斷框架，而不是只靠人類或 VLM 對視覺真實感打分。這對機器人資料生成、sim-to-real 與 world-model planning 都有獨立價值；也與今日另一篇 XEWorld 互補：XEWorld 問跨機身是否泛化，GAUGE 問生成的動態是否符合可量測的物理。

## 一句話理解

不要只問模擬或生成影片「像不像真的」，而要用真實軌跡與物理參數定位它「哪一條物理規律、哪一個量」偏掉了。

## Summary / Abstract 說了什麼

摘要介紹 GAUGE：22 組受控任務涵蓋剛體、纜線、紡織物與體積可變形物體，並配對真實軌跡、校準物理 metadata、量測不確定性與任務專屬 observables。涵蓋的現象包括碰撞、摩擦、動量傳遞、振盪、自接觸與形變。

它區分兩種常被混在一起的評估：

1. **方程形式是否正確**：例如生成軌跡是否大致符合某種時間函數或守恆關係；
2. **物理參數是否正確**：即使曲線形式對，也可能估出錯誤的加速度、動量轉移量或振盪時間尺度。

可用簡化觀念表示：若真實軌跡由 $x(t;\phi)$ 決定，$\phi$ 是摩擦、重力、彈性或阻尼等物理參數，生成模型可能學到同一類函數形狀，卻產生

$$
\hat{x}(t)=x(t;\hat{\phi}),\qquad \hat{\phi}\neq\phi.
$$

肉眼看起來仍「像物理運動」，但對規劃與控制而言，時間點和作用量可能已經錯了。

摘要自稱，作者在 14 類任務比較 Isaac Sim、Genesis、Newton，另以 5 類剛體任務測試 6 個 image-to-video 模型。結果宣稱沒有任何 physics engine 全面忠實，困難集中在衝擊接觸、快速布料運動與體積形變；影片模型則會出現方程形式看似正確、參數與時間穩定性卻錯誤的情況。本次未讀結果章節，不能獨立核對比較公平性或誤差幅度。

## Introduction 的問題設定

Introduction 從 real-to-sim-to-real pipeline 出發：模擬可支援大規模 robot learning、policy evaluation 與資料生成，但其有效性取決於環境的物理忠實度。視覺擬真並不保證動作、接觸或形變正確；錯誤動態可能讓 policy 利用模擬漏洞，也可能使 policy 排名失真。

作者認為現有 benchmark 常依賴視覺真實感、人的 plausibility 判斷或個別物理現象，難以回答具體是哪個機制出錯。GAUGE 因而採用真實受控實驗，提供毫米級觀測、校準參數與量測不確定性，並把數值 simulator 與生成式 world model 分成兩條評估 protocol：前者重建相同場景後比較軌跡，後者從初始影像與文字提示生成後續影片，再從影片恢復運動軌跡，檢查方程結構、參數準確度與時間穩定性。

Introduction 自稱資料約含 1,560 次 motion-capture trials，並把剛體接觸、布料材料反應與體積軟體力學放入同一套標準化集合。這個範圍宣稱值得關注，但任務覆蓋、校準方法與資料品質仍須讀後續章節才能判斷。

## 研究的第一性問題

- **基本問題**：一段模擬或生成軌跡要滿足什麼，才能被視為足以支撐機器人學習與規劃的物理近似？
- **約束**：真實量測有誤差；不同材料與機制需要不同 observable；數值模擬器與影片模型輸出形式不同。
- **既有方法卡點**：感知相似度對動量、摩擦、接觸與材料參數不敏感；人類 plausibility 分數難定位錯誤；單一物理 regime 的 benchmark 不易比較。
- **作者試圖移動的邊界**：從「整體像不像」推進到「方程形式、參數、軌跡與時間穩定性在哪裡不符」，並以同一真實量測基礎診斷兩類 simulator。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提供 22 類、約 1,560 次真實動態量測的跨 regime 任務集合。
- 以校準物理參數、不確定性與 task-specific observable 支援具體失敗診斷。
- 用共同的真實實驗基礎，分別評估主流 physics engine 與生成式影片 world model。
- 區分物理方程形式符合、參數準確度與時間穩定性，揭露視覺合理但數值錯誤的生成。

### 我的保守判讀

- 以真實量測取代純感知分數，是重要的評估方向；但不同物理 regime 是否能用「統一」分數公平彙總，仍需小心。
- 22 類任務很廣，卻未必覆蓋流體、致動器、感測器噪聲、機器人—物體閉迴路互動等部署問題；Introduction 也明示其重點並非所有物理現象。
- video world model 的評估還包含從生成畫面追蹤軌跡的誤差。必須區分是生成動態錯誤，還是視覺追蹤／參數反推錯誤。
- physics engine 結果高度依賴場景建模、solver、time step 與參數校準；「沒有全面忠實的引擎」不等於引擎在適當調參後不可用。
- 摘要列出的模型與任務數量不對稱；影片模型只測剛體子集，不能直接外推到布料或軟體生成能力。

## 可放進資料庫的筆記

1. **視覺逼真與物理忠實是兩個座標軸**：Physical AI benchmark 不應用單一感知分數替代動態量測。
2. **方程形式對，不代表參數對**：曲線看起來像自由落體或振盪，時間尺度與作用量仍可能足以讓控制失敗。
3. **benchmark 應回報失敗位置，而非只做排行榜**：知道是摩擦、衝擊、布料或軟體誤差，才有工程修正價值。
4. **真實量測也要附不確定性**：reference 不是絕對真值；誤差若落在儀器與重複試驗變異內，不能過度解讀。
5. **sim-to-real 的可信度取決於任務相關 observable**：不同機制需看位置、速度、動量、曲率、應變或週期，不能一律用畫面距離。
6. **比較模擬器要公布校準帳本**：場景重建、材料參數、solver 與 time step 都可能比品牌名稱更影響結果。
7. **生成式 world model 的評估是測量鏈**：生成、追蹤、參數估計每一步都會帶入誤差，需分層驗證。
8. **可用的 simulator 不必全域完美，但要知道適用域**：診斷 benchmark 的價值在建立每種引擎／模型的物理能力邊界。

## 後續想追的問題

1. 量測不確定性如何傳遞到 generalized trajectory error 與模型排名？
2. 各 physics engine 是否使用相同校準預算、solver 精度與 time step？
3. 從生成影片恢復軌跡時，如何隔離遮擋、形變與 tracker 誤差？
4. 為何 video world model 只測 5 類剛體任務，後續能否擴展到纜線、布料與軟體？
5. benchmark 分數與下游 robot policy 的 sim-to-real 成功率是否真的相關？
