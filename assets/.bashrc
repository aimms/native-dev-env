export PYENV_ROOT="/usr/local/pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

if [[ "$SHELL" == "/bin/zsh" ]]; then
  alias vi-zshrc="vi $HOME/.zshrc"
  alias src-zshrc="source $HOME/.zshrc"
else
  alias vi-bashrc="vi $HOME/.bashrc"
  alias src-bashrc="source $HOME/.bashrc"
fi

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

alias a="pyenv activate"
alias v="pyenv versions"
alias c='(){ pyenv virtualenv $1 && pyenv activate $1 && pip install --upgrade pip && pip install wheel ;}'
