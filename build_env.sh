#!/usr/bin/env bash

set -e

if [[  "$1" == "-h" || "$1" == "--help" || $# -gt 1  ]]; then
    echo "Usage: $0 <version>"
    exit 1
fi


script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

pushd $script_dir || exit

if [ "$1" != "" ]; then
	version="$1"
fi

os=ubuntu:20.04
container=build

pfx=aimmspro/devenv]
img_essentials=$pfx-essentials

img_native_base=$pfx-native-base
img_native=$pfx-native
img_native_theming=$pfx-native-theming
img_native_ssh_server=$pfx-native-ssh-server

img_cloud=$pfx-cloud
img_cloud_theming=$pfx-cloud-theming

b_echo(){
  # shellcheck disable=SC2145
  echo "[build_env] $@"
}

b_echo "Building devenv images"

create(){
  local container=$1
  local image=$2

  b_echo "Creating container: $container from: $image"
  set +e
  buildah rm $container 2> /dev/null
  set -e
  container=$(buildah from --name $container $image)
  container_exists=1
}

maybe_create(){
  local container=$1
  local image=$2

  b_echo "Building image: $image"

  if [ -e $container_exists ]; then
    create $container $image $image
  else
    b_echo "Using existing container: $container"
  fi
  echo "$container"
}

image_exists(){
  local image=$1

  for img in $(buildah images --format "{{.Name}}")
  do
    if [[ "$img" == "localhost/$image" ]]; then
      echo 1
      return
    fi
  done

  echo 0
}

maybe_upload(){
  if [[ "$version" != "" && $(image_exists $1) -eq 1 ]]; then
    b_echo "Uploading $1"
    buildah tag $1 "$1:latest"
    buildah tag $1 "$1:$version"
    buildah push "$1:$version"
    buildah push "$1:latest"
  fi
}

run_stage(){
    buildah unshare ./utils/buildah_run_in_chroot.sh $container $script_dir ./stages/$1
}

# shellcheck disable=SC2046
if [ $(image_exists $img_essentials) -eq 0 ]; then
  create $container $os $img_essentials

  buildah config --author "AIMMS B.V. <developer@aimms.com>" $container
  buildah config --env DEBIAN_FRONTEND=noninteractive $container
  buildah config --env GIT_EDITOR=vim $container
  buildah config --env PYENV_VIRTUALENV_DISABLE_PROMPT=1 $container
  buildah config --env LANG=en_US.utf8 $container
  buildah config --env LC_ALL=en_US.UTF-8 $container
  buildah config --env LANGUAGE=en_US:en $container
  buildah config --env TERM=xterm-256color $container

  run_stage 00_essentials.sh

  buildah config --entrypoint /bin/bash $container
  buildah commit $container $img_essentials
fi
maybe_upload $img_essentials

# shellcheck disable=SC2046
if [ $(image_exists $img_native_base) -eq 0 ]; then
  maybe_create $container $img_essentials

  run_stage 01_native_base.sh

  buildah commit $container $img_native_base
fi
maybe_upload $img_native_base


# shellcheck disable=SC2046
if [ $(image_exists $img_native) -eq 0 ]; then
  maybe_create $container $img_native_base $img_native

  run_stage 02_native.zsh

  buildah commit $container $img_native
fi
maybe_upload $img_native

# shellcheck disable=SC2046
#if [ $(image_exists $img_native_theming) -eq 0 ]; then
#  maybe_create $container $img_native $img_native_theming
#
#  buildah config --env DEVENV_THEMING=1 $container
#
#  run_stage 05_theming.zsh
#
#  buildah config --entrypoint /bin/zsh $container
#  buildah commit $container $img_native_theming
#fi
#maybe_upload $img_native_theming

#shellcheck disable=SC2046
if [ $(image_exists $img_native_ssh_server) -eq 0 ]; then
  create $container $img_native $img_native_ssh_server

  buildah config --env DEVENV_SSH_SERVER=1 $container
  buildah config --entrypoint "/usr/sbin/sshd -D" $container
  buildah config --port 22 $container

  run_stage 03_native_ssh_server.zsh

  buildah commit $container $img_native_ssh_server
fi
maybe_upload $img_native_ssh_server

#shellcheck disable=SC2046
if [ $(image_exists $img_cloud) -eq 0 ]; then
  create $container $img_essentials

  run_stage 04_cloud.zsh

  buildah commit $container $img_cloud
fi


## shellcheck disable=SC2046
#if [ $(image_exists $img_cloud_theming) -eq 0 ]; then
#  maybe_create $container $img_cloud $img_cloud_theming
#
#  buildah config --env DEVENV_THEMING=YES $container
#  buildah config --env TERM=xterm-256color $container
#  buildah config --entrypoint /bin/zsh $container
#
#  run_stage 06_theming.zsh
#
#  buildah commit $container $img_cloud_theming
#fi
#maybe_upload $img_cloud

set +e
buildah rm $container 2> /dev/null
b_echo 'Done'

popd || exit # script_dir
