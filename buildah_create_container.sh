#!/usr/bin/env bash

if [[ $# -lt 2 || "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: $0 <container name>"
  exit 1
fi

os="ubuntu:20.04"

container=$(buildah from --name $1 $os)
buildah config --env DEBIAN_FRONTEND=noninteractive $container
buildah config --env GIT_EDITOR=vim $container
buildah config --env PYENV_VIRTUALENV_DISABLE_PROMPT=1 $container
buildah config --entrypoint /bin/zsh $container
buildah config --env LANG=en_US.utf8 $container
buildah config --env LC_ALL=en_US.UTF-8 $container
buildah config --env LANGUAGE=en_US:en $container