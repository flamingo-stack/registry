# Prerequisites

This page lists what you need in place before working with the **Registry** repository (`flamingo-stack/registry`), part of the Flamingo / OpenFrame open-source stack.

> **Note on repository state:** The automated code-graph scan for this repository found no indexed package manifests (no `package.json`, no `pom.xml`), no shell/CLI bootstrap scripts, and no Docker Compose files. The graph also reports no recorded upstream dependencies or downstream consumers for this repository. Coverage for this scan is `full`, meaning the absence of these artifacts reflects the current state of the repository rather than a gap in analysis. Treat the requirements below as the general baseline expected across Flamingo/OpenFrame repositories; verify actual tooling needs against the repository contents once you have it checked out locally.

## Required Software and Versions

| Tool | Purpose | Notes |
|------|---------|-------|
| Git | Clone and manage the repository | Required to obtain the source at `https://github.com/flamingo-stack/registry.git` |
| A terminal/shell (bash-compatible) | Run verification and setup commands | macOS, Linux, or WSL on Windows |

> No language runtime, build tool, or container manifest (`package.json`, `pom.xml`, Dockerfiles, Compose files) was detected in the current snapshot of this repository. Once such manifests are added, this table should be updated to reflect the exact toolchain (e.g., Node.js, Java/Maven, Docker) and pinned versions they specify.

## System Requirements

| Resource | Minimum |
|----------|---------|
| Operating System | Linux, macOS, or Windows with WSL |
| Disk space | Enough free space to clone the repository and any dependencies you add locally |
| Network access | Outbound HTTPS access to `github.com` to clone/pull the repository |

## Account / Access Requirements

- **GitHub account** with read access to `https://github.com/flamingo-stack/registry` to clone the repository, and write/PR access if you intend to contribute changes.
- **OpenMSP Slack community access** for support, questions, and coordination — this project does not use GitHub Issues or GitHub Discussions for that purpose. Join via the [OpenMSP Slack invite](https://join.slack.com/t/openmsp/shared_invite/zt-36bl7mx0h-3~U2nFH6nqHqoTPXMaHEHA) or learn more at the [OpenMSP community site](https://www.openmsp.ai/).

## Environment Variables

No environment variables are defined by manifests, scripts, or configuration files currently indexed for this repository. If you introduce build tooling, runtime configuration, or credentials as part of your work, document the required variables here (name, purpose, and an example non-secret value) so the prerequisites stay accurate.

## Verification Commands

Use the following commands to confirm your baseline tooling is ready before you start working with the repository.

```bash
# Confirm Git is installed
git --version

# Clone the repository
git clone https://github.com/flamingo-stack/registry.git
cd registry

# Confirm the clone succeeded and inspect the repository contents
ls -la
git status
```

If these commands succeed without error, your environment is ready for the next step. Once you have cloned the repository, continue to the introduction and quick-start guides for further setup specific to this project.
