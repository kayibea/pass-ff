#!/usr/bin/env bash
set -euo pipefail

die() {
  echo "pass ff: $*" >&2
  exit 1
}

store="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

[[ -d "$store" ]] || die "password store not found: $store"
cd "$store" || die "failed to cd into password store"

command -v fzf &>/dev/null || die "fzf not found in PATH"
command -v pass &>/dev/null || die "pass not found in PATH"

query=""
pass_args=()

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

files=$(
  find . -type f -name '*.gpg' -not -path '*/.*' -printf '%P\n' |
    sed 's/\.gpg$//' |
    sort
) || die "failed to list password entries"

file="$(
  printf '%s\n' "$files" | fzf -e \
    --query="$query"
)" || exit 0

[[ -n "$file" ]] || exit 0

pass "${pass_args[@]}" "$file"
