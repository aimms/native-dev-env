#!/bin/bash

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" || ( $# -eq 2 && "$2" != "--upload" ) || $# -gt 2  ]]; then
    echo "Usage: $0 <version>"
    exit 1
fi

version="$1"

function build_image() {
  local dir_name=$1
  local img_name=$2
  local name="${img_name}:latest"
  local v_name="${img_name}:${version}"
  local upload="$3"

  if [  "$4" != "" ]; then
    local build_arg="--build-arg BASE=$4"
  fi

  echo "Building ${name}..."
  docker build -t ${name} $build_arg ./${dir_name}
  docker tag ${name} "${v_name}"

  if [ "${upload}" == "--upload" ]; then
    echo "Uploading image: ${img_name}"
    docker push "${v_name}"
    docker push "${name}"
  fi
}

build_image essentials aimmspro/devenv-essentials "$2"
build_image python aimmspro/devenv-python "$2"
build_image cloud aimmspro/devenv-cloud "$2"
build_image theming aimmspro/devenv-cloud-theming "$2" "cloud"
build_image native aimmspro/devenv-native "$2"
build_image theming aimmspro/devenv-native-theming "$2" "native"
