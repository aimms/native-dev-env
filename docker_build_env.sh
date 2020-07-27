#!/bin/bash

function build_image() {
  img_tag=`git describe --tags | sed 's/\-.*//'`

  local dir_name=$1
  local name="${2}:${img_tag}"
  pushd ./${dir_name}

  echo "Building ${name}..."
  docker build -t "${name}" --build-arg img_tag=${img_tag} .
  docker tag "${name}" "${img_name}:latest"

  popd
}

build_image base aimmspro/native-devenv-base
build_image essentials aimmspro/native-devenv-essentials
build_image devenv aimmspro/native-devenv
build_image devenvcpp aimmspro/native-devenv-cpp

