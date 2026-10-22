export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_MAGIC_FUNCTIONS=true
plugins=(git python archlinux history sudo copypath copyfile dirhistory jsontools)
source $ZSH/oh-my-zsh.sh

export EDITOR='micro'

# Historique
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE HIST_VERIFY INC_APPEND_HISTORY SHARE_HISTORY

# Navigation et completion
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt COMPLETE_IN_WORD ALWAYS_TO_END AUTO_MENU

# Plugins systeme (chemins Arch)
for f in /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
         /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
    [ -f "$f" ] && source "$f"
done
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_HIGHLIGHT_MAXLENGTH=200
command -v fzf >/dev/null && source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

export PATH="$HOME/.local/bin:$PATH"

# Alias generaux
alias zshconfig="$EDITOR ~/.dotfiles/zsh/.zshrc"
alias reload="source ~/.zshrc"
alias cl="clear"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"
alias ls="eza --icons --group-directories-first"
alias ll="eza -alh --icons --group-directories-first"
alias la="eza -a --icons --group-directories-first"
alias lt="eza --tree --icons -a -I '.git|node_modules|.cache'"
alias cat="bat --style=plain --paging=never"
alias grep="grep --color=auto"
alias df="df -h"
alias du="du -h"

# Alias git
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"
alias gla="git log --oneline --graph --decorate --all"
alias gcm="git commit -m"
alias gp="git push"
alias gpu="git pull"

# Alias dev / systeme
alias python="python3"
alias serve="python3 -m http.server 8000"
alias ports="sudo lsof -i -P | grep LISTEN"
alias update="yay -Syu"

# Fonctions
mkd() { mkdir -p "$@" && cd "$_"; }
cdl() { cd "$1" && ll; }
backup() { cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"; }
search() { rg --color=always --line-number --no-heading "$@" | fzf --ansi; }
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2|*.tbz2) tar xjf "$1" ;;
            *.tar.gz|*.tgz)   tar xzf "$1" ;;
            *.tar)            tar xf "$1" ;;
            *.bz2)            bunzip2 "$1" ;;
            *.gz)             gunzip "$1" ;;
            *.zip)            unzip "$1" ;;
            *.7z)             7z x "$1" ;;
            *)                echo "'$1' : format non gere" ;;
        esac
    else
        echo "'$1' n'est pas un fichier"
    fi
}

# ETNA
export ETNA_LOGIN="bardat_r"
alarma() { ssh "${ETNA_LOGIN}@alarma.my-etna.io"; }
gac() {
    case "$PWD" in
        *etna-repos*) echo "gac desactive dans etna-repos"; return 1 ;;
    esac
    [ -z "$1" ] && { echo "Usage: gac \"message\""; return 1; }
    git add -A && git commit -m "$*" && git push
}

# Prompt Starship + prompt transitoire
eval "$(starship init zsh)"
zle-line-init() {
    emulate -L zsh
    [[ $CONTEXT == start ]] || return 0
    while true; do
        zle .recursive-edit
        local -i ret=$?
        [[ $ret == 0 && $KEYS == $'\4' ]] || break
        [[ -o ignore_eof ]] || exit 0
    done
    local saved_prompt=$PROMPT saved_rprompt=$RPROMPT
    PROMPT="%F{green}"$'\uf0da'"%f "
    RPROMPT=''
    zle .reset-prompt
    PROMPT=$saved_prompt
    RPROMPT=$saved_rprompt
    if (( ret )); then
        zle .send-break
    else
        zle .accept-line
    fi
    return ret
}
zle -N zle-line-init

# Reglages propres a cette machine (hors dotfiles)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
