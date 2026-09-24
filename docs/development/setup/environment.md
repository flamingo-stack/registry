# Development Environment Setup

This guide walks you through setting up your local development environment for contributing to the **Flamingo Registry**. Because the registry is a structured-data catalog (not a compiled application), setup is lightweight — focused on editor tooling, linting, and validation utilities.

## IDE Recommendations

### Visual Studio Code (Recommended)

VS Code is the recommended editor for working with the Flamingo Registry due to its strong YAML, JSON, and Markdown support.

**Download:** [https://code.visualstudio.com/](https://code.visualstudio.com/)

#### Required Extensions

Install the following extensions for the best experience:

| Extension | Publisher | Purpose |
|---|---|---|
| **YAML** | Red Hat | YAML language server, schema validation, auto-complete |
| **Markdown All in One** | Yu Zhang | Enhanced Markdown editing and preview |
| **GitLens** | GitKraken | Advanced Git history and blame annotations |
| **EditorConfig for VS Code** | EditorConfig | Enforces consistent file formatting |

Install all at once via the terminal:

```bash
code --install-extension redhat.vscode-yaml
code --install-extension yzhang.markdown-all-in-one
code --install-extension eamodio.gitlens
code --install-extension editorconfig.editorconfig
```

#### Optional Extensions

| Extension | Publisher | Purpose |
|---|---|---|
| **JSON Schema Store** | Built-in (settings) | Auto-discovers schemas for JSON files |
| **Prettier** | Prettier | Consistent formatting for YAML/JSON/Markdown |
| **Spell Right** | Bartekduras | Spell checking for documentation |

### Other Supported Editors

| Editor | Notes |
|---|---|
| **JetBrains IDEs** (IntelliJ, WebStorm) | Excellent YAML support built-in; install `.editorconfig` plugin |
| **Neovim / Vim** | Use `yaml-language-server` via LSP and `vim-markdown` plugin |
| **Sublime Text** | Install `YAML` and `SublimeLinter` packages |
| **Emacs** | Use `yaml-mode` and `flycheck` for linting |

## Required Development Tools

| Tool | Version | Installation |
|---|---|---|
| **Git** | 2.x or later | [https://git-scm.com/](https://git-scm.com/) |
| **yamllint** | Latest | `pip install yamllint` |
| **jq** | 1.6 or later | Package manager (`brew install jq`, `apt install jq`) |

### Installing yamllint

`yamllint` is used to check YAML files for syntax errors and style issues:

```bash
# macOS
brew install yamllint

# Linux (Debian/Ubuntu)
sudo apt install yamllint

# Cross-platform via pip
pip install yamllint
```

Verify the installation:

```bash
yamllint --version
```

### Installing jq

`jq` is used for parsing and querying JSON schema and config files:

```bash
# macOS
brew install jq

# Linux (Debian/Ubuntu)
sudo apt install jq

# Windows (via Chocolatey)
choco install jq
```

Verify:

```bash
jq --version
```

## Environment Variables for Development

Set the following optional variables in your shell profile (`~/.bashrc`, `~/.zshrc`, etc.) if you're integrating with the live Flamingo/OpenFrame platform during local development:

```bash
# Optional: OpenFrame platform API access
export FLAMINGO_API_URL="https://api.flamingo.run"
export FLAMINGO_API_KEY="your-api-key-here"

# Optional: Registry environment context
export REGISTRY_ENV="development"
```

> **Security:** Never hardcode secrets in repository files. Use your shell's environment configuration or a tool like `direnv` to manage per-project variables. See [Security Guidelines](../security/README.md) for details.

## Editor Configuration

If the repository includes an `.editorconfig` file, it will automatically enforce consistent formatting. The standard configuration for registry files follows this pattern:

```text
root = true

[*]
charset = utf-8
end_of_line = lf
indent_style = space
indent_size = 2
insert_final_newline = true
trim_trailing_whitespace = true

[*.md]
trim_trailing_whitespace = false
```

## VS Code Workspace Settings

If the repository includes a `.vscode/settings.json`, it will configure schema associations automatically. A typical configuration for registry YAML files:

```json
{
  "yaml.schemas": {
    "./schemas/service.schema.json": "catalog/services/*.yaml",
    "./schemas/integration.schema.json": "catalog/integrations/*.yaml",
    "./schemas/component.schema.json": "catalog/components/*.yaml"
  },
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[yaml]": {
    "editor.defaultFormatter": "redhat.vscode-yaml"
  }
}
```

## Verifying Your Setup

Run these checks to confirm your environment is correctly configured:

```bash
# Verify Git
git --version

# Verify yamllint
yamllint --version

# Verify jq
jq --version

# Test YAML linting on an existing file (adjust path as needed)
yamllint catalog/services/
```

If all commands return without errors, your environment is ready.

---

> For cloning the repo and running local validation checks, see [Local Development](local-development.md).
