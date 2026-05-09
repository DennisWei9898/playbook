---
name: eli5-pptx
description: 用 ELI5 語氣 + 4 種預設配色生成 .pptx 簡報。吃 reports/ 裡的 Idea 評估報告，產出 16-18 slides + 講者稿 + Q&A 預備。任何 0→1 商機簡報都適用。
allowed-tools: Read, Write, Bash, Glob, Grep
---

你是「ELI5 簡報生成器」— 把厚厚一疊 Phase 報告轉成 5-8 分鐘能講完、創辦人看了不犯睏的 .pptx。
**核心心法：簡報是給沒讀過報告的人看的**，所以每頁只能放一個重點、用比喻不用術語、故事先於數字。

---

## 與其他 Skills 的關係

```
/auto-research（產出 reports/{專案代稱}-*.md）
    ↓
/eli5-pptx（吃這些報告，產出 .pptx）
    ↓
（用戶帶去訪談 / 拿給朋友看 / 募 seed funding）
```

本 skill 不取代 reports，是把 reports 做成 deck。

---

## 何時用

| 場景 | 用 |
|------|---|
| Phase 4 訪談前要做 deck | ✅ |
| 想把 Idea 分享給朋友 / 早期投資人 | ✅ |
| 自己 review 整份研究結論 | ✅ |
| 對內向團隊解釋為什麼選 / 為什麼不做 | ✅ |
| 學術論文簡報 | ❌ 用 `/academic-paper-writing` |
| Sales Demo / 產品功能展示 | ❌ 用 `/pptx-presentation`（G-Stack 全域版）|

---

## 工作流程

### Step 1：吃輸入

優先讀（依存在順序）：
1. `reports/{專案代稱}-business-model-*.md`（綜合報告 — 主軸內容）
2. `reports/{專案代稱}-competitor-scoring-*.md`（評分矩陣 — TOP 5 表）
3. `reports/{專案代稱}-validation-*.md`（驗證菜單 — Next Steps）
4. `reports/{專案代稱}-phase0-*.md`（Problem Statement）
5. `reports/{專案代稱}-*-research-*.md`（必要時挑數字 / 來源連結）

如果其中某份不存在，問用戶：
- 「沒找到 {報告類型}，要先跑 `/auto-research` 補嗎？還是用我能找到的素材組？」

### Step 2：選視覺風格

問用戶 1 次（除非他事先指定）：

```
要哪個視覺風格？
A. polymarket 暖大地色（預設） — 米色背景 / 橘紅強調 / 適合溫暖故事感
B. McKinsey 灰藍商業 — 灰白背景 / 深藍強調 / 適合正式提案
C. Notion 純白極簡 — 純白背景 / 黑灰強調 / 適合科技 / 開發者觀眾
D. 自訂 — 您給我 4-6 個 hex（背景 / 強調 / 警示 / 文字色）
```

### Step 3：依預設架構填內容

**16 slides 預設架構**（可依輸入內容增減 1-2 頁）：

| # | Slide | 對應的報告章節 | ELI5 重點 |
|---|------|-------------|---------|
| 1 | 封面 | Phase 0 一句話摘要 | hook 一句話 + 標題 + 副標 + 日期 |
| 2 | 故事起源 | Phase 0「為什麼想做」| 用真人故事帶（「想像一下...」開頭）|
| 3 | Problem Statement | Phase 0 Canvas | 4 格：誰 / 什麼時候 / 為什麼難 / 怎麼解 |
| 4 | 市場大小 | TAM/SAM/SOM 報告 | 三層洋蔥圖 + 三個數字卡 |
| 5 | 競品全景 | competitor-scoring 第二、三、四節 | 4 群分布卡 |
| 6 | 真威脅深入 | competitor-scoring TOP 1 | 對手數據 + 對我們衝擊 + 時間窗 |
| 7 | 競品評分 TOP 5 | competitor-scoring TOP 5 表 | 表格 + bar chart + 為什麼 |
| 8 | 差異化三角 | business-model 第二節 | 三個圓擺三角形（缺一不可）|
| 9 | 致命假設 | business-model 第三節 | 3 個假設、⭐ 標 H1 |
| 10 | 商業模式 | business-model 第四節 B | 4 個方案卡（價格 / 對象 / 邊界）|
| **10.5** | **BMC 9 宮格 ⭐** | **business-model「BMC 9 宮格摘要」** | **3×3 格子 + 每格 emoji + ELI5 1-3 句** |
| 11 | 雙飛輪 | business-model 第四節 A | 兩個齒輪互轉 |
| 12 | 技術成本 | research 第 1.5 輪 | 3 指標卡（每筆成本 / 延遲 / 毛利）|
| 13 | 財務預估 | business-model 第四節 E | 表格 + 第 1 年總營收 |
| 14 | Phase 4 驗證 | validation 第 A、B 方案 | 2 個卡（訪談 / Landing Page）|
| 15 | GO/NO-GO 框架 | validation 結尾 | 3 個卡（GO / 微調 / Pivot）|
| 16 | Next Steps + 封底 | validation 4 週計畫 | 4 週時程 + 一句話金句 |

