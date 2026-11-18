# Quality assurance and test standards

Shared by the Manage Account repos from the DEFRA [quality assurance and test standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/quality_assurance_standards.md) and the testing guidance in the DEFRA [GitHub Copilot guide](https://github.com/DEFRA/software-development-standards/blob/main/docs/guides/github_copilot.md). Last synced 9 November 2026.

The repo's test projects, what each pins and how each runs are the Repo profile `Test projects`. Snapshots and other files a change must not alter are the Repo profile `Frozen artefacts`: a difference in one means the behaviour changed, so stop and ask. The repo's `AGENTS.md` records the DEFRA criteria that do not apply to it.

## Acceptance criteria

- Every story has positive **and** negative acceptance criteria written in its spec before development starts. The spec names the scenarios; the tests pin them.
- Default criteria for a story: the behaviour matches the spec; validation exists for every input; unauthorised and forbidden callers are refused; no obvious performance issue; no existing behaviour has regressed.
- **Negative scenarios are as important as positive ones.** "A write client can create a record" implies "a read-only client cannot" and "a missing required field is rejected with a message naming it". Test all of them.

## Writing tests

- Follow the testing pyramid: prove logic in unit tests, persistence and wiring in integration tests, and the public contract end to end. Do not reach for a slower test when a faster one proves the same thing.
- Use the test framework and libraries the stack rule names. Do not introduce another test framework, assertion or mocking library.
- Name tests by behaviour in the repo's existing style. A test name reads as a statement about the service.
- Arrange, act, assert, with the arrangement built from the repo's shared fixtures where one exists.
- Assert on observable behaviour (status code, body, stored data, rendered output), not on implementation detail or on which internal method was called.
- Test data is synthetic. Never copy production data or real company, address or personal details into fixtures, snapshots or test names.
- Each test is independent and runs in any order. Never depend on another test's data.
- When a snapshot changes, read the diff and decide whether the behaviour change is intended by the spec before accepting it. Never accept a snapshot to make a build green.
- No skipped test committed without a Jira reference in the reason.

## Coverage

- The stack rule gives the coverage figure; it never decreases.
- Do not chase a number: a test written only to raise coverage, a near-duplicate scenario, or a test that restates the framework is a liability. Each test should prove a behaviour someone cares about.
- Never weaken, delete or skip an assertion, test or check to make a build pass. A red test is reporting something; understand it first.

## Wider QA practice

- All stories undergo risk-based exploratory testing against the local stack or a CDP environment.
- Performance testing (default tool: JMeter) covers load at 120% of the likely maximum, soak, and stress, for releases that change throughput characteristics.
- Keep the team aware of testing risks; produce a test completion report before a major release.
