# Contributing Guidelines

Thank you for your interest in contributing to the **Registry** repository, part of the [Flamingo](https://flamingo.run) / [OpenFrame](https://openframe.ai) ecosystem. This document describes how code style, branching, commits, and reviews are handled in this repository.

> **Note:** This repository does not use GitHub Issues or GitHub Discussions for coordination. All community discussion, questions, and support happen on the **OpenMSP Slack community**: [openmsp.ai](https://www.openmsp.ai/) — join via the [Slack invite link](https://join.slack.com/t/openmsp/shared_invite/zt-36bl7mx0h-3~U2nFH6nqHqoTPXMaHEHA). Please use Slack rather than opening a GitHub Issue.

## Table of Contents

- [Code Ownership](#code-ownership)
- [Code Style and Conventions](#code-style-and-conventions)
- [Branch Naming and PR Process](#branch-naming-and-pr-process)
- [Commit Message Format](#commit-message-format)
- [Automated Code Review](#automated-code-review)
- [Review Checklist](#review-checklist)

---

## Code Ownership

This repository defines ownership through the [`.github/CODEOWNERS`](https://github.com/flamingo-stack/registry/blob/main/.github/CODEOWNERS) file. Ownership rules are **last-match-wins**, so broader patterns are listed above more specific ones:

```text
*                          @flamingo-stack/devops-engineers
/.github/CODEOWNERS        @flamingo-stack/devops-engineers
```

In practice this means:

- The `@flamingo-stack/devops-engineers` team owns the entire repository by default.
- Changes to `.github/CODEOWNERS` itself are also owned by `@flamingo-stack/devops-engineers`.

Any pull request that touches files under a given pattern will automatically request review from the matching team. Keep this in mind when opening a PR — review requests are assigned by GitHub based on this file, not manually.

---

## Code Style and Conventions

This repository's automation stack (documentation and code-review pipelines) is driven by GitHub Actions workflows under `.github/workflows/`, including:

- [`.github/workflows/doc-orchestrator.yml`](https://github.com/flamingo-stack/registry/blob/main/.github/workflows/doc-orchestrator.yml) — the documentation generation pipeline.
- [`.github/workflows/flamingo-code-review.yml`](https://github.com/flamingo-stack/registry/blob/main/.github/workflows/flamingo-code-review.yml) — the automated AI code-review pipeline.
- [`.github/workflows/regsync-images-to-ghcr.yml`](https://github.com/flamingo-stack/registry/blob/main/.github/workflows/regsync-images-to-ghcr.yml) — a scheduled job that syncs container images into GHCR.

When contributing changes to these or any other files in the repository, follow these general conventions:

- **Keep workflow files declarative and well-commented.** The existing workflows in this repository favor extensive inline comments explaining *why* a trigger, guard, or condition exists — not just *what* it does. Follow that pattern when modifying automation.
- **Never hardcode secrets or tokens** directly in a workflow step. Secrets must be passed per-step (as seen in `doc-orchestrator.yml` and `flamingo-code-review.yml`), never placed in job-level `env:` blocks, to avoid exposure in setup logs.
- **Prefer explicit, named environment variables** over inline literals, and document fallbacks with comments (see the `env:` blocks in `doc-orchestrator.yml` for the established pattern of `client_payload` → `inputs` → literal fallback chains).
- **YAML formatting:** two-space indentation, and keep list/mapping structure consistent with the existing workflow files.
- For scheduled or sync-style jobs like `regsync-images-to-ghcr.yml`, pin third-party tool versions explicitly (e.g. `REGSYNC_VERSION: v0.10.0`) rather than tracking `latest`.

If you are proposing a substantial change to how the documentation or review pipelines behave, discuss it first on the OpenMSP Slack community so maintainers are aware before you invest time in the change.

---

## Branch Naming and PR Process

### Branching

Work should be branched from `main`, which is the default branch used by the automation in this repository (see `SOURCE_BRANCH` default of `'main'` in `doc-orchestrator.yml`). Use descriptive branch names that reflect the nature of the change, for example:

```text
fix/regsync-timeout
chore/update-codeowners
docs/contributing-guidelines
```

### Opening a Pull Request

1. Branch from `main`.
2. Make your changes, following the conventions above.
3. Push your branch and open a pull request against `main` at [flamingo-stack/registry/pulls](https://github.com/flamingo-stack/registry/pulls).
4. Do **not** open a paired GitHub Issue for the change — describe context and rationale directly in the PR description, and use the OpenMSP Slack community for any broader discussion.
5. The automated review pipeline (`flamingo-code-review.yml`) reviews the PR automatically once it enters review:
   - It reviews when the PR is **opened**, marked **ready for review**, **reopened**, or when the `flamingo-review` label is applied.
   - It does **not** re-review on every subsequent push (`synchronize` is intentionally excluded by default) — this is designed to avoid noisy, repeated reviews on every commit.
   - To request another pass after the initial review, add the `flamingo-review` label to the PR, or leave a top-level comment starting with `@flamingo-review` (use `@flamingo-review full` to force a full re-read of the entire cumulative diff instead of just the incremental delta).
   - If you need continuous review on every push (e.g. for a large or risky refactor), apply the `flamingo-review-always` label, which subscribes the PR to review on every `synchronize` event.
6. Draft PRs are excluded from automatic review — the review runs once the PR is marked ready for review.
7. Ensure your PR does not modify only `docs/**` or `**.md` paths if you intend to trigger a code-graph reindex — those paths are deliberately excluded from the `push` trigger so that documentation-only merges do not rebuild the code graph.

### Merging

- Pull requests are merged into `main`.
- CODEOWNERS-based review is required from `@flamingo-stack/devops-engineers` for changes across the repository (or the relevant matching team, if ownership rules are extended in the future).

---

## Commit Message Format

Write clear, descriptive commit messages that explain the **intent** of a change, not just the mechanics. Favor the same standard of explanation seen in this repository's existing workflow files, where non-obvious decisions carry a short rationale.

Guidelines:

- Use the imperative mood in the subject line (e.g. "Fix regsync timeout", not "Fixed" or "Fixes").
- Keep the subject line concise (ideally under ~72 characters).
- If the change is non-trivial, add a body explaining **why**, especially for changes to automation/workflow files, where a comment-free diff can be hard to reason about later.
- Reference the relevant Slack discussion instead of a GitHub Issue number, since Issues are not used in this repository.

Example:

```text
Pin regsync to v0.10.0 in image sync workflow

Avoids picking up untested regsync releases automatically.
Discussed on OpenMSP Slack (#openframe-dev).
```

---

## Automated Code Review

Every pull request that enters review is evaluated by the **Flamingo Code Review** pipeline (`.github/workflows/flamingo-code-review.yml`). Understanding how it triggers will help you get a timely review:

| Trigger | When it fires |
|---|---|
| `pull_request: opened` | When a new (non-draft) PR is created |
| `pull_request: ready_for_review` | When a draft PR is marked ready |
| `pull_request: reopened` | When a closed PR is reopened |
| `pull_request: labeled` (`flamingo-review`) | On-demand re-review request |
| `pull_request: synchronize` (with `flamingo-review-always` label) | Continuous review on every push, opt-in only |
| `issue_comment: created` (`@flamingo-review`) | Manual re-review via PR comment, from a user with write access |
| `issue_comment: edited` (checkbox toggle) | Re-review triggered by checking a task box in the bot's own summary comment |

Key behaviors to be aware of as a contributor:

- The `flamingo-review` label is **consumed automatically** once processed — it is removed by a dedicated job so that re-applying it can trigger review again.
- The `flamingo-review-always` label is **durable** — it is not auto-removed, since it represents an ongoing "keep reviewing this PR" preference.
- Comment-based re-review commands only work from users with `OWNER`, `MEMBER`, or `COLLABORATOR` association, and only on comments/edits made by a human (not by the bot itself), to prevent re-triggering loops.
- Fork-originated pull requests are handled carefully: the workflow explicitly checks that the head repository matches the base repository before consuming labels or resolving comment commands, since a fork PR only carries a read-only token.

---

## Review Checklist

Before requesting review (or re-review) on a pull request, verify:

- [ ] The branch is based on the latest `main`.
- [ ] The PR description explains **what** changed and **why**, with a link to any relevant OpenMSP Slack discussion if applicable.
- [ ] No secrets, tokens, or credentials are hardcoded anywhere in the diff, especially in workflow files.
- [ ] Any new or modified GitHub Actions step that needs a secret passes it **per-step**, not via job-level `env:`.
- [ ] Workflow YAML changes preserve the existing comment style, explaining rationale for non-obvious conditions (trigger guards, fallback chains, concurrency groups).
- [ ] Any change to `.github/workflows/doc-orchestrator.yml` preserves the `paths-ignore` exclusion of `docs/**` and `**.md` on the `push` trigger, so documentation merges do not needlessly rebuild the code graph.
- [ ] Any change to `.github/workflows/flamingo-code-review.yml` preserves the fork-safety checks (`head.repo.full_name == github.repository`) before any job that could act with write permissions or secrets.
- [ ] Version pins for third-party tools (e.g. `REGSYNC_VERSION` in `regsync-images-to-ghcr.yml`) are updated deliberately, not left to float.
- [ ] `.github/CODEOWNERS` is updated if new paths need dedicated ownership beyond the default `@flamingo-stack/devops-engineers` coverage.
- [ ] Commit messages follow the format described above.
- [ ] No GitHub Issue was opened for this change — context lives in the PR description or the OpenMSP Slack community.

---

For environment setup and local development workflow, see the [Development overview](../README.md) and [Local Development guide](../setup/local-development.md). For prerequisites before you start contributing, see [Prerequisites](../../getting-started/prerequisites.md) and [Quick Start](../../getting-started/quick-start.md).
