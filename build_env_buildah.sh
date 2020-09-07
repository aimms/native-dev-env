#!/usr/bin/env bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd "$script_dir" || exit

ubuntu_ver=20.04

# essentials
container=$(buildah from ubuntu:$ubuntu_ver)

alias b='buildah run --runtime /usr/bin/crun $container -- '
mo
i='apt install -y --no-install-recommends'


buildah config --env DEBIAN_FRONTEND=noninteractive $container

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        locales software-properties-common wget ca-certificates build-essential cmake doxygen graphviz ccache cppcheck openssh-server gdb rsync ninja-build zip gnupg python3-pip sudo \
    && rm -rf /var/lib/apt/lists/*


b apt update
b apt upgrade -y
b $i zsh vim tmux wget curl fontconfig git zip git ca-certificates
b $i build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev  libncurses5-dev libncursesw5-dev \
    xz-utils libffi-dev liblzma-dev python-openssl
b $i llvm clang-10 libc++-dev libc++abi-dev

b update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-10 100
b update-alternatives --install /usr/bin/clang clang /usr/bin/clang-10 100
b update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
b update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100
b rm -rf /var/lib/apt/lists/*

#container=$(buildah from aimmspro/devenv-essentials)

buildah config --env GIT_EDITOR=vim $container

buildah config --env PYTHON_VERSION=3.8.5 $container
buildah config --env PYENV_VIRTUALENV_DISABLE_PROMPT=1 $container

b bash -c 'curl https://pyenv.run | bash'
b bash -c 'MAKE_OPTS="V=1 -j`grep -c ^processor /proc/cpuinfo`" LLVM_PROFDATA=/usr/bin/llvm-profdata-10 CONFIGURE_OPTS=--enable-optimizations /root/.pyenv/bin/pyenv install $PYTHON_VERSION --verbose'

buildah copy --chown root $container $script_dir/assets /tmp
b mv /tmp/.zshrc /root
b /tmp/state0.zsh && rm -f /tmp/stage0.zsh

buildah config --entrypoint /bin/zsh $container

buildah commit $container aimmspro/devenv-cloud


popd || exit # script_dir