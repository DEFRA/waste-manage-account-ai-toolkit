# Centralise the AI-assisted development skills and rules

| | |
|---|---|
| Type | Improvement (tooling). Moves the shared skills and rules into this repo and changes how the consuming repos get them. Does not change what the rules or skills require, beyond making them independent of any one repo. |
| Priority | P2. Nothing is blocked, but the copies have already drifted and each new repo adds to the cost. |
| Parent | None. This work has no Jira story. |
| Risk | Medium (see Risks) |
| Source | Refinement with the author, 18 November 2026. `DEFRA/waste-organisations` (main), `DEFRA/waste-manage-account-frontend` pull request 121 and `DEFRA/waste-organisations-smoke-tests` pull request 3, read on 18 November 2026; the author confirmed on that date that the two pull requests hold the skills and rules the team wants in those repos. |

## Problem/Opportunity

The team uses AI coding tools to write specs, plan and build features across several repos. Each
repo carries its own copy of the skills (`.agents/skills/`) and the shared rules (`doc/rules/`),
with some parts specific to that repo. This has three costs:

- **Onboarding.** A new repo needs the whole set copied in and adapted.
- **Updates.** A change to a skill or a shared rule needs a pull request in every repo.
- **Drift.** An update that misses a repo leaves the repos behaving differently.

All three costs are visible on 18 November 2026. `waste-organisations` improved its skills and
rules three times; the frontend's main still has the older set (`spec-breakdown`, no
`slice-deliver`) and the smoke tests' main has none. Two open pull requests bring them in line by
copying and adapting: 1,505 changed lines in the frontend (pull request 121) and 2,711 in the
smoke tests (pull request 3).

With those two pull requests, the wanted state in every repo is the same layout:

| | `waste-organisations` (main) | frontend (pull request 121) | smoke tests (pull request 3) |
|---|---|---|---|
| Skills | `commit`, `pr-preflight`, `pr-review`, `slice-deliver`, `spec-clarify` | the same five | the same five |
| Shared rules | six files | six files | six files |
| Stack rule | `csharp-dotnet.md` | `javascript-nodejs.md` | `javascript-nodejs.md`, for a Mocha suite |
| Also | `AGENTS.md`, pull request template | and `.claude/rules/specs.md` | and `.claude/rules/specs.md` |

The six shared files are `common-coding.md`, `containers.md`, `continuous-integration.md`,
`git-workflow.md`, `quality-assurance.md` and `security-logging.md`.

The copies are adapted, not identical, so they cannot be shared unchanged today:

- The skills name each repo's own gate and tools. `slice-deliver`'s script is 693 lines in the
  frontend and 704 in the smoke tests, where it also checks Prettier, ESLint, Docker and port 8080.
- The shared rules differ by repo: `security-logging.md` is 57 lines in `waste-organisations` and
  36 in the smoke tests, which also record accepted deviations from the DEFRA standards.

Success is one place to change a skill or a shared rule, no pull request in the consuming repos
when it changes, and a new repo onboarded by adding two small files.

## Proposed Solution

### This repo is the single source

`ogonna-ee/waste-manage-account-ai-toolkit`, public, holds the toolkit while it is a proof of
concept. It moves to the DEFRA organisation once the Manage Account engineers adopt it (see
Decisions). It holds:

```
skills/<name>/SKILL.md       the skills, in the open Agent Skills format
rules/shared/*.md            the six shared rules
rules/stack/*.md             csharp-dotnet.md, javascript-nodejs.md
templates/AGENTS.md          the thin per-repo file (see below)
templates/settings.json      the consuming repo's `.claude/settings.json` (see below)
.claude-plugin/              plugin.json and marketplace.json, for Claude Code (see below)
install.sh                   installer for Codex
AGENTS.md, verify.sh         this repo's own rules and gate (see `specs/0002-toolkit-verification-gate.md`)
```

The plugin root is the repo root, so the rules ship inside the plugin. A skill finds the toolkit
root as the folder two levels above its own `SKILL.md`, resolved with `readlink -f` so the Codex
symlink lands in the clone. It reads `rules/shared/<name>.md` and `rules/stack/<name>.md` from
there. A skill names the script next to it, `scripts/slice.sh`, by that same resolved folder,
never by a path in the consuming repo.

