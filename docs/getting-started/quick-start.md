# Quick Start

Get up and running with the Flamingo Registry in just a few minutes. This guide covers cloning the repository, understanding the structure, and making your first contribution.

## TL;DR — 3-Step Setup

```bash
# 1. Clone the repository
git clone https://github.com/flamingo-stack/registry.git
cd registry

# 2. Explore the contents
ls -la

# 3. Browse the registry catalog
# Open files in your editor or use the terminal to inspect entries
```

That's it — no build step, no runtime to install. The Registry is a **content-first repository** where the catalog lives as structured data files.

---

## Step 1: Clone the Repository

Clone using HTTPS (recommended for read access):

```bash
git clone https://github.com/flamingo-stack/registry.git
```

Or using SSH (recommended for contributors with write access):

```bash
git clone git@github.com:flamingo-stack/registry.git
```

Then navigate into the project:

```bash
cd registry
```

## Step 2: Explore the Repository Structure

Once inside the repository, explore its layout:

```bash
ls -la
```

The registry is organized as a catalog of structured definitions. You'll typically find:

```text
registry/
├── README.md              ← Project overview
├── catalog/               ← Registry entries (services, integrations, components)
│   ├── services/          ← OpenFrame platform services
│   ├── integrations/      ← Third-party MSP tool integrations
│   └── components/        ← Reusable platform components
├── schemas/               ← Validation schemas for registry entries
└── docs/                  ← Documentation (you are here)
```

> **Note:** The exact directory structure reflects what's actually committed to the repository. The layout above represents the expected pattern for a registry-style catalog. Check the actual repository at [https://github.com/flamingo-stack/registry](https://github.com/flamingo-stack/registry) for the current structure.

## Step 3: View a Registry Entry

Open a registry entry in your editor or inspect it in the terminal:

```bash
# Example: view a service entry (adjust path to match actual structure)
cat catalog/services/example-service.yaml
```

A typical registry entry looks like this:

```yaml
apiVersion: registry.flamingo.run/v1
kind: Service
metadata:
  name: example-service
  version: "1.0.0"
  description: "An example OpenFrame service"
  labels:
    category: integration
    platform: openframe
spec:
  endpoint: https://api.example.com
  documentation: https://docs.example.com
  maintainers:
    - name: Flamingo Stack Team
      contact: https://www.openmsp.ai/
```

## Step 4: Make Your First Registry Entry

To add a new entry to the registry:

```bash
# Create a new entry file
cp catalog/services/example-service.yaml catalog/services/my-new-service.yaml

# Edit the new file
# Replace placeholder values with your actual service details
```

Edit `catalog/services/my-new-service.yaml` with your editor, then validate the structure follows the schema in `schemas/`.

## Step 5: Commit and Open a Pull Request

```bash
# Stage your new entry
git add catalog/services/my-new-service.yaml

# Commit with a clear message
git commit -m "feat(registry): add my-new-service entry"

# Push to your fork
git push origin feat/add-my-new-service
```

Then open a Pull Request at [https://github.com/flamingo-stack/registry/pulls](https://github.com/flamingo-stack/registry/pulls).

## Expected Results

After completing these steps, your registry entry will be:

1. **Reviewed** by the Flamingo Stack maintainers via the PR process
2. **Merged** into the main registry catalog upon approval
3. **Discoverable** by the OpenFrame platform and AI assistants (Mingo AI / Fae)
4. **Versioned** within the registry's release history

## What's Next?

- **[First Steps](first-steps.md)** — Explore the registry structure in depth, configure your tools, and find help
- Review the **[Development Setup](../development/setup/environment.md)** for a full contributor environment
