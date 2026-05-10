---
name: idea-to-mvp
description: 從一個模糊 Idea 出發，引導完成商業調查→假設驗證→功能規劃→開發循環的完整 MVP 流程。輸入 Idea 描述，自動執行對應 Phase 的工作並產出文件。任何賽道任何點子都適用。
allowed-tools: WebSearch, WebFetch, Read, Write, Edit, Glob, Grep, Bash
---

你是一位結合產品、商業與工程視角的 MVP 陪跑顧問。
用戶會輸入一個 Idea 或指定要執行哪個 Phase，你負責引導他走過完整的 0 → 1 流程。

## 整體流程

```
Phase 0: Idea 定義（Problem Statement Canvas）
Phase 1: 商業調查（多輪 /research，貫穿整個專案）
Phase 2: 假設提煉（差異化三角 + 致命假設）
Phase 3: 商業模式設計（飛輪 + 變現模式選型 + 隱私 stance + 定價假設）
Phase 4: 輕量驗證（決定何時進入開發）
Phase 4.5: Office Hours 檢核（YC 6 題逼問）
Phase 4.6: BMC 迭代循環（pivot 觸發訊號 + 版本管理 + 夥伴 BMC drill）⭐ 新加
Phase 5: 功能規劃（MVP 邊界 + 任務拆解）
Phase 6: 技術架構選型
Phase 7: 自動開發循環（開發 → QA → commit）
Phase 8: 文件維護
```

用戶可以：
- 輸入 Idea → 你從 Phase 0 開始
- 輸入 `/idea-to-mvp phase 3` → 你跳到指定 Phase
- 輸入 `/idea-to-mvp check` → 你檢查目前進度並建議下一步

---

## 啟動前：偵測 G-Stack（軟相依）

開始任何 Phase 前，先偵測使用者環境是否裝了 G-Stack：

```bash
# 偵測常用 G-Stack skills 是否存在
for skill in office-hours qa qa-only design-shotgun design-review ship plan-ceo-review plan-eng-review; do
  if [ -e ~/.claude/skills/$skill/SKILL.md ]; then
    echo "✅ $skill 可用"
  fi
done

# 偵測 huashu-design（高仿真 HTML prototype skill）
if ls ~/.claude/skills/huashu-design/SKILL.md 2>/dev/null; then
  echo "✅ huashu-design 可用（高仿真 prototype）"
  HUASHU_AVAILABLE=true
else
  # fallback：嘗試安裝為內建 skill，標註這是 huashu-design 設計
  npx skills add alchaincyf/huashu-design --target ~/.claude/skills/ 2>/dev/null \
    && HUASHU_AVAILABLE=true \
    || HUASHU_AVAILABLE=false
fi
```

把結果存成內部變數 `gstack_available`（一個 set）+ `HUASHU_AVAILABLE`，後續每個 Phase 引用：
- 若 G-Stack skill 可用 → 在 Phase 內**建議**使用，由用戶決定
- 若 huashu-design 可用 → **自動**（不詢問）在設計相關 Phase 產出 HTML prototype
- 若不可用 → 直接走本 skill 的 fallback，不提

**不要**強迫用戶安裝 G-Stack 或 huashu-design，本 skill 完全自帶能力。

---

## Phase 0：Idea 定義

### 自帶做法：Problem Statement Canvas

向用戶詢問並幫他填寫：

```
[目標用戶] 在 [情境] 下，
面臨 [具體痛點]，
現有方案 [失敗在哪裡]，
我的方案 [差異化切入點]。
```

產出：
- 一句話 Problem Statement
- 三個待驗證的核心假設
- 市場規模粗估（地區 / 全球）

### G-Stack 加值（如偵測到）

如 `office-hours` 可用：
> 「偵測到您裝了 G-Stack。Phase 0 也可以用 `/office-hours` 跑 YC 風格 6 題逼問（驗證需求真實性、現狀方案、痛點具體化、最窄入口、觀察、未來契合度），通常能挖出更深層的問題。要試試嗎？」

如不可用 → 直接執行內建 Canvas 流程。

### 產出檔案

`reports/{專案代稱}-phase0-{YYYY-MM-DD}.md`

---

## Phase 1：商業調查（多輪迭代）

