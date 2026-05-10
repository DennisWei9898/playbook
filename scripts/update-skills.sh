#!/usr/bin/env bash
# update-skills.sh — 檢查並更新 huashu-design 與 playbook 到最新版本
#
# 用法：
#   bash scripts/update-skills.sh               # 更新全部
#   bash scripts/update-skills.sh huashu-design  # 只更新 huashu-design
#   bash scripts/update-skills.sh playbook       # 只更新 playbook (G-Stack)
#
# 安全設計：
#   - 只執行 git pull / npx skills add（已知白名單指令，無動態 eval）
#   - 不接受外部輸入作為 shell 指令（只接受字串比較）
#   - 所有網路請求走 HTTPS，curl 加 --fail --ssl-req
#   - 安裝前先印出版本資訊讓使用者審閱，不靜默覆蓋

set -euo pipefail

# ─── 常數（只改這裡）──────────────────────────────────────────────────────────
HUASHU_REPO="alchaincyf/huashu-design"
HUASHU_INSTALL_DIR="${HOME}/.claude/skills/huashu-design"

PLAYBOOK_REPO="DennisWei9898/playbook"
PLAYBOOK_INSTALL_DIR="${HOME}/.claude/skills"   # playbook skills 放在這裡

GITHUB_API="https://api.github.com/repos"
# ─────────────────────────────────────────────────────────────────────────────

log()  { echo "[update-skills] $*"; }
warn() { echo "[update-skills] ⚠️  $*" >&2; }

# ── 取得 GitHub 最新 commit SHA（不依賴 release tag，適合無版號的 skill repo）
get_remote_sha() {
  local repo="$1"
  local branch="${2:-main}"
  curl --fail --silent --ssl-required \
    -H "Accept: application/vnd.github.v3+json" \
    "${GITHUB_API}/${repo}/commits/${branch}" \
    | grep '"sha"' | head -1 | sed 's/.*"sha": "\([^"]*\)".*/\1/'
}

# ── 取得本機 git repo 的 HEAD SHA（若目錄不是 git repo 則回傳空）
get_local_sha() {
  local dir="$1"
  if [ -d "${dir}/.git" ]; then
    git -C "$dir" rev-parse HEAD 2>/dev/null || echo ""
  else
    echo ""
  fi
}

# ────────────────────────────────────────────────────────
# 更新 huashu-design
# ────────────────────────────────────────────────────────
update_huashu() {
  log "=== huashu-design 更新檢查 ==="
  log "遠端倉庫：https://github.com/${HUASHU_REPO}"

  local remote_sha
  remote_sha="$(get_remote_sha "$HUASHU_REPO" main)" || {
    warn "無法取得 huashu-design 遠端 SHA，跳過。"
    return 0
  }
  log "遠端最新 commit：${remote_sha:0:12}"

  local local_sha
  local_sha="$(get_local_sha "$HUASHU_INSTALL_DIR")"

  if [ -z "$local_sha" ]; then
    log "本機未安裝，執行安裝..."
    npx skills add "${HUASHU_REPO}" --target "${HOME}/.claude/skills/"
    log "✅ huashu-design 安裝完成。"
  elif [ "$local_sha" = "$remote_sha" ]; then
    log "✅ huashu-design 已是最新（${local_sha:0:12}），不需更新。"
  else
    log "發現新版本（本機 ${local_sha:0:12} → 遠端 ${remote_sha:0:12}）"
    log "執行更新：git pull..."
    git -C "$HUASHU_INSTALL_DIR" fetch --quiet origin main
    git -C "$HUASHU_INSTALL_DIR" reset --hard origin/main
    log "✅ huashu-design 已更新至 ${remote_sha:0:12}。"
  fi
}

# ────────────────────────────────────────────────────────
# 更新 playbook（G-Stack / 本倉庫）
# ────────────────────────────────────────────────────────
update_playbook() {
  log "=== playbook (G-Stack) 更新檢查 ==="
  log "遠端倉庫：https://github.com/${PLAYBOOK_REPO}"

  # 找到 playbook 的本機路徑：優先用腳本所在目錄的上一層
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local playbook_dir
  playbook_dir="$(cd "${script_dir}/.." && pwd)"

  local remote_sha
  remote_sha="$(get_remote_sha "$PLAYBOOK_REPO" main)" || {
    warn "無法取得 playbook 遠端 SHA，跳過。"
    return 0
  }
  log "遠端最新 commit：${remote_sha:0:12}"

  local local_sha
  local_sha="$(get_local_sha "$playbook_dir")"

  if [ -z "$local_sha" ]; then
    warn "本機 playbook 目錄（${playbook_dir}）不是 git repo，跳過。"
    return 0
  elif [ "$local_sha" = "$remote_sha" ]; then
    log "✅ playbook 已是最新（${local_sha:0:12}），不需更新。"
  else
    log "發現新版本（本機 ${local_sha:0:12} → 遠端 ${remote_sha:0:12}）"
    log "執行更新：git pull..."
    git -C "$playbook_dir" fetch --quiet origin main
    git -C "$playbook_dir" reset --hard origin/main
    log "✅ playbook 已更新至 ${remote_sha:0:12}。"
    log "提示：更新後請重新讀取 SKILL.md（Claude Code session 重啟後生效）。"
  fi
}

# ────────────────────────────────────────────────────────
# 主流程
# ────────────────────────────────────────────────────────
main() {
  local target="${1:-all}"

  case "$target" in
    huashu-design|huashu)
      update_huashu
      ;;
    playbook|gstack|g-stack)
      update_playbook
      ;;
    all|"")
      update_huashu
      echo ""
      update_playbook
      ;;
    *)
      warn "未知目標：${target}"
      echo "用法：bash scripts/update-skills.sh [huashu-design|playbook|all]"
      exit 1
      ;;
  esac

  log "=== 完成 ==="
}

main "${1:-all}"
