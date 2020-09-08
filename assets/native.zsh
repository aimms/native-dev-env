#!/usr/bin/env zsh

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

apt update && apt install -y --no-install-recommends \
      zsh make autoconf automake doxygen graphviz ccache \
      python-is-python3 python3-pyenv \
      llvm-11 clang-format-11 clang-tidy-11 clang-tools-11 clang-11 clangd-11 libc++-11-dev \
      libc++1-11 libc++abi-11-dev libc++abi1-11 libclang1-11 lld-11 llvm-11-runtime llvm-11


/host/assets/update_alternatives.sh 11 100

cp /host/assets/.zshrc $HOME/.zshrc

chown root:root $HOME/.zshrc

source $HOME/.zshrc

pyenv global system

c dev && pyenv global dev

pip install cmake
pip install conan
pip install ninja

apt autoremove -y
rm -rf /var/lib/apt/lists/*