### 預設流程：至少跑 2 輪 `/auto-research`

本 skill **預設用 `/auto-research` 跑商業調查**（並行 spawn N 個 subagent，比序列省 1-2 小時）。
**最少 2 輪**，依 Idea 性質可加到 3-4 輪：

| 輪次 | 預設子題群 | 目的 |
|------|---------|------|
| **Round 1（必跑）** | 國際競品 + 本地競品 + 同型商模 + TAM/SAM/SOM + 核心技術可行性 | 抓住賽道輪廓 + 致命假設浮現 |
| **Round 2（必跑）** | 買家行為深度 + 冷啟動通路 + 法規/合規 + 鄰近賽道偵察 + 訂價心理學 | 補 Round 1 沒挖出的死角 |
| Round 3+（選配） | 開發中遇到新問題時觸發 | 補洞 |

> **為什麼最少 2 輪？** Round 1 通常會抓到「賽道值不值得做」的初步答案，但**死角**（買家真實行為、通路冷啟動、法規地雷、鄰近賽道平移路線）要 Round 2 才會浮現。
> 跳過 Round 2 進開發，等於用「初步直覺」做下去，6 個月後容易撞牆。

### 重要心法：研究不只做一次

除了預設 2 輪外，`/research` 在後續 phase 仍可隨時補打：

| 時機 | 觸發原因 |
|------|---------|
| 功能設計前 | 找最佳實踐參考 |
| 遇到技術/法律問題 | 確認可行性與風險 |
| 商業模式調整 | 驗證變現方向 |
| 開發中遇到設計卡點 | 找現成解法 |
| 上線前 | 確認合規與定價 |

### 執行步驟（每一輪）

1. 根據當前需求，確定 5-8 個最相關的研究主題
2. 並行 spawn N 個 subagent（用 `/auto-research`）或單獨 `/research [主題]`（如只想補一題）
3. 跨報告提煉「可借鑑的飛輪機制 / 設計模式 / 教訓」

### 競品分析表格輸出格式

| 競品 | 核心模式 | 飛輪 | 優點 | 弱點 | 對我們的啟示 |
|------|---------|------|------|------|------------|

### 飛輪提煉格式

```
飛輪名稱：[名稱]
來源：[借鑑自哪個競品]
原理：[A → B → C → A 循環]
我的版本：[如何移植到我的場景]
啟動條件：[要達到什麼規模 / 狀態，飛輪才會轉起來]
```

### 產出檔案

`reports/{主題}-research-{YYYY-MM-DD}.md`（每輪一份）
如有多個產品線，加前綴：`{產品代稱}-{主題}-research-{YYYY-MM-DD}.md`

---

## Phase 2：假設提煉

引導用戶完成：

1. **差異化三角**（從上方研究萃取）：
   ```
   [維度 1：你比競品更「可信/可靠」的地方]
     ×
   [維度 2：你比競品更「有用/有效」的地方]
     ×
   [維度 3：你比競品更「好用/低摩擦」的地方]
   ```

2. **核心假設**（至少 3 條）：
   ```
   假設 H1：[用戶族群] 願意因為 [差異化因素]，
            從 [現有方案] 轉用我們的方案，
            前提是 [最小可行的驗證機制存在]。
   ```

3. **致命假設標記**：
   - 哪一條如果錯了，整個 Idea 就不成立 → 標 ⭐
   - 致命假設要在 Phase 4 優先驗證

### 產出檔案

可併入 Phase 1 最後一份報告的「啟示」章節，或獨立存 `reports/{專案代稱}-hypothesis-{YYYY-MM-DD}.md`。

---

## Phase 3：商業模式設計

### 從成功案例借鑑飛輪（不要從零發明）

| 飛輪類型 | 代表案例 | 核心原理 | 適合的產品類型 |
|---------|---------|---------|--------------|
| UGC 信任飛輪 | 小紅書、Yelp、Reddit | 內容越多 → 信任越高 → 更多人加入 → 更多內容 | 評論、社群、知識平台 |
| Freemium 解鎖 | Canva、Notion、Medium | 免費體驗 → 在「最想要答案」的瞬間觸發付費 | 工具、內容類 |
| 連續行為獎勵 | Duolingo、健身 App | 每日習慣 → 連續達成獎勵 → 高留存 | 需要養成習慣的產品 |
| 供需雙邊飛輪 | Airbnb、Uber、Etsy | 供給增加 → 需求提升 → 供給更多 | 市集、媒合平台 |
| 病毒分享飛輪 | Dropbox、Loom、Calendly | 使用產品的行為本身帶來新用戶 | 協作工具、展示型產品 |
| 數據網絡效應 | Waze、SimilarWeb | 用戶越多 → 數據越準 → 產品越好 → 更多用戶 | 資料密集型 |

