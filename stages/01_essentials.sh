#!/usr/bin/env bash

set -e

export DEBIAN_FRONTEND=noninteractive

# install basic tools
apt update && apt upgrade -y && apt install -y --no-install-recommends \
    zsh vim wget git zip unzip python-is-python3 python3-venv locales fakeroot

chsh -s /bin/bash

# generate locales
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

wget -O - https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash -

mv $HOME/.pyenv /usr/local/pyenv
export PYENV_ROOT="/usr/local/pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$(pyenv init -)"
pyenv rehash

cp /host/assets/.bashrc $HOME/.bashrc
chown root:root $HOME/.bashrc

apt autoremove -y && rm -rf /var/lib/apt/lists/*
