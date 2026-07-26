# Contributing to the Flamingo Registry

Thank you for contributing to the **Flamingo Registry**! This document covers the conventions, workflows, and standards we follow to keep the registry consistent, high-quality, and easy to maintain.

The registry is part of the [OpenFrame](https://openframe.ai) platform ecosystem and is maintained as an open-source project by the Flamingo Stack community.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Naming and Style Conventions](#naming-and-style-conventions)
- [Branch Naming](#branch-naming)
- [Commit Message Format](#commit-message-format)
- [Pull Request Process](#pull-request-process)
- [Updating Existing Entries](#updating-existing-entries)
- [Security Guidelines](#security-guidelines)
- [Reviewing Pull Requests](#reviewing-pull-requests)
- [Getting Help](#getting-help)

---

## Code of Conduct

We are a welcoming, inclusive community. All contributors are expected to be respectful, constructive, and collaborative.

For real-time discussion and support, join us on:

- **OpenMSP Slack**: [https://www.openmsp.ai/](https://www.openmsp.ai/)
- **Invite link**: [https://join.slack.com/t/openmsp/shared_invite/zt-36bl7mx0h-3~U2nFH6nqHqoTPXMaHEHA](https://join.slack.com/t/openmsp/shared_invite/zt-36bl7mx0h-3~U2nFH6nqHqoTPXMaHEHA)

> **Note:** We do not use GitHub Issues or GitHub Discussions. All questions, feedback, and conversation happen on the OpenMSP Slack.

---

## Getting Started

Before contributing, make sure your environment is set up correctly:

1. **Prerequisites** — See the [Prerequisites guide](./docs/getting-started/prerequisites.md) for required tools
2. **Environment setup** — See [Environment Setup](./docs/development/setup/environment.md) for IDE and tooling configuration
3. **Local development** — See [Local Development](./docs/development/setup/local-development.md) for the cloning and validation workflow

### Quick Setup

```bash
# Clone the repository
git clone https://github.com/flamingo-stack/registry.git
cd registry

# Install recommended tools (macOS example)
brew install yamllint jq

# Verify tools are available
yamllint --version
jq --version
```

---

## Naming and Style Conventions

### Entry Names (`metadata.name`)

All registry entry names must follow **kebab-case** (lowercase words separated by hyphens):

| ✅ Correct | ❌ Incorrect |
|---|---|
| `connectwise-manage` | `ConnectWise_Manage` |
| `datto-rmm` | `DattoRMM` |
| `azure-ad-integration` | `azure ad integration` |

Rules:
- Lowercase only
- Words separated by hyphens (`-`), not underscores (`_`) or spaces
- Must be globally unique within the catalog
- Should clearly reflect the vendor or service name

### File Naming

Registry entry files must match the `metadata.name` field:

```text
catalog/integrations/connectwise-manage.yaml    ← metadata.name: connectwise-manage
catalog/services/notification-service.yaml      ← metadata.name: notification-service
```

### YAML Style

- Use **2-space indentation** (no tabs)
- Include a document start marker (`---`) at the top of every file
- Use double quotes for string values that contain special characters
- Keep lines under 120 characters where possible

```yaml
---
apiVersion: registry.flamingo.run/v1
kind: Integration
metadata:
  name: my-integration
  version: "1.0.0"
  description: "A clear, concise description of this integration"
  labels:
    category: psa
    vendor: my-vendor
spec:
  homepage: "https://vendor.example.com"
  documentation: "https://docs.vendor.example.com"
  maintainers:
    - name: Your Name
      contact: "https://www.openmsp.ai/"
```

### Version Format

All entries must use **Semantic Versioning** ([semver.org](https://semver.org)):

```text
MAJOR.MINOR.PATCH

Examples:
  1.0.0      ← Initial release
  1.1.0      ← Backward-compatible new features
  1.1.1      ← Backward-compatible bug fixes
  2.0.0      ← Breaking changes
```

---

## Branch Naming

All work must happen on **feature branches**. Never commit directly to `main`.

| Branch Type | Pattern | Example |
|---|---|---|
| New registry entry | `feat/<entry-name>` | `feat/connectwise-manage` |
| Update existing entry | `fix/<entry-name>` | `fix/datto-rmm-version` |
| Schema changes | `schema/<change-description>` | `schema/add-category-field` |
| Documentation updates | `docs/<topic>` | `docs/update-contributing-guide` |
| CI/tooling changes | `ci/<change-description>` | `ci/add-schema-validation` |

```bash
# Create a feature branch
git checkout -b feat/my-new-integration
```

---

## Commit Message Format

We follow the **Conventional Commits** specification ([conventionalcommits.org](https://www.conventionalcommits.org/)):

```text
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

### Types

| Type | When to Use |
|---|---|
| `feat` | Adding a new registry entry |
| `fix` | Correcting an existing entry (wrong version, broken URL, etc.) |
| `schema` | Changes to schema definitions |
| `docs` | Documentation-only changes |
| `ci` | Changes to CI/CD pipeline configuration |
| `chore` | Maintenance tasks (renaming files, cleanup) |

### Examples

```bash
# Adding a new integration entry
git commit -m "feat(integrations): add connectwise-manage entry"

# Fixing a broken URL in an existing entry
git commit -m "fix(integrations): update homepage URL for datto-rmm"

# Updating the service schema
git commit -m "schema(service): add required homepage field"

# Updating documentation
git commit -m "docs(contributing): clarify branch naming conventions"
```

---

## Pull Request Process

### Before Opening a PR

1. **Validate locally** — run `yamllint catalog/` and any available schema validation scripts
2. **Check for duplicates** — ensure your `metadata.name` does not already exist in the catalog:

```bash
grep -r "name: my-new-integration" catalog/
```

3. **Review your entry** — read through the final YAML one more time for completeness and accuracy
4. **Sync with main** — rebase your branch on the latest `main`:

```bash
git fetch origin
git rebase origin/main
```

### Opening the Pull Request

- **Title**: Follow the same Conventional Commits format as your commit message
  - ✅ `feat(integrations): add connectwise-manage integration`
  - ❌ `Added new thing`
- **Description**: Include a brief explanation of what the entry is and why it's being added

### PR Checklist

Before submitting, confirm each of the following:

```text
Pull Request Checklist:

[ ] Entry name follows kebab-case naming convention
[ ] File name matches metadata.name
[ ] YAML syntax is valid (yamllint passes)
[ ] Schema validation passes (if tooling available)
[ ] Version follows semantic versioning
[ ] All URLs are valid HTTPS endpoints
[ ] No secrets or credentials included
[ ] No duplicate entry names in the catalog
[ ] Description is clear and accurate
[ ] Labels are set appropriately (category, vendor)
```

### Security PR Checklist

```text
Security Checklist:

[ ] No secrets, API keys, or credentials in any file
[ ] No internal or private network URLs in registry entries
[ ] All URLs use HTTPS (not HTTP) where applicable
[ ] No personally identifiable information (PII) in entry metadata
[ ] No executable scripts introduced without maintainer approval
```

### Review Process

1. The CI pipeline runs automatically — all checks must pass before review
2. At least one maintainer reviews the entry for accuracy and convention compliance
3. Feedback is provided via PR comments
4. After approval, a maintainer merges the PR into `main`

> **Questions about your PR?** Reach out on [OpenMSP Slack](https://www.openmsp.ai/) — we don't use GitHub Issues.

---

## Updating Existing Entries

When updating an existing registry entry:

1. **Bump the version** — increment `metadata.version` following semver rules
2. **Use a `fix/` branch** — follow the branch naming conventions above
3. **Describe the change** in your commit message and PR description

```yaml
# Before (patch fix example)
metadata:
  version: "1.0.0"

# After
metadata:
  version: "1.0.1"
```

---

## Security Guidelines

The Flamingo Registry is a **public repository**. The following must **never** appear in any committed file:

- API keys or tokens
- Passwords or passphrases
- Private/internal network URLs
- OAuth client secrets
- Certificate or key material

```yaml
# ❌ WRONG — secret in a registry entry
spec:
  apiKey: "sk-live-abc123xyz"

# ✅ CORRECT — public references only
spec:
  homepage: "https://vendor.example.com"
```

For local development secrets, use environment variables in your shell profile — never in files within the repository:

```bash
# Add to ~/.zshrc or ~/.bashrc (NOT in the repo)
export FLAMINGO_API_KEY="your-api-key-here"
```

For more detail, see the [Security Guidelines](./docs/development/security/README.md).

---

## Reviewing Pull Requests

All community members are welcome to review PRs. When reviewing:

- Focus on **accuracy** — is the information correct and complete?
- Check **naming convention compliance** — kebab-case, semver, HTTPS URLs
- Validate that **URLs are accessible** and point to the correct resources
- Flag any **security concerns** (see Security Guidelines above)
- Be **constructive and respectful** in all feedback

---

## Getting Help

Stuck? Have a question?

- **OpenMSP Slack**: [https://www.openmsp.ai/](https://www.openmsp.ai/) — the primary support channel
- **Pull Requests**: [https://github.com/flamingo-stack/registry/pulls](https://github.com/flamingo-stack/registry/pulls) — see existing PRs for examples of well-formed contributions
- **Releases**: [https://github.com/flamingo-stack/registry/releases](https://github.com/flamingo-stack/registry/releases) — see what has been shipped

Thank you for helping build the Flamingo Registry! 🦩

---

<div align="center">
  Built with 💛 by the <a href="https://www.flamingo.run/about"><b>Flamingo</b></a> team
</div>