The skill set is `commit`, `spec-clarify`, `slice-deliver`, `pr-review` and `pr-preflight`.
`spec-breakdown` is not carried over: `spec-clarify` now writes the Work breakdown.

### Developers install locally

- **Claude Code.** The skills are packaged as one Claude Code plugin: a package Claude Code can
  install, defined by `.claude-plugin/plugin.json`. Claude Code installs a plugin only from a
  marketplace, which is its name for a catalogue file in a git repo
  (`.claude-plugin/marketplace.json`) that lists plugins and where they live. This repo holds
  both: a catalogue with one entry, the plugin in this same repo. Nothing is published to a public
  store. Each consuming repo's `.claude/settings.json` names the catalogue
  (`extraKnownMarketplaces`) and enables the plugin (`enabledPlugins`), so a developer is prompted
  to install it on opening the repo. Claude Code then takes updates from this repo, with no action
  in the consuming repo.
- **Codex.** `install.sh` clones or updates this repo in a fixed local folder and links `skills/`
  into Codex's user-level skills folder. Running it again updates the skills.

The rules ship with the skills. A skill that needs a rule reads it from the toolkit, not from the
consuming repo.

### Skills read a repo profile

No skill names a repo's commands, test projects or folders. Each reads them from a `## Repo profile`
section in the consuming repo's `AGENTS.md`. The section is one Markdown table with the columns
`Entry` and `Value`. The entry names are fixed; a skill matches them exactly:

| Entry | Value (example, `waste-organisations`) |
|---|---|
| Stack rule | `csharp-dotnet` |
| Gate commands | the commands in order, one per line in the cell, separated by `<br>` |
| Gate prerequisites | `Docker running; host port 5432 free` (`none` when there are none) |
| Test projects | `Api.Tests: unit; Api.IntegrationTests: against Compose; Api.V1.Tests: frozen v1 behaviour` |
| Specs folder | `specs/` |
| Spec file naming | `NNNN-<ticket-id>-slug.md` |
| Frozen artefacts | `tests/Api.V1.Tests/**, *.verified.*` (`none` when there are none) |
| Pull request template | `.github/PULL_REQUEST_TEMPLATE.md` |
| Review lenses | extra lenses for this repo beyond the stack rule's, or `none` |

`Gate commands` and `Gate prerequisites` cover what the repo's old `AGENTS.md` said under
"Local Build And Test Checks" and "Postgres And Liquibase". The stack rule carries the review
lenses that every repo on that stack shares, under a `## Review lenses` heading, so `pr-review`
and `pr-preflight` apply the core lenses, then the stack rule's, then the profile's.

A skill stops and reports when the profile lacks an entry it needs.

### Each repo keeps a thin `AGENTS.md`

`AGENTS.md` stays in every repo because it is the one file both tools read on every turn. It
holds only:

- what the repo is and its stack;
- the Repo profile;
- constraints that exist only in that repo (for example Liquibase and the v1 tests in
  `waste-organisations`), and that repo's accepted deviations from a shared or stack rule;
- the required toolkit, how to install it, and an instruction to stop when a toolkit skill is
  not available.

`doc/rules/`, `.agents/skills/`, `.claude/skills/` and `.claude/rules/` are deleted from each
consuming repo.

### Change control

A change to a skill or rule is a reviewed pull request to this repo. Releases are tagged, so a
bad change can be reverted in one place.

### Work breakdown

Five pull requests: two in this repo, then one in each consuming repo. Slices 1 and 2 are the
proof of concept. The author then presents it to the Manage Account engineers; slices 3 to 5
follow adoption and the repo's move to DEFRA.

