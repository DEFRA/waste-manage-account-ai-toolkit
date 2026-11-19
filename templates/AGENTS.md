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

Read [doc/constraints.md](doc/constraints.md) before changing code, tests, a workflow, the
Dockerfile or the local stack. It holds the rules that exist only in this repo and its accepted
deviations from a shared or stack rule. The ones that matter most:

- <A constraint whose breach is costly or hard to undo. Keep this list to five at most.>

## AI toolkit

This repo requires the Manage Account AI toolkit, `DEFRA/waste-manage-account-ai-toolkit`. The
skills and the shared rules live there, not in this repo. Before any task, find the toolkit folder
and read `shared-instructions.md` in it. Follow it as if it were part of this file.

The toolkit folder is:

- **Claude Code:** the `installPath` of `wma-ai-toolkit@waste-manage-account-ai-toolkit` in
  `~/.claude/plugins/installed_plugins.json`.
- **Codex:** two levels above the target of the `~/.agents/skills/commit` symlink
  (`readlink -f ~/.agents/skills/commit`).

If the folder cannot be found, or a toolkit skill is not available, stop and tell the developer to
install the toolkit:

- **Claude Code:** run `claude plugin install wma-ai-toolkit --marketplace DEFRA/waste-manage-account-ai-toolkit`
  in a terminal, then start a new session.
- **Codex:** run `install.sh` from the
  [toolkit repo](https://github.com/DEFRA/waste-manage-account-ai-toolkit); run it again to update.
