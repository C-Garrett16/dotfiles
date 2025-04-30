
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


# Prompt
eval "$(starship init zsh)"
