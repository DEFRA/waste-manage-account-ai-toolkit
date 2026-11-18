# Common coding standards

Shared by the Manage Account repos from the DEFRA [common coding standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/common_coding_standards.md) and [coding principles](https://github.com/DEFRA/software-development-standards/blob/main/docs/principles/coding_principles.md). Last synced 9 November 2026.

## Principles

- **Main is always shippable**: the main branch is always in a state of 'shippable to production': tested, styled, documented, building.
- **The code is not yours**: write and commit code for the next developer, who will not have your context. They must be able to derive intent from the code alone.
- **Work in the open**: code is open as early as possible; going private is the managed exception.
- **Code securely** and **we test our code**: every change is provably correct through tests.

## Standards

- All coding is done on a branch; no changes directly to `main`.
- All branches have CI covering code style, security checking, dependency checking, build and unit tests.
- Unit test coverage meets the coverage figure in the stack rule. Every change has sufficient coverage and total coverage must not decrease.
- All code is reviewed by another developer before merge.
- All repos are connected to SonarQube Cloud and the Defra standard quality gate is met.
- All code is checked for security and dependency vulnerabilities: no out-of-date dependencies or libraries with known vulnerabilities.

## Readability

- No generic names: `p`, `temp`, `v`, `data2`, `x`.
- Prefer named fields over positional tuples and arrays: a value whose parts have names reads; a list of bare values does not.
- Avoid unexplained acronyms, especially domain-specific ones (CDP, EPR). Spell one out where it is first used in a file.
- Name things for the intent of the thing and the person who comes after you, not what makes sense to you today.
- Stick to the conventions of the language and framework in use, as encoded in the repo's formatter and linter settings and the existing code.
- **Separate in order to name**: break code into small functions whose names express intent. Aim for code that needs no comments.

### Comments (when unavoidable)

- Comments are code: keep them small and refactor them as the code changes.
- Document _why_ the thing is needed or why it is done this way, never the _how_.
- Comment in the right place: a decision where it bites. Point at the spec that made the decision.
- Only write about the code: no names, dates, commit references or opinions.
- Never leave commented-out code; git history is the record.
- Write comments as you write the code, or you never will.

## Simplicity

- Do not code for reuse until there is a confirmed need for reuse.
- Apply the [rule of three](<https://en.wikipedia.org/wiki/Rule_of_three_(computer_programming)>) before abstracting.
- Do not break the application apart until there is a confirmed need. The path to reuse is: module or namespace, then shared package, then (only with proven multi-service demand) a separate application.

## Documentation and licensing

- Document the _how_ for the project: how to build, run, test and use it. The README follows the DEFRA [README standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/readme_standards.md); update it when setup, run or test steps change.
- Design decisions live in the spec files in the Repo profile's `Specs folder`, not in chat history or commit messages alone.
- The repo carries the Open Government Licence v3 and the README states the licence.
