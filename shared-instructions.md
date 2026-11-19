# Manage Account AI toolkit: shared instructions

Every consuming repo's `AGENTS.md` sends its AI coding tool here before any task. Follow this file as if it were part of that `AGENTS.md`. Paths below are relative to the folder this file is in, the toolkit folder.

## What wins

1. The consuming repo's `AGENTS.md`, and the constraints file its "Constraints" section names.
2. This file and the rules it points to.

Where the two disagree, the repo wins. Never read a rule or a skill from a copy in the consuming repo.

## Before any task

- Read `rules/shared/ai-assisted-development.md`. It applies to every task: when to stop, how specs are handled, the ralph loop, and what never goes into a prompt.
- Read the Repo profile in the consuming repo's `AGENTS.md`. Its `Gate commands` are the gate; never guess a command or a path it does not give.
- Before changing code, tests, a workflow, the Dockerfile or the local stack, read the constraints file the consuming repo's `AGENTS.md` names.

## Skills

The toolkit's skills are `spec-clarify`, `slice-deliver`, `commit`, `pr-review` and `pr-preflight`; the tool lists each with its description. When a task matches one of them, follow the skill rather than improvising.

## Rules

The rules apply to every change, whether or not a skill is running. Read the rule that matches the task before changing anything.

| Task | Rule |
|---|---|
| Writing or changing code; adding a dependency | `rules/stack/<Stack rule>.md`, the Repo profile's `Stack rule` |
| Readability, naming, comments, simplicity | `rules/shared/common-coding.md` |
| Branches, commit messages, pull requests | `rules/shared/git-workflow.md` |
| Secure coding, secrets, logging | `rules/shared/security-logging.md` |
| Acceptance criteria, tests, coverage | `rules/shared/quality-assurance.md` |
| Workflow changes | `rules/shared/continuous-integration.md` |
| Dockerfile, Compose and image changes | `rules/shared/containers.md` |
| Writing or changing a spec; the ralph loop | `rules/shared/ai-assisted-development.md` |
