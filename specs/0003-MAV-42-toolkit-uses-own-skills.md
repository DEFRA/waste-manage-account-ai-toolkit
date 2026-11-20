# The toolkit uses its own skills, with CI

| | |
|---|---|
| Type | Improvement (tooling). Gives this repo a Repo profile, a stack rule, constraints, a pull request template and a pull request check, so its own skills, hook and rules apply to it. Carries one bug fix to `slice-deliver`. |
| Priority | P2. Nothing outside the toolkit is blocked. The `slice-deliver` bug has a workaround: name the story's branch, not a slice's, in the spec's Notes. |
| Parent | `specs/0001-centralise-ai-skills-and-rules.md` and `specs/0002-toolkit-verification-gate.md`. Jira story MAV-42, which pull request 3 also carried. |
| Risk | Low (see Risks) |
| Source | Refinement with the author, 20 November 2026. `pr-preflight` stopped on draft pull request DEFRA/waste-manage-account-ai-toolkit#3 with `Repo profile: missing`. The `main` ruleset, `DEFRA/waste-organisations` `.github/workflows/check-pull-request.yml` and `.github/CODEOWNERS`, and the diff of pull request 3 were read on 20 November 2026. |

## Problem/Opportunity

The toolkit's skills and rules apply to every Manage Account repo except the toolkit itself. On
20 November 2026:

1. `AGENTS.md` has no `## Repo profile` table, so `commit`, `spec-clarify`, `slice-deliver`,
   `pr-preflight` and `pr-review` all stop with `Repo profile: missing`, and
   `hooks/session-start.sh` never loads `shared-instructions.md` in this repo.
2. No stack rule fits. `rules/stack/` holds `csharp-dotnet.md` and `javascript-nodejs.md`; the
   toolkit is Bash and Markdown tested with bats. The skills read `rules/stack/<Stack rule>.md`,
   and `pr-preflight`'s coverage check has no figure to compare for bats.
3. There is no `.github/PULL_REQUEST_TEMPLATE.md`.
4. There is no constraints file and no list of branch rulesets, though `shared-instructions.md`
   and `rules/shared/git-workflow.md` expect both.
5. There is no `.claude/settings.json`, so a contributor is not prompted to install the plugin.
   Once it is installed, the plugin runs from its cache (the `main` version), so a branch's change
   to a skill or the hook is only tested by starting Claude Code with `--plugin-dir .`, which
   nothing documents.
6. There is no CI, though `rules/shared/common-coding.md` and
   `rules/shared/continuous-integration.md` require a check on every pull request. The `main`
   ruleset requires a pull request with one approval, code-owner review, resolved threads and
   signed commits, but no status check, and the code-owner rule has no `CODEOWNERS` file to act on.

Separately, `slice-deliver` names a slice's branch wrongly when a spec's Notes list slice
branches. `slice_branch_name` in `skills/slice-deliver/scripts/slice.sh` takes the first name in
backticks on the Notes' `- Branch...` line and appends `-slice-<n>`. In
`DEFRA/waste-organisations` spec 0007 the Notes say
`` - Branches: `MAV-42-gds-address-format-slice-1`, `-slice-2` ``, so slice 2 got
`MAV-42-gds-address-format-slice-1-slice-2`, and the script looked for slice 1 at
`MAV-42-gds-address-format-slice-1-slice-1`. Draft pull request 3 (branch
`MAV-42-slice-branch-suffix`) fixes it; this spec carries that fix so pull request 3 can be closed.

Success is that a developer in this repo runs any toolkit skill and gets a result, not a stop,
that every pull request here is checked by CI with the same gate a developer runs locally, and
that the slice branch bug is fixed with tests.

## Proposed Solution

### Repo profile

`AGENTS.md` gains a `## Repo profile` table with the entries `templates/AGENTS.md` lists:

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

The values follow `templates/AGENTS.md` and do not trip `./verify.sh`. `AGENTS.md`'s
`## Verification gate` section is updated to name the Gate commands, run both before every commit
and pull request, replacing "when a shell script changes, run `bats tests/` as well". Its
`## Specs` section is updated to the same naming: the ticket id when the work has one. Specs 0001
and 0002 keep their names. The layout block gains the new files.

### Stack rule

