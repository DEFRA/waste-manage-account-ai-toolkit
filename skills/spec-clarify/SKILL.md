---
name: spec-clarify
description: >
  Turn a Jira story, bug or rough idea for this repo into a spec in its specs folder, in the repo's
  spec format, by asking the author questions one topic at a time: problem, scope, testable
  acceptance criteria with negative cases, risks, priority, size. Writes one spec file, named by
  the repo's spec file naming, and nothing else; never implements and never edits a delivered spec.
  Use whenever asked to write, draft, refine or clarify a spec or story, for example
  "/spec-clarify ABC-123 ...", "/clarify", "write the spec for ABC-123", "turn this story into a
  spec", "refine this idea". Every spec has a Work breakdown, one slice per pull request, also
  when there is only one; work is never split into child specs.
---

# Spec clarify

This skill produces a spec in the format below, named by the Repo profile's `Spec file naming`
and written to its `Specs folder`.

You are running an idea refinement workshop with the developer. The output is a spec that a
reviewer can approve and that a developer, or an AI coding tool, can implement without asking
the author what was meant.

## Toolkit root

`TOOLKIT_ROOT` is the folder two levels above this `SKILL.md`, resolved with `readlink -f` so
that a symlinked install still finds the toolkit:

```bash
TOOLKIT_ROOT="$(dirname "$(dirname "$(dirname "$(readlink -f <path of this SKILL.md>)")")")"
```

Read every `rules/shared/<name>.md` and `rules/stack/<name>.md` this skill names under
`TOOLKIT_ROOT`, never under the consuming repository.

The consuming repo's own rules are its `AGENTS.md` and the constraints file that `AGENTS.md`
names under `## Constraints`. Read both; where they disagree with a toolkit rule, they win.

## Usage

`/spec-clarify <ticket-id> <one-line idea>` in Claude Code, or `$spec-clarify` in Codex. Without
an argument, ask for the story key and a one-line description first.

## Repo profile

Read the `## Repo profile` table in the consuming repo's `AGENTS.md` before anything else, and
take these entries from it:

- `Specs folder`: where specs live and where the new spec is written.
- `Spec file naming`: the new spec's file name pattern.
- `Test projects`: the projects a test for an acceptance criterion lives in.
- `Stack rule`: the stack rule under `rules/stack/` that applies to this repo.

When the table or one of these entries is absent, stop and report
`Repo profile: missing <entry>`. Never guess a folder, a name or a project.

## Ground rules

- **Ask, do not assume.** Work through the phases below one topic at a time, in chat, offering
  options where you can and waiting for the answer. Use the tool's question facility if it has
  one; plain questions in chat are fine otherwise.
- **Read before asking.** Read `AGENTS.md`, the `Specs only` ground rule below, the latest two
  specs in the `Specs folder` for format and prior decisions, and the code the idea touches.
  Confirm what already exists with a code search before calling anything missing.
- **Sources are referenced, not pasted.** Ask the author to paste the Jira story text, comments
  and the relevant Confluence section if you cannot read them; cite them by title and date in the
  spec. Never put credentials or personal data into the spec.
- **Specs only.** Write one file in the `Specs folder`. Do not change code, tests or any other
  spec. A delivered spec (one whose story is merged) is never edited: a change to something it
  decided is recorded in the new spec's Decisions with the earlier spec named.
- **Testable means testable here.** Every acceptance criterion names an observable result a
  test in a project in `Test projects` can check.

## Phases

### 1. Understand

Establish: the problem or opportunity, who benefits (Manage Account, other W&CE services, the
team, operations), what triggered it, and what success looks like. Then search the code and
record what is already in place, with file names.

### 2. Classify

Feature, Bug, Improvement, Spike (time-boxed research), Task (no direct user impact), or Epic.
An Epic is not one spec: say so and ask which of its stories to specify first.

### 3. Scope

What is in, what is explicitly out, what the minimum is. Ask about anything an earlier spec
decided that this work would change; those become Decisions that name the superseded spec.

### 4. Acceptance criteria

Three to twelve criteria, each one line, each checkable by a test. Cover the negative paths as
carefully as the positive, starting from the default criteria in
`rules/shared/quality-assurance.md` and the stack rule's acceptance criteria defaults. Map Jira
scenarios to criteria by number. Bugs get current behaviour, expected behaviour, steps to
reproduce and impact in Problem/Opportunity, and a criterion that the bug no longer occurs.

### 5. Risk and dependencies

Unknowns, risky areas, dependencies on other stories or teams, and a risk level (low, medium,
high) with the reason. For high uncertainty, propose a spike spec first.