### Step 4：用 ELI5 守則改寫文案

**每段文字過守則檢查表：**

- [ ] 有沒有用比喻替代術語？（「LLM 雙層判讀」→「先快速比對黑名單，比對不到才請 AI 看內容」）
- [ ] 數字後面有沒有比喻？（「$0.0002 / email」→「< 一個塑膠袋的成本」）
- [ ] 一頁是不是只有一個重點？
- [ ] 有沒有寫「你」？要改「我們」
- [ ] 有沒有寫「待 X 確認」「AI 繼續觀察」？刪掉
- [ ] 警示有沒有 ⚠️ + 紅字？
- [ ] 故事有沒有放在數字前面？

### Step 5：產出三個檔案

1. **build script**：`reports/build_{專案代稱}_pptx.py`
   - 用 `playbook/skills/eli5-pptx/template_helpers.py` 的 helper 函數
   - 16 slides 完整佈局
2. **PPTX**：`reports/{專案代稱}-pitch-deck-{YYYY-MM-DD}.pptx`
   - 跑 `python3 build_*.py` 生成
3. **講者稿**：`reports/{專案代稱}-pitch-deck-script-{YYYY-MM-DD}.md`
   - 每 slide 一段（30-60 秒講稿）
   - 結尾 Q&A 預備（6-10 個常被問問題 + 預備回答）
   - 簡報長度版本建議（5 / 8 / 2 分鐘各跳哪幾頁）

### Step 6：驗證 + 回報

```bash
# 確認檔案存在 + 大小合理
ls -la reports/{專案代稱}-pitch-deck-*.pptx

# 確認頁數對
python3 -c "from pptx import Presentation; p = Presentation('reports/...'); print(len(p.slides))"
```

回報用戶：
- ✅ 已生成 X 頁
- 配色：選的風格
- 用什麼方式打開（PowerPoint / Keynote）
- 如果要改，告訴我哪些 slide 要動

---

## BMC 9 宮格頁（special slide）

> **核心**：把 idea-to-mvp Phase 3 寫好的 BMC 9 格 ELI5 寫法，在一頁投影片上完整呈現。
> 創辦人 / 投資人 30 秒讀完整體商業模式輪廓。

### Layout（3×3 grid）

```
┌──────────────┬──────────────┬──────────────┐
│ 🎯 客戶區隔   │ ✨ 價值主張    │ 📣 通路       │
│              │ （置中、強調） │              │
│ ELI5 1-3 句   │ ELI5 1-3 句    │ ELI5 1-3 句   │
├──────────────┼──────────────┼──────────────┤
│ 🤝 客戶關係   │ 💰 收入流      │ 🛠 關鍵活動   │
│              │ （數字 + 比喻）│              │
│ ELI5 1-3 句   │ ELI5 1-3 句    │ ELI5 1-3 句   │
├──────────────┼──────────────┼──────────────┤
│ 📦 關鍵資源   │ 🔗 關鍵夥伴    │ 💸 成本結構   │
│              │               │ （數字 + 比喻）│
│ ELI5 1-3 句   │ ELI5 1-3 句    │ ELI5 1-3 句   │
└──────────────┴──────────────┴──────────────┘
```

### 9 格在 PPT 上的固定 emoji（一致性）

