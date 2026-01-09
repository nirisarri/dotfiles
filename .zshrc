# ============================================================================
# ZSH Configuration File (.zshrc)
# ============================================================================
# This file configures the Z shell with prompt, completions, keybindings,
# aliases, and integrations for a development environment on macOS.
# ============================================================================

# ============================================================================
# HOMEBREW ENVIRONMENT
# ============================================================================
# Add Homebrew bin directory (macOS only)
if [ "$(uname)" = "Darwin" ]; then
  export homebrew="/opt/homebrew"
else
  export homebrew="/home/linuxbrew/.linuxbrew"
fi

path+=("$homebrew"/bin)

# Initialize Homebrew environment variables (required for macOS)
eval "$($homebrew/bin/brew shellenv)"

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================
# Share history between sessions and ignore duplicates
setopt histignorealldups sharehistory
# Keep 10000 lines of history within the shell and save it to ~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify


# ============================================================================
# PATH CONFIGURATION
# ============================================================================
# Add local bin directory to PATH
path+=("/Users/nic/.local/bin")

# path+=("/usr/local/go/bin")
# path+=("/home/nic/go/bin")

# (Pyenv and alternative prompt systems disabled; using oh-my-posh instead)

# ============================================================================
# KEYBINDINGS
# ============================================================================
# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e
# ============================================================================
# PLATFORM-SPECIFIC KEYBINDINGS
# ============================================================================
# Configure word navigation and history search based on OS
if [ -f "/proc/sys/fs/binfmt_misc/WSLInterop" ] || uname -r | grep -qEi "(microsoft|wsl)"; then
  bindkey "^[[1;5D" backward-word
  bindkey "^[[1;5C" forward-word
  bindkey '^[[A' history-search-backward
  bindkey '^[[B' history-search-forward
elif [ "$(uname)" = "Darwin" ]; then
  # macOS keybindings for history search and word navigation
  bindkey '^[[A' history-search-backward
  bindkey '^[[B' history-search-forward
  bindkey '^[[1;3D' backward-word
  bindkey '^[[1;3C' forward-word
fi


# ============================================================================
# FZF (FUZZY FINDER) INTEGRATION
# ============================================================================
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
eval "$(zoxide init zsh)"
# Use fd for faster file searching with fzf, excluding .git directories
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"


# ============================================================================
# COMPLETION SYSTEM
# ============================================================================
# Load and configure the modern zsh completion system
autoload -Uz compinit
compinit

# ============================================================================
# COMPLETION STYLING
# ============================================================================
# Configure appearance and behavior of completion system
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# ============================================================================
# COMMAND ALIASES
# ============================================================================
# File listing (using eza for better file display)
alias ll='eza --icons=always -l'
alias la='eza --icons=always -la'
alias l='eza --icons=always -l'
alias ls='eza --icons=always'

# Docker aliases
alias d='docker'
alias dc='docker compose'
alias dcup='docker compose up -d'
alias dss='docker stack services'
alias ds='docker stack'

# Utility aliases
alias tf='terraform'
alias cat2='/bin/cat'          # Fallback to system cat
alias cat='bat'               # Use bat for syntax-highlighted file viewing
alias thanos='rm -rf'          # Dangerous remove (use with caution!)
alias ".."="cd .."            # Quick parent directory navigation

# ============================================================================
# PLATFORM-SPECIFIC ALIASES
# ============================================================================
# WSL-specific aliases (not applicable on macOS but included for portability)
if [ -f "/proc/sys/fs/binfmt_misc/WSLInterop" ] || uname -r | grep -qEi "(microsoft|wsl)"; then
    alias ssh='ssh.exe'
    alias ssh-add='ssh-add.exe'
fi

# ============================================================================
# PLUGIN CONFIGURATION
# ============================================================================
# Load zsh plugins for enhanced functionality
plugins=(zsh-autosuggestions zsh-syntax-highlighting zoxide)

# ============================================================================
# DISABLED: NVM (Node Version Manager) - Uncomment if needed
# ============================================================================
## export NVM_DIR="$HOME/.nvm"
## [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
## [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ============================================================================
# DISABLED: kubectl autocompletion - Uncomment if using kubectl/kubecolor
# ============================================================================
# source <(kubectl completion zsh)
# source <(kubecolor completion zsh)
# compdef kubecolor=kubectl
# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/bin/kubecolor kubecolor

# ============================================================================
# DISABLED: Kubernetes tools - Uncomment if using minikube, helm, kind, etc.
# ============================================================================
# source <(minikube completion zsh)
# source <(helm completion zsh)
# source <(kind completion zsh)
# eval "$(starship init zsh)"

# ============================================================================
# PROMPT INITIALIZATION
# ============================================================================
# Initialize oh-my-posh prompt with catpuccin macchiato theme (macOS only)
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/catpuccin_macchiato.omp.json)"
fi

# ============================================================================
# ZSH PLUGIN SOURCING
# ============================================================================
# Load zsh-autosuggestions plugin from Homebrew installation
source $homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ============================================================================
# Configuration Complete
# ============================================================================
