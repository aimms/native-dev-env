export PYENV_ROOT="/usr/local/pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

alias vi-rc="vi ~/.zshrc"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

alias v='pyenv versions'
a() { pyenv activate "$1"; }
c() { pyenv virtualenv "$1" && pyenv activate "$1" && pip install -U pip wheel; }
