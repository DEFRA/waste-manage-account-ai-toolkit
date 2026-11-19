# waste-manage-account-ai-toolkit

The shared AI-assisted development skills and rules for the Manage Account repos. Claude Code
installs it as the `wma-ai-toolkit` plugin; Codex installs it with `install.sh`. Each consuming
repo keeps a thin `AGENTS.md`, with its Repo profile, a `doc/constraints.md` with its repo-only
rules, and a `.claude/settings.json`. Its `AGENTS.md` sends the tool to
[shared-instructions.md](shared-instructions.md) here for the skills and the shared rules. The
design is in [specs/0001-centralise-ai-skills-and-rules.md](specs/0001-centralise-ai-skills-and-rules.md).

## Install for Claude Code

A repo onboarded with `templates/settings.json` prompts you to install the plugin when you open
it. To install it by hand, run this in a terminal, not inside a Claude Code session:

```bash
claude plugin install wma-ai-toolkit --marketplace DEFRA/waste-manage-account-ai-toolkit
```

It adds this repo as a marketplace if it is not one already, and installs the plugin for your
user, with no dialog. Start a new Claude Code session afterwards. The `/plugin` commands inside
a session do the same through a dialog.

Claude Code then takes updates from this repo. The skills run as `/wma-ai-toolkit:<skill>`, for
example `/wma-ai-toolkit:commit`.

## Install for Codex

```bash
curl -fsSLO https://raw.githubusercontent.com/DEFRA/waste-manage-account-ai-toolkit/main/install.sh
bash install.sh
```

`install.sh` clones the toolkit to
`${XDG_DATA_HOME:-$HOME/.local/share}/waste-manage-account-ai-toolkit` and links each skill into
`~/.agents/skills`, and links the toolkit itself at `~/.wma-ai-toolkit`, the fixed path a repo's
`AGENTS.md` gives Codex for `shared-instructions.md`. Run `bash install.sh` again to update. The skills run as `$<skill>`, for
example `$commit`.

## Onboard a repo

1. Copy [templates/AGENTS.md](templates/AGENTS.md) to the repo's `AGENTS.md` and fill in its
   description, its Repo profile and its few most important constraints. It stays thin: the
   skills and the rules come from [shared-instructions.md](shared-instructions.md) in the toolkit,
   which the plugin loads in Claude Code and Codex reads at `~/.wma-ai-toolkit`.
2. Copy [templates/constraints.md](templates/constraints.md) to the repo's `doc/constraints.md`
   and fill in the rules that exist only in that repo.
3. Copy [templates/settings.json](templates/settings.json) to the repo's `.claude/settings.json`,
   so Claude Code prompts each developer to install the plugin.
4. Copy [templates/CLAUDE.md](templates/CLAUDE.md) to the repo's `CLAUDE.md`, so Claude Code
   reads `AGENTS.md`.
5. Copy [templates/PULL_REQUEST_TEMPLATE.md](templates/PULL_REQUEST_TEMPLATE.md) to the repo's
   `.github/PULL_REQUEST_TEMPLATE.md` and replace each `<...>` with what is particular to the repo.
6. Add the lines of [templates/gitignore](templates/gitignore) to the repo's `.gitignore`.

## Change control

A change to a skill or rule is a reviewed pull request to this repo. Releases are tagged, so a bad
change can be reverted in one place. A merged change reaches every consuming repo with no pull
request there.

## Before a pull request

Run `./verify.sh`. It checks the toolkit's own files and prints `PASS` when every check passes.
It needs `shellcheck` and `jq`.