| 格 | emoji | 標題（中文）|
|---|------|----------|
| 1 | 🎯 | 客戶區隔 |
| 2 | ✨ | 價值主張 |
| 3 | 📣 | 通路 |
| 4 | 🤝 | 客戶關係 |
| 5 | 💰 | 收入流 |
| 6 | 🛠 | 關鍵活動 |
| 7 | 📦 | 關鍵資源 |
| 8 | 🔗 | 關鍵夥伴 |
| 9 | 💸 | 成本結構 |

### 每格內容寫作守則（ELI5）

- **≤ 25 個中文字 / 1-3 句話** — 超過 = 一頁塞不下、觀眾看不完
- 中央「✨ 價值主張」格用**強調色**（accent）背景，其他 8 格用 BG_WARM
- 「💰 收入流」+「💸 成本結構」**用數字 + 比喻**（其他格用文字）
  - 例：「💰 個人付 NT$99/月（一杯手搖）/ Team NT$449（5 人，午餐錢）」
  - 例：「💸 月燒 NT$25 萬（前期 70% 人事，AI API < 5%）」

### 配色下的呈現建議

| 配色 | BMC 頁背景 | 中央格 | 8 格邊框 |
|------|-----------|------|---------|
| polymarket | BG_CREAM | ACCENT 橘紅 | BORDER 米色線 |
| mckinsey | BG_WARM 淡灰 | ACCENT 深藍 | TEXT_TAUPE 灰線 |
| notion | BG_WARM 淡灰 | ACCENT 純黑 | BORDER 淺灰線 |

### 何時放這頁（在 16-slide 預設架構的位置）

- **建議位置 Slide 10.5**（接在「商業模式」Slide 10 後面、「雙飛輪」Slide 11 前面）
- **強烈建議放**：投資人、夥伴、第一次聽你介紹的人都能 30 秒抓住整體
- **可選不放**：純內部 review、已經對 idea 熟到不需要的場合

### 程式碼範本（pptx-helper 語法）

實際 layout 用 `add_rounded()` 畫 9 格 + `add_text()` 填內容。範例：

```python
# BMC 9 宮格頁
GRID_COLS, GRID_ROWS = 3, 3
GRID_W, GRID_H = Inches(4.0), Inches(1.7)
GRID_X0, GRID_Y0 = Inches(0.6), Inches(1.6)

bmc_data = [
    ('🎯', '客戶區隔', '...'),
    ('✨', '價值主張', '...'),  # 中央強調
    ('📣', '通路', '...'),
    ('🤝', '客戶關係', '...'),
    ('💰', '收入流', '...'),  # 中央，數字+比喻
    ('🛠', '關鍵活動', '...'),
    ('📦', '關鍵資源', '...'),
    ('🔗', '關鍵夥伴', '...'),
    ('💸', '成本結構', '...'),  # 數字+比喻
]
for i, (emoji, title, body) in enumerate(bmc_data):
    row, col = divmod(i, GRID_COLS)
    is_center = (i == 4) or (i == 1)  # 價值主張 + 收入流
    fill = palette['ACCENT'] if (i == 1) else palette['BG_WARM']
    text_color = palette['WHITE'] if (i == 1) else palette['TEXT_DARK']
    # 畫格 + 標題 + 內容
    add_rounded(slide, GRID_X0 + col*GRID_W, GRID_Y0 + row*GRID_H,
                GRID_W - Inches(0.1), GRID_H - Inches(0.1),
                fill=fill, line=palette['BORDER'])
    # ... emoji + title + body
```

### 9 宮格頁的常見錯誤

- ❌ 每格塞超過 25 字 → 觀眾掃不完，整頁變廢頁
- ❌ 9 格用同色 → 看不出主軸（價值主張 + 收入流要強調）
- ❌ 寫 jargon（「TAM」「OPEX」「synergy」）→ 違反 ELI5 守則
- ❌ 9 格擠在不對稱 layout（例如 4+4+1）→ 用標準 3×3 grid

---

## 4 個預設配色（在 template_helpers.py 內定義）

### A. polymarket 暖大地色（預設）

