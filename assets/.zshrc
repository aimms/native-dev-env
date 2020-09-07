alias vi-zshrc="vi ~/.zshrc"
alias src-zshrc="source ~/.zshrc"

export PATH="/root/.pyenv/bin:$PATH"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
alias a="pyenv activate"
alias v="pyenv versions"
alias c='(){ pyenv virtualenv $1 && pyenv activate $1 && pip install -U pip && pip install -U wheel && pip install -U setuptools ;}'