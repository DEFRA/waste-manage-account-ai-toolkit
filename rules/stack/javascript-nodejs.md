# JavaScript and Node.js standards

Shared by the Manage Account JavaScript repos from the DEFRA [JavaScript standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/javascript_standards.md) and [Node.js standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/node_standards.md). Last synced 30 July 2026. The rules for web servers and browser code (server framework, session state, front-end frameworks, progressive enhancement) apply to a web service; a test suite with no server or browser code has nothing to apply in them.

## JavaScript

- Use vanilla JavaScript. Do not use extensions to the language such as TypeScript without an approved exception: no `.ts` files, no type annotations, no JSDoc-driven type checking introduced as a workaround.
- Use ES modules (each package is `"type": "module"`). CommonJS only where a dependency genuinely requires it.
- Prefer `async`/`await` over callbacks and promise chains; avoid nested callbacks. Every promise is awaited or returned; a floating promise in a test lets it pass before its assertion has run.
- The DEFRA standard lints with [neostandard](https://github.com/neostandard/neostandard) and does not extend or modify its ruleset. Prettier owns formatting. Accepted deviations from either live in the repo's `AGENTS.md`; do not change the linter or the Prettier configuration without a team decision, and do not disable a rule inline without a comment that says why.
- Do not use front-end JavaScript frameworks (React, Vue, Angular, etc.). They conflict with [progressive enhancement](https://www.gov.uk/service-manual/technology/using-progressive-enhancement). Use [GOV.UK Design System](https://design-system.service.gov.uk/) components via govuk-frontend instead. Any framework use for a highly-functional enhancement (e.g. an interactive map) must be managed as an explicit exception.
- All pages must work without client-side JavaScript and without CSS.

## Node.js

- Node.js code follows the JavaScript standards above.
- Do not store session state on the app server. Never tie a session to a particular server instance; use a shared store, not in-process storage.
- Do not block the event loop or worker pool. Don't do too much work for any client in a single callback or task; push CPU-intensive work to another service.
- Prefer what Node provides to a dependency: `fetch` for HTTP, `AbortSignal.timeout` for a request timeout, `node:assert/strict` for assertions.
- The server framework and the test suite's layout are repo-specific; they live in the repo's `AGENTS.md` constraints.

### Versions

- Stay on Active LTS Node versions (see `.nvmrc`). Don't drop behind Maintenance LTS; don't progress beyond Active LTS.

### Package management

- Use npm only. Any other package manager requires governance approval.
- Pin all dependencies to exact versions in `package.json`: never `^`, `~`, `*`, `x` or ranges. Commit `package-lock.json` with every dependency change.
- Keep `dependencies` and `devDependencies` correctly separated: a package needed at run time in the image is a `dependency`; one used only to build, test, lint or format is a `devDependency`.
- Use `npm ci`, not `npm install`, in CI, in production Docker builds and for a local install that must match the lock file.
- Vet third-party packages before adding them: see the DEFRA [choosing packages guide](https://github.com/DEFRA/software-development-standards/blob/main/docs/guides/choosing_packages.md) and the dependency rules in the repo's `AGENTS.md`.
- **npm audit** runs in the pull request check and fails it when an installed package has an advisory at or above the repo's audit level. The command and level are in the repo's `AGENTS.md`.
- The repo `.npmrc` must keep these settings:

  | Setting               | Purpose                                                                                                                                                                                                                                |
  | --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | `save-exact=true`     | Saves exact versions; prevents version-range drift pulling in a later, potentially vulnerable release.                                                                                                                                 |
  | `ignore-scripts=true` | Blocks `preinstall`/`postinstall` lifecycle scripts — a common vector for arbitrary code execution from compromised packages. Pass `--ignore-scripts=false` per-command only when a package genuinely needs it.                        |
  | `min-release-age=7`   | Refuses packages published fewer than 7 days ago, giving time for package-takeover and typosquatting attacks to be detected. Bypass a single install with `--min-release-age=0` only after due diligence on the package and publisher. |

## Tests

See [quality-assurance.md](../shared/quality-assurance.md) for the shared test rules; the repo's test projects are its Repo profile `Test projects`.

- A service's unit tests use Vitest with coverage through `@vitest/coverage-v8`. A suite of checks against a running service uses Mocha with `node:assert/strict`.
- No `it.only` or `describe.only` is committed.

## Acceptance criteria defaults

Start from the default criteria in [quality-assurance.md](../shared/quality-assurance.md) and, for a web service, make these criteria specific to the story:

- Screens and content match the prototype or wireframe.
- Pages use GOV.UK Design System components (govuk-frontend), never hand-rolled ones.
- Pages meet WCAG 2.2 AA in all supported browsers, including mobile.
- Every field is validated on the server, with the GOV.UK error message and error summary patterns.
- The journey works without client-side JavaScript and without CSS.
- Invalid or missing input shows which message, and which field the error summary links to.
- An unauthenticated user is redirected to sign-in and back to the requested page afterwards.
- An unauthorised user sees the 403 page.
- Session expiry mid-journey and a failing back-end call each give the result the spec states.

## Review lenses

None beyond the core lenses. A lens that only one repo needs, such as the frontend's `accessibility`, is repo-only and lives in that repo's Repo profile `Review lenses`.

## Coverage

- Unit test coverage measured by Vitest must stay at or above 90% and must never decrease.
- A repo with no production code to cover, such as a smoke test suite, states so in its `AGENTS.md`.

## Logging

- Application code logs through pino with the Elastic Common Schema formatter (`@elastic/ecs-pino-format`), through the logger the server framework configures. Log levels stay configurable by environment.
- `console` is a lint error in application code: review rejects a `console` call even where the repo's linter does not flag it.
