#!/usr/bin/env bash

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: $0 <command>"
  exit 1
fi

if [ "$DOCKER_RUN_CMD" == "" ]; then
  DOCKER_RUN_CMD="docker run"
fi

if [ "$CONTAINERS_STORAGE" == "" ]; then
  CONTAINERS_STORAGE="$HOME/.local/share/containers/buildah_storage"
fi

echo "DOCKER_RUN_CMD: $DOCKER_RUN_CMD"
echo "CONTAINERS_STORAGE: $CONTAINERS"


script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

mkdir -p $CONTAINERS_STORAGE

# shellcheck disable=SC2145
$DOCKER_RUN_CMD --rm --net=host --security-opt label=disable --security-opt seccomp=unconfined --device /dev/fuse:rw -v $CONTAINERS_STORAGE:/var/lib/containers/storage:Z -v $script_dir:/host:Z  -it docker://quay.io/buildah/stable:latest bash -c "cd /host ; $@"

