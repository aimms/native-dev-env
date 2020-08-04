#!/bin/zsh

cat << 'EOF' >> ~/.zshrc

# zsh plugins
plugins=(
  git
  cargo
  rust
  rustup
  cp
  debian
  dirhistory
  dirpersist
  encode64
  gitignore
  helm
  kubectl
  pip
  pyenv
  terraform
  tmux
)

# oh-my-zsh theme
ZSH_THEME="avit"

export GIT_EDITOR=vim

alias vi-zshrc="vi ~/.zshrc"
alias src-zshrc="source ~/.zshrc"

EOF

