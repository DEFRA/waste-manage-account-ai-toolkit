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

@test "install.sh links the toolkit at a fixed path" {
  run "$INSTALL" --dir "$TOOLKIT"

  [ "$status" -eq 0 ]
  [ -L "$HOME/.wma-ai-toolkit" ]
  [ "$(readlink "$HOME/.wma-ai-toolkit")" = "$TOOLKIT" ]
  [ -f "$HOME/.wma-ai-toolkit/shared-instructions.md" ]
}

@test "install.sh repoints the toolkit link when run again" {
  mkdir -p "$BATS_TEST_TMPDIR/old"
  ln -s "$BATS_TEST_TMPDIR/old" "$HOME/.wma-ai-toolkit"

  run "$INSTALL" --dir "$TOOLKIT"

  [ "$status" -eq 0 ]
  [ "$(readlink "$HOME/.wma-ai-toolkit")" = "$TOOLKIT" ]
}

@test "install.sh refuses to replace a real folder at the toolkit link" {
  mkdir -p "$HOME/.wma-ai-toolkit"

  run "$INSTALL" --dir "$TOOLKIT"

  [ "$status" -eq 1 ]
  [[ $output == *".wma-ai-toolkit is not a symlink"* ]]
}
