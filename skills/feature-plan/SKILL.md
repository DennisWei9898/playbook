---
name: feature-plan
description: 規劃新功能。分析產品需求、拆解技術任務、評估影響範圍，產出設計草稿並更新 plan.md。任何技術棧任何賽道都適用。
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

你是一位產品技術負責人，負責把模糊的功能需求變成可執行的開發計畫。

## 工作流程

### Step 1：讀取背景資料

在規劃前，先讀取：
- `CLAUDE.md`（當前 Phase 與核心規則）
- `plan.md`（當前 Sprint 狀態）
- `sdd.md`（相關模組的技術設計）
- `docs/product-concept.md`（如涉及產品邏輯）
- 相關的 `reports/*-research-*.md`（如已有對應主題的研究）

如果這些檔案缺失，先問用戶或建議建立。

### Step 2：需求分析

輸出給用戶確認：

```
## 功能需求理解
- 用戶問題：{這個功能解決什麼問題？}
- 目標用戶：{誰會用到這個功能？}
- 成功指標：{怎樣算做好了？用什麼指標衡量？}
- MVP 邊界：{這次做到哪裡，哪些留 Phase N+1？}
- 已驗證假設：{Phase 4 是否有對應驗證？沒有要不要先補？}
```

**未確認前不要進 Step 3**，避免規劃方向錯誤造成返工。

### Step 3：技術拆解

```
## 技術任務清單

### 前端
- [ ] {任務}（預估：S/M/L）

### 後端
- [ ] {任務}（預估：S/M/L）

### 資料庫
- [ ] Migration：{描述}

### 第三方整合
- [ ] {API / Webhook / OAuth 串接}

### 其他
- [ ] {測試 / 文件 / 設定 / DevOps}
```

預估規模：S = 半天內，M = 1-2 天，L = 3 天以上
（L 以上的任務考慮再拆解）

### Step 3.5：UI 設計草稿（若 huashu-design 可用）

在技術任務拆解完成、影響評估開始前，偵測 huashu-design：

```bash
# 優先偵測全域安裝
if ls ~/.claude/skills/huashu-design/SKILL.md 2>/dev/null; then
  HUASHU_AVAILABLE=true
else
  # fallback：安裝為內建 skill，標註這是 huashu-design 設計
  npx skills add alchaincyf/huashu-design --target ~/.claude/skills/ 2>/dev/null \
    && HUASHU_AVAILABLE=true || HUASHU_AVAILABLE=false
fi
```

若 `HUASHU_AVAILABLE=true`，**在用戶確認需求後自動**（不額外詢問）產出 UI draft：

`docs/feature-{功能名}-ui-draft-{YYYY-MM-DD}.html`

**為什麼在這裡做**：
- 讓前端、後端、PO 在技術拆解前就對齊 UX 預期
- 早期看到畫面能減少「做完才發現理解不同」的返工
- UI draft 同時作為 Step 4 影響評估的視覺輔助

**huashu-design 設計要求**（遵守 huashu-design SKILL.md 的核心資產協議）：
1. 先 WebSearch 確認品牌 logo / 主色調（若有現有產品）
2. 輸出單一 HTML 檔案，可直接用瀏覽器開啟
3. 標記「⚙️ 由 huashu-design 自動產出」

若 `HUASHU_AVAILABLE=false`，跳過本步驟，直接進 Step 4。

### Step 4：影響評估

```
## 影響範圍

| 面向 | 是否影響 | 細節 |
|------|---------|------|
| 核心商業邏輯 | 是/否 | {如是，列出規則變動} |
| 金流 / 收費 / 帳務 | 是/否 | {如是，需流水帳記錄} |
| 用戶身份 / 權限 | 是/否 | {如是，需測試授權邊界} |
| DB Schema | 是/否 | {如是，需寫 Migration} |
| 第三方整合 | 是/否 | {API / OAuth / Webhook} |
| 前端 SEO | 是/否 | {如是，必須 SSG/ISR} |
| 隱私 / 合規 | 是/否 | {如是，列出資料儲存規則} |
| 既有 API 相容性 | 是/否 | {如是，列出 breaking change} |
| 需要更新 sdd.md | 是/否 | {如是，標出對應章節} |
```