A new `rules/stack/shell-markdown.md`, with the sections the skills read from a stack rule:

- **Shell:** Bash with `#!/usr/bin/env bash` and `set -euo pipefail`; `shellcheck` clean, and a
  `# shellcheck disable=` only with a comment that says why; runs on macOS's and Ubuntu's Bash and
  their BSD and GNU tools.
- **Markdown:** skills in the Agent Skills format; rules one topic per file; plain Markdown that
  any tool reads.
- **Tests:** bats, one `tests/<script>.bats` per script; a test builds its own fixture in a
  temporary folder and touches nothing outside it.
- **Acceptance criteria defaults:** a script change states its exit status and output for each
  case, with at least one negative case; a skill or rule change states the behaviour a developer
  sees.
- **Review lenses:** none beyond the core lenses; this repo's lenses are in its Repo profile.
- **Coverage:** bats reports no coverage figure, so there is none to compare. In its place, every
  changed behaviour of a script has a bats test, including its negative cases, and no test is
  removed without the behaviour it covered.

No skill changes: they read this rule as they read the other two.

### Constraints

`AGENTS.md` gains a `## Constraints` section, as in `templates/AGENTS.md`, that points at
`doc/constraints.md` and lists at most five constraints. `doc/constraints.md` follows
`templates/constraints.md` and holds:

- **What does not apply:** SonarQube Cloud, Docker, Trivy and the container rules. The toolkit has
  no runtime code and no image; `shellcheck` is its static analysis. Recorded as an accepted
  deviation from `rules/shared/continuous-integration.md`, dated 20 November 2026.
- **Code:** skills, shared rules and templates stay generic; repo-specific detail belongs in a
  consuming repo's `AGENTS.md` or constraints. Never edit a delivered spec.
- **Continuous integration:** the workflow, its job name as the required check, and the `main`
  ruleset (no deletion, no force push, a pull request with one approval and code-owner review,
  stale approvals dismissed, resolved threads, signed commits, squash or merge, and the required
  check once it is added).
- **Git and pull requests:** commits follow Conventional Commits as `AGENTS.md` states, which
  differs from the shared rule; a pull request title carries the ticket id when the work has one.
- **Local procedures:** testing a branch with `claude --plugin-dir .`, pointing at the README.

### Pull request template and settings

- `.github/PULL_REQUEST_TEMPLATE.md` is `templates/PULL_REQUEST_TEMPLATE.md` completed for this
  repo: the ticket id, or `Jira: none` with the reason; no generated files in `Size:`; "How to
  test" run with `claude --plugin-dir .` or `install.sh` from the branch; checklist items for the
  Gate commands, bats tests for changed scripts, the `generic` and `two-tools` lenses, and actions
  pinned to full SHAs.
- `.claude/settings.json` is `templates/settings.json` unchanged.
- `README.md` gains a "Test a change to the toolkit" section: the installed plugin runs from its
  cache, so start `claude --plugin-dir .` from the branch's checkout to run its skills and hook;
  for Codex, run the branch's `install.sh` against the local clone.

### CI

`.github/workflows/check-pull-request.yml`, modelled on `DEFRA/waste-organisations`'s:

- Runs on `pull_request` to `main`, for `opened`, `edited`, `reopened`, `synchronize` and
  `ready_for_review`.
- `permissions: contents: read` and nothing more.
- One job, id `pr-validator`, name `Run Pull Request Checks`, on `ubuntu-latest`: check out,
  install `bats` (`shellcheck` and `jq` are on the runner; the workflow confirms them), then run
  the Gate commands in order: `./verify.sh`, then `bats tests/`.
- Every action pinned to a full commit SHA with the version as a trailing comment, the SHA looked
  up from the action's repository at the time, never from memory.
- No Sonar, Docker or Trivy step (see Constraints).

`.github/CODEOWNERS` holds one rule, `* @DEFRA/waste-manage-account`, with a comment saying the
team owns the repository, as line 5 of `DEFRA/waste-organisations`'s does.

Rulesets are set in GitHub, not in the repo. After slice 2 merges and the check has run green on
`main`'s next pull request, Ogonna, as the repo's owner, adds `Run Pull Request Checks` as a
required status check on the `main` ruleset, and records the date in `doc/constraints.md`'s
Continuous integration section in the next pull request.

