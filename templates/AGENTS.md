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

Stop and tell the developer to install the toolkit when a skill is not available.