| Slice | Repo | Work | Verified by |
|---|---|---|---|
| 1 | this repo | Plugin and marketplace manifests, `install.sh`, `templates/AGENTS.md`, README, and `commit` and `pr-preflight` made generic. Stops there: the other skills and the rules come in slice 2. Answers open questions 1 and 2. | Both skills installed and run in Claude Code and Codex against `waste-organisations` and `waste-manage-account-frontend`, using a Repo profile held locally. Criteria 4, 5, 6. |
| 2 | this repo | `spec-clarify`, `pr-review` and `slice-deliver` (with `slice.sh`) made generic; `rules/shared/` and `rules/stack/` added, reconciled from the three baseline copies (see Dependencies); what is particular to one repo moves to that repo's `AGENTS.md` in slices 3 to 5. | Each skill run in the same two repos with no edit to the skill. Criteria 1, 4. |
| 3 | `waste-organisations` | `AGENTS.md` reduced to the thin form with its Repo profile; `.claude/settings.json` added; local skills and rules deleted. | The repo's full gate passes; `pr-preflight` runs from the toolkit. Criteria 2, 3, 7. |
| 4 | `waste-manage-account-frontend` | As slice 3. | As slice 3. |
| 5 | `waste-organisations-smoke-tests` | As slice 3. | As slice 3. |

## Acceptance Criteria

- [ ] 1. A change to a skill or shared rule is made in this repo only and reaches every consuming repo with no pull request in them.
- [ ] 2. A new repo is onboarded by adding a thin `AGENTS.md` and `.claude/settings.json`, and nothing else.
- [ ] 3. No consuming repo contains a copy of a toolkit skill or a shared rule.
- [ ] 4. The five skills run unchanged in the .NET API, the Node.js frontend and the smoke tests.
- [ ] 5. The skills install and run in both Claude Code and Codex from this repo, with no copy in the consuming repo.
- [ ] 6. A developer without the toolkit installed is told to install it; the tool does not improvise the skill.
- [ ] 7. A skill stops and reports when the Repo profile lacks an entry it needs; it does not guess a command.
- [ ] 8. Each consuming repo's gate and frozen tests are unchanged by the migration.

## Out of Scope

- Changing what the rules or skills require, beyond removing repo-specific detail.
- Adoption by teams outside the Manage Account repos.
- GitHub Copilot, Cursor and any other tool. The skills stay in the open Agent Skills format and the rules in plain Markdown, so a tool can be added later.
- Cloud and CI agents (for example Claude Code on the web). The toolkit is for local development only, and none is used on these repos.
- Editing any delivered spec in the consuming repos.
- Pinning a toolkit version per repo.

## Decisions

| Topic | Decision |
|---|---|
| Tools | Claude Code and Codex only, for now. Author, 18 November 2026, narrowing the same day's first answer, which also named GitHub Copilot and Cursor. |
| Update model | Local install from a central source, with no pull request in the consuming repos. Author, 18 November 2026, preferred over a sync job that opens a pull request per repo. |
| Home | `ogonna-ee/waste-manage-account-ai-toolkit`, public, created on 18 November 2026 as a proof of concept. Ogonna moves it to the DEFRA organisation after presenting it to the Manage Account engineers and once they adopt it. Author, 18 November 2026. |
| Owner | Ogonna owns the repo and approves changes to it during the proof of concept. Author, 18 November 2026. Ownership after the move is agreed at adoption. |
| Local development only | No cloud or CI agent is used on the consuming repos, and the toolkit does not support one. Author, 18 November 2026. |
| `AGENTS.md` | Stays in each repo in a thin form, because no tool-neutral local install delivers always-on rules. 18 November 2026. |
| Skill set | `commit`, `pr-preflight`, `pr-review`, `slice-deliver` and `spec-clarify` in every repo. Author, 18 November 2026. `spec-breakdown` is therefore dropped: `spec-clarify` writes the Work breakdown. |
| Baseline | The toolkit's content is reconciled from `waste-organisations` main, frontend pull request 121 and smoke-tests pull request 3. Author, 18 November 2026: the two pull requests hold what the team wants in those repos. |
| Pull request template | Stays in each repo: its checklist is specific to the repo. 18 November 2026. |
| Spec file names | `NNNN-<slug>.md` in this repo, without a ticket id. Author, 18 November 2026. |
| Codex skills folder | Codex loads user skills from `~/.agents/skills/` and follows symlinked skill folders; `$CODEX_HOME/skills` is deprecated. `install.sh` clones to `${XDG_DATA_HOME:-$HOME/.local/share}/waste-manage-account-ai-toolkit` and links each `skills/<name>` into `~/.agents/skills/<name>`. Codex docs, 18 November 2026. |
| Plugin skill names | Claude Code exposes a plugin skill as `/<plugin>:<skill>`; the bare `/<skill>` also resolves unless another command uses the name. The plugin is named `wma-ai-toolkit` and the marketplace `waste-manage-account-ai-toolkit`, so the install key is `wma-ai-toolkit@waste-manage-account-ai-toolkit`. The thin `AGENTS.md` names skills by the namespaced form. Claude Code docs, 18 November 2026. |
| Plugin updates | `plugin.json` sets no `version`, so Claude Code tracks the repo's commit; `templates/settings.json` sets `autoUpdate` to `true` on the marketplace entry. Releases are still tagged for revert. 18 November 2026. |
| Repo profile format | One `## Repo profile` table with fixed entry names, as listed under "Skills read a repo profile". Stack-wide review lenses live in the stack rule; repo-only lenses in the profile. 18 November 2026. |
| Stack review lenses | `csharp-dotnet.md` carries `api-contract`, `data` and `architecture`. `javascript-nodejs.md` carries none: the frontend's `accessibility` and Hapi `architecture` lenses are repo-only and go in that repo's profile `Review lenses` in slice 4. Planning pass, 18 November 2026. |
| Toolkit root in a skill | Every `SKILL.md` has a `## Toolkit root` section that resolves `TOOLKIT_ROOT` as two folders above the file with `readlink -f`, and reads `rules/` under it. Planning pass, 18 November 2026. |
| Baseline refs | The two baseline pull requests are read as `origin/pr-121` in `waste-manage-account-frontend` and `origin/pr-3` in `waste-organisations-smoke-tests`, fetched on 18 November 2026 into the sibling checkouts under `../`. |