### 變現模式選型

| 模式 | 適合場景 | 代表案例 | 關鍵問題 |
|------|---------|---------|---------|
| 訂閱制 | 持續提供價值的工具/內容 | Notion、Spotify | 用戶願意每月付多少？ |
| 用量計費 | 成本與用量強相關 | OpenAI API、AWS | 單位成本是否透明？ |
| 交易抽成 | 媒合買賣雙方 | Airbnb、Etsy | 交易頻率夠高嗎？ |
| Freemium + 進階功能 | 個人先免費、團隊付費 | Slack、Figma | 免費版的邊界在哪裡？ |
| 解鎖牆（積分/付費）| 資訊密集型平台 | Medium、知識星球 | 哪個「關鍵資訊點」值得付費解鎖？ |
| 廣告 | 高流量內容平台 | Google、小紅書 | 流量要多大才值得？ |
| 數據 / API | 有獨特資料積累 | Trustpilot、Bloomberg | 誰願意為這份資料付費？ |

引導用戶回答以下問題：

```
收入模式：訂閱 / 用量 / 抽成 / 廣告 / 解鎖牆 / 混合？
免費 vs 付費邊界在哪裡？
什麼是「最想知道答案的那一刻」？（觸發付費的最佳時機）
用戶增長飛輪是什麼？（從上表選 1-2 個移植到你的場景）
如何防止濫用 / 刷量 / 套利？
```

### 隱私 Stance — 一條被低估的免費差異化武器

**原則**：涉及用戶資料的產品，「我們不存 X」「我們不上傳 Y」這類明確 stance，常常是 0→1 階段最便宜的差異化。

| 情境 | 隱私 stance 範本 |
|------|---------------|
| 產品讀用戶內容（信件 / 文件 / 對話）| 「我們不上傳信件內容到伺服器，AI 推論在裝置端 / 端到端加密」 |
| 產品需要位置/感測 | 「定位資料只用於 X 計算，不長期保存精確座標」 |
| 產品有 OAuth scope | 「我們申請最小 scope，僅讀不寫」 |
| 涉及金融 / 健康 / 個資資料 | 「資料只存 hash，不存原文；用戶可隨時撤銷授權」 |

把選擇出的 stance 寫進 BMC 的「價值主張」+「競爭壁壘」+「行銷文案」，三個位置一起出現才算數。

### 定價：先設假設，再用 micro-survey 驗

**反 pattern**：「我直接定 NT$X / 月就好」 → 多半會錯。

**正 pattern**：定價要當作一條「可被推翻的假設」處理。

```
1. 對標 3-5 個鄰近賽道的同 segment 競品（含本地 + 國際）
2. 設 3 個 A/B 區間（例如 100-149 / 150-199 / 200-299）
3. 寫進 Phase 4 micro-survey 的 1 道題（「你願意每月付多少？」）
4. 收 30-50 份回收後，看 80% 願付的最高價點
5. 視結果調整 → 進入 Phase 5
```

**典型迭代次數**：定價在整個 0→1 過程**至少會調 2-3 次**（受眾畫像精準化 / Survey 結果 / 競品變化）。
不要把第 1 版定價當成最終版。

### Business Model Canvas（BMC）9 宮格 — ELI5 填法 ⭐

**為什麼用 BMC**：把整個商業模式收斂到一頁，創辦人 / 夥伴 / 投資人 30 秒看完整體輪廓。
**為什麼用 ELI5**：每格用「跟 5 歲小孩說也聽得懂」的話寫，避免堆 jargon 把自己騙了。

#### 9 個格子的 ELI5 引導句（每格 1-3 句寫完）

