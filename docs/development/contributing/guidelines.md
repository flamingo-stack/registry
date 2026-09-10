# Contributing Guidelines

Thank you for contributing to the **Flamingo Registry**! This document covers the conventions, workflows, and standards we follow to keep the registry consistent, high-quality, and easy to maintain.

The registry is part of the [OpenFrame](https://openframe.ai) platform ecosystem and is maintained as an open-source project by the Flamingo Stack community.

## Code of Conduct

We are a welcoming, inclusive community. All contributors are expected to be respectful, constructive, and collaborative. For real-time discussion and support, join us on:

- **OpenMSP Slack**: [https://www.openmsp.ai/](https://www.openmsp.ai/)
- **Invite link**: [https://join.slack.com/t/openmsp/shared_invite/zt-36bl7mx0h-3~U2nFH6nqHqoTPXMaHEHA](https://join.slack.com/t/openmsp/shared_invite/zt-36bl7mx0h-3~U2nFH6nqHqoTPXMaHEHA)

---

## Naming and Style Conventions

### Entry Names (metadata.name)

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
- Should reflect the vendor or service name clearly

### File Naming

Registry entry files should match the `metadata.name` field:

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

All work should happen on **feature branches**. Never commit directly to `main`.

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
2. **Check for duplicates** — ensure your `metadata.name` doesn't already exist in the catalog
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
- **Checklist**: Complete the PR checklist (see below)

### PR Checklist

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

### Review Process

1. CI pipeline runs automatically — all checks must pass
2. At least one maintainer reviews the entry
3. Feedback is provided via PR comments
4. After approval, a maintainer merges the PR into `main`

> **Note:** We don't use GitHub Issues or GitHub Discussions. For questions about your PR, reach out on the [OpenMSP Slack](https://www.openmsp.ai/).

---

## Updating Existing Entries

When updating an existing registry entry:

1. **Bump the version** — increment `metadata.version` following semver rules
2. **Describe the change** — update or add a `changelog` field if the schema supports it
3. **Use a `fix/` branch** — follow the branch naming conventions above

```yaml
# Before
metadata:
  version: "1.0.0"

# After (patch fix)
metadata:
  version: "1.0.1"
```

---

## Reviewing Pull Requests

All community members are welcome to review PRs. When reviewing:

- Focus on **accuracy** (is the information correct?) and **completeness** (are all required fields present?)
- Check for **naming convention compliance**
- Validate that **URLs are accessible** and point to the right resources
- Flag any **security concerns** (see [Security Guidelines](../security/README.md))
- Be **constructive and respectful** in all feedback

---

## Getting Help

Stuck? Have a question about the contribution process?

- **OpenMSP Slack**: [https://www.openmsp.ai/](https://www.openmsp.ai/) — the primary support channel
- **Pull Requests**: [https://github.com/flamingo-stack/registry/pulls](https://github.com/flamingo-stack/registry/pulls) — see existing PRs for examples
- **Releases**: [https://github.com/flamingo-stack/registry/releases](https://github.com/flamingo-stack/registry/releases) — see what's been shipped

Thank you for helping build the Flamingo Registry! 🦩
