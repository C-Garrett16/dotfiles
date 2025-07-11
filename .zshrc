# Doom Emacs
export PATH="$HOME/.config/emacs/bin:$PATH"

# Pip
export PATH="$HOME.local/bin:$PATH"
# >>> Zinit load section >>>

# Load Zinit
source "${ZINIT_HOME:-$HOME/.zinit}/bin/zinit.zsh"

# Predictive text
zinit light zsh-users/zsh-autosuggestions

# Completions
zinit light zsh-users/zsh-completions

# History substring search (press up/down arrows with partial command)
zinit light zsh-users/zsh-history-substring-search

# Optional but faster than default:
# zinit light zdharma-continuum/fast-syntax-highlighting

# Syntax highlighting — must go LAST
zinit light zsh-users/zsh-syntax-highlighting

# <<< Zinit load section <<<

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# User Aliases
alias ls='eza -la --icons --color=always --group-directories-first'
alias lt='eza --tree --level=2'
alias needreboot='[[ "$(uname -r)" != "$(pacman -Q linux | awk "{print \$2}" | cut -d. -f1-2)" ]] && echo "Kernel mismatch: reboot recommended." || echo "No reboot needed."'
alias clean-cache='sudo paccache -r'

acp () {
  if [ -z "$1" ]; then
    echo "⚠️  Commit message required"
    return 1
  fi
  git add .
  git commit -m "$1"
  git push
}

restdoom () {
  killall emacs
  emacs --daemon
  emacsclient -c -a 'vim' &
}

# Prompt
eval "$(starship init zsh)"

# Mount Google Drive
#rclone mount gdrive: ~/GoogleDrive --vfs-cache-mode writes

# Created by `pipx` on 2025-05-09 14:21:08
export PATH="$PATH:/home/cgreid/.local/bin"