### Slice branch fix

In `slice_branch_name`, after the Notes branch is read and before the story check, a trailing
`-slice-<digits>` is dropped:

```bash
[[ $name =~ ^(.+)-slice-[0-9]+$ ]] && name=${BASH_REMATCH[1]}
```

The function's comment says why: Notes may name a slice's branch rather than the story's. Three
bats tests from pull request 3 go into `tests/slice.bats`, with the negative cases below.

### Work breakdown

Three pull requests in this repo. Slice 1 is delivered by hand, because `slice-deliver` needs the
Repo profile it adds. Slice 3 is delivered with `slice-deliver` to prove the toolkit runs its own
skills.

| Slice | Work | Verified by |
|---|---|---|
| 1 | Repo profile, `## Constraints` and updated layout and gate sections in `AGENTS.md`; `rules/stack/shell-markdown.md`; `doc/constraints.md`; `.github/PULL_REQUEST_TEMPLATE.md`; `.claude/settings.json`; README "Test a change to the toolkit". | Criteria 1 to 6. |
| 2 | `.github/workflows/check-pull-request.yml` and `.github/CODEOWNERS`. Then Ogonna adds the required check. | Criteria 7 to 10. |
| 3 | The `slice_branch_name` fix and its bats tests, delivered with `slice-deliver`. Pull request 3 is then closed. | Criteria 11 to 16. |

## Acceptance Criteria

Slice 1:

- [ ] 1. `./verify.sh` prints `PASS` and `bats tests/` passes on the slice's branch.
- [ ] 2. With `CLAUDE_PROJECT_DIR` set to this repo, `hooks/session-start.sh` prints the
  SessionStart JSON carrying `shared-instructions.md`; without a `## Repo profile` heading in
  `AGENTS.md` it prints nothing and exits zero, as today.
- [ ] 3. Started with `claude --plugin-dir .`, `pr-preflight`, `pr-review`, `spec-clarify` and
  `commit` each run in this repo without stopping on a missing Repo profile entry or a missing
  stack rule. Checked by hand.
- [ ] 4. `rules/stack/shell-markdown.md` has `## Tests`, `## Acceptance criteria defaults`,
  `## Review lenses` and `## Coverage` sections, and `## Coverage` says what replaces a figure.
- [ ] 5. `AGENTS.md` names `doc/constraints.md` under `## Constraints`, and `doc/constraints.md`
  lists the `main` ruleset and records Sonar, Docker and Trivy as not applying, with the reason.
- [ ] 6. `README.md` documents `claude --plugin-dir .` for testing a branch, and
  `doc/constraints.md` points to it.

Slice 2:

- [ ] 7. A pull request to `main` runs `Run Pull Request Checks`, which runs `./verify.sh` then
  `bats tests/` and passes on a clean branch.
- [ ] 8. The check fails when `./verify.sh` fails (for example a file under `skills/` containing
  `Api.Tests`) and when a bats test fails.
- [ ] 9. Every `uses:` in the workflow is a 40-character commit SHA followed by a version comment,
  and the workflow declares only `contents: read`.
- [ ] 10. `.github/CODEOWNERS` makes `@DEFRA/waste-manage-account` the owner of every path.

Slice 3, `slice.sh status <spec> 2` on a fixture spec `specs/0007-ABC-42-thing.md`:

- [ ] 11. With no Notes branch, it prints `slice_branch=ABC-42-thing-slice-2` and
  `previous_branch=ABC-42-thing-slice-1`.
- [ ] 12. With Notes `` - Branch: `ABC-42-short`. ``, it prints `slice_branch=ABC-42-short-slice-2`
  and `previous_branch=ABC-42-short-slice-1`.
- [ ] 13. With Notes `` - Branches: `ABC-42-short-slice-1`, `-slice-2`. ``, it prints
  `slice_branch=ABC-42-short-slice-2` and `previous_branch=ABC-42-short-slice-1`, never a doubled
  `-slice-` suffix.
- [ ] 14. Negative: with Notes `` - Branch: `ABC-42-slice-thing`. `` (`-slice-` not at the end) or
  `` - Branch: `ABC-42-short-slice-`. `` (no digits), the name is kept and the slice is appended:
  `ABC-42-slice-thing-slice-2` and `ABC-42-short-slice--slice-2`.
