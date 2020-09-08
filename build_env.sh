#!/usr/bin/env bash

set -e


#if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" || ($# -eq 2 && "$2" != "--upload") || $# -gt 2 ]]; then
#  echo "Usage: $0 <version>"
#  exit 1
#fi

#version="$1"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$script_dir" || exit

pfx=aimmspro/devenv
img_essentials=$pfx-essentials
img_cloud=$pfx-cloud
img_cloud_theming=$pfx-cloud-theming

img_native=$pfx-native
img_native_theming=$pfx-native-theming

# essentials
container=build
#buildah rm $container 2> /dev/null

b(){
  # shellcheck disable=SC2068
  buildah run --runtime /usr/bin/crun $container -- "$@"
}

image_exists(){
  if [ "$(buildah images --format '{{.Name}}' | grep $1)" != "" ]; then
    echo 1
  else
    echo 0
  fi
}

maybe_create(){
  if [ -e $no_container ]; then
    buildah from --name $1 $2
    no_container=1
    echo "Created container: $1 from image: $2"
  fi
}


# shellcheck disable=SC2046
if [ $(image_exists $img_essentials) -eq 0 ]; then
  maybe_create $container ubuntu:20.04

  buildah config --env DEBIAN_FRONTEND=noninteractive $container
  buildah config --env GIT_EDITOR=vim $container
  buildah config --env PYENV_VIRTUALENV_DISABLE_PROMPT=1 $container
  buildah config --entrypoint /bin/zsh $container

  b apt update
  b apt upgrade -y
  b apt install -y --no-install-recommends \
    zsh vim tmux wget curl fontconfig git zip unzip git ca-certificates \
    python-is-python3 python3-venv

  b rm -rf /var/lib/apt/lists/*

  b bash -c 'curl https://pyenv.run | bash'

  buildah copy --chown root $container $script_dir/assets/.zshrc /root/.zshrc
  b zsh -c 'source ~/.zshrc ; pyenv global system'

  buildah commit --squash $container $img_essentials
fi

# shellcheck disable=SC2046
if [ $(image_exists $img_cloud) -eq 0 ]; then
  maybe_create $container $img_essentials

  buildah copy --chown root $container $script_dir/assets/cloud.zsh /tmp/
  b /tmp/cloud.zsh && rm -f /tmp/cloud.zsh
  buildah commit --squash $container $img_cloud
fi

# shellcheck disable=SC2046
if [ $(image_exists $img_native) -eq 0 ]; then
  maybe_create $container $img_cloud

  b apt update
  b apt upgrade -y
  b apt install -y --no-install-recommends doxygen graphviz ccache wget gnupg \
    lsb-release software-properties-common make autoconf automake
  b bash -c 'curl https://apt.llvm.org/llvm.sh | bash'
  b apt install -y --no-install-recommends libc++-dev libc++abi-dev clang-tidy-11
  b update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-11 100
  b update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 100
  b update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
  b update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100
  b update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-11 100

  b rm -rf /var/lib/apt/lists/*

  buildah copy --chown root $container $script_dir/assets/native.zsh /tmp/
  b /tmp/native.zsh && rm -f /tmp/native.zsh
  
  buildah commit --squash $container $img_native
fi

# shellcheck disable=SC2046
#if [ $(image_exists $img_cloud_theming) -eq 0 ]; then
#  maybe_create $container $img_cloud
#
#  buildah copy --chown root $container $script_dir/assets /tmp
#  b /tmp/theming.zsh && rm -f /tmp/*
#  buildah commit --squash $container $img_cloud_theming
#fi

#ARG BASE
#FROM aimmspro/devenv-$BASE:latest
#
#ENV TERM=xterm-256color
#ENV ENABLE_THEMING=YES
#
#COPY ../assets/logo.py /root/.logo.py
#COPY MesloLGS* /usr/share/fonts/truetype/
#RUN fc-cache -vf
#COPY ../assets/.p10k.zsh /root/
#COPY ../assets/theming.zsh /tmp/setup.zsh
#RUN /tmp/setup.zsh && rm -f /tmp/setup.zsh
#RUN zsh -c "source ~/.zshrc && info"
#
#CMD zsh

popd || exit # script_dir
