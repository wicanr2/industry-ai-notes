# Manipulation Feasible Navigation Among Movable Obstacles with Discrete Contact Pushing

## 原文資訊

- 論文：Manipulation Feasible Navigation Among Movable Obstacles with Discrete Contact Pushing
- 作者：Shaohu Wang、Aiguo Song、Yulong Yuan、Zhongyu Sun、Tianyuan Miao、Qinjie Ji
- arXiv ID：2609.23312v1
- 分類：cs.RO
- 發表 / 更新：2026-09-20 / 2026-09-20
- 連結：[abs](https://arxiv.org/abs/2609.23312v1) / [pdf](https://arxiv.org/pdf/2609.23312v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（官方 arXiv HTML，只讀至 Related Work 前）
- 擷取日期：2026-09-22

## 為什麼選這篇

這篇處理一個很具體的 Physical AI 問題：移動機器人遇到大型可移動障礙時，不應永遠把物體當牆繞開；但「推開它」也不是單一動作，而要同時考慮新路徑是否值得、物體能放在哪裡、機械臂能否接觸，以及移動後會不會堵住下一段路。

它與 LLM + Robotics 的關聯在於，作者沒有讓 LLM 直接決定物理動作，而只在直接 relocation 因空間不足而失敗時，用 LLM 推測可能要先移動哪些輔助障礙，再由 deterministic geometric planning 驗證。這種「語意模型產生稀疏假說、幾何系統保留裁決權」的分工，比泛稱 LLM planner 更具工程可讀性；另一個獨立價值則是用離散接觸模式把高階 relocation pose 接到 whole-body pushing controller。

## 一句話理解

這篇把「繞路還是推障礙」拆成可驗證的高階 relocation 規劃與可組合的接觸推動，並只在組合依賴難以枚舉時讓 LLM 提案、由幾何規劃驗證。

## Summary / Abstract 說了什麼

作者提出 hierarchical navigation among movable obstacles（NAMO）框架。高階 planner 從參考路徑找出真正擋路的物體，搜尋同時滿足幾何、manipulation 與後續 navigation constraints 的 relocation plan；若其他可移動物體占據放置、接近或推動空間，才選擇性呼叫 LLM 推測 auxiliary manipulation dependencies，且所有推測都要經 deterministic planning 驗證。

執行層把箱形障礙表面定義成離散 contact modes，依位置與姿態誤差在線選擇接觸面與區域，透過 contact switching 組合直推、側推與轉角推。recurrent reinforcement-learning policy 協調 mobile base 與 manipulator，追蹤 tool center point（TCP）目標並維持 end-effector reachability。摘要自稱模擬與實機驗證涵蓋繞行、單／多障礙 relocation 與依賴受限情境；本次未讀實驗章節，因此不判斷成功率、泛化或比較優勢。

## Introduction 的問題設定

Introduction 先指出傳統 navigation 把物體視為不可穿越障礙，面對可移動大型物體時可能付出不必要繞路成本，甚至無路可走。NAMO 則允許機器人主動改變環境，但同時產生耦合決策：選繞行或互動、找出真正限制候選路徑的物體、選擇有利且物理可執行的 relocation pose。

第二層難題是 manipulation dependency。擋路物體不一定是唯一要移動的物體；其他箱體可能占據預定放置點、接近路徑或推動空間，因此「為了移動 A，先移動 B」的依賴會改變搜尋結構。作者把 LLM 放在這個條件式分支，而非取代整個 planner，並要求幾何規劃逐一驗證假說。

第三層難題是高階可行不等於物理可執行。未致動的大箱體只能透過接觸移動；中央接觸偏向平移，偏心接觸會引入旋轉力矩，方向改變時還需要底座重定位與重新接觸。作者因此主張，分別訓練多個 pushing skills 不足以涵蓋複雜 relocation，需要把目標物體 pose 映射成有限 contact modes，再交給共享的 whole-body controller 追蹤 TCP reference。

Introduction 最後把完整系統描述成兩層：上層比較 navigation-only 與 interaction-enabled hypotheses，搜尋可執行 relocation；下層用 contact-mode switching 與 RL controller 將直推、側推、轉角推組成連續行為。核心介面不是自然語言，而是經幾何驗證的 target object pose 與可執行的接觸參考。

## 研究的第一性問題

- **基本問題**：可移動障礙不是單純的地圖占用格，而是可以用動作交換未來通行空間的環境狀態。
- **核心約束**：路徑縮短不代表 manipulation 可行；物體放置、接近空間、接觸位置、末端可達性與後續通行必須同時成立。
- **既有方法卡點**：高階 relocation path 可能忽略 mobile manipulator 的接觸執行條件；分離 pushing skills 又不易組合多階段姿態改變。
- **作者試圖移動的邊界**：讓 task-level relocation search 與 whole-body pushing 共享明確介面，並把 LLM 限制在需要提出依賴假說、但可被幾何驗證的環節。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提出面向大型、不可抓取、可推動箱形障礙的 manipulation-feasible NAMO planner，同時比較繞行與互動方案。
- 在直接 relocation 失敗時，以 LLM 輔助推測 auxiliary obstacles 與 manipulation dependencies，再由 deterministic planning 驗證。
- 用 discrete contacts、TCP references 與共享 whole-body RL policy 組合直推、側推與轉角推。
- 在模擬與實機情境整合驗證 decision making、relocation 與 multi-contact pushing。

### 我的保守判讀

- 最值得關注的 LLM 設計不是「規劃能力強」，而是它只擴充候選假說、不繞過幾何可行性檢查，較容易界定錯誤責任。
- 已知環境、箱形、可推且不可抓等假設讓問題可處理，也限制了對未知材質、非剛體、任意形狀與動態人流的外推。
- discrete contact modes 提供組合性，但有限 contact set 是否足以處理摩擦變化、卡住與滑動，需要完整方法與實驗才能判斷。
- 摘要與 Introduction 沒有提供足夠資料評估 LLM 在整體成功率中的邊際貢獻、誤提案率與額外延遲。
- 系統把 high-level plan 接到 learned controller，仍需確認 planner 使用的可行性模型與實際 controller 能力是否一致，否則可能產生 model-policy gap。

## 可放進資料庫的筆記

1. **障礙物也可以是決策變數**：Physical AI 不只在固定世界中找路，也可以用操作改寫未來的可達空間。
2. **先比較不改環境與改環境的總成本**：互動只有在 relocation 成本加後續路徑成本優於繞行時才合理。
3. **幾何可行不等於 manipulation-feasible**：規劃器必須納入接近、接觸、末端可達性與放置後通行，而非只檢查物體軌跡無碰撞。
4. **LLM 適合提案，不適合擁有最後裁決權**：在可形式驗證的領域，讓模型提出 dependency hypotheses，再交給 deterministic checker。
5. **選擇性呼叫比全程代理更可控**：只有搜尋失敗暴露組合缺口時才用 LLM，可縮小成本、延遲與錯誤面。
6. **離散接觸是高低階協定**：上層不用直接輸出連續關節控制，下層也不必理解整個任務語意。
7. **依賴是環境中的前置條件圖**：移動 A 之前必須移動 B，與 tool-use agent 的 prerequisite planning 結構相似，但節點與邊必須由物理檢查落地。
8. **驗證器的能力界線決定 LLM 安全性**：只有 checker 能完整捕捉的幾何與操作條件，才真的受到保護。

## 後續想追的問題

1. LLM dependency inference 相對於枚舉或傳統搜尋，究竟節省多少節點與時間，又引入多少錯誤候選？
2. deterministic verifier 檢查哪些條件；摩擦、質量、接觸不確定性是否仍只由 controller 吸收？
3. planner 預測 manipulation feasible 時，使用的能力模型如何與實際 RL policy 校準？
4. contact switching 的穩定條件、失敗偵測與重新規劃機制為何？
5. 從已知箱形環境擴展到未知形狀、可抓／可推混合物件與動態障礙時，哪一層最先失效？
