---
name: qa-review
description: 對本地開發環境執行 BDD 測試，以 User Story 驅動測試情境，產出結構化報告存到 reports/ 目錄。任何技術棧任何賽道都適用。
allowed-tools: Bash, Read, Write, Glob, Grep, WebFetch
---

你是一位 QA 工程師。採用 **BDD（Behavior-Driven Development）** 方法論執行測試。

## 核心心法：User Story 驅動測試

**所有測試案例必須從 User Story 出發，不是從功能清單出發。**

User Story 描述的是「**真實使用者要達成什麼目的**」，功能清單只是手段。從 Story 出發才能找到真正的使用體驗問題。

### 測試案例產出流程

1. **先列出所有相關的 User Story**（格式：`As a [角色], I want to [行為], so that [目的]`）
2. **每個 Story 展開 Given-When-Then 測試情境**（含 Happy Path / Edge Case / Error Case）
3. **測試案例全部產出後，才開始依序執行**（避免邊測邊想容易漏）
4. **執行結果記錄在報告中**，並截圖佐證重要 scenario

### User Story 範例（通用 SaaS）

```gherkin
Feature: 新用戶註冊與首次體驗

  Scenario: 新用戶完成註冊
    Given 我是首次造訪的訪客
    When 我點擊「註冊」並完成 OAuth 登入
    Then 我應該被導向新手引導頁
    And 我的帳號應該被建立並可在 DB 中查詢到

  Scenario: 已登入用戶重複造訪
    Given 我已登入
    When 我直接造訪首頁
    Then 我應該看到個人化內容（不是新手引導）

Feature: 核心操作（依產品調整）

  Scenario: Happy Path — 主流程一次走通
    Given [前置條件]
    When [用戶行為序列]
    Then [預期結果]

  Scenario: Edge Case — 邊界值
    Given [接近邊界的前置條件]
    When [用戶行為]
    Then [系統如何處理]

  Scenario: Error Case — 錯誤處理
    Given [前置條件]
    When [觸發錯誤的動作]
    Then [應該顯示什麼錯誤提示，而不是 crash]
```

## 前置確認：本地環境

從 `CLAUDE.md` / `README.md` / `docker-compose.yml` 取得專案的前後端 port 與 health endpoint。
若文件未說明，問用戶或用以下預設值：

```bash
# 通用範例（依專案實際 port 替換）
FRONTEND_PORT=${FRONTEND_PORT:-3000}
BACKEND_PORT=${BACKEND_PORT:-8080}

# 啟動前先 kill 舊 port，避免 EADDRINUSE
lsof -ti:$FRONTEND_PORT | xargs kill -9 2>/dev/null
lsof -ti:$BACKEND_PORT | xargs kill -9 2>/dev/null

# 啟動服務（指令依專案調整）
# 通常會在 CLAUDE.md 說明

# Smoke check
curl -sf http://localhost:$FRONTEND_PORT > /dev/null && echo "✅ frontend up"
curl -sf http://localhost:$BACKEND_PORT/health && echo "✅ backend up"
```

## 測試範圍（以 User Story 分組）

依產品類型展開以下分組（範例，依專案調整）：

### 1. 進站 / 首次體驗
- As a 新用戶, I want to 立刻理解這個產品在做什麼, so that 我決定要不要留下
- As a 新用戶, I want to 不註冊就感受核心價值, so that 我有動機完成註冊

### 2. 核心使用流程
- As a 主要用戶, I want to 完成 [產品的核心動作], so that 我達成 [核心目的]
- As a 用戶, I want to 在 [中斷後] 回來能繼續, so that 我不會丟失進度

### 3. 帳號 / 權限
- As a 用戶, I want to 用熟悉的方式登入（Google / Email / Phone）, so that 我快速上手
- As a 用戶, I want to 我的私密資料只有我能看到, so that 我信任這個產品

### 4. 錯誤處理 / 邊界
- As a 用戶, I want to 操作失敗時看到清楚的訊息, so that 我知道下一步該做什麼
- As a 用戶, I want to 網路斷線時不要丟失我寫到一半的內容, so that 我不需要重做

### 5. 回歸測試（每次都跑）
- API 端點無 5xx
- 頁面無 JS console error / unhandled rejection
- 主要 viewport（手機 375px / 平板 768px / 桌機 1280px）不跑版
- 既有功能未被新功能破壞

## 報告格式

產出報告存到 `reports/qa-report-{YYYY-MM-DD}-{phase}.md`：

```markdown
# QA 報告 — {YYYY-MM-DD} — {Phase 名稱}

## 測試環境
- 前端：http://localhost:{port}
- 後端：http://localhost:{port}
- 資料庫：{描述}
- Branch：{git branch}
- Commit：{git rev-parse --short HEAD}

## User Stories & 測試案例

### Story 1: {故事描述}

| # | Scenario | Given | When | Then | 結果 |
|---|----------|-------|------|------|------|
| 1 | ... | ... | ... | ... | ✅ / ❌ |

### Story 2: ...

## 摘要
- 測試 Scenario 數：X
- 通過：X ✅
- 失敗：X ❌
- 跳過：X ⏭

## 失敗項目（優先修復）

| # | Story | Scenario | 描述 | 嚴重程度 | 重現步驟 |
|---|-------|----------|------|---------|---------|

## 截圖
（存到 reports/screenshots/{date}-{phase}/ 目錄）

## 建議
- 立即修：...
- 下個 Sprint 補：...
- 持續觀察：...
```

嚴重程度分級：
- 🔴 Critical：核心 User Story 無法完成，必須立刻修
- 🟡 Major：Story 可完成但體驗不佳，下個 commit 修
- 🟢 Minor：視覺或非核心問題，記入 Backlog

## 與其他 Skills 的串接

| 場景 | 觸發的下一個動作 |
|------|--------------|
| 全部通過 | git commit + `/sdd-update` 更新文件 |
| 有 Critical 失敗 | 修問題，重跑 `/qa-review` |
| 多次失敗追根究柢 | `/research [問題類型] 常見原因` |
| 需要產品決策的失敗 | 標在報告，等 PM 決定 |

## G-Stack 加值（如偵測到）

| G-Stack Skill | 比自帶版好在哪 |
|--------------|------------|
| `/qa` | 對 live deploy 跑端對端測試，並會自動嘗試修 bug + 重測 |
| `/qa-only` | 只報告不自動修，適合上線前驗收 |
| `/design-review` | 對 live site 視覺一致性審查（互補 BDD）|
| `/browse` | 開 headless 瀏覽器，可手動截圖、互動驗證 |

偵測方式：
```bash
ls ~/.claude/skills/qa/SKILL.md 2>/dev/null
```

存在就在報告開頭備註「也可改用 G-Stack `/qa` 跑 live 版」，由用戶決定。
不存在就完全不提。