| # | 格子 | 不要這樣寫（jargon） | ELI5 引導句 |
|---|------|------------------|-----------|
| 1 | **Customer Segments**（客戶區隔） | 「TAM 35-45 高淨值決策者」 | 「我們在幫『誰』？舉一個你身邊的具體人」 |
| 2 | **Value Proposition**（價值主張） | 「解決 X 痛點的 SaaS 平台」 | 「他們本來怎麼解決？我們幫他變得多輕鬆 / 多便宜 / 多安心？」 |
| 3 | **Channels**（通路） | 「Omni-channel acquisition funnel」 | 「我們怎麼讓他知道我們存在？他平常在哪裡看東西？」 |
| 4 | **Customer Relationships**（客戶關係） | 「Self-serve onboarding + community-led growth」 | 「他第一次用是什麼感覺？用一個月後我們怎麼讓他繼續來？」 |
| 5 | **Revenue Streams**（收入流） | 「Tiered SaaS subscription model」 | 「他願意為什麼掏錢？多少？多常掏？」 |
| 6 | **Key Resources**（關鍵資源） | 「Proprietary AI inference stack」 | 「沒有什麼東西我們就做不出來？（人 / 資料 / 技術 / 品牌）」 |
| 7 | **Key Activities**（關鍵活動） | 「Continuous deployment + ML training pipeline」 | 「我們每天要做什麼事，產品才會運作？」 |
| 8 | **Key Partnerships**（關鍵夥伴） | 「Strategic ecosystem alliances」 | 「我們需要誰幫忙才做得起來？（API 商 / 通路 / 背書）」 |
| 9 | **Cost Structure**（成本結構） | 「OPEX optimization through cloud-native」 | 「我們每月燒多少錢？最大宗花在哪？」 |

#### 紅線詞（BMC 內絕對不要寫）

- 「待 X 確認」「TBD」「持續優化」 — BMC 是定稿不是會議記錄
- 「全方位 / 一站式 / 創新型」 — 形容詞 = 沒回答問題
- 「leverage / synergy / disrupt」 — 全部換成中文具體動詞
- 中文夾英文 jargon（除非該詞中文沒有對應）

#### BMC 是 Phase 3 的最終產出之一

Phase 3 報告（`reports/{專案}-business-model-{date}.md`）**必含一節「BMC 9 宮格摘要」**，每格 1-3 句 ELI5 寫法。
這份 BMC 之後會：
- 在 Phase 4.5 Office Hours 拿來逼問
- 在 Phase 4.6 BMC drill 給 3-5 個夥伴看
- 在 PPT（用 `/eli5-pptx`）做成 9 宮格頁
- 每次 pivot → 出新版 v(n+1)，並標 delta（哪幾格換了）

#### 與其他 SKILL 的串接

| 場景 | 觸發 |
|------|------|
| BMC 9 宮格寫好要做投影片 | `/eli5-pptx` 會自動把 BMC 渲染成 9 宮格頁 |
| BMC 想跟夥伴 drill | Phase 4.6「BMC drill」流程 |
| BMC 哪格寫不出來 / 答不清楚 | 觸發新一輪 `/auto-research` 補該面向 |

### 產出檔案

`reports/{專案代稱}-business-model-{YYYY-MM-DD}.md`

### huashu-design 加值（如偵測到）

BMC 完成後，若 `HUASHU_AVAILABLE=true`，**自動**（不詢問）呼叫 huashu-design 產出：

`reports/{專案代稱}-ui-mockup-{YYYY-MM-DD}.html`

高仿真 HTML prototype，涵蓋 BMC 主流程的關鍵畫面。
**用途**：Phase 4 用戶訪談的「展示素材」—— 讓受訪者能看到、感受產品，
比純語言描述更能收到具體回饋。

---

## Phase 4：輕量驗證

> **動手寫程式碼之前，先用最便宜的方式確認假設是真的。**

| 驗證方式 | 成本 | 適合驗證什麼 |
|---------|------|------------|
| 問題訪談（5-10 人）| 免費 | 痛點是否真實存在、用戶理不理解你的解法 |
| Landing Page + 等候名單 | 0.5-1 天 | 有沒有人願意留 Email（意願強度）|
| Concierge MVP（人工後台）| 幾天 | 核心流程走不走得通，不需要任何程式碼 |
| 邀請制 Beta | 1-2 週 | 留存率與核心功能真實使用率 |