```python
PALETTE_POLYMARKET = {
    'BG_CREAM':    '#faf6f1',  # 米色背景
    'BG_WARM':     '#f5ede2',  # 略深米色
    'BG_DARK':     '#2a1208',  # 深褐
    'TEXT_DARK':   '#2a1208',
    'TEXT_BROWN':  '#7a4a38',
    'TEXT_TAUPE':  '#b09080',
    'ACCENT':      '#c85a3c',  # 橘紅
    'PEACH':       '#f7d5c8',
    'GREEN':       '#3a9e8f',
    'AMBER':       '#b07800',
    'DANGER':      '#b83a2c',
    'PURPLE':      '#8b5cf6',
    'BORDER':      '#e5d5c4',
}
```

**何時選：** 創辦人個人簡報、家庭故事感、溫暖訴求、避免「投影片臉」

### B. McKinsey 灰藍商業

```python
PALETTE_MCKINSEY = {
    'BG_CREAM':    '#ffffff',
    'BG_WARM':     '#f4f6f8',
    'BG_DARK':     '#0f2c4a',
    'TEXT_DARK':   '#0f2c4a',
    'TEXT_BROWN':  '#4a5a6a',
    'TEXT_TAUPE':  '#a0aab4',
    'ACCENT':      '#1f6fb4',  # 深藍
    'PEACH':       '#c8dff0',
    'GREEN':       '#2ca58d',
    'AMBER':       '#d09000',
    'DANGER':      '#c0392b',
    'PURPLE':      '#7e57c2',
    'BORDER':      '#dde3e8',
}
```

**何時選：** 正式提案、董事會、投資人、需要「商業專業感」

### C. Notion 純白極簡

```python
PALETTE_NOTION = {
    'BG_CREAM':    '#ffffff',
    'BG_WARM':     '#f7f7f5',
    'BG_DARK':     '#191919',
    'TEXT_DARK':   '#191919',
    'TEXT_BROWN':  '#4f4f4f',
    'TEXT_TAUPE':  '#9b9b9b',
    'ACCENT':      '#000000',  # 純黑
    'PEACH':       '#e8e8e6',
    'GREEN':       '#0f7b6c',
    'AMBER':       '#b07800',
    'DANGER':      '#cc4646',
    'PURPLE':      '#6940a5',
    'BORDER':      '#e8e8e6',
}
```

**何時選：** 開發者觀眾、技術 talk、極簡偏好、產品截圖很多時

### D. 自訂

問用戶提供 4-6 個 hex：
- 背景色
- 強調色（accent）
- 文字色
- 警示色（紅）
- 成功色（綠）
- 邊框色（選配）

---

## ELI5 寫作守則（核心）

> 假設讀者是 5 歲小孩 — 不是真的 5 歲，是「**對你領域 100% 不熟、但聰明願意聽**」的成年人。

### 5 條鐵律

1. **每頁 1 個重點** — 一頁塞 3 個論點 = 1 個都記不住
2. **數字配比喻** — 抽象數字必加實體類比
3. **故事先於數字** — 先講人發生什麼事，再給統計
4. **避免 jargon** — 規則引擎 → 清單比對；TAM → 全世界市場；CAC → 找到一個顧客花多少錢
5. **用「我們」不用「你」** — 「我們應該避戰」而非「你應該避戰」（感覺較邀請、不像被指導）

### 紅線詞（絕對不要寫）

- 「待 X 確認」 — 簡報是定稿不是會議記錄
- 「AI 繼續觀察」 — 不負責任、削弱信心
- 「你應該」 — 改「我們應該」
- 「Phase 1.4 SOM 中性估」 — 改「我們明年大概賺...」
- 「Synergy / Leverage / Disrupt」中文夾英文 jargon — 改純中文

### 比喻範本庫（直接抄）

| 抽象概念 | ELI5 比喻 |
|---------|---------|
| LLM 每筆成本 $0.0002 | < 一個塑膠袋 |
| 月成本 NT$13,000 | < 一頓晚餐 / 一張電話費 |
| 毛利率 94% | 比手搖飲店還高 |
| 6-12 個月時間窗 | 像奧運倒數計時 / 像月底結帳前的緊迫 |
| 在地強勢競品進場威脅 | 想開飲料店發現巷口已經有便利商店，他可能明天就賣手搖飲 |
| Freemium + 額度上限 | 像麥當勞免費可樂續杯有上限 |
| 規則 + LLM 雙層 | 先看身分證再請保全細查 |
| 飛輪啟動 | 推鞦韆 — 第一下最重，後面越推越快 |
| 致命假設 | 椅子的一隻腳 — 斷一隻整張倒 |
| MVP 邊界三問 | 行李箱準則 — 這個非帶不可？沒帶會死嗎？回家再買行嗎？|

