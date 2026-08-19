#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="${PAGES_REPO:-wicanr2/industry-ai-notes}"
SITE_URL="${PAGES_URL:-https://wicanr2.github.io/industry-ai-notes/}"
VENV="$ROOT/.venv-docs"

cd "$ROOT"

if [[ "$(git branch --show-current)" != "main" ]]; then
  echo "錯誤：本地 Pages 發布只能從 main 分支執行。" >&2
  exit 1
fi

remote_url="$(git remote get-url origin)"
if [[ "$remote_url" != *"github.com/wicanr2/industry-ai-notes"* ]]; then
  echo "錯誤：origin 並非 wicanr2/industry-ai-notes：$remote_url" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain --untracked-files=no)" ]]; then
  echo "錯誤：工作樹仍有已追蹤但未提交的變更，拒絕發布。" >&2
  git status --short
  exit 1
fi

gh auth status >/dev/null

local_sha="$(git rev-parse HEAD)"
remote_sha="$(git ls-remote origin refs/heads/main | cut -f1)"
if [[ "$local_sha" != "$remote_sha" ]]; then
  echo "錯誤：本地 HEAD 尚未與 origin/main 同步。" >&2
  echo "local=$local_sha remote=$remote_sha" >&2
  exit 1
fi

if [[ ! -x "$VENV/bin/python" ]]; then
  uv venv --python 3.12 "$VENV"
fi
uv pip install --python "$VENV/bin/python" -r requirements-docs.txt

"$VENV/bin/python" scripts/prepare_site.py
cp -R docs-assets/. .site-docs/
"$VENV/bin/mkdocs" build --strict

"$VENV/bin/mkdocs" gh-deploy \
  --strict \
  --force \
  --remote-name origin \
  --remote-branch gh-pages \
  --message "本地部署網站：{sha}"

pages_sha="$(git ls-remote origin refs/heads/gh-pages | cut -f1)"
if [[ -z "$pages_sha" ]]; then
  echo "錯誤：無法讀取遠端 gh-pages SHA。" >&2
  exit 1
fi

if gh api "repos/$REPO/pages" >/dev/null 2>&1; then
  gh api --method PUT "repos/$REPO/pages" \
    -f build_type=legacy \
    -f 'source[branch]=gh-pages' \
    -f 'source[path]=/' >/dev/null
else
  gh api --method POST "repos/$REPO/pages" \
    -f build_type=legacy \
    -f 'source[branch]=gh-pages' \
    -f 'source[path]=/' >/dev/null
fi

# 設定 branch source 通常會自動觸發建置；再明確要求一次，確保本次 commit 被發布。
gh api --method POST "repos/$REPO/pages/builds" >/dev/null 2>&1 || true

build_status=""
build_commit=""
for _ in $(seq 1 60); do
  # Pages source 剛切換時，latest build endpoint 可能短暫回傳 404。
  if ! build_info="$(gh api "repos/$REPO/pages/builds/latest" --jq '[.status, (.commit // "")] | @tsv' 2>/dev/null)"; then
    sleep 5
    continue
  fi
  IFS=$'\t' read -r build_status build_commit <<<"$build_info"

  if [[ "$build_status" == "built" && ( -z "$build_commit" || "$build_commit" == "$pages_sha" ) ]]; then
    break
  fi
  if [[ "$build_status" == "errored" ]]; then
    echo "錯誤：GitHub Pages branch build 失敗（commit=${build_commit:-unknown}）。" >&2
    exit 1
  fi
  sleep 5
done

if [[ "$build_status" != "built" ]]; then
  echo "錯誤：等待 GitHub Pages branch build 完成逾時（status=${build_status:-unknown}）。" >&2
  exit 1
fi

pages_config="$(gh api "repos/$REPO/pages" --jq '[.build_type, .source.branch, .source.path, .html_url] | @tsv')"
IFS=$'\t' read -r build_type source_branch source_path html_url <<<"$pages_config"
if [[ "$build_type" != "legacy" || "$source_branch" != "gh-pages" || "$source_path" != "/" ]]; then
  echo "錯誤：Pages source 驗證失敗：$pages_config" >&2
  exit 1
fi

curl --fail --silent --show-error --location --retry 6 --retry-delay 5 "$SITE_URL" >/dev/null

printf 'Local source commit: %s\n' "$local_sha"
printf 'Published gh-pages commit: %s\n' "$pages_sha"
printf 'Pages build: %s\n' "$build_status"
printf 'Pages source: %s:%s (%s)\n' "$source_branch" "$source_path" "$build_type"
printf 'Pages URL: %s\n' "${html_url:-$SITE_URL}"
