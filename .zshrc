# Set up the prompt
# autoload -Uz promptinit
# promptinit
# prompt adam1

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
setopt histignorealldups sharehistory
path+=("/home/nic/.local/bin")
path+=("/usr/local/go/bin")
# path+=("/home/nic/go/bin")

# Pyenv path to override windows...
path+=(" /home/nic/.pyenv")
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
## eval "$(oh-my-posh init zsh --config ~/mySettings/nicpowerline_linux.omp.json)"
# eval "$(starship init zsh)"
# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
if [ -f "/proc/sys/fs/binfmt_misc/WSLInterop" ] || uname -r | grep -qEi "(microsoft|wsl)"; then
  bindkey "^[[1;5D" backward-word
  bindkey "^[[1;5C" forward-word
  bindkey '^[[A' history-search-backward
  bindkey '^[[B' history-search-forward
fi

# Use modern completion system
autoload -Uz compinit
compinit

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
eval "$(zoxide init zsh)"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
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
 
alias ll='eza --icons=always -l'
alias la='eza --icons=always -la'
alias l='eza --icons=always -l'
alias ls='eza --icons=always'

alias d='docker'
alias dc='docker compose'
alias dcup='docker compose up -d'
alias dss='docker stack services'
alias ds='docker stack'
alias tf='terraform'
alias cat2='cat'
alias cat='bat'
alias thanos='rm -rf'
alias mk="minikube"
alias k="kubectl"
alias kc="kubecolor"
alias kk="kubecolor"
alias ".."="cd .."


if [ -f "/proc/sys/fs/binfmt_misc/WSLInterop" ] || uname -r | grep -qEi "(microsoft|wsl)"; then
    alias ssh='ssh.exe'
    alias ssh-add='ssh-add.exe'
fi
# These 2 aliases  hook up ssh to the 1Password SSH agent

plugins=(zsh-autosuggestions zsh-syntax-highlighting zoxide)
# . /home/nic/z.sh
 # eval $(dircolors -b $HOME/.dircolors)


## export NVM_DIR="$HOME/.nvm"
## [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
## [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# #kubectl autocompletion
# autoload -Uz compinit
# compinit
# source <(kubectl completion zsh)
# compdef kubecolor=kubectl

# get zsh complete kubectl
source <(kubectl completion zsh)
source <(kubecolor completion zsh)
# alias kubectl=kubecolor
# make completion work with kubecolor
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/kubecolor kubecolor

#minikube autocompletion
source <(minikube completion zsh)

source <(helm completion zsh)
# Load Angular CLI autocompletion.
# source <(ng completion script)

source <(kind completion zsh)

eval "$(starship init zsh)"

source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
