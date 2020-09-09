#!/usr/bin/env bash

export HOME=/root
export DEBIAN_FRONTEND=noninteractive

# install basic tools
apt update && apt upgrade -y && apt install -y --no-install-recommends \
    zsh zsh vim wget git zip unzip python-is-python3 python3-venv locales fakeroot

# generate locales
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

wget -O - https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash -

mv ~/.pyenv /usr/local/pyenv
export PYENV_ROOT="/usr/local/pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$(pyenv init -)"
pyenv rehash
cp /host/assets/.zshrc ~/.zshrc

apt autoremove -y && rm -rf /var/lib/apt/lists/*
