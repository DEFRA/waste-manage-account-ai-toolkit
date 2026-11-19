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

| Skill | What it does | Claude Code | Codex |
|---|---|---|---|
| spec-clarify | Turns a Jira story, bug or idea into a spec with a Work breakdown; the first step of every story | `wma-ai-toolkit:spec-clarify` | `$spec-clarify` |
| slice-deliver | Delivers one slice of a spec as a pull request ready for review; never merges or requests reviewers | `wma-ai-toolkit:slice-deliver` | `$slice-deliver` |
| commit | Stages and commits finished work as atomic Conventional Commits | `wma-ai-toolkit:commit` | `$commit` |
| pr-review | Reviews a colleague's pull request and reports findings; never approves or comments | `wma-ai-toolkit:pr-review` | `$pr-review` |
| pr-preflight | Checks your own pull request before review and fixes mechanical, in-spec findings | `wma-ai-toolkit:pr-preflight` | `$pr-preflight` |

When a task matches one of these skills, follow the skill rather than improvising. Stop and tell the developer to install the toolkit when a skill is not available:

- **Claude Code:** accept the prompt to install the `wma-ai-toolkit` plugin on opening the repo, or run `claude plugin install wma-ai-toolkit --marketplace DEFRA/waste-manage-account-ai-toolkit` in a terminal.
- **Codex:** run `install.sh` from the toolkit repo; run it again to update.

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
