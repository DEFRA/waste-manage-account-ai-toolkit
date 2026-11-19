<!-- Title: <ticket-id>: Short summary (imperative, capitalised, 50 characters, no trailing period). No prefix when the work has no Jira story. See rules/shared/git-workflow.md in the AI toolkit (https://github.com/DEFRA/waste-manage-account-ai-toolkit). -->

## Why

<!-- Why this change is needed and briefly what it does. Not a copy of the story. -->

Jira: <!-- the ticket id, or "none" with the reason when the work has no Jira story -->
Spec: <!-- the spec file, or "none" -->
Size: <!-- N non-generated changed lines (added plus removed, without <this repo's generated files>), against the guide of about 800. See "Keep the PR small" in the AI toolkit's rules/shared/git-workflow.md for the command -->

## What changed

- <!-- One bullet per behaviour change, not per file -->

## How to test

<!-- Everything QA or another developer needs to verify this change without reading the code.
     Required for any behaviour, schema or configuration change. For a docs-only or tooling PR,
     replace this section with "No behaviour change: <reason>". -->

**Environment:** <!-- <how to run this repo locally>; and/or the CDP environment -->
**Preconditions:** <!-- <data, services, configuration or secrets needed> -->

### Steps

1. <!-- What to do. Expected: the result -->
2. <!-- Negative case: <the conditions this repo must refuse or fail on>. Expected: the result -->

### Automated tests

- <!-- The tests or spec scenarios covering this change -->

### Not covered

- <!-- What needs a human, or can only be confirmed on CDP after merge -->

## Checklist

- [ ] Size counted and given on the `Size:` line above (about 800 non-generated changed lines is a guide, not a limit)
- [ ] Full gate run locally: <the Repo profile's Gate commands>
- [ ] Tests added or updated; coverage not decreased
- [ ] No PII or secrets in code, logs or test data
- [ ] README or spec updated where behaviour or setup changed
- [ ] New dependencies pinned to exact versions, with the reason for choosing them in the description
- [ ] <checks particular to this repo>
