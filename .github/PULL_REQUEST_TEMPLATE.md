<!-- Title: <ticket-id>: Short summary (imperative, capitalised, 50 characters, no trailing period). No prefix when the work has no Jira story. See rules/shared/git-workflow.md. -->

## Why

<!-- Why this change is needed and briefly what it does. Not a copy of the story. -->

Jira: <!-- the ticket id, or "none" with the reason when the work has no Jira story -->
Spec: <!-- the spec file, or "none" -->
Size: <!-- N changed lines (added plus removed; this repo has no generated files), against the guide of about 800. See "Keep the PR small" in rules/shared/git-workflow.md for the command -->

## What changed

- <!-- One bullet per behaviour change, not per file -->

## How to test

<!-- Everything another developer needs to verify this change without reading the code.
     Required for any change to a skill, script, hook, template or workflow. For a change to a
     rule's or spec's text only, replace this section with "No behaviour change: <reason>". -->

**Environment:** <!-- Claude Code started with `claude --plugin-dir .` from this branch's checkout, and/or Codex after `bash install.sh --dir .`; the consuming repo the skill is run in, if any -->
**Preconditions:** <!-- the Repo profile, spec or branch the run needs -->

### Steps

1. <!-- What to do. Expected: the result -->
2. <!-- Negative case: a missing Repo profile entry, a missing tool, or input the script must refuse. Expected: the result -->

### Automated tests

- <!-- The bats tests covering this change -->

### Not covered

- <!-- What needs a human, such as running the skill in Codex or in a consuming repo -->

## Checklist

- [ ] Size counted and given on the `Size:` line above (about 800 changed lines is a guide, not a limit)
- [ ] Full gate run locally: `./verify.sh` then `bats tests/`
- [ ] Every changed script behaviour has a bats test, negative cases included
- [ ] No PII or secrets in scripts, tests or fixtures
- [ ] README, `doc/constraints.md` or spec updated where behaviour or setup changed
- [ ] Skills, shared rules and templates stay generic: no consuming repo's names, ports or commands
- [ ] A change to a skill, `install.sh`, the hook or `shared-instructions.md` works in both Claude Code and Codex
- [ ] Every action in a changed workflow is pinned to a full commit SHA with its version as a comment
- [ ] No delivered spec edited
