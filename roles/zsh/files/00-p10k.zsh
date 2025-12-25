# Load Powerlevel10k theme (Assuming installed via Homebrew)
# M1/M2/M3 Mac (Apple Silicon) path
if [ -f /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]; then
    source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# Intel Mac path
elif [ -f /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme ]; then
    source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
