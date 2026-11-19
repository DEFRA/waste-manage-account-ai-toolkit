# <repo>

<What the repo is, in one or two sentences, and its stack.>

## Repo profile

| Entry | Value |
|---|---|
| Stack rule | <`csharp-dotnet` or `javascript-nodejs`> |
| Gate commands | <the gate commands in order, separated by `<br>`> |
| Gate prerequisites | <what must be running or free before the gate, or `none`> |
| Test projects | <each test project and what it covers, separated by `;`> |
| Specs folder | <`specs/`> |
| Spec file naming | <`NNNN-<ticket-id>-slug.md`> |
| Frozen artefacts | <paths a change must never alter, or `none`> |
| Pull request template | <`.github/PULL_REQUEST_TEMPLATE.md`> |
| Review lenses | <review lenses for this repo beyond the stack rule's, or `none`> |

## Constraints

- <A rule that exists only in this repo.>
- <An accepted deviation from a shared or stack rule, naming the rule and the reason.>

## AI toolkit

This repo requires the Manage Account AI toolkit,
`DEFRA/waste-manage-account-ai-toolkit`. It provides these skills:

| Skill | What it does | Claude Code | Codex |
|---|---|---|---|
| spec-clarify | Turns a Jira story, bug or idea into a spec with a Work breakdown; the first step of every story | `wma-ai-toolkit:spec-clarify` | `$spec-clarify` |
| slice-deliver | Delivers one slice of a spec as a pull request ready for review; never merges or requests reviewers | `wma-ai-toolkit:slice-deliver` | `$slice-deliver` |
| commit | Stages and commits finished work as atomic Conventional Commits | `wma-ai-toolkit:commit` | `$commit` |
| pr-review | Reviews a colleague's pull request and reports findings; never approves or comments | `wma-ai-toolkit:pr-review` | `$pr-review` |
| pr-preflight | Checks your own pull request before review and fixes mechanical, in-spec findings | `wma-ai-toolkit:pr-preflight` | `$pr-preflight` |

When a task matches one of these skills, follow the skill rather than improvising.

To install it:

- **Claude Code:** accept the prompt to install the `wma-ai-toolkit` plugin when you open this repo.
- **Codex:** run `install.sh` from the toolkit repo; run it again to update.

### Rules

The shared and stack rules live in the toolkit, not in this repo, and they apply to every change,
whether or not a skill is running. Before changing anything, find the toolkit folder and read the
rule that matches the task.

The toolkit folder is:

- **Claude Code:** the `installPath` of `wma-ai-toolkit@waste-manage-account-ai-toolkit` in
  `~/.claude/plugins/installed_plugins.json`.
- **Codex:** two levels above the target of the `~/.agents/skills/commit` symlink
  (`readlink -f ~/.agents/skills/commit`).

| Task | Rule, under the toolkit folder |
|---|---|
| Every task; writing or changing a spec; the ralph loop | `rules/shared/ai-assisted-development.md` |
| Writing or changing code; adding a dependency | `rules/stack/<Stack rule>.md`, the Repo profile's `Stack rule` |
| Readability, naming, comments, simplicity | `rules/shared/common-coding.md` |
| Branches, commit messages, pull requests | `rules/shared/git-workflow.md` |
| Secure coding, secrets, logging | `rules/shared/security-logging.md` |
| Acceptance criteria, tests, coverage | `rules/shared/quality-assurance.md` |
| Workflow changes | `rules/shared/continuous-integration.md` |
| Dockerfile, Compose and image changes | `rules/shared/containers.md` |

Where a rule and this file's Constraints disagree, Constraints win. Never read a rule from a copy
in this repo.

Stop and tell the developer to install the toolkit when a skill is not available or the toolkit
folder cannot be found.