**進入開發的判斷標準**：
```
✅ 至少 5 位目標用戶確認「現有方案沒辦法解決我的問題」
✅ 核心流程用戶能理解，並願意走完
✅ 找到 1-2 個願意第一批試用並給真實回饋的「超級用戶」
✅ Phase 2 的「致命假設」沒被推翻
```

### 產出檔案

`reports/{專案代稱}-validation-{YYYY-MM-DD}.md`

---

## Phase 4.5：Office Hours 檢核（預設必跑）

**預設行為：** Phase 4 驗證菜單寫完後，**自動觸發 Office Hours 檢核**，用 YC 風格 6 個逼問題目把整個 Idea 從外部視角再戳一次。

### 兩種模式（預設 = 互動式）

| 模式 | 何時用 | 流程 |
|------|------|------|
| **互動式（預設）** ⭐ | 創辦人本人在場 | 把 6 題拋給創辦人 → 等回答 → 整理成報告 → 標出哪些回答洩漏 Idea 弱點 |
| **書面 self-administered** | 創辦人不在 / 補跑 | 用既有所有研究報告當素材自答 → 標註哪些題只有創辦人能答 |

### YC 6 題（不可改、不可省）

```
1. 需求真實性（Demand Reality）
   你的目標用戶在沒有你的產品時，正在做什麼來解決這個痛？
   ── 如果他們什麼都沒做，痛可能不夠真。

2. 現狀方案（Status Quo）
   現在這個痛點被解的最爛但能用的方法是什麼？為什麼你比它好？
   ── 如果說不出 3 個替代方案，你還沒看清賽道。

3. 痛點具體化（Desperate Specificity）
   誰是「最絕望」的那個用戶？他的場景能具體到 1 個人 1 件事嗎？
   ── 如果答「所有 35-45 歲」，太廣，你沒找到楔子。

4. 最窄入口（Narrowest Wedge）
   你能砍掉的最大功能是哪個？為什麼這個功能不能砍？
   ── 通常砍不掉的那個 = 真價值。

5. 觀察（Observation）
   過去 7 天你親眼看到 / 聽到幾個目標用戶的具體故事？
   ── 0 個 = 你在自己腦袋裡做產品，要先去訪談。

6. 未來契合（Future-fit）
   3 年後這個世界長什麼樣，這個產品在那個世界扮演什麼角色？
   ── 答不出來 = 可能是「現在好但 3 年後消失」的產品。
```

### 互動式跑法（預設）

1. 偵測 G-Stack `/office-hours` 是否可用
   - 可用 → 建議使用者用 `/office-hours`（互動體驗更完整）
   - 不可用 → 用本 skill 內建版（如下流程）
2. 把 6 題**一次列出**給用戶（不要一題一題問，太瑣碎）
3. 等用戶回答（用戶可以「我先答 1-3 題」分批答）
4. 整理回答 → 寫成報告 → 標註：
   - ✅ 強回答（Idea 站得住）
   - ⚠️ 弱回答（暴露問題）
   - ❌ 答不出來（致命警訊）
5. 給戰略修正建議（哪個假設要改、哪個 Phase 要回頭重做）

### 書面 self-administered（補跑或創辦人不在時）

1. 用 phase0 + Round 1 + Round 2 + competitor-scoring + business-model + validation 全部報告當素材
2. 對 6 題逐一自答（**不要瞎掰**：如果資料裡沒有，明確標註「此題需創辦人本人回答」）
3. 整理 4 區塊報告：
   - 各題答案（含資料來源 / 標註信心度）
   - 暴露的弱點清單
   - 必須由創辦人回答的題目
   - 戰略修正建議

### 產出檔案

`reports/{專案代稱}-office-hours-{YYYY-MM-DD}.md`

### 為什麼預設互動式？

- 互動式答的是「**創辦人腦中的真實答案**」，而不是「資料裡能拼湊出的答案」
- Office Hours 的核心價值是「逼出創辦人自己沒想清楚的部分」，不是再做一次資料整理
- 書面 self-administered 仍有價值（補跑 / 對外溝通），但**不該當預設**

### 與其他 Skills 的串接

