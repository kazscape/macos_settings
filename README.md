# macOS Setup with Ansible

This repository automates the provisioning and configuration of a macOS development environment using **Ansible**. It manages Homebrew packages, dotfiles (via GNU Stow), and system preferences in a modular, role-based architecture.

## 🚀 Features

- **Role-Based Architecture**: Organized into modular roles (`homebrew`, `dotfiles`, `macos`, etc.) for better maintainability.
- **Makefile Support**: Simple commands to check and apply configurations without typing long Ansible commands.
- **Homebrew Management**: Automates installation of Formulae (CLI tools) and Casks (GUI applications).
- **Dotfiles Management**: Integrated with GNU Stow to symlink configuration files (currently optional).

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

*(Equivalent to: `ansible-playbook local.yml --syntax-check` and `--check` mode)*

### 2. Apply Changes

Executes the playbook and applies the configurations to your machine.
**Note:** You may be asked for your `sudo` password during execution for system changes.

```bash
make apply

```

## ⚙️ Configuration

You can customize the installation by editing the variables and playbook files.

### Managing Packages

To add or remove software, edit **`group_vars/all.yml`**:

* **`homebrew_packages`**: List of CLI tools (e.g., `git`, `neovim`, `tree`).
* **`homebrew_cask_apps`**: List of GUI applications (e.g., `google-chrome`, `iterm2`).
* **`homebrew_taps`**: List of third-party repositories.

### Enabling/Disabling Roles

To control which tasks are run, edit **`local.yml`**.
For example, if you want to enable the `dotfiles` role later, uncomment it here:

```yaml
  roles:
    - common
    - homebrew
    # - dotfiles  <-- Uncomment to enable
    # - macos     <-- Uncomment to enable

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
    ├── common/           # Basic setup tasks
    ├── homebrew/         # Installs Taps, Formulae, and Casks
    ├── dotfiles/         # Clones repo and runs GNU Stow
    ├── macos/            # macOS system preferences (Finder, Dock, etc.)
    └── zsh/              # Shell configuration

```

## ⚠️ Notes

* **Python Interpreter Warning**: You might see a warning `[WARNING]: Host 'localhost' is using the discovered Python interpreter...`. This is normal and can be safely ignored.
* **Dotfiles**: The `dotfiles` role is designed to work with [GNU Stow](https://www.gnu.org/software/stow/). Ensure your dotfiles repository structure is compatible before enabling the role.

```

```