## Open Questions

None open. Questions 1 and 2 were answered on 18 November 2026 from the Codex and Claude Code
documentation and are recorded in Decisions ("Codex skills folder" and "Plugin skill names").

Questions 3 to 5 of the first draft (cloud and CI agents, ownership, the move to DEFRA) were
answered by the author on 18 November 2026 and are recorded in Decisions.

## Dependencies

- `DEFRA/waste-manage-account-frontend` pull request 121 and `DEFRA/waste-organisations-smoke-tests` pull request 3, both open on 18 November 2026, are the baseline for those repos. They merge before slice 2 reconciles the copies, and slices 4 and 5 then remove what they added. If either changes before it merges, slice 2 uses the merged version.
- Slices 3 to 5 wait for adoption by the Manage Account engineers and the repo's move to the DEFRA organisation. Each consuming repo's `.claude/settings.json` and `install.sh` name the repo's owner, so migrating after the move means the consuming repos name the final owner from the start. Slices 1 and 2 do not depend on either.
- The ralph loop that `slice-deliver` drives must be available on the developer's machine, as it is today.

## Risks

Medium.

- **Unverified Codex install path.** The Codex half of the design rests on open question 1. If Codex has no user-level skills folder, it falls back to a synced copy in each repo, which brings back the per-repo pull request for Codex users.
- **No per-repo pin.** A bad toolkit change reaches every repo at once. Mitigated by review and tagged releases here.
- **Nothing forces an install or an update.** A developer can run with a stale or missing toolkit. Mitigated by the stop instruction in the thin `AGENTS.md`; staleness is not detected.
- **Adoption is not certain.** If the engineers do not adopt the toolkit, slices 3 to 5 do not happen and the consuming repos keep their copies; nothing in them has changed by then.
- **`slice-deliver` is the hardest skill to make generic.** It depends on the ralph loop, `slice.sh` and each repo's gate.
- **Reconciling adapted copies.** The shared rules and `javascript-nodejs.md` differ between repos, some of it deliberately (the smoke tests are a Mocha suite with no production code). Slice 2 compares them and asks before choosing; a rule that cannot be shared stays in that repo's `AGENTS.md`.

## Notes

- Agent Skills format: `SKILL.md` with `name` and `description` front matter, as the current skills already use.
- The consuming repos today expose the skills to Claude Code through `.claude/skills/` symlinks to `.agents/skills/`. The plugin replaces both.
