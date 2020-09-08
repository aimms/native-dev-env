#!/usr/bin/env bash

export HOME=/root

# install basic tools
DEBIAN_FRONTEND=noninteractive \
  apt update && apt upgrade -y && apt install -y --no-install-recommends \
    zsh vim curl wget git zip unzip ca-certificates python-is-python3 python3-venv locales

# generate locales
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8


curl https://pyenv.run | bash

cp /host/assets/.zshrc ~/.zshrc

zsh -c 'source ~/.zshrc ; pyenv global system'

rm -rf /var/lib/apt/lists/*
