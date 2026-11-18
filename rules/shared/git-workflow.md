# Git workflow: version control, commits and pull requests

Shared by the Manage Account repos from the DEFRA [version control standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/version_control_standards.md), [pull requests process](https://github.com/DEFRA/software-development-standards/blob/main/docs/processes/pull_requests.md) and [developer workflows guide](https://github.com/DEFRA/software-development-standards/blob/main/docs/guides/developer_workflows.md). Last synced 9 November 2026.

## Version control standards

- All code is held in the Defra GitHub organisation.
- GitHub flow: `main` plus short-lived story branches. CDP supports no other workflow.
- `main` is protected by repository rulesets: the repo's `AGENTS.md` lists its branch rulesets. No direct commits to `main`, ever.
- Releases are tagged and versioned by the CDP build action on every merge to `main`. **Accepted deviation:** the version number lives in the CDP tag, not in the source code, because CDP owns release versioning for everything it hosts.

## Pull request process

Goals: focused PRs, simple reviews, a clean commit history, and respect for reviewers' time.

1. **Always on a branch.** However small the change: `git checkout -b <ticket-id>-<slug>`, where `<ticket-id>` is the story's Jira key, whatever its project. A branch that delivers one slice of a spec ends with the slice: `<ticket-id>-<slug>-slice-<n>`. The DEFRA process uses a plain descriptive name; these repos prefix the Jira key so the PR title and story link can be derived from it. Dependabot branches are exempt. Work that is not associated with a Jira story takes no key: the branch has a short descriptive name and the PR title is the summary alone. Never invent a placeholder key.
2. **Start with an empty commit** (`git commit --allow-empty`) using this template, so the PR is visible from the start:

   ```text
   50 character limited title

   Jira story key of the originating story or bug

   Description covering why we're making this change, and briefly what the change is.
   ```

   Cover **the actual change you intend to make**, not a repeat of the backlog story; the Jira story key provides that context.

3. **Push immediately and open the PR** (`git push -u origin <ticket-id>-<slug>`). Title it `<ticket-id>: summary`, or the summary alone when the work has no Jira story, and fill in the Repo profile `Pull request template`, which GitHub offers in place of the commit message; the empty commit still carries the why in the history. Assign yourself. Open it as a draft until it is ready for review, and complete the "How to test" section before you request review.
4. **Code, committing frequently** with the `commit` skill: Conventional Commits subjects and short bulleted bodies (see "Commit messages" below). Keep `WIP` noise to a minimum; the messages are visible in the PR.
5. **Keep your branch up to date** with `git rebase origin/main` (preferred over merge, to keep the PR history clean). Never rebase or force-push a branch someone else is working on.
6. **Keep the PR small.** One spec slice or one plan item per PR. A PR that mixes a schema change, an endpoint and a refactor is three PRs. Size guide: at most about 800 non-generated changed lines, where generated means the paths in the Repo profile `Frozen artefacts`; above that, split by spec slice before asking for review. Count the lines, added plus removed, with `git diff --numstat origin/main...HEAD -- . ':!<pattern>' | awk '{ n += $1 + $2 } END { print n + 0 }'`, one `':!<pattern>'` per `Frozen artefacts` pattern, and give the figure on the `Size:` line of the PR description. The `pr-review` and `pr-preflight` skills flag a PR over the guide with a suggested split point. The figure was proposed in November 2026 and the team can revise it here.
7. **Get it reviewed.** At least one other developer must review and approve before merge; the repo's branch rulesets may require more. AI review (the `pr-preflight` and `pr-review` skills) prepares for the human review and never replaces or approves it.
8. **Squash and merge**, then **delete the branch**. The squash commit is what `main` records: its subject is the PR title and its body is the PR description, never the list of every branch commit message, which would also carry any co-author trailers onto `main`. With one commit in the PR, GitHub uses that commit's subject, so give it the `<ticket-id>: ` prefix too.

## Pull request description

The description follows the Repo profile `Pull request template`:

- **Why**: why the change is needed and briefly what it does, with the Jira story key, or `Jira: none` with the reason when the work has no story, the spec file where one exists, and the size: the non-generated changed lines against the size guide (step 6 above). Not a copy of the story.
- **What changed**: one bullet per behaviour change, not per file.
- **How to test**: everything QA or another developer needs to verify the change without reading the code: environment, preconditions (data, configuration, credentials), numbered steps with the expected result, the negative cases, the automated tests and spec scenarios that cover the change, and what still needs a human. Required for any behaviour, schema or configuration change; "No behaviour change: <reason>" is acceptable for a docs-only or tooling PR.
- **Checklist**: within the size guide, the gate, tests and coverage, no PII or secrets, docs updated.

This is how the repos meet the DEFRA quality assurance standard's expectation that each story's testing is documented alongside the story. The `pr-review` and `pr-preflight` skills check that "How to test" is present, matches the diff and could be followed without reading the code.

## Commit messages

**Branch commits** follow [Conventional Commits](https://www.conventionalcommits.org/): `<type>(<scope>): <subject>` with an imperative subject of at most 50 characters and an optional body of at most three short bullets. The toolkit's `commit` skill produces this format. Branch commits never reach `main`, so they carry no Jira key, and the DEFRA process asks only that interim messages are not ignored. No tool signatures or co-author trailers.

**The PR title and the squash commit** are what `main` records, so the DEFRA commit message rules apply to them, and to the empty commit that opens the PR:

1. Separate subject from body with a blank line
2. Limit the subject line to 50 characters
3. Capitalise the subject line
4. Do not end the subject line with a period
5. Use the imperative mood in the subject line (_Add ability_, not _Added ability_)
6. Use the body to explain _what and why_, not _how_, and name the Jira story key where one exists

Source: [How to write a Git commit message](https://chris.beams.io/posts/git-commit/), as adopted by the DEFRA pull requests process.

## Ralph loop commits

- The build loop commits with the `commit` skill after the full gate passes, one plan item per commit or per small set of atomic commits.
- Loop artefacts (`IMPLEMENTATION_PLAN.md`, `PROGRESS.md`, `PROMPT_*.md`, `.ralph/`) are gitignored and never staged.
- Merging to `main` is always a human's squash merge after review; the loop pushes to the story branch only.
