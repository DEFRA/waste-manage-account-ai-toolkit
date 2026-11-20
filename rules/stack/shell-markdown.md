# Shell and Markdown standards

For a repo whose code is Bash scripts and Markdown, such as a toolkit of AI skills and rules,
tested with [bats](https://github.com/bats-core/bats-core). There is no DEFRA standard for either;
this rule follows the shared rules and the conventions already in use. Written 20 November 2026.

## Shell

- Bash, started with `#!/usr/bin/env bash` and `set -euo pipefail`.
- `shellcheck` reports nothing. A `# shellcheck disable=` names the check and says why on the same
  line.
- A script runs on macOS's and Ubuntu's Bash and on their BSD and GNU tools. Where the two differ
  (`sed -i`, `readlink -f`, `date`, `grep -P`), use a form both accept or test for the difference.
- Quote every expansion. Read input with `read -r`. Use `[[ ]]` for tests and `$( )` for command
  substitution.
- A script fails with a message on standard error that names what failed and exits non-zero. It
  never continues after a failed step. `|| true` is only for a command whose empty result is a
  normal answer, such as a `grep` that finds nothing; never to hide a failure.
- A function does one thing and is named for it. A comment says why, not what.
- No secrets, tokens or personal data in a script, a fixture or its output.

## Markdown

- A skill is a folder `skills/<name>/` with a `SKILL.md` in the Agent Skills format: front matter
  with `name`, equal to the folder, and `description`. Scripts a skill runs live in its `scripts/`
  folder.
- A rule covers one topic in one file and links to the standard it comes from, with the date it
  was last synced.
- Plain Markdown that any tool reads: headings, lists, tables and fenced code blocks.
- A relative link points at a file that exists.

## Dependencies

- A new tool a script needs is named in the Repo profile's `Gate prerequisites`, checked by the
  script with a message naming it when it is missing, and installed in CI.
- Prefer what Bash, `git`, `jq` and the POSIX tools give to a new tool.

## Tests

See [quality-assurance.md](../shared/quality-assurance.md) for the shared test rules; the repo's
test projects are its Repo profile `Test projects`.

- One `tests/<script>.bats` per script, named for it.
- A test builds its fixture in `$BATS_TEST_TMPDIR` or a folder it makes and removes, and touches
  nothing outside it: not the user's home, not the repo's working tree, not the network.
- Name a test by behaviour, as a statement: `@test "a slice branch comes from the story branch the
  Notes give"`.
- Assert on exit status and on output lines, not on the order of unrelated lines.

## Acceptance criteria defaults

Start from the default criteria in [quality-assurance.md](../shared/quality-assurance.md) and
make these specific to the story:

- A script change states the exit status and the output for each case, with at least one negative
  case: missing input, a missing tool, or input the script must refuse.
- A skill or rule change states what a developer sees when the skill runs, and what it stops on.
- A change that both tools use (a skill, an installer, a hook) states the result in each.

## Review lenses

None beyond the core lenses. A lens that only one repo needs lives in that repo's Repo profile
`Review lenses`.

## Coverage

- bats reports no coverage figure, so there is no figure to keep or compare.
- In its place: every changed behaviour of a script has a bats test, including its negative
  cases, and no test is removed without the behaviour it covered.
- A change to Markdown only (a skill's text, a rule) has no test; it is checked by review and by
  running the skill.