### 6. Priority

P0 critical (blocking), P1 high, P2 medium (default), P3 low, P4 backlog, with the rationale.

### 7. Size

Estimate the pull requests the work needs and write the Work breakdown table in every spec, also
when the work is one pull request: the table then has one slice. The reader finds the number of
pull requests in the same place in every spec, and "build slice 1 of spec NNNN" always works. A
spec is one pull request when its non-generated change stays within the size guide in
`rules/shared/git-workflow.md` and mixes no unrelated concerns; say so, with the estimate, in a
line above the table. If it needs more, slice it: the spec stays one file and is never split into
child specs. Each slice is one pull request, built on its own and in order ("build slice 1 of spec
NNNN"); when every slice is merged, the spec's development is complete. Write each slice to stand
alone:

- **One slice is still a table.** Its Work names what the pull request builds, as any slice does,
  and its Verified by names the test projects and every acceptance criterion.
- **Slice a pull request, not a task.** A slice has its own observable result and its own tests.
  Never a "README", "tests" or "run the full suite" slice: documentation, tests and the full gate
  belong to every slice.
- **Work says what the slice builds and where it stops.** Name the files and types, and the
  Proposed Solution subsections it implements. Where a reader could expect more, say what is left
  to a later slice.
- **Verified by is provable.** Name the test project and the result it shows, and the acceptance
  criteria the slice satisfies.
- **Order is build order.** A slice may rely only on earlier slices, and every slice leaves main
  shippable: nothing needs a later slice to compile or pass the gate.
- **Do not over-slice.** Split only for the size guide or for mixed concerns. Fold a slice with
  nothing of its own to verify into its neighbour; prefer fewer, well-bounded slices to many small
  ones, since each costs a review.
- **Every acceptance criterion is covered by a slice.** Confirm the slices with the author before
  writing them.

### 8. Write the spec

Path: the `Specs folder` and a file name following `Spec file naming`, where `NNNN` is the next
number after the highest in the `Specs folder` and the slug comes from the story title. Use this
structure, with the section headings exactly as written:

```markdown
# <ticket-id>: Title

| | |
|---|---|
| Type | Feature / Bug / Improvement / Spike / Task, with one sentence on what changes and what does not |
| Priority | P0 to P4 with the rationale |
| Parent | Parent story or epic, if any |
| Risk | Low / Medium / High (see Risks) |
| Source | Jira story and comments by date, Confluence pages by title and version, refinement answers by date |

## Problem/Opportunity

## Proposed Solution

(subsections as needed, following the stack rule; always end with "### Work breakdown", one
slice per pull request, a single slice when the work is one pull request)

### Work breakdown

(one line: how many pull requests the work needs and why, with the size estimate)

| Slice | Work | Verified by |
|---|---|---|
| 1 | what the slice builds and where it stops | the tests in `Test projects` and the acceptance criteria it meets |

## Acceptance Criteria

- [ ] one line per criterion, Jira scenario numbers in brackets

## Out of Scope

## Decisions

| Topic | Decision |
|---|---|
| ... | what was decided, when, why; name any earlier spec it supersedes |

## Open Questions

## Dependencies

## Risks

## Notes
```

British English, absolute dates, no pasted sources, no personal data. Keep the Proposed Solution
concrete enough to implement from: field names, file and folder names that follow
`rules/stack/<Stack rule>.md`.

### 9. Present and confirm

Show the author the type, priority, title, acceptance criteria and open questions, and ask
whether the spec says what they meant. Adjust until it does.

### 10. Next steps

Say which applies: the Work breakdown has one slice and development can start; it has several
slices and development starts with slice 1; it needs a spike first; or open questions block it and who
can answer them. A
spec can be reviewed as its own pull request before implementation starts; recommend that for
anything larger than one slice.

## Do and do not

Do:

- Push for concrete, testable criteria and for the negative cases.
- Make exclusions explicit; Out of Scope is where scope creep is stopped.
- Name the earlier spec whenever a decision changes something it decided.
- Record who decided what and when in Decisions, so the spec is a record, not just a plan.
- Write the Work breakdown in every spec: one slice when the work fits one pull request,
  otherwise slices that each stand alone.

Do not:

- Accept vague criteria ("make validation better", "improve performance").
- Skip the "why"; the Problem/Opportunity section is what a reviewer judges the solution against.
- Edit a delivered spec, or paste its text into the new one.
- Start implementing, create branches, or change anything outside the `Specs folder`.
- Invent Jira keys, dates or decisions; ask.
