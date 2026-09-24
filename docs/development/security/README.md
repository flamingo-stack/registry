# Security

> **Repository:** [flamingo-stack/registry](https://github.com/flamingo-stack/registry)

This document describes the security posture, patterns, and expectations for the `registry` repository, part of the Flamingo / OpenFrame ecosystem. It complements the organization's broader [Privacy Policy](https://flamingo.run) commitments and is intended for engineers writing, reviewing, or operating code in this repository.

> **Note on scope:** The repository graph currently reports `registry` with an **unknown role** and no indexed dependencies, published artifacts, or consumers (coverage: `full`). This means the automated code graph has not yet resolved a manifest (no `package.json` or `pom.xml` was found) or detected cross-repository usage for this repository. The guidance below is therefore written as the baseline security standard that applies to every repository in the Flamingo organization, including this one, rather than as an inventory of specific frameworks or libraries detected in this codebase. As the repository grows and its manifests are indexed, this document should be revisited so framework-specific guidance (for example, Spring Security annotations or npm dependency audits) can be added with concrete citations.

---

## 1. Authentication and Authorization Patterns

Regardless of the specific framework a service in this repository ends up using, contributors must follow these baseline patterns:

- **Never implement custom cryptography or auth primitives.** Use well-reviewed, maintained libraries for password hashing, token issuance, and signature verification rather than hand-rolled implementations.
- **Principle of least privilege.** Every credential, service account, or API token used by code in this repository should be scoped to the minimum set of operations it needs. Do not reuse a single broad-access credential across multiple services.
- **Separate authentication from authorization.** Authentication (proving identity) and authorization (checking permissions) should be distinct, composable checks — never infer authorization solely from the presence of a valid session or token.
- **Fail closed.** When an authorization check cannot be completed (for example, a downstream permissions service is unreachable), the default behavior must be to deny access, not to allow it.
- **Validate on the server, not just the client.** Any authorization decision enforced only in a UI or CLI client is not a security control — it must be re-checked server-side.

```text
Request → Authenticate (who is this?) → Authorize (what can they do?) → Handler
```

> When this repository's manifests are indexed (a `package.json`, `pom.xml`, or equivalent), this section should be updated to reference the specific authentication middleware, session handling, and role/permission model actually in use — do not assume a specific framework without that evidence.

---

## 2. Data Encryption and Secure Storage

- **Encrypt sensitive data at rest** wherever this repository persists credentials, tokens, personal data, or configuration secrets. Rely on well-known, audited encryption libraries rather than custom encoding schemes.
- **Encrypt data in transit.** All network calls made by services or tooling in this repository — internal or external — should use TLS. Do not disable certificate validation, even in local development, without an explicit and reviewed exception.
- **Avoid storing secrets in application data stores in plaintext.** Where secrets must be persisted (API keys, refresh tokens, webhook signing secrets), they must be encrypted or stored in a dedicated secrets manager rather than in ordinary database columns or config files.
- **Minimize what you store.** Per the organization's Privacy Policy, self-hosted deployments (such as OpenFrame) are designed so that Flamingo AI does not access or collect customer data, and data remains under customer control. Code in this repository should not introduce telemetry, logging, or storage that undermines that guarantee — do not log full request/response bodies, tokens, or personal data.
- **Support data deletion.** If this repository stores any user- or customer-controlled data, it must support timely deletion consistent with the retention expectations described in the Privacy Policy (for example, diagnostic/support data is expected to be deleted promptly, typically within 24 hours, once its purpose is served).

---

## 3. Input Validation and Sanitization

All external input — HTTP request bodies, query parameters, headers, CLI arguments, file uploads, and environment-derived configuration — must be treated as untrusted.

- **Validate at the boundary.** Reject malformed input as early as possible (at the API/controller layer) instead of relying on downstream code to tolerate bad data.
- **Allow-list over deny-list.** Prefer validating input against an explicit allow-list of accepted shapes/values rather than trying to block a list of known-bad patterns.
- **Parameterize, never concatenate.** Any code that builds a database query, shell command, or file path from user input must use parameterized queries, safe path-joining utilities, or equivalent APIs — never raw string concatenation of untrusted input into an executable statement.
- **Sanitize before render.** Any user-supplied content that is rendered back to a browser or terminal must be escaped/sanitized for the output context (HTML, shell, log line) to prevent injection.
- **Validate file uploads and paths.** Reject unexpected file types, enforce size limits, and normalize/validate any user-supplied file path to prevent path traversal outside an intended directory.

```text
Untrusted input --> [Boundary validation] --> [Business logic] --> [Output encoding] --> Response
```

---

## 4. Common Security Vulnerabilities and Mitigations

| Vulnerability class | Description | Mitigation |
|---|---|---|
| Injection (SQL/Command/Template) | Untrusted input executed as code or query | Use parameterized queries/prepared statements; avoid shelling out with unsanitized input |
| Broken authentication | Weak session handling, predictable tokens | Use vetted auth libraries; rotate and expire tokens; enforce strong session invalidation on logout |
| Broken access control | Missing or client-only authorization checks | Enforce authorization server-side on every request; deny by default |
| Sensitive data exposure | Secrets or personal data logged, cached, or transmitted in plaintext | Encrypt at rest and in transit; scrub secrets from logs and error messages |
| Security misconfiguration | Default credentials, verbose stack traces, permissive CORS | Harden defaults; disable debug/verbose error output in production; restrict CORS origins |
| Vulnerable dependencies | Outdated or unmaintained third-party libraries | Track dependency versions and apply updates promptly when advisories are published |
| Server-Side Request Forgery (SSRF) | Server fetches attacker-controlled URLs | Validate and allow-list destination hosts/schemes before making outbound requests |
| Insecure deserialization | Deserializing untrusted payloads into objects | Avoid deserializing untrusted data with unsafe formats; validate schema before parsing |

> **Never disable TLS verification, authentication checks, or input validation "temporarily" for debugging** in code that can reach a shared branch. If a debugging exception is unavoidable, gate it behind an explicit, clearly-named local-only flag and remove it before merging.

---

## 5. Security Testing and Code Review Guidelines

- **Treat security-relevant changes as high scrutiny.** Any change touching authentication, authorization, cryptography, secret handling, or external input parsing should get explicit reviewer attention to those aspects, not just functional correctness.
- **Write tests for the negative path.** For every access-control or validation rule, add a test that confirms the *disallowed* case is actually rejected (invalid token, wrong role, malformed payload), not only that the happy path works.
- **Review dependency changes.** When a pull request adds or upgrades a dependency, reviewers should consider whether the new/updated package has known relevant advisories.
- **Do not approve code that logs secrets.** Reject any pull request that logs tokens, passwords, private keys, or full personal-data payloads, even at debug level.
- **Coordinate with the wider development workflow.** Security-focused review should be applied alongside the general contribution process described in the [Contributing Guidelines](../contributing/guidelines.md) and exercised through the practices in [Testing](../testing/README.md).
- **No public issue trackers for vulnerability reports.** This organization does not use GitHub Issues or GitHub Discussions for coordination (see the [OpenMSP Slack community](https://www.openmsp.ai/) for community discussion instead). Do not file suspected security vulnerabilities as public GitHub issues or discussions on `flamingo-stack/registry`; report them privately as described below.

---

## 6. Environment Variables and Secrets Management

- **Never commit secrets to the repository.** API keys, database credentials, signing keys, and tokens must never appear in source files, commit history, or configuration checked into `flamingo-stack/registry`.
- **Use environment variables for configuration, not for storing raw secret material in code.** Reference environment variables like `` `$DATABASE_URL` `` or `` `$API_KEY` `` from configuration loading code rather than hardcoding values.
- **Keep local environment files out of version control.** Any local `.env`-style file used for development should be excluded from commits and treated as sensitive.
- **Rotate credentials that are ever exposed.** If a secret is accidentally committed or leaked, treat it as compromised: rotate it immediately rather than only removing it from the latest commit (history retains old values).
- **Scope secrets per environment.** Development, staging, and production credentials should be distinct — a development token must never grant access to production resources.
- **Support customer self-hosting.** Consistent with OpenFrame's self-hosted model, where Flamingo AI does not access or collect customer data and all data remains under customer control, configuration for self-hosted deployments should make it clear which environment variables carry customer-supplied secrets so operators can manage them within their own infrastructure.

For general environment setup instructions (as distinct from secrets handling), see [Environment Setup](../setup/environment.md) and [Local Development](../setup/local-development.md).

---

## Reporting a Vulnerability

If you discover a security issue in this repository, do not open a public GitHub issue. Instead, contact the team through the channels the organization actually publishes for security and privacy matters:

- **Privacy/security inquiries:** privacy@flamingo.so
- **General inquiries:** info@flamingo.so
- **Community coordination:** the [OpenMSP Slack community](https://www.openmsp.ai/) ([invite link](https://join.slack.com/t/openmsp/shared_invite/zt-36bl7mx0h-3~U2nFH6nqHqoTPXMaHEHA))

## Responsibility and Disclaimer

Per the Flamingo AI Privacy Policy, Flamingo AI implements reasonable technical and organizational safeguards, but **customers remain fully responsible for the security of their own infrastructure** when self-hosting products such as OpenFrame. Use of Flamingo AI products, and any code from this repository, is at your own risk, and deployers are responsible for compliance with applicable data protection laws in their own environment.

---

For a broader view of how this repository fits into the rest of the Flamingo/OpenFrame development workflow, see the [Development overview](../README.md). For onboarding steps before working on this repository, see [Introduction](../../getting-started/introduction.md), [Prerequisites](../../getting-started/prerequisites.md), and [Quick Start](../../getting-started/quick-start.md).
