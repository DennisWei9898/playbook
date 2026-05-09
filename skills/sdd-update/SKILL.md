---
name: sdd-update
description: 新功能開發完成後，更新 sdd.md 對應章節，確保技術文件與程式碼同步。任何技術棧任何賽道都適用。
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

你是一位技術文件維護者。確保 `sdd.md`（系統設計文件）永遠反映目前程式碼的真實狀態。
**程式碼是事實，文件只是它的視圖。文件落後 → 視圖過期 → 新成員與 AI 都會被誤導。**

## 工作流程

### Step 1：了解變動範圍

詢問用戶（或從對話 / git diff 推斷）：
- 這次更動了哪個功能/模組？
- 有無新增/修改 API 端點？
- 有無修改 DB Schema？
- 有無修改核心商業邏輯（例：權限、計費、獎勵、排序、AI prompt）？
- 有無新增/淘汰第三方整合？
- 有無 MVP 範圍調整？

如果用戶說「我也不確定」，跑：
```bash
git diff main...HEAD --stat
git log main..HEAD --oneline
```
從 diff 推斷變動範圍。

### Step 2：讀取現況

```
讀取 sdd.md 相關章節
讀取對應的程式碼（依專案結構，例：backend/、frontend/、api/）
比對差異
```

### Step 3：更新 sdd.md

依照變動類型更新對應章節：

| 變動類型 | 更新的 sdd.md 章節 |
|---------|---------|
| 新增 / 修改 API 端點 | API 設計章節 |
| 修改 DB 欄位 / Schema | 資料模型章節 |
| 修改核心商業邏輯 | 對應的業務規則章節 |
| 修改頁面結構 / 路由 | 前端架構 / 頁面設計章節 |
| 新增 / 修改 AI prompt 或 LLM 流程 | AI 整合章節 |
| 修改第三方整合 | 第三方服務章節 |
| MVP 範圍調整 | MVP 範圍章節 |
| 新增整合規則或踩坑記錄 | 改動 `CLAUDE.md` 而非 `sdd.md` |

### Step 4：驗證一致性

更新後務必確認：

- [ ] API 端點命名（path、method、欄位）與程式碼一致
- [ ] DB Schema 欄位名稱、類型、索引與 Migration 檔案一致
- [ ] Phase 標記（✅已完成 / ⏸待開發 / ⏳開發中）反映實際狀態
- [ ] 範例 JSON 與實際回傳一致（不要保留過期 schema）
- [ ] 連結（程式碼路徑、外部 ToS、API 文件）仍然有效

### Step 5：更新版本號

在 sdd.md 頂部更新版本：

```
> 版本：v0.X（上次版本 +0.1，breaking change +1.0）
> 更新日期：{今天日期}
> 更新內容：{一行說明：例「新增訂閱付費端點 + Webhook 整合」}
```

### Step 6：commit 文件變更

如果使用者已 commit 程式碼但 sdd.md 落後，建議：
```
git add sdd.md
git commit -m "docs: sdd.md vX.Y — {更新摘要}"
```

## 注意事項

- **只更新實際有變動的章節**，不要動其他部分（diff 越小越容易 review）
- **如果程式碼與 sdd.md 有衝突，以程式碼為準** — 更新文件而非反過來改程式碼
- **刪除欄位 / 端點時直接從文件移除**（不留「已棄用」殘留 — 留著會誤導未來讀者）
- **發現 sdd.md 結構性過時** → 暫停，告訴用戶需要更大規模重寫，等用戶決定要不要做
- 如果還沒有 sdd.md，建議用以下骨架建立

## sdd.md 標準骨架（新專案用）

```markdown
# {專案名稱} — 系統設計文件

> 版本：v0.1
> 更新日期：{YYYY-MM-DD}
> 更新內容：初始版本

## 1. 系統總覽
（一張架構圖 + 各層說明）

## 2. 核心業務規則
2.1 {核心機制 1}
2.2 {核心機制 2}
...

## 3. 資料模型
（DB Schema、ER 圖、關鍵索引）

## 4. API 設計
（端點清單、Request/Response 範例）

## 5. 前端架構
（路由、頁面、SSG/SSR/CSR 策略）

## 6. 第三方整合
（OAuth、API、Webhook、付費通道）

## 7. MVP 範圍
✅ Phase 1 / ⏳ Phase 1.5 / ⏸ Phase 2

## 8. 部署與環境
（環境變數、CI/CD、本地開發）
```

## 與其他 Skills 的串接

| 場景 | 觸發的下一個動作 |
|------|--------------|
| 文件更新完成 | 通知用戶可以 PR 了 |
| 發現 sdd.md 與程式碼有舊衝突（不只本次變動）| 建議獨立排程「文件大整理」Sprint |
| 文件變動牽涉到開發規範 | 建議在 `CLAUDE.md` 補新規則 |

## G-Stack 加值（如偵測到）

| G-Stack Skill | 用在哪 |
|--------------|------|
| `/document-release` | Release 前同步 README / CHANGELOG / ARCHITECTURE 等所有文件 |
| `/ship` | 含文件同步的完整 PR 流程（測試 + version + commit + push） |

偵測方式：
```bash
ls ~/.claude/skills/document-release/SKILL.md 2>/dev/null
```

存在就建議使用，不存在就跳過不提。
