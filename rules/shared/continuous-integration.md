# Continuous integration standards

Shared by the Manage Account repos from the DEFRA [continuous integration standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/continuous_integration.md). Last synced 9 November 2026.

## What CI must check

Every branch build verifies: the code builds, tests pass, code style passes, code quality passes (SonarQube Cloud) and security checks pass.

The pull request check runs the Repo profile `Gate commands`, the same gate a developer runs locally before a PR is proposed. A command added to one is added to the other in the same change.

## Branch protection

`main` is protected by a repository ruleset requiring the pull request check, approving reviews, resolved review threads and signed commits. The required check is the job's `name`. Renaming the job renames the required check: update the ruleset in the same change, or the PR cannot merge.

## GitHub Actions

Use GitHub Actions for CI builds. The publish workflow calls Defra's `cdp-build-action`; do not replace it with a bespoke build or deployment.

### Commit SHA pinning (required)

Pin every action to a full-length commit SHA, never a tag or branch. Tags and branches can be moved by an attacker who compromises the action's repository, an increasingly common supply-chain attack. Reference the version as a trailing comment for clarity:

```yaml
# Use:
uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7

# Not:
uses: actions/checkout@v7
# Nor:
uses: actions/checkout@main
```

To update an action, test the new version, then update the SHA and the comment together. Find the SHA by viewing the commit for the target tag in the action's repository; never write one from memory.

### Permissions

A workflow declares the least `permissions` it needs. Write permissions and `id-token: write` belong to the workflow that publishes, not to the pull request check.

## Maintainability and test coverage

SonarQube Cloud (Defra organisation) runs in CI and the Defra standard quality gate must be met. The coverage figure and the tests that report it are in the stack rule.