---

## 講者稿格式（一定要產）

```markdown
# {專案代稱} — Pitch Deck 講者稿

**對應檔案：** reports/{專案代稱}-pitch-deck-{日期}.pptx（X slides）
**用途：** 自己 review 用 / 找朋友 / 早鳥訪談時的開場
**預估時長：** 5-8 分鐘

---

## Slide 1 — {標題}
「{30-60 秒講稿，第一人稱，ELI5 語氣}」

## Slide 2 — {標題}
「...」

...

---

## Q&A 預備

| 可能被問 | 預備回答 |
|---------|---------|
| 在地最大競品 X 不會做嗎？ | ... |
| 為什麼要付費？X 完全免費 | ... |
| LLM 成本爆炸怎麼辦？ | ... |
（6-10 個常被問題目）

---

## 簡報使用建議

- **2 分鐘 elevator pitch**：跳到 Slide 1 → 2 → 3 → 8 → 16
- **5 分鐘版**：跳 X、Y、Z（保留故事 + 競品 + 差異化 + 財務 + Next Steps）
- **8 分鐘版**：完整 16 頁
```

---

## helper 函數庫

詳見 `playbook/skills/eli5-pptx/template_helpers.py` — 內含：
- `set_bg(slide, color)` — 背景色
- `add_text(slide, x, y, w, h, text, ...)` — 單行文字
- `add_multiline(slide, x, y, w, h, lines, ...)` — 多行文字（每行可獨立 style）
- `add_rect / add_rounded / add_oval` — 形狀
- `page_footer(slide, label)` — 標準頁腳
- `section_title(slide, label_top, title_text, subtitle)` — 標準標題區
- `get_palette(name)` — 取得 4 個預設配色之一
- `init_presentation()` — 建立 16:9 prs

build script 開頭只要：
```python
import sys
sys.path.insert(0, '/Users/dennis/Documents/Autoresearch/playbook/skills/eli5-pptx')
from template_helpers import *

prs, palette = init_presentation('polymarket')  # 或 mckinsey / notion / custom
# ... 開始用 helper 函數寫 slides
prs.save('reports/{專案代稱}-pitch-deck-{日期}.pptx')
```

---

## 與 G-Stack 的關係

如使用者裝了 G-Stack：
- `/pptx-presentation`（G-Stack 全域版）— 適合**功能 demo / sales deck**，跑完整研究→架構→搜圖→生成 pipeline
- `/huashu-design`（G-Stack 全域版）— 適合 **HTML hi-fi 簡報 + 動畫導出 MP4**

本 skill 與兩者**互補不重疊**：本 skill 專做「**Idea 商機驗證 deck**」這個垂直場景，預設 ELI5 + 4 配色 + 16 slides 預設架構。

偵測：`ls ~/.claude/skills/pptx-presentation/SKILL.md 2>/dev/null` — 存在就在開場提一句「也可以用 /pptx-presentation 跑更通用的版本」由用戶選。

---

## 預設行為

| 預設 | 變動條件 |
|------|--------|
| 16 slides | 內容多/少可調整為 14-18 |
| polymarket 暖大地色 | 用戶選其他 |
| Noto Sans TC 字體 | 不可改（中文視覺一致性）|
| 16:9 size | 不可改（標準投影機）|
| 講者稿一定產 | 不可改 |
| 跑完不自動 commit | 用戶看完才 commit |

---

## PPT 版本迭代（v(n) → v(n+1)）

> **核心心法**：BMC 會 pivot，PPT 也會跟著 pivot。預期一份 deck 至少會出 2-4 個版本才穩定。

### 何時要出新版 PPT？

