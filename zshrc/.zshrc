# -------------------------------------
# 🚀 Instant Prompt for Powerlevel10k
# -------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------------------------
# 📦 zinit
# -------------------------------------
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# -------------------------------------
# 🎨 Powerlevel10k Theme
# -------------------------------------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_DIR_PATH_SEPARATOR="/"
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_left"

# -------------------------------------
# 💡 Oh My Zsh
# -------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# -------------------------------------
# 🧠 General Aliases & Config
# -------------------------------------
alias cl="clear"
alias nd="npm run dev"
alias bd="bun run dev"
alias cd="z"
alias ci="cargo init"
alias cr="cargo run"

# -------------------------------------
# 🍺 Homebrew
# -------------------------------------
export PATH="/opt/homebrew/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"

# -------------------------------------
# ☕ SDKMAN (Java, etc.)
# -------------------------------------
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# -------------------------------------
# 🟢 Node.js - NVM
# -------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# -------------------------------------
# 🧠 Yazi File Manager
# -------------------------------------
export EDITOR=nvim
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(< "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd "$cwd"
    fi
    rm -f "$tmp"
}

# -------------------------------------
# 🧠 Zsh Plugins
# -------------------------------------
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# -------------------------------------
# 📜 Zsh History
# -------------------------------------
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history hist_expire_dups_first hist_ignore_dups hist_verify

# -------------------------------------
# ⌨️ Arrow key history navigation
# -------------------------------------
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# -------------------------------------
# 📁 Eza (better ls)
# -------------------------------------
alias ls="eza --icons=always"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2 --icons --git"

# -------------------------------------
# 📍 Zoxide (better cd)
# -------------------------------------
eval "$(zoxide init zsh)"

# -------------------------------------
# 🧠 VS Code
# -------------------------------------
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# -------------------------------------
# 🐍 Python
# -------------------------------------
export PATH="/usr/local/bin:$PATH"

# -------------------------------------
# 🔍 fzf + fd
# -------------------------------------
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
_fzf_compgen_dir() { fd --type=d --hidden --exclude .git . "$1"; }

# Source fzf-git if it exists
[[ -f ~/fzf-git.sh/fzf-git.sh ]] && source ~/fzf-git.sh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
    local command=$1
    shift
    case "$command" in
        cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
        export|unset) fzf --preview "eval 'echo ${}'" "$@" ;;
        ssh) fzf --preview 'dig {}' "$@" ;;
        *) fzf --preview "$show_file_or_dir_preview" "$@" ;;
    esac
}

# -------------------------------------
# 🐈 Bat (better cat)
# -------------------------------------
export BAT_THEME=tokyonight_night

# -------------------------------------
# 🤯 thefuck
# -------------------------------------
eval "$(thefuck --alias)"
eval "$(thefuck --alias fk)"

# -------------------------------------
# ⏳ Atuin
# -------------------------------------
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# -------------------------------------
# 🧪 Bun
# -------------------------------------
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# -------------------------------------
# 🌀 Git Aliases
# -------------------------------------
alias lg="lazygit"
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb="git branch"
alias gba="git branch -a"
alias gadd="git add"
alias ga="git add -p"
alias gcoall="git checkout -- ."
alias gr="git remote"
alias gre="git reset"

# -------------------------------------
# ⚙️ Custom Shell Env
# -------------------------------------
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# -------------------------------------
# 🧬 Conda Init (don't move)
# -------------------------------------
__conda_setup="$('/Users/yaswanthgudivada/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
elif [ -f "/Users/yaswanthgudivada/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/Users/yaswanthgudivada/miniconda3/etc/profile.d/conda.sh"
else
    export PATH="/Users/yaswanthgudivada/miniconda3/bin:$PATH"
fi
unset __conda_setup

# -------------------------------------
# LM Studio
# -------------------------------------
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/yaswanthgudivada/.lmstudio/bin"
# End of LM Studio CLI section
# -------------------------------------

# -------------------------------------
# Carapace
# -------------------------------------
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)
# export LS_COLORS="$(vivid generate catppuccin-mocha)"

# ------------------------------------
# Ruby 
# ------------------------------------
eval "$(rbenv init -)"

# ------------------------------------
# Selenium
# ------------------------------------
export CLASSPATH="/usr/local/lib/java/*:$CLASSPATH"

# ------------------------------------
# .local Path
# ------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# ------------------------------------
# 🔧 Go
# ------------------------------------
export PATH="$HOME/go/bin:$PATH"

# ------------------------------------
# Bun
# ------------------------------------
alias bun-setup="bun ~/.bun/setup-project.js"


# -----------------------------------
# Enable vim mode
# -----------------------------------
bindkey -v

# Keep common Emacs-style bindings inside vi mode ###

# In insert mode (viins map)
bindkey -M viins '^a' beginning-of-line   # Ctrl-a → go to start
bindkey -M viins '^e' end-of-line         # Ctrl-e → go to end
bindkey -M viins '^f' forward-char        # Ctrl-f → forward one char
bindkey -M viins '^b' backward-char       # Ctrl-b → backward one char
bindkey -M viins '^k' kill-line           # Ctrl-k → delete to end of line
bindkey -M viins '^u' backward-kill-line  # Ctrl-u → delete to start of line
bindkey -M viins '^y' undo                # Ctrl-y → undo
bindkey -M viins '^w' backward-kill-word  # Ctrl-w → delete word backwards
bindkey -M viins '^[d' kill-word          # Alt-d → delete word forwards
bindkey -M viins '^p' up-line-or-history  # Ctrl-p → prev command
bindkey -M viins '^n' down-line-or-history # Ctrl-n → next command
bindkey -M viins '^l' clear-screen        # Ctrl-l → clear
bindkey -M viins '^d' delete-char-or-list # Ctrl-d → exit if empty

# Same bindings for normal mode (vicmd map) where it makes sense
bindkey -M vicmd '^a' beginning-of-line
bindkey -M vicmd '^e' end-of-line
bindkey -M vicmd '^f' forward-char
bindkey -M vicmd '^b' backward-char
bindkey -M vicmd '^k' kill-line
bindkey -M vicmd '^u' backward-kill-line
bindkey -M vicmd '^y' undo
bindkey -M vicmd '^w' backward-kill-word
bindkey -M vicmd '^[d' kill-word
bindkey -M vicmd '^p' up-line-or-history
bindkey -M vicmd '^n' down-line-or-history
bindkey -M vicmd '^l' clear-screen
bindkey -M vicmd '^d' delete-char-or-list