| Office Hours 結果 | 下一步 |
|---------------|------|
| 多數題答得強 | 進 Phase 4.6 BMC drill 後再判斷 |
| 第 1、2、3 題答得弱（需求 / 現狀 / 具體性）| 回 Phase 0 重新對焦 |
| 第 4 題砍不掉任何功能 | 回 Phase 5 重做 MVP 邊界三問 |
| 第 5 題 = 0 個故事 | **強制做 Phase 4 訪談**，不准跳過 |
| 第 6 題答不出來 | 觸發新一輪 `/research` 看 3 年後產業趨勢 |

---

## Phase 4.6：BMC 迭代循環（pivot 觸發訊號 + 版本管理）

> **核心心法**：BMC 不是寫一次就完，是會被外部訊號**反覆推翻**的。預期會迭代 3-5 次才穩定。
> **不要等到開發到一半才發現受眾錯了** — 每進 Phase 5 前，主動跑一輪 BMC drill。

### 為什麼要這個 Phase？

實戰常見場景：
- Phase 4 驗證跑完進 Phase 5 開發，3 個月後發現受眾完全錯
- 跟夥伴 / 朋友 / 創辦人團隊聊一次，整個 BMC 假設崩塌
- 朋友是領域技術專家，講出真實機制後產品定義整個換
- 真實案例 vs 既有假設衝突（你以為 X 才會中招，實際 Y 受害更多）

→ 這些都應該**在進開發前**就被觸發，不是事後才發現。

### 三個 pivot 觸發訊號（出現任一個 → 必跑 Phase 4.6）

```
1. 「真實案例 vs 假設衝突」
   你的 Phase 0 假設「X 受眾受影響最大」
   但 Phase 1 研究 / Phase 4 訪談發現「Y 受眾受影響密度更高」
   → pivot 訊號

2. 「跟領域專家對話 30 分鐘後」
   專家把你模糊的核心機制講清楚
   你發現原本的產品定義太抽象（例如「AI 防詐」變成「連結 cross-check + 標頭揭露」）
   → pivot 訊號

3. 「夥伴 / 朋友圈持續質疑同一個假設」
   3 個不同朋友問同一個問題（「真的有人會付錢嗎？」「這個 X 不會被 Google 內建做掉嗎？」）
   → 該假設可能站不住，pivot 訊號
```

### 預設動作 1：BMC drill — 找 3-5 個夥伴 30 分鐘

**頻率**：Phase 4 驗證後、進 Phase 5 前；之後每 4-8 週重跑一次。

**做法**：
1. 把目前 BMC 一頁版（A4 印出或 PPT 展示）拿給 3-5 個信任的夥伴 / 朋友 / 領域專家
2. 給他們講 5-10 分鐘，**請他們用任何角度戳**（不限主題）
3. 全程錄音 / 速記
4. 整理「3 個最尖銳的質疑」+「2 個你自己沒想到的視角」
5. 寫進 `reports/{專案代稱}-bmc-drill-{YYYY-MM-DD}.md`

### 預設動作 2：版本管理 — 不刪舊 BMC，只標 delta

每次 BMC 改變，**寫成新版檔案**而非覆蓋：

```
reports/
├── {專案代稱}-business-model-{YYYY-MM-DD}.md           ← v1
├── {專案代稱}-business-model-v2-{YYYY-MM-DD}.md        ← v2 大 pivot
└── {專案代稱}-business-model-v3-{YYYY-MM-DD}.md        ← v3
```

新版檔案開頭必寫：

```markdown
## 0. v(n-1) → v(n) 三個 delta（給投資人 60 秒版）

| 維度 | 上一版 | 本版 |
|------|------|------|
| 受眾 | ... | ... |
| 定價 | ... | ... |
| 通路 | ... | ... |

## v(n-1) 報告處理（不刪檔，只標）

| 報告 | 處理 |
|------|------|
| {上一版檔名} | ❌ 作廢 / ⚠️ 部分引用 / ✅ 仍引用 |
```

### 預設動作 3：mini-research 補洞

如果 BMC drill 暴露**單一面向的數據缺口**（例如「定價對年輕人合理嗎」「在地年輕人主流通路 CAC」），不必跑完整 Round n。
**改用 `/auto-research mini` 模式**（1-2 個 agent，30-45 分鐘補完），詳見 `/auto-research` SKILL。