- [ ] 15. Negative: with Notes `` - Branch: `ABC-42-slice-1`. ``, dropping the suffix leaves
  `ABC-42`, which does not start with `ABC-42-`, so the name comes from the spec's file name:
  `ABC-42-thing-slice-2`.
- [ ] 16. The slice's pull request is opened by `slice-deliver` in this repo, passes
  `Run Pull Request Checks`, and pull request 3 is closed with a link to it.

## Out of Scope

- Changing what any skill does, beyond the slice branch fix. The skills read the new stack rule
  as they read the others.
- SonarQube Cloud, Docker and Trivy for this repo.
- Changing the `main` ruleset in the repo: GitHub holds it, and Ogonna changes it.
- A publish or release workflow.
- Checking in `verify.sh` that `AGENTS.md`'s Repo profile is complete.
- Editing specs 0001 and 0002.

## Decisions

| Topic | Decision |
|---|---|
| Stack rule | A new `rules/stack/shell-markdown.md`, not a `none` value the skills accept. Author, 20 November 2026: no skill changes, and the toolkit's shell conventions sit where the skills already look. |
| Coverage | `shell-markdown.md` states that bats has no figure and that every changed script behaviour has a bats test in its place. 20 November 2026. |
| Constraints | In `doc/constraints.md`, named from `AGENTS.md`, the same shape as a consuming repo. Author, 20 November 2026. |
| Required check | Ogonna adds `Run Pull Request Checks` to the `main` ruleset after slice 2 merges and the check has run green. Author, 20 November 2026. |
| Sonar, Docker, Trivy | Do not apply; recorded as a deviation in `doc/constraints.md`. Author, 20 November 2026. |
| CODEOWNERS | Added, naming only the team `@DEFRA/waste-manage-account`, as line 5 of `DEFRA/waste-organisations`'s file. Author, 20 November 2026. |
| `--plugin-dir` | Documented in `README.md` for people, with a pointer from `doc/constraints.md` for the AI tool. Author, 20 November 2026. |
| Order | Self-use first, by hand; CI second; the slice branch fix last, through `slice-deliver`. Author, 20 November 2026. |
| Spec file naming | `NNNN-<ticket-id>-slug.md`, the ticket id left out when the work has no Jira story; this spec carries MAV-42. Author, 20 November 2026, changing the "Spec file names" decision of spec 0001 for later specs. |
| Pull request 3 | Its fix and tests are carried here; the author closes it once slice 3 merges. Author, 20 November 2026. |

## Open Questions

None open.

## Dependencies

- Slice 2 needs the `@DEFRA/waste-manage-account` team to have write access to this repo, or
  GitHub ignores the `CODEOWNERS` rule.
- Adding the required check needs admin rights on this repo.
- Slice 3 needs slices 1 and 2 merged, and the ralph loop on the developer's machine.

## Risks

Low.

- **Testing the installed version by mistake.** A contributor who forgets `--plugin-dir .` tests
  `main`, not the branch. Mitigated by the README section and the pull request template's "How to
  test".
- **Bats tests that need a git identity.** Tests that commit fixtures may fail on a CI runner with
  no `user.name` and `user.email`. Slice 2 sets them in the workflow or the tests if they do.
- **Tool differences between macOS and Ubuntu.** A script that passes locally on BSD tools may fail
  on the runner's GNU tools, or the reverse. CI makes this visible; the stack rule asks for both.
- **Branch names.** `slice.sh` requires a slice's branch to start with the spec's ticket id, so
  slice 3 runs on `MAV-42-toolkit-uses-own-skills-slice-3`. Slices 1 and 2 use the same
  convention by hand. The spec itself is on `MAV-42-toolkit-uses-own-skills`, the story's branch,
  which no slice reuses.

## Notes

- Branch: `MAV-42-toolkit-uses-own-skills`. Each slice adds `-slice-<n>`.
- `verify.sh` does not scan `AGENTS.md`, `doc/`, `specs/` or `.github/`, so naming
  `waste-organisations` there is allowed. `skills/` and `rules/shared/` stay free of its tokens.
- The job name and id match `DEFRA/waste-organisations`, so the required check has the same name
  across the Manage Account repos.
