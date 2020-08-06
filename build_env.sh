#!/bin/bash

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0 <version>"
    exit 1
fi

version="$1"

function build_image() {
  local dir_name=$1
  local img_name=$2
  local name="${2}:latest"

  echo "Building ${name}..."
  docker build -t ${name} ./${dir_name}
  docker tag ${name} "${img_name}:${version}"
  docker tag ${name} "${img_name}:latest"
}

build_image essentials aimmspro/devenv-essentials
build_image cloud aimmspro/devenv-cloud
build_image cloud-ohmyzsh aimmspro/devenv-cloud-ohmyzsh
build_image native aimmspro/devenv-native
build_image native-ohmyzsh aimmspro/devenv-native-ohmyzsh
