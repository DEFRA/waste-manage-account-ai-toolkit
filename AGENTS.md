# waste-manage-account-ai-toolkit

The shared AI-assisted development skills and rules for the Manage Account repos, packaged as a Claude Code plugin and installed for Codex by `install.sh`. The toolkit has no runtime: it is Markdown, two JSON manifests and shell scripts. The design is in `specs/0001-centralise-ai-skills-and-rules.md`.

## Layout

```
skills/<name>/SKILL.md       the skills, in the open Agent Skills format
rules/shared/*.md            the shared rules, one per topic
rules/stack/*.md             csharp-dotnet.md, javascript-nodejs.md
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
tests/*.bats                 bats tests for the shell scripts
```

## Specs

- Specs live in `specs/` and are named `specs/NNNN-<slug>.md`, with no ticket id.
- Never edit a delivered spec.

## Commits

- Commits follow Conventional Commits: `type(scope): subject`, imperative, lowercase, at most 50 characters, with an optional body of up to three bullets.
- Commits carry no tool signatures and no co-author trailers.

## Verification gate

Run `./verify.sh` before every commit and every pull request. It is the one command that checks the toolkit's own files, and it prints `PASS` when every check passes. When a shell script changes, run `bats tests/` as well.
