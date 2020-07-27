#!/bin/zsh

echo "export PATH=\"${HOME}/.pyenv/bin:${HOME}/.cargo/bin:\$PATH\"" >> ~/.zshrc
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
  zsh_reload
  dirhistory
)

# oh-my-zsh theme
ZSH_THEME="avit"

export GIT_EDITOR=vim

alias vi-zshrc="vi ~/.zshrc"
alias src-zshrc="source ~/.zshrc"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
alias a="pyenv activate"
alias v="pyenv versions"
alias c='(){ pyenv virtualenv $1 && pyenv activate $1 && pip install --upgrade pip ;}'
EOF
