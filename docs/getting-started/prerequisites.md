# Prerequisites

Before you can work with the Flamingo Registry, ensure your environment meets the requirements listed on this page. The Registry is part of the [OpenFrame](https://openframe.ai) platform ecosystem and is designed for MSP developers and platform operators.

## Required Software

| Tool | Minimum Version | Purpose |
|---|---|---|
| **Git** | 2.x or later | Cloning and contributing to the repository |
| **A terminal / shell** | Any modern shell | Running commands |
| **A text editor or IDE** | Any | Editing configuration and code |

> **Note:** Because the verified repository facts show no frontend framework (no `package.json`), no backend build tool (no `pom.xml`), and no container orchestration files (no `docker-compose`), the Registry is likely a **data/configuration repository** — a catalog of YAML, JSON, or Markdown definitions rather than a compiled application. No specific language runtime may be required to contribute or consume the registry.

## Account and Access Requirements

| Requirement | Details |
|---|---|
| **GitHub Account** | Required to clone, fork, and submit pull requests to [flamingo-stack/registry](https://github.com/flamingo-stack/registry) |
| **OpenMSP Slack** | Recommended — join at [https://www.openmsp.ai/](https://www.openmsp.ai/) for community support |
| **Flamingo Platform Access** | Optional — needed if integrating with live OpenFrame tenants |

## System Requirements

| Resource | Recommended |
|---|---|
| **Operating System** | Linux, macOS, or Windows (with WSL2 recommended for Windows users) |
| **Disk Space** | 100 MB minimum for the registry content |
| **Internet Connection** | Required for cloning the repository and accessing platform APIs |

## Environment Variables

Depending on how you integrate with the OpenFrame platform, you may need to configure the following environment variables. Refer to your environment's configuration for exact values:

| Variable | Description | Required |
|---|---|---|
| `FLAMINGO_API_URL` | Base URL for the Flamingo/OpenFrame platform API | Optional (for platform integration) |
| `FLAMINGO_API_KEY` | API key for authenticating with the platform | Optional (for platform integration) |
| `REGISTRY_ENV` | Deployment environment (`development`, `staging`, `production`) | Optional |

> **Security Note:** Never commit secrets or API keys to the repository. Store all credentials in your local environment or a secrets manager. See your platform's documentation for secret management best practices.

## Verifying Your Environment

Run the following commands to confirm your environment is ready:

### Check Git

```bash
git --version
```

Expected output (version may vary):

```text
git version 2.x.x
```

### Check Network Access to GitHub

```bash
git ls-remote https://github.com/flamingo-stack/registry.git HEAD
```

Expected output (commit hash will vary):

```text
<commit-hash>	HEAD
```

If this command hangs or errors, check your network or proxy settings.

### Verify SSH or HTTPS Authentication (GitHub)

```bash
ssh -T git@github.com
```

Expected output:

```text
Hi <your-username>! You've successfully authenticated, but GitHub does not provide shell access.
```

Or, if using HTTPS with a personal access token, ensure `git credential` is configured.

## Optional Tools

These tools are not strictly required but improve the developer experience:

| Tool | Purpose |
|---|---|
| **VS Code** | Recommended editor with excellent Markdown and YAML support |
| **yamllint** | Linting YAML registry definition files |
| **jsonlint / jq** | Validating and querying JSON registry files |
| **pre-commit** | Enforcing code quality hooks before committing |

## Next Steps

Once your environment is ready, proceed to:

- **[Quick Start](quick-start.md)** — Clone the repository and make your first registry entry
- **[First Steps](first-steps.md)** — Explore the registry structure and key features