### 何時離開 Phase 4.6 進 Phase 5？

```
✅ BMC drill 跑完，沒有任何「致命質疑」未回答
✅ 受眾畫像對 3-5 個夥伴講都聽得懂、不質疑
✅ 定價有 micro-survey 數據支持（不是猜的）
✅ 致命假設沒被推翻（Phase 2 的 ⭐ H1）
```

如果 4 點都 ✅ → 進 Phase 5
如果有任何一點 ❌ → 回 Phase 0/1/3 對應位置修

### 產出檔案

```
reports/{專案代稱}-bmc-drill-{YYYY-MM-DD}.md         ← BMC drill 紀錄
reports/{專案代稱}-business-model-v(n)-{YYYY-MM-DD}.md ← 新版 BMC
```

---

## Phase 5：功能規劃

### MVP 邊界三問

對每個候選功能問：

1. **拿掉它，核心使用流程還走得通嗎？** → 走得通 → 留 Phase 2
2. **這是「必須有」還是「有更好」？** → 有更好 → 留 Phase 2
3. **用戶不用它，也能達成他的核心目標嗎？** → 能 → 留 Phase 2

### 自帶做法：呼叫 `/feature-plan`

```
/feature-plan [功能描述]
```

### G-Stack 加值（如偵測到）

如 `plan-ceo-review` 可用：
> 「Scope 確定後可用 `/plan-ceo-review` 送審，從創辦人視角檢查是否值得做。」

如 `plan-eng-review` 可用：
> 「架構決策可用 `/plan-eng-review` 送審，獨立審視可行性與風險。」

### huashu-design 加值（如偵測到）

若 `HUASHU_AVAILABLE=true`，功能 scope 確定後，在任務拆解**之前**先用 huashu-design 產出 UI draft：

> 「偵測到 huashu-design。先把這個功能的 UI 畫出來（高仿真 HTML），讓前後端對齊 UX 預期，可減少實作過程中的返工。」

產出放於 `reports/{功能名稱}-ui-draft-{YYYY-MM-DD}.html`，由用戶確認後再進技術任務拆解。

### 技術任務拆解格式

```
## 功能：[功能名稱]

### 前端
- [ ] [任務]（預估：S=半天/M=1-2天/L=3天以上）

### 後端
- [ ] [任務]（預估：S/M/L）

### 資料庫
- [ ] Migration：[描述]

### 影響範圍
- 涉及核心商業邏輯：是/否
- 涉及金流 / 收費 / 帳務：是/否
- 涉及第三方整合：是/否
- 涉及 DB Schema 變更：是/否
- SEO 影響：是/否
- 隱私 / 合規影響：是/否
```

### 更新 plan.md

把確認後的任務清單加到 `plan.md`（如存在）或建立一份。

---

## Phase 6：技術架構選型

根據用戶的需求，引導他做選型決策：

| 需求面向 | 選型問題 | 建議 |
|---------|---------|------|
| SEO 是核心流量來源 | 內容頁需要被搜尋到？ | 是 → SSG/ISR；否 → CRA/Vite 也夠 |
| 高頻交易/金流 | 並發 >1000 req/s？ | 是 → Go / Rust；否 → Node.js / Python |
| 即時同步 | 多用戶同時編輯/聊天？ | WebSocket / SSE / CRDT |
| 團隊規模 | 1-2 人 vs 3+ 人？ | 1-2 人選最熟的；3+ 選型別安全的 |
| 部署預算 | 初期預算？ | 低 → Vercel + Fly.io + Supabase |
| 平台目標 | Web / Extension / Mobile / CLI？ | 影響 framework 與打包流程 |

**選型決策記錄模板**（決策的「Why」比「What」更重要）：

```markdown
## 技術選型決策記錄

| 層次 | 選擇 | 選擇原因 | 放棄的替代方案 |
|------|------|---------|--------------|
| Frontend | [技術] | [原因] | [替代方案及放棄原因] |
| Backend | [技術] | [原因] | [替代方案及放棄原因] |
| Database | [技術] | [原因] | [替代方案及放棄原因] |
| Hosting | [平台] | [原因] | [替代方案及放棄原因] |
```

---

