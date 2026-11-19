#!/usr/bin/env bats

TOOLKIT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
HOOK="$TOOLKIT/hooks/session-start.sh"

setup() {
  PROJECT="$BATS_TEST_TMPDIR/project"
  mkdir -p "$PROJECT"
  export CLAUDE_PROJECT_DIR="$PROJECT"
  export CLAUDE_PLUGIN_ROOT="$TOOLKIT"
}

@test "session-start.sh loads the shared instructions in a repo with a Repo profile" {
  printf '# Repo\n\n## Repo profile\n\n| Entry | Value |\n' > "$PROJECT/AGENTS.md"

  run "$HOOK"

  [ "$status" -eq 0 ]
  context="$(jq -r '.hookSpecificOutput.additionalContext' <<< "$output")"
  [ "$(jq -r '.hookSpecificOutput.hookEventName' <<< "$output")" = "SessionStart" ]
  [[ $context == *"toolkit folder is $TOOLKIT."* ]]
  [[ $context == *"# Manage Account AI toolkit: shared instructions"* ]]
  [[ $context == *"rules/shared/git-workflow.md"* ]]
}

@test "session-start.sh prints nothing in a repo with no AGENTS.md" {
  run "$HOOK"

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "session-start.sh prints nothing when AGENTS.md has no Repo profile" {
  printf '# Repo\n\nThe Repo profile is described elsewhere.\n' > "$PROJECT/AGENTS.md"

  run "$HOOK"

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}
