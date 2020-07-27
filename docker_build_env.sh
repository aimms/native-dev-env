#!/bin/bash



function build_image() {
  img_name=$0
  img_tag=`git describe --tags`
  name="${img_name}:${img_tag}"

  pushd docker

  echo "Building ${name}..."
  docker build -t ${name} --build-arg img_tag=${img_tag}
  docker tag ${name} "${img_name}:latest"
}

build_image base
#build_image essentials
#build_image devenv

popd
