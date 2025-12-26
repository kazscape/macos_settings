# ==============================================================================
# 0. Powerlevel10k Instant Prompt (MUST BE AT THE TOP)
# ==============================================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
# 1. Base Configuration (XDG Standard)
# ==============================================================================
# Define the standard configuration directory
export XDG_CONFIG_HOME="$HOME/.config"
export ZSH_CONFIG_DIR="$XDG_CONFIG_HOME/zsh/conf.d"

# Ensure PATH includes standard locations
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# ==============================================================================
# 2. Dynamic Configuration Loading
# ==============================================================================
# Load all .zsh files from ~/.config/zsh/conf.d/
if [ -d "$ZSH_CONFIG_DIR" ]; then
    # (N) flag prevents error if no files match
    for config_file in "$ZSH_CONFIG_DIR"/*.zsh(N); do
        source "$config_file"
    done
fi

# ==============================================================================
# 3. Other Settings
# ==============================================================================
# (必要であればここにプロンプト設定や補完の設定などを追記)
autoload -Uz compinit && compinit

# Added by Antigravity
export PATH="/Users/kazuharu.yamauchi/.antigravity/antigravity/bin:$PATH"
