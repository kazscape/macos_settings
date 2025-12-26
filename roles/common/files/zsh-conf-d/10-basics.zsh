# --- Aliases ---
alias reload-zsh="source ~/.zshrc"
# alias edit-zsh="nvim ~/.zshrc" 

# --- History Setup ---
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# --- Key Bindings ---
# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
