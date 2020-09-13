#!/usr/bin/env bash

set -e

export HOME=/root
export DEBIAN_FRONTEND=noninteractive

apt update && apt upgrade -y
apt install -y --no-install-recommends gnupg ca-certificates wget fakeroot

# add latest clang / llvm repo
fakeroot --  mknod -m 666 /dev/null c 1 3
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

cat << EOF >> /etc/apt/sources.list
deb http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main
deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main
EOF

# installing dev tools
apt update && apt install -y --no-install-recommends \
      make autoconf automake doxygen graphviz ccache \
      llvm-11 clang-format-11 clang-tidy-11 clang-tools-11 clang-11 clangd-11 libc++-11-dev \
      libc++1-11 libc++abi-11-dev libc++abi1-11 libclang1-11 lld-11 llvm-11-runtime llvm-11

/host/assets/update_alternatives.sh 11 100

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export PYENV_ROOT="/usr/local/pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

pyenv global system

pyenv virtualenv dev
pyenv activate dev

c dev
pyenv global dev

pip install cmake

ln -s /usr/local/pyenv/shims/cmake /usr/bin/cmake

pip install ninja
pip install conan

mkdir -p $HOME/.conan
# allowing conan to use latest clang
cp /host/assets/conan_settings.yml $HOME/.conan/settings.yml

apt autoremove -y && rm -rf /var/lib/apt/lists/*
