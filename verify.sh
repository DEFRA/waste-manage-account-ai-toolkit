#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
shopt -s nullglob

FORBIDDEN_TOKENS=(
  'Api.Tests'
  'Api.IntegrationTests'
  'Api.V1.Tests'
  'csharpier'
  'CSharpier'
  'doc/rules/'
  '.agents/skills/'
  'npm run'
  '5432'
  '8080'
  'Liquibase'
  'waste-organisations'
  'docker compose'
  'Postgres And Liquibase'
  'Local Build And Test Checks'
  'V1 API Tests'
)

STACK_TOKENS=(
  'dotnet'
  'NuGet'
  'npm'
  'Serilog'
  'Mocha'
  'Vitest'
  'Hapi'
)

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

require_tool() {
  command -v "$1" >/dev/null 2>&1 || fail "$1 is required but not installed"
}

check_shell_scripts() {
  local script
  for script in install.sh verify.sh hooks/*.sh skills/*/scripts/*.sh; do
    [[ -f "$script" ]] || continue
    shellcheck "$script" || fail "shellcheck reported problems in $script"
  done
}

check_manifests() {
  local manifest
  for manifest in .claude-plugin/*; do
    [[ -f "$manifest" ]] || continue
    jq -e .name "$manifest" >/dev/null || fail "$manifest is not valid JSON with a name"
  done
}

front_matter_value() {
  local key="$1" file="$2"
  awk -v key="$key" '
    NR == 1 && $0 != "---" { exit }
    NR > 1 && $0 == "---" { exit }
    NR > 1 && index($0, key ":") == 1 {
      value = substr($0, length(key) + 2)
      sub(/^[ \t]+/, "", value)
      sub(/[ \t]+$/, "", value)
      print value
      exit
    }
  ' "$file"
}

check_skill_front_matter() {
  local skill_file folder name description
  for skill_file in skills/*/SKILL.md; do
    folder="$(basename "$(dirname "$skill_file")")"
    name="$(front_matter_value name "$skill_file")"
    description="$(front_matter_value description "$skill_file")"
    [[ "$name" == "$folder" ]] || fail "$skill_file has name '$name', expected '$folder'"
    [[ -n "$description" ]] || fail "$skill_file has no description"
  done
}

check_skills_are_generic() {
  [[ -d skills ]] || return 0
  local token
  for token in "${FORBIDDEN_TOKENS[@]}"; do
    if grep -rnF -- "$token" skills/; then
      fail "skills/ contains the repo-specific token '$token'"
    fi
  done
}

check_shared_rules_are_stack_free() {
  [[ -d rules/shared ]] || return 0
  local token
  for token in "${STACK_TOKENS[@]}"; do
    if grep -rnF -- "$token" rules/shared/; then
      fail "rules/shared/ contains the stack token '$token'"
    fi
  done
}

require_tool shellcheck
require_tool jq

check_shell_scripts
check_manifests
check_skill_front_matter
check_skills_are_generic
check_shared_rules_are_stack_free

echo PASS
