#!/bin/zsh

mv ~/.zshrc ~/.zshrc.oh-my-zsh

cat << 'EOF' >> ~/.zshrc

alias vi-zshrc="vi ~/.zshrc"
alias src-zshrc="source ~/.zshrc"
export GIT_EDITOR=vim
export PATH="${HOME}/.cargo/bin:${HOME}/.pyenv/bin:$PATH"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
alias a="pyenv activate"
alias v="pyenv versions"
alias c='(){ pyenv virtualenv $1 && pyenv activate $1 && pip install --upgrade pip && pip install wheel ;}'

if [[ ${ENABLE_OH_MY_ZSH} == "YES" ]]; then
  source ~/.zshrc.oh-my-zsh

  # zsh plugins
  plugins=(
    git
    cargo
    rust
    rustup
    encode64
    gitignore
    kubectl
    pip
    pyenv
    terraform
    tmux
  )

  # oh-my-zsh theme
  ZSH_THEME="avit"
fi

EOF


