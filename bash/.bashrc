#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
alias zed="zeditor"
export LS_COLORS="di=38;2;167;192;128"
eval "$(starship init bash)"
export EDITOR=fresh
export VISUAL=fresh
# Created by `pipx` on 2026-07-11 11:27:49
export PATH="$PATH:/home/ryanb/.local/bin"
eval "$(direnv hook bash)"

# opencode
export PATH=/home/ryanb/.opencode/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
