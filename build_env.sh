#!/usr/bin/env bash

set -e

#if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" || ($# -eq 2 && "$2" != "--upload") || $# -gt 2 ]]; then
#  echo "Usage: $0 <version>"
#  exit 1
#fi

#version="$1"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$script_dir" || exit

ubuntu_ver=20.04
i='apt install -y --no-install-recommends'

# essentials
container=essentials
img_essentials=aimmspro/devenv-essentials

container_exists(){
  buildah run --runtime /usr/bin/crun $1 -- sh -c ':' 2>/dev/null
  echo $?
}

# shellcheck disable=SC2046
if [ $(container_exists $container) -ne 0 ]; then
  buildah from --name $container ubuntu:$ubuntu_ver
  echo "Created new container: $container"

  b(){
    # shellcheck disable=SC2068
    buildah run --runtime /usr/bin/crun $container -- $@
  }

  buildah config --env DEBIAN_FRONTEND=noninteractive $container
  buildah config --env GIT_EDITOR=vim $container
  buildah config --env PYTHON_VERSION=3.8.5 $container
  buildah config --env PYENV_VIRTUALENV_DISABLE_PROMPT=1 $container
  buildah config --entrypoint /bin/zsh $container


  b apt update
  b apt upgrade -y
  b $i zsh vim tmux wget curl fontconfig git zip git ca-certificates
  b $i build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev libncurses5-dev libncursesw5-dev \
    xz-utils libffi-dev liblzma-dev python-openssl
  b $i llvm clang-10 libc++-dev libc++abi-dev

  b update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-10 100
  b update-alternatives --install /usr/bin/clang clang /usr/bin/clang-10 100
  b update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
  b update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100
  b rm -rf /var/lib/apt/lists/*
  buildah commit $container $img_essentials
  buildah rm $container
fi

container=python
if [ $(container_exists $container) -ne 0 ]; then
  buildah from --name $container $img_essentials 
  echo "Created new container: $container"

  b(){
    # shellcheck disable=SC2068
    buildah run --runtime /usr/bin/crun $container -- $@
  }
  b bash -c 'curl https://pyenv.run | bash'
  b bash -c 'MAKE_OPTS="V=1 -j`grep -c ^processor /proc/cpuinfo`" LLVM_PROFDATA=/usr/bin/llvm-profdata-10 CONFIGURE_OPTS=--enable-optimizations /root/.pyenv/bin/pyenv install $PYTHON_VERSION --verbose'

  buildah copy --chown root $container $script_dir/assets/.zshrc /root/.zshrc
  buildah commit $container aimmspro/devenv-python
  buildah rm $container
fi



#buildah copy --chown root $container $script_dir/assets /tmp
#b mv /tmp/.zshrc /root
#b /tmp/state0.zsh && rm -f /tmp/stage0.zsh


popd || exit # script_dir
