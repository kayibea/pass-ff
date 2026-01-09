#!/usr/bin/env bash
set -euo pipefail

store="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

cd "$store" || {
  echo "Failed to cd into password store ($store)" >&2
  exit 1
}

command -v fzf >/dev/null 2>&1 || {
  echo "fzf not found, aborting." >&2
  exit 1
}

query=""
pass_args=()
if [[ $# -gt 0 ]]; then
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --)
        shift
        query="$*"
        break
        ;;
      *)
        pass_args+=("$1")
        shift
        ;;
    esac
  done
fi

if command git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  preview_cmd='git --no-pager -c color.ui=always log --follow --stat --summary --patch-with-stat --name-status --find-renames=100% -- {}.gpg'
else
  preview_cmd='stat {}.gpg'
fi

file="$(
  find . -type f -name '*.gpg' -not -path '*/.*' -printf '%P\n' |
    sed 's/\.gpg$//' |
    sort |
    fzf -e \
      --query="$query" \
      --ansi \
      --preview="$preview_cmd" \
      --preview-window=right:60%:wrap
)"

[[ -z "$file" ]] && {
  echo "Aborted!"
  exit 0
}

pass "${pass_args[@]}" "$file"
