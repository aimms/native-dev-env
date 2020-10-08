if [[ "$SHELL" == "/bin/zsh" ]]; then
  alias vi-rc="vi $HOME/.zshrc"
  alias s-rc="source $HOME/.zshrc"
else
  alias vi-rc="vi $HOME/.bashrc"
  alias s-rc="source $HOME/.bashrc"
fi

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

alias v="pyenv versions"
a(){ pyenv activate $1 ; }
c(){ pyenv virtualenv $1 && pyenv activate $1 && pip install --upgrade pip && pip install wheel ; }
