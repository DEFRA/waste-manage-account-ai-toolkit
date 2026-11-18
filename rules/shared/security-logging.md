# Security and logging standards

Shared by the Manage Account repos from the DEFRA [security standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/security_standards.md), [logging standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/logging_standards.md), [security principles](https://github.com/DEFRA/software-development-standards/blob/main/docs/principles/security_principles.md) and [application credentials guide](https://github.com/DEFRA/software-development-standards/blob/main/docs/guides/application_credentials.md). Last synced 9 November 2026.

The repo's `AGENTS.md` records the DEFRA criteria that do not apply to it.

## Secure coding

- Follow the [OWASP Secure Coding Practices quick reference guide](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/) (version 2).
- Secure development is everyone's concern; security is woven into everyday practice, not bolted on.
- Validate all input at the boundary. Return a safe error; never leak stack traces, exception text, SQL or connection strings.
- Deny by default: every route requires authentication and authorisation unless it is a deliberate, documented exception.
- Never log, echo or include in a response the `Authorization` header, an API key secret or a token.

## Secrets and credentials

- Credentials come from the CDP secrets mechanism as environment variables.
- Never commit credentials, tokens, connection strings or `.env` values. Development-only values live only in the local configuration the repo's `AGENTS.md` names, and must never be reused anywhere else.

## GitHub Advanced Security

Defra has GitHub Advanced Security enabled organisation-wide. Maximise these built-in features rather than third-party tools:

- **Dependency graph** enabled (foundation for the features below).
- **Dependabot** raises PRs for vulnerable or outdated dependencies, with grouped updates to reduce noise.
- **Dependency audit**: the stack rule names the audit that fails the PR check on a package with a known vulnerability. Never switch the audit off or lower its level.
- **Security tab** reviewed regularly: Dependabot alerts, code scanning alerts, secret scanning alerts. Open alerts are resolved, not left to age.
- If a secret ever reaches git history, treat it as compromised and follow the DEFRA [credential exposure process](https://github.com/DEFRA/software-development-standards/blob/main/docs/processes/credential_exposure.md): rotate first, then clean the history.
- Never bypass GitHub push protection or dismiss a security alert without the approval described in [resolving GitHub security alerts](https://github.com/DEFRA/software-development-standards/blob/main/docs/processes/github_security_alerts.md) (post in `#github-support`).

## Logging

The stack rule names the logger and format. Always log through it; never write to the console directly or add a second logging library.

### Only log useful information

Errors, warnings, informational messages, debug messages and audit events. Be aware of what third-party libraries log and configure them rather than letting them log payloads or headers.

### Log levels per environment

Levels stay configurable through configuration and environment variables; never hard-code a level. Baseline, following the DEFRA standard: **development** debug or information; **test and staging** warnings and errors; **production** errors and critical warnings.

### Use structured logs

Follow the [Elastic Common Schema (ECS)](https://www.elastic.co/docs/reference/ecs), applied by the formatter the stack rule names. Do not invent custom log formats or fields.

### Never log PII or sensitive data

Sanitise before logging. This includes, but is not limited to: names, addresses, email addresses, phone numbers, National Insurance numbers, company registration details tied to a person, bank details, usernames, passwords, API keys and tokens. Log identifiers (a record id, the request id) instead of values. Never log a request or response body.

### Centralised logging and protective monitoring

Logs go to stdout and are aggregated by CDP's centralised logging. Protective monitoring events (authentication failures, access control changes, configuration changes, significant decisions) should be sent to the Security Operations Centre; engage the SOC team for guidance before adding such events.
