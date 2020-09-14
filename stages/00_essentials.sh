#!/usr/bin/env bash

set -e

export DEBIAN_FRONTEND=noninteractive

apt update
apt install -y --no-install-recommends fakeroot

fakeroot -- mknod -m 600 /dev/console c 5 1
fakeroot -- mknod -m 666 /dev/null c 1 3
fakeroot -- mknod -m 622 /dev/console c 5 1
fakeroot -- mknod -m 666 /dev/null c 1 3
fakeroot -- mknod -m 666 /dev/zero c 1 5
fakeroot -- mknod -m 666 /dev/ptmx c 5 2
fakeroot -- mknod -m 666 /dev/tty c 5 0
fakeroot -- mknod -m 444 /dev/random c 1 8
fakeroot -- mknod -m 444 /dev/urandom c 1 9

# install basic tools
apt upgrade -y && apt install -y --no-install-recommends \
    zsh vim wget curl git zip unzip python-is-python3 python3-venv locales fakeroot

# generate locales
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

curl https://pyenv.run | bash

mv $HOME/.pyenv /usr/local/pyenv
export PYENV_ROOT="/usr/local/pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$(pyenv init -)"
pyenv rehash

cp /host/assets/.bashrc $HOME/.bashrc
chown root:root $HOME/.bashrc

apt autoremove -y && rm -rf /var/lib/apt/lists/*
