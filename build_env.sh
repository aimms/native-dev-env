#!/bin/bash

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" || ( $# -eq 2 && "$2" != "--upload" ) || $# -gt 2  ]]; then
    echo "Usage: $0 <version>"
    exit 1
fi

version="$1"

function build_image() {
  local dir_name=$1
  local img_name=$2
  local name="${2}:latest"
  local upload="$3"

  echo "Building ${name}..."
  docker build -t ${name} ./${dir_name}
  docker tag ${name} "${img_name}:${version}"
  docker tag ${name} "${img_name}:latest"

  if [ "${upload}" == "--upload" ]; then
    echo "Uploading image: ${img_name}"
    docker push "${img_name}:${version}"
    docker push "${name}"
  fi
}

build_image essentials aimmspro/devenv-essentials "$2"
build_image python aimmspro/devenv-python "$2"
build_image cloud aimmspro/devenv-cloud "$2"
build_image cloud-ohmyzsh aimmspro/devenv-cloud-ohmyzsh "$2"
build_image native aimmspro/devenv-native "$2"
build_image native-ohmyzsh aimmspro/devenv-native-ohmyzsh "$2"
