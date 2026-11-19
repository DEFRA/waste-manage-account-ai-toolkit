# AI-assisted development

Shared by the Manage Account repos. These rules were in every repo's `AGENTS.md` before the toolkit; they apply to every task an AI coding tool takes on, whether or not a skill is running.

## Before any change

- Read the repo's `AGENTS.md` and the rule that matches the task before changing anything.
- If a request conflicts with these rules or the repo's `AGENTS.md`, say so and stop. Never proceed silently or work round a rule.
- When a task matches a toolkit skill, follow the skill rather than improvising.
- A human developer reviews and approves every pull request. AI review supplements that review and never approves.

## Scope of AI changes

- An AI-suggested change must be in spec: the linked story's acceptance criteria, plus these rules applied to the lines the change touches.
- A valuable finding outside that scope is raised as a suggested new Jira story, never as a change or a change request on the pull request.

## Specs

- Specs live in the Repo profile's `Specs folder` and are named by its `Spec file naming`. A new spec is written with the `spec-clarify` skill, so it has the sections, the sources and the positive and negative acceptance criteria the team expects.
- Every spec has a "Work breakdown" table, one slice per pull request, with a single slice when the work is one pull request. A spec whose work would exceed the pull request size guide in [git-workflow.md](git-workflow.md), or that mixes concerns, stays one spec and is sliced in that table before development starts. Work is never split into child specs.
- A delivered spec, one whose story is merged, is a record of what was built and why. Never edit it, not even its open questions, decisions or notes. When new work changes something it decided, record the change and its reason in the new spec and name the spec it supersedes.
- Edit a spec only while its own story is still in progress. A spec that already exists is never renamed.

## Ralph loop

- One plan item per iteration.
- Never stage or commit the loop's artefacts: `IMPLEMENTATION_PLAN.md`, `PROGRESS.md`, `PROMPT_*.md`, `ralph.yaml` and `.ralph/`. The repo's `.gitignore` lists them.
- Stop and report, instead of forcing a fix, when a test of a path in the Repo profile's `Frozen artefacts` fails, when a delivered spec would need editing, or when an acceptance criterion cannot be met without a decision.

## Prompts and context

- Never put secrets, credentials or personal data into prompts, specs, tickets or test data. Test data is synthetic.
- Reference files, specs and standards by path or link; do not paste them into prompts or rules.
