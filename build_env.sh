#!/usr/bin/env bash


#if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" || ($# -eq 2 && "$2" != "--upload") || $# -gt 2 ]]; then
#  echo "Usage: $0 <version>"
#  exit 1
#fi

#version="$1"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$script_dir" || exit

img_essentials=aimmspro/devenv-essentials
img_python=aimmspro/devenv-python

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
  maybe_create $container alpine

  apk update
  apk upgrade
  apk add bash zsh vim tmux curl fontconfig git zip unzip \
      automake autoconf make openssl-dev \
       zlib-dev bzip2-dev xz-dev libffi-dev \
       readline-dev sqlite-dev ncurses-dev \
       g++
       #llvm clang

  buildah config --env GIT_EDITOR=vim $container
  buildah config --env PYTHON_VERSION=3.8.5 $container
  buildah config --env PYENV_VIRTUALENV_DISABLE_PROMPT=1 $container
  buildah config --entrypoint /bin/zsh $container

  buildah commit $container $img_essentials
fi
# shellcheck disable=SC2046
if [ $(image_exists $img_python) -eq 0 ]; then
  maybe_create $container $img_essentials

  b bash -c 'curl https://pyenv.run | bash'
  b bash -c 'MAKE_OPTS="V=1 -j`grep -c ^processor /proc/cpuinfo`" /root/.pyenv/bin/pyenv install $PYTHON_VERSION --verbose'

  buildah copy --chown root $container $script_dir/assets/.zshrc /root/.zshrc
  buildah commit $container $img_python
  buildah rm $container
fi



#buildah copy --chown root $container $script_dir/assets /tmp
#b mv /tmp/.zshrc /root
#b /tmp/state0.zsh && rm -f /tmp/stage0.zsh


popd || exit # script_dir
