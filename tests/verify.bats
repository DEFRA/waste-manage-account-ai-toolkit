#!/usr/bin/env bats

setup() {
  COPY="$BATS_TEST_TMPDIR/toolkit"
  mkdir -p "$COPY"
  cp -R "$BATS_TEST_DIRNAME/../." "$COPY"
  cd "$COPY" || return 1
}

@test "verify.sh prints PASS on an unchanged copy" {
  run ./verify.sh

  [ "$status" -eq 0 ]
  [ "$output" = "PASS" ]
}

@test "verify.sh fails when a skill contains a repo-specific token" {
  echo "Run the Api.Tests project." >> skills/commit/SKILL.md

  run ./verify.sh

  [ "$status" -eq 1 ]
  [[ $output == *"FAIL: skills/ contains the repo-specific token 'Api.Tests'"* ]]
}

@test "verify.sh fails when plugin.json is not valid JSON" {
  echo '{ "name": ' > .claude-plugin/plugin.json

  run ./verify.sh

  [ "$status" -eq 1 ]
  [[ $output == *"FAIL: .claude-plugin/plugin.json is not valid JSON with a name"* ]]
}

@test "verify.sh fails when a SKILL.md name differs from its folder" {
  sed -i.bak 's/^name: commit$/name: committer/' skills/commit/SKILL.md
  rm skills/commit/SKILL.md.bak

  run ./verify.sh

  [ "$status" -eq 1 ]
  [[ $output == *"FAIL: skills/commit/SKILL.md has name 'committer', expected 'commit'"* ]]
}
