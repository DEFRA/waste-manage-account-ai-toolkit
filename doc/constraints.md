# Constraints of waste-manage-account-ai-toolkit

Rules that exist only in this repo, and its accepted deviations from the shared rules of the
Manage Account AI toolkit. `AGENTS.md` sends an AI coding tool here before it changes a skill, a
rule, a template, a script, a test or a workflow. Where a line here disagrees with a toolkit rule,
this file wins.

## What does not apply

- **SonarQube Cloud, Docker, Trivy and `rules/shared/containers.md`.** The toolkit has no runtime
  code, no coverage figure and no image. `shellcheck`, run by `./verify.sh`, is its static
  analysis. Accepted deviation from `rules/shared/continuous-integration.md` and
  `rules/shared/common-coding.md`, 20 November 2026 (spec 0003).
- **CDP release tagging.** CDP does not build this repo; releases are tagged in this repo, as the
  README's "Change control" says.

## Code

- Skills, shared rules and templates stay generic. A skill or template reads what is particular to
  a repo from that repo's Repo profile or constraints file; it never names a consuming repo, a
  project, a port or a command of one. `./verify.sh` checks its token lists; review checks the
  rest (the `generic` lens).
- A stack rule may name its stack's tools; `rules/shared/` may not (`./verify.sh` checks).
- A change to a skill, `install.sh`, the session-start hook or `shared-instructions.md` keeps it
  working in both Claude Code and Codex (the `two-tools` lens).
- Never edit a delivered spec. A change to what a delivered spec decided is a new spec.

## Tests

- `bats tests/` runs every test file; each script has its own, as the Repo profile's Test projects
  list. A test builds its fixture in a temporary folder and touches nothing outside it.
- There is no coverage figure: `rules/stack/shell-markdown.md` says what replaces it.

## Security, configuration and logging

- No secrets: the toolkit holds none and needs none. `install.sh` clones a public repo over HTTPS.

## Continuous integration

- `.github/workflows/check-pull-request.yml` runs on every pull request to `main`. Its one job,
  `Run Pull Request Checks`, installs `bats` and runs the Gate commands in order: `./verify.sh`,
  then `bats tests/`. A command added to the Gate commands is added to the job in the same change.
- `.github/CODEOWNERS` makes the `@DEFRA/waste-manage-account` team the owner of every path, for
  the ruleset's code-owner review.
- Branch ruleset `main`, read on 20 November 2026: no deletion; no force push; a pull request
  with one approving review and code-owner review, stale approvals dismissed on push, approval of
  unattributed changes required, and every review thread resolved; squash or merge only; signed
  commits. No required status check yet: the repo's owner adds `Run Pull Request Checks` after
  slice 2 merges and records the date here.

## Git and pull requests

- Branch commits follow Conventional Commits as `AGENTS.md` states, with no tool signatures or
  co-author trailers.
- A pull request title carries the Jira key, `<ticket-id>: Summary`, when the work has a story,
  and is the summary alone when it has none, as `rules/shared/git-workflow.md` says.
- A pull request follows `.github/PULL_REQUEST_TEMPLATE.md`.

## Local procedures

### Test a change to the toolkit

The installed plugin runs from Claude Code's plugin cache, which follows `main`, so a session
started the usual way runs `main`'s skills and hook, not your branch's. Start Claude Code with
`claude --plugin-dir .` from this checkout to run the branch's. For Codex, run
`bash install.sh --dir .` from this checkout, and `bash install.sh` afterwards to go back to
`main`. The README's "Test a change to the toolkit" gives the steps.
