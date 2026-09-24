# Local Development Guide

This guide covers how to clone, set up, and work with the Flamingo Registry locally. Because the registry is a **structured data catalog** (not a compiled application), the local workflow is focused on editing, validating, and testing registry entry definitions.

## Clone the Repository

Clone the repository using HTTPS (for read access or first-time contributors):

```bash
git clone https://github.com/flamingo-stack/registry.git
cd registry
```

Or using SSH (recommended for contributors with commit access):

```bash
git clone git@github.com:flamingo-stack/registry.git
cd registry
```

## Explore the Repository Layout

After cloning, inspect the directory structure:

```bash
ls -la
```

You should find the following top-level structure (actual contents may vary):

```text
registry/
├── catalog/               ← Registry entries (the core content)
│   ├── services/          ← Platform service definitions
│   ├── integrations/      ← Third-party MSP tool integrations
│   └── components/        ← Reusable components and libraries
├── schemas/               ← JSON Schema / YAML Schema validation rules
├── docs/                  ← Documentation (this directory)
└── .editorconfig          ← Formatting rules
```

## Working with Registry Entries

### Create a New Entry

Registry entries are YAML or JSON files in the `catalog/` directory. To create a new entry:

```bash
# Navigate to the relevant catalog section
cd catalog/integrations/

# Copy an existing entry as a starting point
cp example-integration.yaml my-new-integration.yaml

# Open in your editor
code my-new-integration.yaml
```

A registry entry follows this pattern:

```yaml
apiVersion: registry.flamingo.run/v1
kind: Integration
metadata:
  name: my-new-integration
  version: "1.0.0"
  description: "Brief description of this integration"
  labels:
    category: psa        # e.g., psa, rmm, monitoring, security
    vendor: acme-corp
spec:
  homepage: https://acmecorp.example.com
  documentation: https://docs.acmecorp.example.com
  maintainers:
    - name: Your Name
      contact: https://www.openmsp.ai/
```

### Edit an Existing Entry

```bash
# Open an existing entry
code catalog/services/existing-service.yaml

# Make your changes, then validate (see below)
```

## Validating Registry Entries

Before committing your changes, validate that your entries are well-formed.

### YAML Syntax Check

```bash
# Validate a single file
yamllint catalog/integrations/my-new-integration.yaml

# Validate all files in a directory
yamllint catalog/
```

A passing check produces no output. Errors look like:

```text
catalog/integrations/my-new-integration.yaml
  12:3      error    wrong indentation: expected 4 but found 2  (indentation)
```

### JSON Schema Validation (If Available)

If the repository includes schema validation tooling:

```bash
# Check if a validation script exists
ls Makefile justfile scripts/

# Run validation (example — check the actual repo for the real command)
make validate
# or
./scripts/validate.sh
```

> **Tip:** Check the repository root for a `Makefile`, `justfile`, or `scripts/` directory that may contain validation helpers.

## Checking for Duplicates

Before adding a new entry, verify no existing entry has the same `name`:

```bash
# Search for a name across all catalog entries
grep -r "name: my-new-integration" catalog/
```

If nothing is returned, your entry name is unique.

## Local Branch Workflow

Work on a dedicated feature branch — never commit directly to `main`:

```bash
# Create a feature branch
git checkout -b feat/add-my-new-integration

# Make your changes
# ... edit files ...

# Stage your changes
git add catalog/integrations/my-new-integration.yaml

# Commit with a clear message
git commit -m "feat(registry): add my-new-integration entry"

# Push to your fork or branch
git push origin feat/add-my-new-integration
```

## Keeping Your Branch Up to Date

When working on a long-running branch, keep it in sync with `main`:

```bash
# Fetch latest changes
git fetch origin

# Rebase your branch on top of main
git rebase origin/main

# Resolve any conflicts, then continue
git rebase --continue
```

## Debug Configuration (Editor)

Since the registry is data-driven, "debugging" typically means inspecting file content. Use these shell tools for quick inspection:

### Query a YAML file with yq

```bash
# Install yq (a YAML processor)
brew install yq        # macOS
sudo apt install yq    # Linux

# Query a field from a registry entry
yq '.metadata.name' catalog/services/my-service.yaml
yq '.spec.endpoint' catalog/services/my-service.yaml
```

### Validate JSON schema files with jq

```bash
# Pretty-print a schema file
jq '.' schemas/service.schema.json

# Check a specific field
jq '.properties.metadata.required' schemas/service.schema.json
```

## Common Local Development Tasks

| Task | Command |
|---|---|
| Validate all YAML files | `yamllint catalog/` |
| Search for an entry by name | `grep -r "name: <value>" catalog/` |
| List all registered services | `ls catalog/services/` |
| Count total registry entries | `find catalog/ -name "*.yaml" \| wc -l` |
| Check for duplicate names | `grep -rh "^  name:" catalog/ \| sort \| uniq -d` |

---

> Once you've made and validated your changes locally, follow the [Contributing Guidelines](../contributing/guidelines.md) to open a Pull Request.
