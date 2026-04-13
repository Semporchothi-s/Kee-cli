# 🗝️ Kee CLI

**Kee** is a cross-platform terminal session recorder and replayer designed to turn messy terminal sessions into reusable, structured YAML recipes. Record your workflows, parameterize them with variables, and play them back safely on any machine.

[![Go Version](https://img.shields.io/badge/Go-1.21+-00ADD8?style=flat&logo=go)](https://go.dev/)
[![Platform](https://img.shields.io/badge/Platform-Windows%20|%20macOS%20|%20Linux-blue)](github.com/sem/kee)

---

## ✨ Features

- 📹 **Session Recording**: Capture natural terminal workflows across Bash, Zsh, Git Bash, and PowerShell.
- ⚡ **Structured Recipes**: Auto-generate readable YAML recipes from your terminal history.
- 🔄 **Safe Replay**: Execute recipes with variable prompts, dry-runs, and destructive command filtering.
- 🛠️ **Interactive Refinement**: Post-record TUI (powered by [Charmbracelet](https://charm.sh/)) to group steps, add variables, and set danger levels.
- 📦 **Dual-Scope Storage**: Manage project-specific recipes in `./.kee/` and global recipes in your user config directory.
- 💉 **Native Shell Integration**: No wrapper shell needed—recording occurs in your native environment via lightweight hooks.


## 📦 Installation

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/Semporchothi-s/Kee-cli/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/Semporchothi-s/Kee-cli/main/install.ps1 | iex
```

---

## 📖 Quick Start

### 1. Initialize & Configure
Prepare your environment by creating config dirs and installing shell hooks:

```bash
kee init
kee hook install
```

### 2. Record a Session
Start recording a recurring workflow (e.g., project setup):

```bash
# This spawns a new sub-shell with recording active
kee start setup-project

# Run your commands normally...
npm install
git init
npm run build

# Use 'k!' prefix to exclude sensitive commands from the log
k! export SECRET_KEY=12345

# To finish recording, exit the shell
exit
```

### 3. Refine & Save
After the shell exits, an interactive UI will guide you through:
- Selecting which commands to keep.
- Replacing hardcoded paths/values with `${VARS}`.
- Setting danger levels for risky steps.

### 4. Run the Recipe
Replay the recorded steps safely:

```bash
kee run setup-project
```

---

## 🛠️ Command Reference

| Command | Description |
|---|---|
| `kee init` | Initialize Kee configuration and detect shells |
| `kee start <name>` | Start recording a new session |
| `kee stop` | Stop active session and start refinement |
| `kee run <name>` | Execute a recipe (Supports `--dry-run`, `--var`, `--yes`) |
| `kee list` | List all project and global recipes (Alias: `ls`) |
| `kee show <name>` | Display recipe steps and metadata |
| `kee update <name>` | Append to or re-record an existing recipe |
| `kee edit <name>` | Interactive TUI for recipe editing |
| `kee delete <name>` | Remove a recipe from disk (Alias: `rm`) |
| `kee validate <name>` | Validate a recipe against the schema |
| `kee doctor` | Troubleshoot environment and health |
| `kee hook install` | Install persistent shell recording hooks |

---

## 📝 Recipe Format

Recipes are stored as human-editable YAML:

```yaml
version: 1
name: example-setup
shell: bash
variables:
  - name: PROJECT_NAME
    required: true
    default: my-app
steps:
  - id: 1
    description: Initialize Project
    run: mkdir ${PROJECT_NAME} && cd ${PROJECT_NAME}
  - id: 2
    description: Dangerous Cleanup
    run: rm -rf ./tmp
    danger_level: high
```

---

## 🛡️ Safety & Reliability

- **Dry Run**: Use `kee run setup --dry-run` to see exactly what will execute without firing a single command.
- **Danger Prompts**: Steps marked with `danger_level: high` (or auto-detected as destructive) require explicit `Allow` during replay.
- **Variable Injection**: Prompting ensures you never accidentally run commands with placeholder values.
- **Transactional Updates**: `kee update` creates automatic backups (`.kee.1`) before overwriting versions.

---

## 🏗️ Technical Stack

- **CLI Framework**: [Cobra](https://github.com/spf13/cobra)
- **TUI/Interactivity**: [Charmbracelet](https://charm.sh/) (`huh`, `lipgloss`, `bubbletea`)
- **Serialization**: YAML v3
- **Languages**: Go 1.23
