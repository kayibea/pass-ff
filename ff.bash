#!/usr/bin/env bash
set -euo pipefail

readonly VERSION="0.0.1"

command -v fzf >/dev/null 2>&1 || {
  echo "fzf not found, aborting." >&2
  exit 1
}

IGNORE_DIRS=(
  ".git"
  ".extensions"
  ".trash"
)

prune_expr=()
for dir in "${IGNORE_DIRS[@]}"; do
  prune_expr+=(-path "*/$dir/*" -o)
done
unset 'prune_expr[${#prune_expr[@]}-1]' # remove trailing -o

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

file="$(find "$PREFIX" \
  \( "${prune_expr[@]}" \) -prune -o \
  -type f -name '*.gpg' -printf '%P\n' |
  sed 's/\.gpg$//' |
  fzf -e --query="$query")"

[[ -z "$file" ]] && exit 0

pass "${pass_args[@]}" "$file"
