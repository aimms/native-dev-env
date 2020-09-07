#!/bin/bash


script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

mkdir -p $HOME/mycontainers

$1 run --runtime crun --rm --net=host --security-opt label=disable --security-opt seccomp=unconfined --device /dev/fuse:rw -v $HOME/mycontainers:/var/lib/containers:Z -v $script_dir:/code:Z  -it docker://quay.io/buildah/stable:latest /code/build_env.sh
 
