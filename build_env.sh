#!/bin/bash

if [[  "$1" != "" && "$1" != "--skip-devenv-cpp"  ]]; then
  echo "Usage: $0 [--skip-devenv-cpp]"
  exit 1
fi

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

if [ "$1" == "--skip-devenv-cpp" ]; then
  echo "Skiping creating of devenv-cpp"
  exit 0
fi

build_image devenvcpp aimmspro/native-devenv-cpp
