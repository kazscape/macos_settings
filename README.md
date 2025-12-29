# macOS Setup with Ansible

This repository automates the provisioning and configuration of a macOS development environment using **Ansible**. It manages Homebrew packages, dotfiles, and system preferences in a modular, role-based architecture.

## 🚀 Features

- **Role-Based Architecture**: Organized into modular roles (`common`, `zsh`, `git`, `bat`, `vscode`, `aws`, `docker`, `runtimes`, etc.) for better maintainability.
- **Makefile Support**: Simple commands to check and apply configurations without typing long Ansible commands.
- **Homebrew Management**: Automates installation of Formulae (CLI tools) and Casks (GUI applications).
- **Dotfiles Integration**: Configuration files are managed within each Ansible role and symlinked directly to `~/.config/`.
- **Automated Theme Management**: Automatically downloads themes from external sources (e.g., Tokyo Night theme for bat and git-delta).

## 📋 Prerequisites

Before running the playbook, ensure you have **Ansible** installed on your machine.

### 1. **Install Homebrew** (if not already installed):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. **Install Ansible**:

```bash
brew install ansible
```

## 🛠️ Usage

This project uses a `Makefile` to simplify execution. Run the following commands from the project root.

### 1. Dry Run (Check)

Checks for syntax errors and simulates the changes without applying them. Useful for verifying what will happen.

```bash
make check
```

_(Equivalent to: `ansible-playbook local.yml --syntax-check` and `--check` mode)_

### 2. Apply Changes

Executes the playbook and applies all configurations, including Homebrew package installations.

```bash
make apply
```

### 3. Apply Configuration Only (Skip Homebrew)

Executes the playbook while skipping the `homebrew` role. Use this for **fast updates** when you only want to reflect changes in config files (symlinks) without waiting for Homebrew updates.

```bash
make apply-config
```

_(Equivalent to: `ansible-playbook local.yml --skip-tags "brew"`)_

## ⚙️ Configuration

You can customize the installation by editing the variables and playbook files.

### Managing Packages

To add or remove software, edit **`group_vars/all.yml`**:

- **`homebrew_packages`**: List of general CLI tools (e.g., `jq`, `tree`). **Note:** Tool-specific packages (like `git`, `awscli`) are now managed in their respective roles.
- **`homebrew_cask_apps`**: List of GUI applications (e.g., `google-chrome`, `slack`). **Note:** Apps like `visual-studio-code` and `docker` are now managed in their respective roles.

### Enabling/Disabling Roles

To control which tasks are run, edit **`local.yml`**.

```yaml
roles:
  - common
  - zsh
  # Development Tools
  - git
  - bat
  - yazi
  - vscode
  - aws
  - docker
  - runtimes
  - nvim
  - wezterm
```

## 📏 Zsh Configuration Convention

Zsh configuration files are split and managed in `~/.config/zsh/conf.d/`. They are loaded in alphabetical order.
We use a **numbering prefix** to ensure dependencies are loaded in the correct order.

| Prefix    | Category         | Description                                  | Examples                            |
| --------- | ---------------- | -------------------------------------------- | ----------------------------------- |
| **00-09** | **Bootstrap**    | Initialization required before anything else | `00-p10k.zsh` (Instant Prompt)      |
| **10-19** | **Zsh Core**     | Basic shell behavior                         | `10-basics.zsh` (History, Bindkeys) |
| **20-29** | **Environment**  | Runtimes and PATH setup                      | `20-runtimes.zsh` (Node, Java, Go)  |
| **30-49** | **CLI Tools**    | Common tools configurations                  | `30-tools.zsh`, `31-fzf.zsh`        |
| **50-79** | **Apps (Roles)** | App-specific aliases and integration         | `50-aws.zsh`, `51-nvim.zsh`         |
| **80-89** | **Visuals**      | Syntax highlighting and theming              | `80-highlighting.zsh`               |
| **90-99** | **Local**        | Secrets and local overrides                  | `99-local_secrets.zsh`              |

### 📜 Managed Zsh Files by Role

| Role      | Prefix  | File                          | Description                                      |
| --------- | ------- | ----------------------------- | ------------------------------------------------ |
| zsh       | 00      | `00-p10k.zsh`                 | Powerlevel10k configuration                      |
| common    | 10      | `10-basics.zsh`               | Basic shell settings (history, bindkeys)         |
| runtimes  | 20      | `20-runtimes.zsh`             | Runtime environments (Node, Java, etc.)          |
| common    | 30      | `30-tools.zsh`                | Common tools configuration                       |
| common    | 31      | `31-fzf.zsh`                  | FZF configuration                                |
| aws       | 50      | `50-aws.zsh`                  | AWS CLI completion & settings                    |
| wezterm   | 50      | `50-wezterm.zsh`              | WezTerm integration                              |
| nvim      | 51      | `51-nvim.zsh`                 | Neovim aliases and integration                   |
| tmux      | 52      | `52-tmux.zsh`                 | Tmux integration                                 |
| aerospace | 53      | `53-aerospace.zsh`            | Aerospace aliases and integration                |
| common    | 80      | `80-highlighting.zsh`         | Syntax highlighting                              |

## 🔧 User-Specific Configuration

Some roles require or allow for user-specific configuration files that are not committed to the repository.

### Git
Create `~/.gitconfig.local` for your personal identity:
```ini
[user]
    name = Your Name
    email = your.email@example.com
```

The git role automatically configures **git-delta** as the default pager with Tokyo Night theme for enhanced diff viewing with syntax highlighting and side-by-side display.

### Yazi
The yazi role installs the terminal file manager with all required dependencies:
- **Core**: `yazi` - Fast terminal file manager
- **Media**: `ffmpegthumbnailer`, `ffmpeg` - Video/audio thumbnails and previews
- **Archive**: `sevenzip` - Archive file support
- **Tools**: `jq`, `poppler`, `imagemagick` - JSON, PDF, and image processing
- **Font**: `font-symbols-only-nerd-font` - Icon support

Shell integration is configured in `common` role (`30-tools.zsh`):
- `y` function: Opens yazi and changes to the directory on exit
- `EDITOR=nvim`: Default editor for opening files

Configuration files are symlinked from the role:
- `~/.config/yazi/yazi.toml` - General settings
- `~/.config/yazi/keymap.toml` - Keybindings
- `~/.config/yazi/theme.toml` - Color scheme (can be customized with flavors)

### AWS
Manage your credentials in `~/.aws/credentials`. This file is ignored by Ansible and Git.
The `~/.aws/config` file is managed by the Ansible role (`roles/aws/files/config`).

## 📂 Directory Structure

```text
.
├── Makefile              # Commands for easy execution (check/apply)
├── ansible.cfg           # Ansible configuration file
├── local.yml             # Main playbook entry point
├── group_vars/
│   └── all.yml           # Global variables (General Package lists)
└── roles/                # Task definitions by category
    ├── common/           # Common CLI tools & basic Zsh configs
    ├── zsh/              # Zsh setup & Powerlevel10k
    ├── git/              # Git configuration with git-delta integration
    ├── bat/              # Bat (better cat) with Tokyo Night theme
    ├── yazi/             # Yazi file manager with dependencies
    ├── vscode/           # VS Code settings
    ├── aws/              # AWS CLI config
    ├── docker/           # Docker Cask
    ├── runtimes/         # Language Runtimes (Python, Node, Java)
    ├── nvim/             # Neovim setup
    ├── wezterm/          # WezTerm setup
    └── macos/            # macOS system preferences
```

