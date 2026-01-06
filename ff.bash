#!/usr/bin/env bash
set -euo pipefail

store="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

cd "$store"

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

file="$(
  find . -type f -name '*.gpg' -not -path '*/.*' -printf '%P\n' |
    sed 's/\.gpg$//' | fzf -e --query="$query"
)"

[[ -z "$file" ]] && exit 0

pass "${pass_args[@]}" "$file"
