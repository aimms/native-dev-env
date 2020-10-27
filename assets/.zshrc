export PYENV_ROOT="/usr/local/pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

alias vi-rc="vi ~/.zshrc"

if [ "$TERM" != "xterm-256color" ]; then
    alias src="source ~/.zshrc"
fi

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

alias v='pyenv versions'
a() { pyenv activate "$1"; }
c() { pyenv virtualenv "$1" && pyenv activate "$1" && pip install -U pip wheel; }

# PROMPT='%(?.%F{green}❯.%F{red}?%?)%f %B%F{240}%1~%f%b %# '
PROMPT='%(?.%F{green}>.%F{red}?%?)%f %B%F{240}%1~%f%b %# '
