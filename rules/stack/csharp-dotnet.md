# C# and .NET standards

Shared by the Manage Account .NET repos from the DEFRA [.NET standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/net_standards.md), [C# coding standards](https://github.com/DEFRA/software-development-standards/blob/main/docs/standards/csharp_coding_standards.md) and [choosing packages guide](https://github.com/DEFRA/software-development-standards/blob/main/docs/guides/choosing_packages.md). Last synced 9 November 2026.

## Platform

- .NET is Defra's secondary stack. Manage Account uses it for backend APIs on CDP; that decision stands and is not revisited per change. Do not add frontend code, Razor, Blazor or MVC views to a .NET repo.
- Stay on the current .NET LTS (`net10.0` in every `.csproj`). Changing the target framework is a story of its own: the Docker base images, `actions/setup-dotnet` and the Sonar scan move with it.
- C# only. Follow Microsoft's [C# coding conventions](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions) and [Framework Design Guidelines](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/) as encoded in `.editorconfig`. CSharpier (`.csharpierrc`, print width 120) owns formatting; run `dotnet csharpier check .` and never hand-format.

## Language

- Nullable reference types and implicit usings are on in every project. Fix a nullable warning at its source; use `!` only with a comment explaining why the value cannot be null there.
- Use modern C#: records for DTOs and immutable data, pattern matching, collection expressions, primary constructors, as the existing code does.
- `async`/`await` end to end, passing the request's `CancellationToken`. Never block with `.Result`, `.Wait()` or `GetAwaiter().GetResult()`.
- Warnings are errors (`TreatWarningsAsErrors` in `Directory.Build.props`) and SonarAnalyzer.CSharp runs on every build. Suppress a rule only with a comment stating the reason, as the `CA1873` line in `.editorconfig` and the `NuGetAuditSuppress` entry do. Never suppress to get a build green.
- Follow SOLID: one responsibility per class, dependencies injected through small interfaces registered in `Program.cs`.
- Follow Microsoft's [secure coding guidelines for .NET](https://learn.microsoft.com/en-us/dotnet/standard/security/secure-coding-guidelines) as well as the OWASP guide in [security-logging.md](../shared/security-logging.md).

## Project layout

```
src/Api/
├── Authentication/   # Basic API-key and JWT handlers, ACL options, scopes and policies
├── Data/             # Mongo context and Postgres DbContext, options; entities in Data/Postgres/Entities
├── Documentation/    # Embedded ReDoc page
├── Dtos/             # Request and response records; validators in Dtos/Validation
├── Endpoints/        # One static class per endpoint under Endpoints/<Resource>/, registered in Endpoints.cs
├── Mapping/          # Extension methods between DTOs and entities
├── Services/         # Business logic and persistence behind interfaces
├── Utils/            # Health, Logging, Metrics, Security, TrustStore
└── Versioning/       # Accept-header version resolution, matcher policy, middleware
```

Put new code in the existing folder for its role. Do not add parallel folders (`Controllers`, `Models`, `Repositories`) or a new project without a spec decision.

## Endpoints

- One static class per endpoint (`Get`, `Post`, `Put`, `Search`) with a `Map<Resource><Verb>` extension method that chains `.WithName`, `.WithTags`, `.WithSummary`, `.WithDescription`, `.Produces...`, `.RequireAuthorization(PolicyNames.X)` and `.WithApiVersions(...)`, registered in `Endpoints.MapApiEndpoints`.
- Handlers are private static methods that rely on the endpoint filter for validation, call one service method and return a `TypedResults` value. No data access, mapping or business rules in a handler.
- Authorisation is declared on the endpoint with the `read` or `write` policy. Never check scopes by hand inside a handler.
- Errors are problem details: `TypedResults.ValidationProblem(errors)` keyed by JSON path for `400`, `ProducesProblem` for the rest, and the global exception handler in `Program.cs` for the unexpected. Never return a stack trace, exception message or connection string to the client.

## Validation and DTOs

- Request and response DTOs are records in `Dtos/` with `[JsonPropertyName]` and data annotations. Members the client cannot set do not exist on the request record.
- Requests use nullable members with `[Required]`, so a missing member is a validation error keyed by JSON path. The DTOs of a version frozen by the repo's constraints file stay as they are.
- A response envelope, the record an endpoint returns, is named after the endpoint: its `.WithName(...)` value followed by `Response`, which gives `<Verb><Resource>Response`.
- A response item, a record inside an envelope, is named after the resource, `<Resource>Response`, and is shared between endpoints when the shape is the same. Add a qualifier only when an endpoint's shape differs, and declare the members the shapes have in common once in a base record (`<Resource>ResponseBase`).
- Validate at the boundary through the endpoint filter and validator pair (`<Verb><Resource>ValidationFilter`, `<Verb><Resource>RequestValidator`): trim before pattern checks, validate every array item, return all errors at once.
- Configuration binds to options classes validated on start (`AddOptions<T>().Bind(...).ValidateDataAnnotations().ValidateOnStart()`). Fail fast on missing configuration; never read `IConfiguration` ad hoc in a service.

## Data access

- Postgres: EF Core LINQ on `PostgresDbContext`, `AsNoTracking()` for reads, one `SaveChangesAsync` per unit of work. `EnableRetryOnFailure` is on, so do not open explicit transactions outside the execution strategy. No SQL built from strings; if raw SQL is ever unavoidable, use `FromSql` with interpolated parameters.
- The schema's owner and how a schema change is made live in the repo's constraints file. Entities in `Data/Postgres/Entities` follow the schema, never the other way round.
- Timestamps come from `TimeProvider` through `TimestampInterceptor`. Never call `DateTime.UtcNow` in domain or persistence code.
- MongoDB: typed `IMongoCollection<T>` with `Builders<T>.Filter`, never a filter built from a string.

## API versioning and OpenAPI

- The version comes from the `Accept` header; `/health`, `/openapi` and `/redoc` are not versioned. Do not add URL-path versioning.
- The frozen versions and the tests that freeze them live in the repo's constraints file. New or changed behaviour is an endpoint declaring the next version with `.WithApiVersions(...)`, which may share its path with the earlier version's endpoint.
- Each version has its own OpenAPI document (`AddOpenApi("v2", ...)` in `Program.cs`) shaped by document, operation and schema transformers. A new version is added to `openApiDocuments` so the ReDoc dropdown lists it. Update the OpenAPI snapshot tests when the contract changes, and only then.

## Dependencies

- NuGet packages only, exact versions, declared in the project that uses them. `Directory.Build.props` carries only what applies to every project: the Sonar analyzer, warnings as errors, nullable reference types and the audit suppression.
- Before adding a package, apply the DEFRA choosing packages guide: maintained, widely used, documented, no known vulnerabilities, and a licence compatible with the Open Government Licence. A package with no licence cannot be used. State the reason for the choice in the PR description.
- Update `.github/dependabot.yml` when a new package belongs to an existing group.
- **NuGet audit** runs on every restore in `all` mode (direct and transitive packages, every severity) with warnings as errors, so the build, and with it the PR check, fails on a package with a known vulnerability.
- Security advisories are never suppressed to pass the build. `NuGetAuditSuppress` is a last resort, carrying the advisory URL and the reason in a comment, and is removed when the fixed package arrives.

## Tests

See [quality-assurance.md](../shared/quality-assurance.md) for the shared test rules; the repo's test projects are its Repo profile `Test projects`.

- Framework and libraries: xUnit v3, AwesomeAssertions, NSubstitute for doubles, AutoFixture for data, Verify for snapshots, `Microsoft.Extensions.TimeProvider.Testing` for time.
- Name tests by behaviour: `Method_Scenario_ShouldExpectation` (`ToEntity_WithBlankAndAbsentRegion_ShouldGiveOneAddress`). A test name reads as a statement about the service.

## Acceptance criteria defaults

Start from the default criteria in [quality-assurance.md](../shared/quality-assurance.md) and make these API criteria specific to the story:

- Invalid or missing input returns `400` with each error keyed by its JSON path.
- A caller without valid credentials gets `401`; a caller without the endpoint's scope gets `403`.
- A request that breaks the version rules gets `405` or `406`.
- Concurrent requests for the same record give the result the spec states.
- What is stored, and what is not, is checked against the stored data.

## Review lenses

| Lens         | Check for                                                                                                                  | Rules to apply |
| ------------ | -------------------------------------------------------------------------------------------------------------------------- | -------------- |
| api-contract | Versions frozen by the repo's constraints file unchanged, `.WithApiVersions` declared, OpenAPI documents and ReDoc list updated, problem details shapes      | this rule      |
| data         | Schema changes made as the repo's constraints file state, entities match the schema, parameterised access, `TimeProvider` for timestamps | this rule |
| architecture | Endpoints, Services, Dtos, Mapping layout; thin handlers; options validated on start; DI registration                      | this rule      |

## Coverage

- Unit coverage reported to SonarQube Cloud must stay at or above 90% on new code and must never decrease overall.
- `[ExcludeFromCodeCoverage]` only on bootstrap wiring (extension methods that register services or middleware), never on logic.

## Logging

- Log through Serilog with the Elastic Common Schema formatter (`Elastic.CommonSchema.Serilog`), configured in `appsettings*.json`. Always inject `ILogger<T>` and use message templates (`logger.LogError(ex, "Failed to create index {Name}", name)`); never `Console.WriteLine` or string interpolation in the message.
- Levels stay configurable through `Serilog:MinimumLevel` in `appsettings*.json` and the `Serilog__MinimumLevel__Default` environment variable; never hard-code a level.
- Enrich logs with the ECS HTTP context, `service.version` and the correlation id from the `x-cdp-request-id` trace header (`TraceHeader` options). Add structured properties through the message template.
- Configure what third-party libraries log (EF Core command logging, the Mongo driver) rather than letting them log payloads.
- Request metrics go through `Amazon.CloudWatch.EMF`. Metric dimensions must never contain PII or free-text input.

## Containers

- Multi-stage builds: the `Dockerfile` has `base`, `build`, `publish` and `final` stages. The final image carries only the published output and curl; tests and the SDK stay in the build stage.
- The only addition to the runtime image is curl, which the CDP platform health check requires.
- Every `FROM` line is pinned by digest (`mcr.microsoft.com/dotnet/aspnet@sha256:...`), as SonarCloud rule `docker:S8431` requires; Dependabot's `docker` ecosystem bumps the digests. Keep the SDK and ASP.NET digests on the same .NET feature version.
- The application reads its version from `SERVICE_VERSION`, set by the CDP build action.
