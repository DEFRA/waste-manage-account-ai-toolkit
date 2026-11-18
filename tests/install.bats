#!/usr/bin/env bats

TOOLKIT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
INSTALL="$TOOLKIT/install.sh"

setup() {
  HOME="$BATS_TEST_TMPDIR/home"
  mkdir -p "$HOME"
  export HOME
}

@test "install.sh --dir links the commit skill" {
  run "$INSTALL" --dir "$TOOLKIT"

  [ "$status" -eq 0 ]
  [[ $output == "Installed "*" skills to ~/.agents/skills" ]]
  [ -L "$HOME/.agents/skills/commit" ]
  [ "$(readlink "$HOME/.agents/skills/commit")" = "$TOOLKIT/skills/commit" ]
}

@test "install.sh exits 2 for an unknown flag" {
  run "$INSTALL" --force

  [ "$status" -eq 2 ]
  [[ $output == "Usage: install.sh"* ]]
  [ ! -e "$HOME/.agents" ]
}

@test "install.sh refuses to replace a real skill folder" {
  mkdir -p "$HOME/.agents/skills/commit"

  run "$INSTALL" --dir "$TOOLKIT"

  [ "$status" -eq 1 ]
  [[ $output == *".agents/skills/commit is not a symlink"* ]]
  [ ! -e "$HOME/.agents/skills/commit/commit" ]
}
