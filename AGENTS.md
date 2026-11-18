# waste-manage-account-ai-toolkit

The shared AI-assisted development skills and rules for the Manage Account repos, packaged as a Claude Code plugin and installed for Codex by `install.sh`. The toolkit has no runtime: it is Markdown, two JSON manifests and shell scripts. The design is in `specs/0001-centralise-ai-skills-and-rules.md`.

## Layout

```
skills/<name>/SKILL.md       the skills, in the open Agent Skills format
rules/shared/*.md            the six shared rules
rules/stack/*.md             csharp-dotnet.md, javascript-nodejs.md
templates/AGENTS.md          the thin per-repo file
templates/settings.json      the consuming repo's `.claude/settings.json`
.claude-plugin/              plugin.json and marketplace.json, for Claude Code
install.sh                   installer for Codex
AGENTS.md, verify.sh         this repo's own rules and gate
```

## Specs

- Specs live in `specs/` and are named `specs/NNNN-<slug>.md`, with no ticket id.
- Never edit a delivered spec.

## Commits

- Commits follow Conventional Commits: `type(scope): subject`, imperative, lowercase, at most 50 characters, with an optional body of up to three bullets.
- Commits carry no tool signatures and no co-author trailers.

## Verification gate

Run `./verify.sh` before every commit and every pull request. It is the one command that checks the toolkit's own files, and it prints `PASS` when every check passes.
