# waste-manage-account-ai-toolkit

The shared AI-assisted development skills and rules for the Manage Account repos. Claude Code
installs it as the `wma-ai-toolkit` plugin; Codex installs it with `install.sh`. Each consuming
repo keeps only a thin `AGENTS.md`, with its Repo profile, and a `.claude/settings.json`. The
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
`~/.agents/skills`. Run `bash install.sh` again to update. The skills run as `$<skill>`, for
example `$commit`.

## Onboard a repo

1. Copy [templates/AGENTS.md](templates/AGENTS.md) to the repo's `AGENTS.md` and fill in its
   Repo profile, constraints and description.
2. Copy [templates/settings.json](templates/settings.json) to the repo's `.claude/settings.json`,
   so Claude Code prompts each developer to install the plugin.

## Change control

A change to a skill or rule is a reviewed pull request to this repo. Releases are tagged, so a bad
change can be reverted in one place. A merged change reaches every consuming repo with no pull
request there.

## Before a pull request

Run `./verify.sh`. It checks the toolkit's own files and prints `PASS` when every check passes.
It needs `shellcheck` and `jq`.
