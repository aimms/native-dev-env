#!/bin/bash

function build_image() {
  local dir_name=$1
  local img_name=$2
  local name="${2}:latest"
  pushd ./${dir_name}

  echo "Building ${name}..."
  docker build -t "${name}" .
  docker tag "${name}" "${img_name}:latest"

  popd
}

build_image base aimmspro/native-devenv-base
build_image essentials aimmspro/native-devenv-essentials
build_image devenv aimmspro/native-devenv
