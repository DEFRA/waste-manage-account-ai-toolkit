# Container standards

Shared by the Manage Account repos from the DEFRA [container standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/container_standards.md), [deployment standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/deployment_standards.md) and [Docker guidance](https://github.com/DEFRA/software-development-standards/blob/main/docs/guides/docker_guidance.md). Last synced 9 November 2026.

## Standards

- Bespoke software is delivered as Docker containers, built with Docker. Linux containers only.
- Production images are **immutable**: once built they do not change, but they are configured. All per-environment behaviour comes from environment variables set by CDP, never from values baked into the image.
- Images are **self-contained** and carry all runtime dependencies; add to an image only what it needs at run time.
- Images are tagged and versioned by the CDP build action on merge to `main`.

A repo's accepted deviations from these standards, and its local stack, live in the constraints of that repo's `AGENTS.md`.
