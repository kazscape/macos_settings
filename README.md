# macOS Setup with Ansible

This repository automates the provisioning and configuration of a macOS development environment using **Ansible**. It manages Homebrew packages, dotfiles, and system preferences in a modular, role-based architecture.

## 🚀 Features

- **Role-Based Architecture**: Organized into modular roles (`homebrew`, `zsh`, `nvim`, `wezterm`, etc.) for better maintainability.
- **Makefile Support**: Simple commands to check and apply configurations without typing long Ansible commands.
- **Homebrew Management**: Automates installation of Formulae (CLI tools) and Casks (GUI applications).
- **Dotfiles Integration**: Configuration files are managed within each Ansible role and symlinked directly to `~/.config/`.

## 📋 Prerequisites

Before running the playbook, ensure you have **Ansible** installed on your machine.

### 1. **Install Homebrew** (if not already installed):

```bash
/bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"

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

- **`homebrew_packages`**: List of CLI tools (e.g., `git`, `neovim`, `tree`).
- **`homebrew_cask_apps`**: List of GUI applications (e.g., `google-chrome`, `iterm2`).

### Enabling/Disabling Roles

To control which tasks are run, edit **`local.yml`**.

```yaml
roles:
  - common
  - zsh
  - nvim
  - wezterm
  # - macos     <-- Uncomment to enable
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
| **50-79** | **Apps (Roles)** | App-specific aliases and integration         | `50-wezterm.zsh`, `50-nvim.zsh`     |
| **80-89** | **Visuals**      | Syntax highlighting and theming              | `80-highlighting.zsh`               |
| **90-99** | **Local**        | Secrets and local overrides                  | `99-local_secrets.zsh`              |

## 🛠️ Role Template & Standardization

To maintain consistency across different tools, we use a **standardized role template**. This allows for a generic, reusable task structure where logic and data are strictly separated.

### 🏗️ Standard Role Structure

Every new role should follow this directory layout:

```text
roles/<role_name>/
├── defaults
│   └── main.yml        # Data: Package lists, symlink paths, and directories
├── files
│   ├── <role_name>/    # Files to be symlinked to the home directory (e.g., .zshrc)
│   └── <role_name>-conf-d/ # Files to be symlinked to ~/.config/zsh/conf.d/
└── tasks
    └── main.yml        # Logic: Generic tasks (Same for all roles)

```

### 📋 How to Create a New Role

We provide a `roles/role/` directory as a blueprint. Follow these steps to add a new tool:

1. **Create a new branch**:

```bash
git checkout -b add-<role_name>

```

2. **Copy the template**:

```bash
cp -r roles/role roles/<role_name>

```

3. **Configure the data**:
   Edit `roles/<role_name>/defaults/main.yml` to define your packages and symlinks.

- **Individual Link Rule**: We link files individually rather than linking entire directories to avoid conflicts in shared paths like `~/.config/zsh/conf.d/`.

4. **Add config files**:
   Place your configuration files in `roles/<role_name>/files/`.

5. **Enable the role**:
   Add the role name to `local.yml`.

6. **Verify and Push**:

```bash
make check
git add .
git commit -m "feat(<role_name>): add new role using standard template"
git push origin add-<role_name>
```

## 📂 Directory Structure

```text
.
├── Makefile              # Commands for easy execution (check/apply)
├── ansible.cfg           # Ansible configuration file
├── inventory             # Defines the target host (localhost)
├── local.yml             # Main playbook entry point
├── group_vars/
│   └── all.yml           # Global variables (Package lists, Repo URLs)
└── roles/                # Task definitions by category
    ├── common/           # Common CLI tools & basic Zsh configs
    ├── zsh/              # Zsh setup & Powerlevel10k
    ├── nvim/             # Neovim setup & config files
    ├── wezterm/          # WezTerm setup & config files
    └── macos/            # macOS system preferences

```

## ⚠️ Notes

- **Monorepo Structure**: Configuration files (dotfiles) are located inside `roles/<role_name>/files/`. Ansible symlinks them to the target destination.
