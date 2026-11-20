# waste-manage-account-ai-toolkit

The shared AI-assisted development skills and rules for the Manage Account repos, packaged as a Claude Code plugin and installed for Codex by `install.sh`. The toolkit has no runtime: it is Markdown, two JSON manifests and shell scripts. The design is in `specs/0001-centralise-ai-skills-and-rules.md`.

## Repo profile

| Entry | Value |
|---|---|
| Stack rule | `shell-markdown` |
| Gate commands | `./verify.sh`<br>`bats tests/` |
| Gate prerequisites | `shellcheck`, `jq` and `bats` on the PATH |
| Test projects | `tests/hook.bats`: the session-start hook; `tests/install.bats`: `install.sh`; `tests/slice.bats`: `slice.sh`; `tests/verify.bats`: `verify.sh` |
| Specs folder | `specs/` |
| Spec file naming | `NNNN-<ticket-id>-slug.md`, without the ticket id when the work has no Jira story |
| Frozen artefacts | Delivered specs: `specs/0001-centralise-ai-skills-and-rules.md`, `specs/0002-toolkit-verification-gate.md`, and each later spec once its last slice merges |
| Pull request template | `.github/PULL_REQUEST_TEMPLATE.md` |
| Review lenses | `generic`: a skill, shared rule or template names no consuming repo, project, port or command (`verify.sh` checks its token lists; the lens covers what they miss); `two-tools`: a change to a skill, `install.sh`, the hook or `shared-instructions.md` still works in both Claude Code and Codex |

## Constraints

Read [doc/constraints.md](doc/constraints.md) before changing a skill, a rule, a template, a script, a test or a workflow. It holds the rules that exist only in this repo and its accepted deviations from a shared rule. The ones that matter most:

- Skills, shared rules and templates stay generic: what is particular to one consuming repo belongs in that repo's `AGENTS.md` or constraints file.
- Never edit a delivered spec.
- The installed plugin runs from its cache, not from your branch: test a change with `claude --plugin-dir .` from this checkout (see the README).
- Every action in a workflow is pinned to a full commit SHA.

## Layout

```
skills/<name>/SKILL.md       the skills, in the open Agent Skills format
rules/shared/*.md            the shared rules, one per topic
rules/stack/*.md             csharp-dotnet.md, javascript-nodejs.md, shell-markdown.md
shared-instructions.md       what every consuming repo's AGENTS.md points its tool at: skills, rules lookup
templates/AGENTS.md          the thin per-repo file
templates/constraints.md     the consuming repo's `doc/constraints.md`, its repo-only rules
templates/settings.json      the consuming repo's `.claude/settings.json`
templates/CLAUDE.md          the consuming repo's `CLAUDE.md`, which imports `AGENTS.md`
templates/PULL_REQUEST_TEMPLATE.md  the common pull request template, completed per repo
templates/gitignore          the ralph loop entries for the consuming repo's `.gitignore`
.claude-plugin/              plugin.json and marketplace.json, for Claude Code
install.sh                   installer for Codex
hooks/                       session-start hook that loads shared-instructions.md in Claude Code
AGENTS.md, verify.sh         this repo's own rules and gate
doc/constraints.md           this repo's own constraints
.claude/settings.json        prompts a contributor to install the plugin; turns off tool attribution
.github/PULL_REQUEST_TEMPLATE.md  this repo's pull request template
.github/workflows/           the pull request check, which runs the gate
.github/CODEOWNERS           the code owners the main ruleset asks to review
tests/*.bats                 bats tests for the shell scripts
```

## Specs

- Specs live in `specs/` and are named `specs/NNNN-<ticket-id>-<slug>.md`, without the ticket id when the work has no Jira story. Specs 0001 and 0002 keep their names.
- Never edit a delivered spec.

## Commits

- Commits follow Conventional Commits: `type(scope): subject`, imperative, lowercase, at most 50 characters, with an optional body of up to three bullets.
- Commits carry no tool signatures and no co-author trailers.

## Verification gate

Run the Repo profile's Gate commands, `./verify.sh` then `bats tests/`, before every commit and every pull request. `./verify.sh` checks the toolkit's own files and prints `PASS` when every check passes; `bats tests/` runs the tests of the shell scripts.
