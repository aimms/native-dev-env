#!/bin/bash



function build_image() {
  pushd ./$1

  img_name=$1
  img_tag=`git describe --tags | sed 's/\-.*//'`
  name="${img_name}:${img_tag}"

  echo "Building ${name}..."
  docker build -t "${name}" --build-arg img_tag=${img_tag} .
  docker tag "${name}" "${img_name}:latest"

  popd
}

build_image base
build_image essentials
#build_image devenv

