alias ls="ls --color=auto"

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

export VISUAL nvim
export EDITOR nvim

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -Uz compinit
compinit

# modify zsh prompt
export PS1="%F{red}%n%f%F{grey}@ctf%f - %/ "