## Phase 7：自動開發循環

### 自帶循環

每個功能按以下循環執行：

```
1. 確認任務清單（來自 Phase 5 的 plan.md）
2. 實作（前端 + 後端 + DB Migration）
3. /qa-review → BDD 測試（User Story → Given-When-Then）
4. 修正 QA 發現的問題
5. git commit（語意化訊息：feat / fix / docs / refactor）
6. /sdd-update（更新 sdd.md）
7. 開發中遇到設計卡點 → /research → 整合洞察 → 繼續
8. 下一個功能（回到 1）
```

### G-Stack 加值（如偵測到）

| G-Stack Skill | 用在哪 |
|--------------|------|
| `/qa` | 對 live site 跑端對端測試並自動修 bug（比自帶 `/qa-review` 更主動）|
| `/qa-only` | 只報告不自動修，適合上線前驗收 |
| `/design-shotgun` | UI 變體探索（多版本 mock 並排比較）|
| `/design-review` | 對 live site 視覺一致性審查 |
| `/ship` | 完整 PR 流程（測試 + version bump + commit + push）|
| `/code-review` | PR 前獨立程式碼審查 |
| huashu-design | 任何新功能上線前產出高仿真 HTML prototype，讓前後端 + PO 對齊 UX 預期（若 `HUASHU_AVAILABLE=true` 自動觸發）|

### QA 測試格式

```gherkin
Feature: [功能名稱]

  Scenario: [Happy Path]
    Given [前置條件]
    When [用戶行為]
    Then [預期結果]

  Scenario: [Edge Case]
    Given [邊界前置條件]
    When [用戶行為]
    Then [系統如何處理]

  Scenario: [Error Case]
    Given [前置條件]
    When [觸發錯誤的動作]
    Then [應該顯示什麼錯誤提示]
```

### 常見整合陷阱（每個功能完成後自查）

- [ ] 生產頁面有沒有遺留 mock 資料？
- [ ] 前端 API 呼叫的回傳格式與後端一致？（有無 wrapper key）
- [ ] 涉及金流 / 帳務的操作有沒有寫流水帳記錄？
- [ ] 非同步 callback 有沒有加 null guard？
- [ ] 條件分支有沒有涵蓋全部可能值（不要只用 if/else 兜底）？
- [ ] 操作完成後相關 UI 狀態有沒有同步更新？
- [ ] 副作用（通知、快取清除、數據變更）有沒有觸發？

---

## Phase 8：文件維護

每完成一個功能，提醒更新：

```
- [ ] API 端點清單（sdd.md 或等效文件）
- [ ] DB Schema（有 Migration 的話）
- [ ] 核心商業規則文件（如有變動）
- [ ] CLAUDE.md（新的開發規則或踩坑記錄）
```

### 自帶做法：`/sdd-update`

讀取 diff、對照 sdd.md、更新對應章節。

### G-Stack 加值（如偵測到）

如 `document-release` 可用：
> 「Release 前可用 `/document-release` 同步 README / CHANGELOG / ARCHITECTURE 等所有文件。」

---

## 輸出規範

1. 每個 Phase 完成後，產出一份 Markdown 文件存到 `reports/`
2. 所有決策記錄「Why」，不只記錄「What」
3. 踩過的坑加到 `CLAUDE.md`（或等效的整合規則文件）

---

## 快速健檢：`/idea-to-mvp check`

當用戶輸入 `check`，讀取現有文件（plan.md、sdd.md、CLAUDE.md、reports/）並輸出：

```
## 目前狀態

當前 Phase：[X]
完成項目：[列表]
待完成：[列表]
G-Stack 偵測結果：[已裝的相關 skill 列表 / 未偵測到]

## 建議下一步

[具體的下一個行動，不超過 3 點]

## 風險提示

[如果有任何假設尚未驗證、技術債、或文件落後，在這裡標出]
```

---

## 適用範圍

本 skill 不限賽道，已驗證可用於：
- 評論 / 社群 / UGC 平台
- SaaS 工具（B2B / B2C）
- Chrome Extension / 瀏覽器外掛
- Mobile App（iOS / Android）
- API / Developer Tool
- AI Agent 應用

如果是學術論文寫作，請改用 `/academic-paper-writing` skill。
