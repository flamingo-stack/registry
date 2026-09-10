# Security Guidelines

This document outlines security best practices for contributors to the **Flamingo Registry** and operators who consume the registry within the [OpenFrame](https://openframe.ai) platform.

## Overview

The Flamingo Registry is a public, open-source catalog repository. Because it is publicly accessible via [GitHub](https://github.com/flamingo-stack/registry), **no secrets, credentials, API keys, or private configuration should ever be committed to this repository.**

Security responsibilities fall into two areas:

1. **Contributor security** — how to contribute safely without leaking sensitive information
2. **Operator security** — how to securely consume the registry in production environments

---

## Secrets and Credentials Management

### Never Commit Secrets

The following must **never** appear in registry entry files, schemas, documentation, or any file committed to the repository:

- API keys or tokens
- Passwords or passphrases
- Private endpoint URLs (internal/corporate network addresses)
- Service account credentials
- OAuth client secrets
- Private certificate or key material

```yaml
# ❌ WRONG — API key in a registry entry
spec:
  apiKey: "sk-live-abc123xyz"
  endpoint: "https://internal.corp-network.example.com"

# ✅ CORRECT — References only, no secrets
spec:
  homepage: "https://vendor.example.com"
  documentation: "https://docs.vendor.example.com"
```

### Managing Local Development Secrets

If you need platform credentials for local testing, store them in your shell environment — never in files within the repository:

```bash
# Add to ~/.bashrc or ~/.zshrc (NOT to any file in the registry repo)
export FLAMINGO_API_KEY="your-api-key-here"
export FLAMINGO_API_URL="https://api.flamingo.run"
```

For per-project environment management, use a tool like `direnv` with a `.envrc` file that is listed in `.gitignore`:

```bash
# .envrc (ensure this file is in .gitignore)
export FLAMINGO_API_KEY="your-api-key-here"
```

```bash
# Verify .envrc is gitignored
grep ".envrc" .gitignore
```

> **If `.envrc` is not in `.gitignore`, add it before creating the file.**

---

## Access Control

### Repository Access

The registry uses a **pull request (PR) model** for all changes. Direct pushes to `main` are restricted to maintainers. This means:

- All changes go through peer review before merging
- No single contributor can unilaterally modify the catalog
- The change history is auditable via Git

### OpenFrame Platform Access

When consuming the registry from the OpenFrame platform:

| Principle | Practice |
|---|---|
| **Least privilege** | Grant read-only access to the registry for most consumers |
| **Token scoping** | Use tokens scoped to registry-read only when integrating |
| **Rotation** | Rotate platform credentials on a regular schedule |
| **Audit logs** | Enable audit logging on the platform for registry access events |

---

## Input Validation and Sanitization

Registry entries are validated against JSON Schema / YAML Schema definitions in the `schemas/` directory. This serves as the primary input validation layer.

### What Schema Validation Catches

- **Type mismatches** — e.g., a version field that is a number instead of a string
- **Missing required fields** — e.g., an entry without a `name` or `version`
- **Enum violations** — e.g., an invalid `kind` value
- **Format violations** — e.g., a malformed URL or semantic version string

### Validating Before Committing

Always run local validation before pushing changes:

```bash
# Validate YAML syntax
yamllint catalog/

# Validate against schema (if a validation script is available)
# Check the repo root for Makefile, justfile, or scripts/
make validate
```

### URL Safety in Registry Entries

All URLs in registry entries should point to publicly accessible, legitimate endpoints. Avoid:

- Internal/private network URLs (e.g., `http://192.168.1.10/api`)
- URLs containing authentication tokens in the query string
- HTTP (non-TLS) endpoints where HTTPS is available

```yaml
# ❌ WRONG — Internal URL and token in query string
spec:
  homepage: "http://10.0.0.5/admin?token=secret123"

# ✅ CORRECT — Public HTTPS URL
spec:
  homepage: "https://vendor.example.com"
```

---

## Dependency and Supply Chain Security

The registry itself has no code dependencies. However, if tooling scripts are added (e.g., validation helpers), follow these principles:

- **Pin dependency versions** — avoid floating version ranges in any tooling manifests
- **Review dependencies** — check the license and provenance of any added tool
- **Minimal tooling surface** — prefer single-purpose tools with small footprints

---

## Vulnerability Reporting

The Flamingo Registry is an open-source project maintained by the Flamingo Stack community.

If you discover a security vulnerability in the registry or the OpenFrame platform:

1. **Do not open a public GitHub issue** — security issues are handled privately
2. **Contact the team via the OpenMSP Slack community** at [https://www.openmsp.ai/](https://www.openmsp.ai/)
3. Provide a clear description of the vulnerability, including steps to reproduce it
4. Allow reasonable time for the maintainers to investigate and address the issue before public disclosure

---

## Security Review Checklist for Pull Requests

When reviewing or submitting a pull request to the registry, check the following:

```text
Security PR Checklist:

[ ] No secrets, API keys, or credentials included in any file
[ ] No internal or private network URLs in registry entries
[ ] All URLs use HTTPS (not HTTP) where applicable
[ ] Entry fields validated against the schema
[ ] No personally identifiable information (PII) in entry metadata
[ ] No executable scripts introduced without maintainer approval
[ ] Dependencies (if any) are pinned to specific versions
```

---

## Common Security Vulnerabilities and Mitigations

| Vulnerability | Risk | Mitigation |
|---|---|---|
| **Secret leakage** | Credentials exposed in public repo | Never commit secrets; use environment variables |
| **Malicious entries** | Entries pointing to malicious endpoints | Maintainer review on all PRs; schema validation |
| **Supply chain attacks** | Compromised tooling in the repo | Pin tool versions; audit added scripts |
| **Phishing via registry** | Fraudulent integration entries | Strict review; verify vendor authenticity |
| **Broken access control** | Unauthorized catalog modifications | Branch protection; PR-required merge policy |

---

> For questions about security practices, reach out on the [OpenMSP Slack community](https://www.openmsp.ai/).
