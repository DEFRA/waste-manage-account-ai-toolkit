#!/usr/bin/env bash
# Puts shared-instructions.md into the session's context, so the shared rules
# apply without the tool having to follow a pointer. Does nothing outside a
# repo that uses the toolkit: the plugin is installed for the user, so this
# runs in every project.
set -euo pipefail

TOOLKIT_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$PWD}"
INSTRUCTIONS="$TOOLKIT_ROOT/shared-instructions.md"

[[ -f "$PROJECT_DIR/AGENTS.md" ]] || exit 0
grep -q '^## Repo profile[[:space:]]*$' "$PROJECT_DIR/AGENTS.md" || exit 0
[[ -f "$INSTRUCTIONS" ]] || exit 0

json_escape() {
  local text=$1
  text=${text//\\/\\\\}
  text=${text//\"/\\\"}
  text=${text//$'\n'/\\n}
  text=${text//$'\r'/}
  text=${text//$'\t'/\\t}
  printf '%s' "$text"
}

context="The Manage Account AI toolkit folder is $TOOLKIT_ROOT. This repo's AGENTS.md has a Repo profile, so the toolkit's shared instructions below apply to every task in this session.

$(cat "$INSTRUCTIONS")"

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$(json_escape "$context")"
