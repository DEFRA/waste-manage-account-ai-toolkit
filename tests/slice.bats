#!/usr/bin/env bats
# shellcheck disable=SC2016  # the backticks are the profile's Markdown, not a command

SLICE="$BATS_TEST_DIRNAME/../skills/slice-deliver/scripts/slice.sh"

setup() {
  REPO="$BATS_TEST_TMPDIR/repo"
  STUBS="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$REPO" "$STUBS"
  # A gh that is never signed in, so no test reaches GitHub.
  printf '#!/bin/sh\nexit 1\n' > "$STUBS/gh"
  chmod +x "$STUBS/gh"
  PATH="$STUBS:$PATH"
  export GIT_AUTHOR_NAME=Test GIT_AUTHOR_EMAIL=test@example.com
  export GIT_COMMITTER_NAME=Test GIT_COMMITTER_EMAIL=test@example.com
  git -C "$REPO" init --quiet
  cd "$REPO" || return 1
}

write_profile() {
  {
    printf '# Repo\n\n## Repo profile\n\n'
    printf '| Entry | Value |\n'
    printf '|-------|-------|\n'
    printf '%s\n' "$@"
    printf '\n## Constraints\n'
  } > AGENTS.md
}

write_spec() {
  local path=$1
  mkdir -p "$(dirname "$path")"
  cat > "$path" << 'EOF'
# Spec

### Work breakdown

| Slice | Work | Verified by |
|-------|------|-------------|
| 1 | Add the thing | A test of the thing |
EOF
}

commit_fixture() {
  git add -A
  git -c commit.gpgsign=false commit --quiet --no-verify -m fixture
}

load_profile_value() {
  # shellcheck disable=SC2034  # read by the evaluated profile_value
  PROFILE_FILE=AGENTS.md
  eval "$(sed -n '/^profile_value() {$/,/^}$/p' "$SLICE")"
}

has_line() {
  local line=$1
  grep -Fxq -- "$line" <<< "$output"
}

@test "profile_value strips the backticks from a value" {
  write_profile '| Specs folder | `docs/specs/` |'
  load_profile_value

  run profile_value "Specs folder"

  [ "$status" -eq 0 ]
  [ "$output" = "docs/specs/" ]
}

@test "profile_value keeps a pipe inside a value" {
  write_profile '| Gate prerequisites | `make deps | tee deps.log` |'
  load_profile_value

  run profile_value "Gate prerequisites"

  [ "$status" -eq 0 ]
  [ "$output" = "make deps | tee deps.log" ]
}

@test "profile_value prints nothing for a missing entry" {
  write_profile '| Specs folder | `specs/` |'
  load_profile_value

  run profile_value "Gate prerequisites"

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "status reports a profile without a Specs folder as a blocker" {
  write_profile '| Spec file naming | `NNNN-<slug>.md` |'
  write_spec specs/0001-x.md
  commit_fixture

  run "$SLICE" status specs/0001-x.md 1

  [ "$status" -eq 0 ]
  has_line "blocker=profile: missing Specs folder"
}

@test "status reports a profile without Gate prerequisites as a blocker" {
  write_profile '| Specs folder | `specs/` |'
  write_spec specs/0001-x.md
  commit_fixture

  run "$SLICE" status 1 1

  [ "$status" -eq 0 ]
  has_line "blocker=profile: missing Gate prerequisites"
  [[ $output != *"missing Spec file naming"* ]]
}

@test "a spec number resolves a four-digit spec in the Specs folder" {
  write_profile '| Specs folder | `specs/` |'
  write_spec specs/0004-x.md
  write_spec specs/003-y.md
  commit_fixture

  run "$SLICE" status 4 1

  [ "$status" -eq 0 ]
  has_line "spec_file=specs/0004-x.md"
}

@test "a spec number resolves a three-digit spec in the Specs folder" {
  write_profile '| Specs folder | `specs/` |'
  write_spec specs/0004-x.md
  write_spec specs/003-y.md
  commit_fixture

  run "$SLICE" status 3 1

  [ "$status" -eq 0 ]
  has_line "spec_file=specs/003-y.md"
}

@test "a spec number resolves a spec in a ./ Specs folder" {
  write_profile '| Specs folder | `./specs/` |'
  write_spec specs/0008-x.md
  commit_fixture

  run "$SLICE" status 8 1

  [ "$status" -eq 0 ]
  has_line "spec_file=specs/0008-x.md"
}

@test "a spec number matching two specs is refused" {
  write_profile '| Specs folder | `specs/` |'
  write_spec specs/0004-x.md
  write_spec specs/004-z.md
  commit_fixture

  run "$SLICE" status 4 1

  [ "$status" -eq 1 ]
  [[ $output == *"found 2"* ]]
}

@test "status prints the Gate prerequisites value" {
  write_profile '| Specs folder | `specs/` |' '| Gate prerequisites | `make deps` |'
  write_spec specs/0001-x.md
  commit_fixture

  run "$SLICE" status 1 1

  [ "$status" -eq 0 ]
  has_line "prerequisites=make deps"
}
