#!/bin/bash

if [ $# -lt 1  ]; then
  echo "Usage: $0 tag_prefix"
  exit 1
fi

echo "Building ${1}/base..."
pushd docker
./utils/docker_build.sh ./base ${1}/base
echo "Building ${1}/essentials..."
./utils/docker_build.sh ./essentials ${1}/essentials ${1}/base
echo "Building ${1}/devenv..."
./utils/docker_build.sh ./devenv ${1}/devenv ${1}/essentials
#echo "Building ${1}/devenvcpp..."
#./utils/docker_build.sh ./devenvcpp ${1}/devenvcpp ${1}/devenv

popd
