#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: $0 <Dockerfile path> <result_tag> [<from_tag>]"
  exit 1
fi

echo "$#"
pushd $1

if [ $# -eq 3 ]; then
  echo "Using base image: ${3}:latest"
  docker build -t $2 --build-arg FROM_IMAGE=${3}:latest .
elif [ $# -eq 2 ]; then
  docker build -t $2 .
else
  echo "Invalid arguments"
fi

popd
