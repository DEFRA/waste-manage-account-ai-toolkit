#!/usr/bin/env bash
set -euo pipefail

TOOLKIT_REPO="https://github.com/DEFRA/waste-manage-account-ai-toolkit.git"
TOOLKIT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/waste-manage-account-ai-toolkit"
CODEX_SKILLS_DIR="$HOME/.agents/skills"

usage() {
  echo "Usage: install.sh [--dir <path>]" >&2
  exit 2
}

fail() {
  echo "install.sh: $*" >&2
  exit 1
}

use_local_dir=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir)
      [[ $# -ge 2 ]] || usage
      [[ -d "$2" ]] || fail "$2 is not a folder"
      TOOLKIT_DIR="$(cd "$2" && pwd)"
      use_local_dir=true
      shift 2
      ;;
    *)
      usage
      ;;
  esac
done

if [[ "$use_local_dir" == false ]]; then
  if [[ -d "$TOOLKIT_DIR" ]]; then
    git -C "$TOOLKIT_DIR" pull --ff-only
  else
    git clone "$TOOLKIT_REPO" "$TOOLKIT_DIR"
  fi
fi

mkdir -p "$CODEX_SKILLS_DIR"

shopt -s nullglob
skill_count=0
for skill_dir in "$TOOLKIT_DIR"/skills/*/; do
  skill_dir="${skill_dir%/}"
  skill_link="$CODEX_SKILLS_DIR/$(basename "$skill_dir")"
  if [[ -e "$skill_link" && ! -L "$skill_link" ]]; then
    fail "$skill_link is not a symlink; remove it and run install.sh again"
  fi
  ln -sfn "$skill_dir" "$skill_link"
  skill_count=$((skill_count + 1))
done

[[ "$skill_count" -gt 0 ]] || fail "no skills found under $TOOLKIT_DIR/skills"

echo "Installed $skill_count skills to ~/.agents/skills"
