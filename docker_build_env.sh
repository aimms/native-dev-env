#!/bin/bash

function build_image() {
  local img_tag=`git describe --tags | sed 's/\-.*//'`
  if [ -e "$img_tag" ]; then
    img_tag=latest
  fi

  local dir_name=$1
  local img_name=$2
  local name="${2}:${img_tag}"
  pushd ./${dir_name}

  echo "Building ${name}..."
  docker build -t "${name}" .
  docker tag "${name}" "${img_name}:latest"

  popd
}

build_image base aimmspro/native-devenv-base
build_image essentials aimmspro/native-devenv-essentials
build_image devenv aimmspro/native-devenv
#build_image devenvcpp aimmspro/native-devenv-cpp

