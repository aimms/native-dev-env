#!/usr/bin/env zsh

set -e

export HOME=/root

# shellcheck disable=SC1090
source $HOME/.bashrc

c dev
pyenv global dev
pip install conan ninja cmake
ln -s /usr/local/pyenv/shims/cmake /usr/bin/cmake

mkdir -p $HOME/.conan
# allowing conan to use latest clang
cp /host/assets/conan_settings.yml $HOME/.conan/settings.yml

apt autoremove -y && rm -rf /var/lib/apt/lists/*
