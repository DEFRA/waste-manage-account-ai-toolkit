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

| Skill | Claude Code | Codex |
|---|---|---|
| commit | `wma-ai-toolkit:commit` | `$commit` |
| spec-clarify | `wma-ai-toolkit:spec-clarify` | `$spec-clarify` |
| slice-deliver | `wma-ai-toolkit:slice-deliver` | `$slice-deliver` |
| pr-review | `wma-ai-toolkit:pr-review` | `$pr-review` |
| pr-preflight | `wma-ai-toolkit:pr-preflight` | `$pr-preflight` |

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
