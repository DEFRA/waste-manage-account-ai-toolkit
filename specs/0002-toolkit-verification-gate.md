# This repo's rules and verification gate

| | |
|---|---|
| Type | Improvement (tooling). Gives this repo an `AGENTS.md` and one command that checks the toolkit's own files. |
| Priority | P2. Needed before the first toolkit change is reviewed. |
| Parent | `specs/0001-centralise-ai-skills-and-rules.md` |
| Risk | Low |
| Source | Planning pass, 18 November 2026. Assumption: the toolkit has no runtime, so its gate is static checks only. |

## Problem/Opportunity

The toolkit is Markdown, two JSON manifests and shell scripts. Nothing checks that a skill is
still generic, that a manifest parses, or that a script is sound. The build loop also needs one
command to prove an iteration did no harm.

## Proposed Solution

- `AGENTS.md` at the root describes the repo, its layout from spec 0001, the specs convention
  (`specs/NNNN-<slug>.md`), the Conventional Commits rule, and names `./verify.sh` as the gate.
  `CLAUDE.md` holds `@AGENTS.md` only, as the consuming repos do.
- `verify.sh` at the root, Bash, `set -euo pipefail`, exits non-zero on the first failing check
  and prints `PASS` on success. Checks, in order:
  1. `shellcheck` on `install.sh`, `verify.sh` and every `skills/*/scripts/*.sh` that exists.
  2. `jq -e .name` on `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`.
  3. Every `skills/<name>/SKILL.md` has front matter whose `name:` equals `<name>` and has a
     `description:`.
  4. No file under `skills/` contains a repo-specific token. The list lives in `verify.sh` as
     the array `FORBIDDEN_TOKENS` and holds at least: `Api.Tests`, `Api.IntegrationTests`,
     `Api.V1.Tests`, `csharpier`, `CSharpier`, `doc/rules/`, `.agents/skills/`, `npm run`,
     `5432`, `8080`, `Liquibase`, `waste-organisations`, `docker compose`, `Postgres And Liquibase`,
     `Local Build And Test Checks`, `V1 API Tests`.
  5. Every file under `rules/shared/` is free of the stack tokens `dotnet`, `NuGet`, `npm`,
     `Serilog`, `Mocha`, `Vitest`, `Hapi`.

A check that finds nothing to check (for example no `skills/` yet) passes.

## Acceptance Criteria

- [ ] 1. `./verify.sh` exits zero and prints `PASS` on a clean tree.
- [ ] 2. `./verify.sh` exits non-zero when a file under `skills/` contains `Api.Tests`.
- [ ] 3. `./verify.sh` exits non-zero when `.claude-plugin/plugin.json` is not valid JSON.
- [ ] 4. `AGENTS.md` names `./verify.sh` under a `## Verification gate` heading.

## Out of Scope

- Running a skill end to end. That is spec 0001's acceptance criteria 4 and 5, checked by hand.
- Markdown linting.

## Decisions

| Topic | Decision |
|---|---|
| Tools | `shellcheck` and `jq` are required on the developer's machine. `verify.sh` fails with a message naming the missing tool. 18 November 2026. |
| Token list | Lives in `verify.sh` only, not in a rule, so one place changes. 18 November 2026. |
