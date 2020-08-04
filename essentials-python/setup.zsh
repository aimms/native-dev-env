#!/bin/zsh

echo "export PATH=\"${HOME}/.pyenv/bin:\$PATH\"" >> ~/.zshrc
echo "export PYTHON_VERSION=\"$1\"" >> ~/.zshrc

cat << 'EOF' >> ~/.zshrc

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
alias a="pyenv activate"
alias v="pyenv versions"
alias c='(){ pyenv virtualenv $1 && pyenv activate $1 && pip install --upgrade pip && pip install wheel ;}'
EOF

