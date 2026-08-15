# HumanoidVLN: A Physics-Grounded Simulator and Benchmark for Vision-Language Navigation Across Diverse Humanoid Embodiments

## 原文資訊

- 論文：HumanoidVLN: A Physics-Grounded Simulator and Benchmark for Vision-Language Navigation Across Diverse Humanoid Embodiments
- 作者：Quan-Dung Pham、Anh Dao、The-Anh Nguyen、Minh Nguyen-Dinh、Phuong Nam Dang、Tri Pham、Hung Tran、Bach Dao、Tuyen P. Le、Truong Nguyen、Quan Nguyen
- arXiv ID：2608.12860v1
- 分類：cs.RO
- 發表 / 更新：2026-08-13 / 2026-08-13
- 連結：[abs](https://arxiv.org/abs/2608.12860v1) / [pdf](https://arxiv.org/pdf/2608.12860v1)
- 本次閱讀範圍：Summary/Abstract + Introduction（arXiv HTML）；未讀 Related Work、平台細節、實驗、Results 與附錄
- 擷取日期：2026-08-15

## 為什麼選這篇

語言導航 benchmark 常把 agent 抽象成可直接轉向、平移的相機或輪式底盤，但 humanoid 的路徑是否可執行，會受到步態、重心、身高、關節自由度與鏡頭晃動影響。這篇把 VLN 的語言／視覺層和雙足物理執行放進同一評估框架，正好位於 LLM/VLM + Robotics / Embodied AI 的交會。

它與今日另一篇 VLA 內部進度解碼的價值不同：前者處理 policy 的可觀察性，HumanoidVLN 處理 benchmark 是否保留 embodiment 與 controller 的真實限制。兩者合起來指向同一部署問題——不能只評模型輸出，還要評訊號經控制堆疊落到特定機體後發生什麼。

## 一句話理解

作者想建立一套不把 humanoid 當成理想化移動相機的 VLN benchmark，讓語言導航模型必須經過雙足控制與不同機體形態接受物理執行檢驗。

## Summary / Abstract 說了什麼

HumanoidVLN 建於 NVIDIA Isaac Sim，示範四種 humanoid：Unitree G1、Unitree H1、Internal-A 與 Internal-B。它們具有 10–12 個下肢 DoF；DoF（degrees of freedom，自由度）表示可獨立控制的關節運動維度。機器人高度涵蓋 1.17–1.80 公尺，目的是讓形態差異成為 benchmark 變數，而不是固定背景。

控制採階層式分工：低層 reinforcement learning policy 負責 locomotion，高層可替換 PD（比例—微分）或 MPC（模型預測控制）path tracker。摘要自稱平台可接入 NaVILA、DualVLN、StreamVLN 與 JanusVLN，也可擴充新機體與模型。

場景來自美術設計資產與 3D Gaussian Splatting 重建，並篩選可導航面積超過 $100\,\mathrm{m}^2$ 的環境。資料包含 933 條 collision-aware 參考 episode；每條有一個細粒度指令與 formal、natural、casual 三種較粗粒度改寫。指令由雙 generator-reviewer、paraphraser multi-agent pipeline 產生，再經 human-in-the-loop 驗證。

**論文自稱：**四模型、四機體比較中，JanusVLN 的平均 success rate 為 43.55%，nDTW 為 48.38。nDTW（normalized Dynamic Time Warping）衡量執行軌跡與參考路徑的形狀相似度並正規化，通常越高越接近參考路徑。20 個 episode 的 sim-to-real pilot 宣稱 navigation error 相關係數為 $r=0.935$；$r$ 接近 1 表示兩組誤差呈強正相關，但不代表數值完全一致或存在因果關係。本次未讀實驗章節，未核對樣本選擇與不確定性。

## Introduction 的問題設定

Introduction 把缺口分成三層。第一，既有 VLN simulator 常用 kinematic teleportation，繞過雙足 locomotion 的穩定性與可達性；即使加入 Isaac Sim，有些工作仍把不同 robot morphology 透過相同 control proxy 處理，因而弱化身高、自由度與重心差異。

第二，scene 數量多不等於適合 humanoid 導航。雙足機器人需要足夠寬廣、障礙較少的 traversable area；若場景拓撲本身不可通過，失敗可能不是 VLN 推理問題。作者因此以至少 $100\,\mathrm{m}^2$ 可通行面積作為實務篩選條件，並加入 3DGS Real2Sim 場景。

第三，理想化穩定鏡頭與光照不符合實際 humanoid 的 egocentric observation。步態會造成相機震動；全自動 VLM annotation 又可能產生空間幻覺。作者以 generator-reviewer、paraphraser 與人工驗證結合，試圖在規模與 grounded instruction 之間折衷。

Introduction 宣稱的貢獻包括：跨四種機體的物理 simulator、87 個大面積高擬真場景、933 episode 的多風格指令資料，以及四種 VLN 模型在四種機體上的 matched zero-shot evaluation。

## 研究的第一性問題

- **基本問題：**同一個語言導航決策，換到不同 humanoid 身體與 controller 後，是否仍然可執行且可比較？
- **約束：**benchmark 要同時保留自然語言、視覺觀察、場景可通行性、雙足動力學與跨機體差異。
- **既有方法卡點：**把 agent 簡化成理想化相機，會把 path prediction 正確誤當成 physical execution 成功；反過來，不可導航場景也會污染模型評估。
- **作者試圖移動的邊界：**從「VLN model benchmark」移到「model × controller × embodiment × environment」的系統 benchmark。

## 可能的貢獻與限制（只基於 summary + introduction）

### 論文自稱

- 提供支援多 humanoid morphology 的 Isaac Sim 物理平台與階層式控制介面。
- 以可通行面積明確篩選場景，並納入 artist-designed 與 3DGS Real2Sim 來源。
- 透過 multi-agent 產生、人工覆核，建立具有細粒度與多語氣版本的 instruction dataset。
- 跨四個 VLN model 與四種 humanoid 進行 matched zero-shot 評估，並做小規模 sim-to-real pilot。

### 我的保守判讀

- 最重要的概念貢獻是把 benchmark 單位從模型擴成整個 embodied stack；同一模型的失敗可能源於 perception、planner、tracker 或 locomotion policy。
- $100\,\mathrm{m}^2$ 是實務篩選門檻，不等於「足以代表真實建築」的理論條件；它也可能偏向寬闊場景，避開最需要 humanoid 靈活性的狹窄空間。
- 933 episode 與 20-episode sim-to-real pilot 可提供方向性證據，但僅憑摘要不足以判斷跨場景、跨機體泛化及統計穩健性。
- multi-agent annotation 加人工覆核能降低幻覺，不表示消除指令模板偏差；formal/natural/casual 改寫是否真的帶來不同 grounding 難度，仍需檢查。
- 摘要註明 code、benchmark、data 將在論文獲接收後釋出；目前的可重現性可能受尚未公開資產限制。

## 可放進資料庫的筆記

1. **Embodied benchmark 的最小單位是 stack：**模型、controller、機體與場景共同決定結果。
2. **可行性要先於智能評分：**場景或路徑物理上不可通過時，不能把失敗全歸因於語言理解。
3. **跨 embodiment 不是只換 URDF：**身高、DoF、重心與鏡頭動態會改變 observation 與 action feasibility。
4. **路徑相似與成功率要並看：**到達終點、路徑忠實度、跌倒率分別反映不同 failure mode。
5. **Sim-to-real 相關不等於 sim-to-real 等值：**高相關只表示案例難易排序可能一致，仍要檢查絕對誤差與系統性偏差。
6. **資料生成要有空間 grounded 的驗證迴路：**VLM 可擴充 instruction，但 reviewer 與人類檢查仍是控制幻覺的必要層。
7. **Benchmark filtering 會定義研究問題：**篩掉小或狹窄場景能提高可執行性，也可能把真實 humanoid 的關鍵困難排除在外。
8. **Physical AI 的效能瓶頸可跨層轉移：**更強 VLN model 未必改善低層 tracking 或 locomotion 造成的失敗。

## 後續想追的問題

1. matched zero-shot 評估如何確保四種機體接收到等價而非偏向某一 morphology 的路徑？
2. PD 與 MPC tracker 對各模型排名、跌倒率與 nDTW 有多大影響？
3. 87 個場景的 3DGS 碰撞幾何、材質與感測噪聲如何校準？
4. 20 個 sim-to-real episode 的選樣方式、相關係數信賴區間與失敗案例為何？
5. 何時公開 code/data，授權是否足以讓其他團隊加入新 humanoid 與商用場景？
