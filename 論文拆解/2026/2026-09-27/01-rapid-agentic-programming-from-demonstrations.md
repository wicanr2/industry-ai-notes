# RAPID: Robot Agentic Programming from Demonstrations

## 原文資訊

- 論文：RAPID: Robot Agentic Programming from Demonstrations
- 作者：Yuyao Liu、Jiayuan Mao、David Hsu、Leslie Pack Kaelbling、Tomás Lozano-Pérez
- arXiv ID：2609.30249v1
- 分類：cs.RO、cs.AI、cs.CV
- 發表 / 更新：2026-09-24 / 2026-09-24（v1）
- 連結：[abs](https://arxiv.org/abs/2609.30249v1) / [pdf](https://arxiv.org/pdf/2609.30249v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML，讀至 Related Work 前）
- 擷取日期：2026-09-27

## 為什麼選這篇

RAPID 位在 coding agent、機器人示範學習與接觸豐富操作的交界。它不是把語言模型直接當連續控制器，而是問：coding agent 擅長的「寫程式—執行—驗證—修正」迴圈，如何在沒有現成測試規格、動作 primitive 與可重設驗證環境時，真正搬進機器人系統？

值得收錄的原因，是它把單次人類示範視為一種較完整的 programming interface：示範不只提供軌跡，也同時提供任務意圖、可行操作線索與重建測試環境的材料。這比「從影片複製動作」多走一步，試圖把示範壓縮成可跨場景重用的關係式程式。

## 一句話理解

RAPID 試圖從一段視覺人類示範，自動補出 coding agent 所需的規格、動作 primitive 與模擬驗證場，再反覆除錯出可重用的機器人操作程式。

## Summary / Abstract 說了什麼

Abstract 將問題拆成 agentic coding loop 的三個缺件：可測試的任務規格、能落到機器人執行的 action primitives，以及能執行與驗證候選程式的互動環境。RAPID 宣稱可從單一視覺人類示範自動推導這三者。

為避免只記住示範中的絕對姿勢、距離與 waypoint，系統採用 object-centric relational program representation。primitive 被寫成實現物件層級運動效果的局部軌跡最佳化程式；多個 primitive 則以關係約束串接，讓場景中的幾何量在執行時重新求解。

Abstract 另自稱，系統在八個接觸豐富的非抓取操作任務、LIBERO-Pro 的一般抓取任務，以及真實 Franka 手臂上具有良好表現與泛化。不過本次沒有閱讀實驗章，因此這些結果只作為作者宣稱，不作獨立驗證。

## Introduction 的問題設定

Introduction 先用人類工程師開發機器人程式的工作流建立類比：工程師不會只產生一次程式，而會根據測試案例反覆執行、觀察失敗並修正。coding agent 的核心優勢也在這個閉環，而非一次性的 code generation。

接著作者指出，機器人領域常預先提供 success signal、人工設計 primitive 與可重設環境；一旦拿掉這些條件，agent 甚至沒有明確的「測試是否通過」介面。因此核心問題不是模型會不會寫 Python，而是誰來建立可驗證的問題邊界。

論文的回答是把 demonstration 當成啟動整個閉環的媒介：從示範推斷任務與階段性 success predicate，建立操作 primitive，重建互動模擬環境，並生成合理的場景變體供候選程式驗證。為了讓程式超越原始場景，表示法只保留策略中的物件角色、關係與效果，把具體幾何留到 runtime 解決。

最後，Introduction 選擇 nonprehensile manipulation 作為主要壓力測試。抓取任務常可由 pick、move、place 等較固定 primitive 組合；推、翻、滑、倚靠環境接觸等非抓取操作則更依賴幾何與物理條件，較能檢驗 primitive 是否真的由示範生成，而不是從人工技能庫取用。

## 研究的第一性問題

- **基本問題**：若沒有現成規格、技能 API 與測試環境，機器人 coding agent 要憑什麼知道程式做對了？
- **約束**：單次示範包含的只是特定物件、姿勢與場景；直接重播容易過擬合，接觸操作又難靠固定 primitive 完整涵蓋。
- **既有方法卡點**：許多 agentic robotics 方法把最昂貴的工程前提——success signal、primitive 與 resettable environment——留給人類預先提供。
- **作者試圖移動的邊界**：從「用模型組合既有機器人 API」移向「由示範建立 API、驗證規格與測試場，再由 agent 反覆除錯」。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 從單一視覺人類示範推導 task specification、manipulation primitives 與 interactive verification environment。
- 以物件中心、關係式程式表示保留策略不變量，而非複製固定軌跡。
- 讓 coding agent 在重建場景及其變體中執行、驗證並修正 primitive 與整體策略。
- 將方法用於接觸豐富的非抓取操作，也延伸到一般抓取任務與真實機器人。

### 我的保守判讀

- 最重要的觀念不是「影片自動變程式」，而是 demonstration 被用來建立一套可執行測試制度。這也說明 agent 能力往往受制於驗證介面，而不只是生成能力。
- 關係式程式確實比絕對 waypoint 更可能泛化，但「哪些角色與關係才是策略不變量」本身仍是強假設；若推斷錯誤，後續反覆驗證可能只是在錯的規格內最佳化。
- 從單視角或單段 RGB-D 示範重建物件幾何、物性與接觸環境，可能形成 sim-to-real 的主要誤差源。Introduction 尚不足以判斷失敗時是程式、感知、物理重建或最佳化哪一層造成。
- 作者的泛化與真機結果尚未由本次有限閱讀核對；不能只依 Abstract 推論已解決開放世界機器人 programming。

## 可放進資料庫的筆記

1. **Agent 的上限常由測試介面決定**：能生成候選方案，不等於有能力辨認哪個方案正確。
2. **示範可以是規格來源，不只是訓練樣本**：從行為中抽取 success predicate、階段與可行約束，價值可能高於逐幀模仿。
3. **泛化需要保存不變量、延後求具體量**：保留物件角色與關係，把姿勢、距離和幾何留到 runtime 解算。
4. **Primitive 不一定是固定技能庫**：它也可以是針對某種效果生成、可驗證、可再最佳化的小程式。
5. **驗證環境也是模型產物**：若 simulator、測試變體與 success predicate 都由系統生成，就必須審計它們是否共同偏向同一錯誤假設。
6. **接觸豐富任務可作表示法壓力測試**：越依賴物理關係的任務，越難靠記憶絕對軌跡蒙混過關。
7. **把 agentic loop 搬到實體世界，先處理可回復性**：真機除錯成本、重設與安全邊界，可能比程式生成本身更關鍵。

## 後續想追的問題

1. task specification 與 success predicate 從示範推斷後，如何避免 specification gaming？
2. 場景變體的可行性過濾準確度如何衡量，是否會刪掉重要但困難的反例？
3. 失敗歸因能否分離感知、重建物理、primitive 程式與 strategy composition？
4. 真機部署需要多少人工校正、重設與安全介入？
5. 同一任務若提供策略不同的示範，RAPID 會學到共同不變量，還是產生互斥程式？