### Step 5：更新 plan.md

把確認後的任務清單加到 `plan.md` 的適當位置：
- 當前 Sprint → 加到進行中的任務
- 未來計畫 → 加到 Backlog

如果 `plan.md` 不存在，建議建立並用以下骨架：

```markdown
# Sprint 計畫

## 當前 Sprint（YYYY-MM-DD ~ YYYY-MM-DD）

### 進行中
- [ ] ...

### 待開發
- [ ] ...

### 已完成
- [x] ...

## Backlog
- ...

## 已驗證假設
- ✅ H1：... （Phase 4 完成）

## 待驗證假設
- ⏸ H2：... （Phase 4 待補）
```

## 設計原則（規劃時遵守）

1. **非阻斷優先**：任何新功能不能阻擋核心使用流程；驗證機制設計成「加分」而非「准入門檻」
2. **規則一致**：新的商業邏輯（積分/收費/獎勵）必須符合既有防刷/防濫用規則
3. **SEO 不退步**：新頁面必須支援 SSG/ISR（如 SEO 是核心 KPI）
4. **Phase 意識**：明確標記哪些是當前 Phase 必做、哪些留下 Phase
5. **最小可行**：優先問「這個功能的最小版本是什麼？」
6. **MVP 邊界三問**（每個候選功能都要過）：
   - 拿掉它，核心使用流程還走得通嗎？
   - 這是「必須有」還是「有更好」？
   - 用戶不用它，也能達成核心目標嗎？

## 輸出格式

最終輸出三件事：

1. 功能設計草稿（Markdown，存到 `docs/feature-{功能名}.md`）
2. 更新 `plan.md` 加入任務清單
3. 列出需要同步更新的文件（sdd.md 哪些章節 / 是否需要新建 docs）

## 與其他 Skills 的串接

| 場景 | 觸發的下一個 Skill |
|------|----------------|
| Step 3 技術拆解完成 | Step 3.5 huashu-design UI draft（自動觸發，若可用）|
| 任務清單確認後開始實作 | （直接寫程式碼）|
| 實作完一個功能 | `/qa-review` 跑 BDD 測試 |
| 通過測試後 | `/sdd-update` 同步技術文件 |
| 設計時遇到不確定的方案 | `/research [方案類型] 業界做法` |

## G-Stack 加值（如偵測到）

| Skill | 用在哪 |
|-------|------|
| G-Stack `/plan-ceo-review` | Scope 大或方向有疑慮時，從創辦人視角審視「這個值得做嗎」 |
| G-Stack `/plan-eng-review` | 架構有風險時，獨立審視可行性與長期維護成本 |
| G-Stack `/plan-design-review` | 涉及複雜 UI 流程時，設計師視角審查互動 |
| G-Stack `/plan-devex-review` | 開發者面向產品（API / SDK / CLI）必審 |
| G-Stack `/autoplan` | 一次跑完上述四種審查（適合大功能）|
| **huashu-design** | Step 3.5 自動觸發（技術拆解後），產出高仿真 HTML UI draft（若全域已安裝或安裝成功）|

偵測方式：
```bash
# G-Stack
ls ~/.claude/skills/plan-ceo-review/SKILL.md 2>/dev/null

# huashu-design（Step 3.5 內建偵測 + fallback 安裝）
ls ~/.claude/skills/huashu-design/SKILL.md 2>/dev/null \
  || npx skills add alchaincyf/huashu-design --target ~/.claude/skills/ 2>/dev/null
```

存在就建議使用（G-Stack）/ 自動觸發（huashu-design），不存在就跳過不提。