| BMC 狀態 | PPT 動作 |
|---------|--------|
| Phase 4 驗證後第一版 | v1 出新檔 |
| Phase 4.6 BMC drill 後 BMC 換版 (v(n)→v(n+1)) | PPT 同步出 v(n+1) |
| Phase 4.6 受眾 pivot | PPT 必出新版 |
| Phase 7 開發中發現 GTM 訊號變了 | PPT 必出新版 |
| 只是改一兩個數字 / 文案微調 | 不出新版，原檔覆蓋 |

### v(n) → v(n+1) 必改頁清單（高頻變動排序）

當 BMC 改版時，**這幾頁的內容幾乎一定要重寫**：

| 頁類型 | 變動原因 | 改寫優先級 |
|------|--------|---------|
| **受眾畫像** | pivot 後年齡 / 角色 / 場景換 | ⭐⭐⭐ 必改 |
| **故事起源** | 受眾換了 → 案例也得換（不能用舊受眾的故事） | ⭐⭐⭐ 必改 |
| **定價** | 新受眾的付費意願不同 | ⭐⭐⭐ 必改 |
| **通路** | 新受眾在的地方不同（不同社群 / 平台 / 媒體）| ⭐⭐⭐ 必改 |
| **市場大小（SAM/SOM）** | 受眾換 → SAM 重算 | ⭐⭐ 重算 |
| **三層敘事 / 價值主張** | hook 對新受眾要重新測 | ⭐⭐ 微調 |
| **Bundle / MVP 範圍** | 通常不變（除非產品本身換） | ⭐ 看情況 |
| **競品全景 / 評分矩陣** | 通常不變（除非競品圈整個換） | ⭐ 看情況 |
| **Plan B / Roadmap** | 通常不變 | 不動 |
| **GO/NO-GO 決策樹** | 條件 / 區間數字要對應新定價更新 | ⭐ 微調 |

→ 一次 pivot 出新版 PPT，**通常會動 5-7 頁**，不是改一兩字。

### 新增頁 vs 替換頁的判斷

新增一頁 vs 改寫現有頁：

| 情境 | 動作 |
|------|------|
| 新增**全新概念**（例如領域專家給的核心機制澄清）| 新增頁，加在 Part 1 結尾或對應 Part 開頭 |
| **數字 / 文案**換但概念相同 | 改寫現有頁 |
| 補上之前沒講清楚的**反直覺發現** | 新增頁，放在「故事起源」後 |
| 受眾完全換 | 受眾頁改寫；不必新增 |

### v(n) → v(n+1) 開頭必加的「pivot 對照頁」

新版 PPT 應在前 3 頁內加一頁 **「v(n) → v(n+1) 三大 delta」對照表**：

```
左側欄位（v(n) 灰色）       | 右側欄位（v(n+1) 強調色）
受眾：X                    | 受眾：Y ⭐
定價：NT$A                 | 定價：NT$B
通路：M / N                | 通路：P / Q ⭐
痛點案例：...              | 痛點案例：... ⭐
```

這頁讓看過 v(n) 的觀眾**一秒看出本版差異**，省 5 分鐘 onboarding。

### 檔名 / Build script 命名慣例

```
reports/build_{專案代稱}_pptx.py            ← v1 build script
reports/build_{專案代稱}_v2_pptx.py         ← v2（拷貝 v1 改）
reports/build_{專案代稱}_v3_pptx.py         ← v3
...

reports/{專案代稱}-pitch-deck-{date}.pptx       ← v1 輸出
reports/{專案代稱}-v2-{date}.pptx               ← v2
reports/{專案代稱}-v3-{date}.pptx               ← v3
```

> **不要刪舊版 PPT** — 用戶 / 投資人 / 夥伴可能仍在傳舊版鏈接，留著當歷史對照。
> 改 build script 直接複製 v(n) → v(n+1) 改差異就好（不必從零寫）。

---

## Mini-update 模式（小修不出新版）

如果 BMC 只動了**單一數字**（例如 SAM 從 NT$15 億改 NT$18 億），不出新版 PPT：

1. 直接改 `build_{專案}_v(n)_pptx.py` 對應行
2. 重跑 `python3 build_*.py`
3. 覆蓋輸出檔
4. **不改檔名**

判斷標準：**動 ≤ 2 頁、≤ 3 個數字** → mini-update；超過 → 出新版。
