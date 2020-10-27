#!/usr/bin/env bash

set -e

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" || $# -gt 2 ]]; then
  echo "Usage: $0 <version> [--upload]"
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

mkdir -p ~/.local/share/containers
docker run --security-opt label=disable --security-opt seccomp=unconfined --device /dev/fuse:rw -v ~/.local/share/containers:/var/lib/containers:Z  -v "$script_dir":/code  quay.io/buildah/stable /bin/bash -c "cd /code/ && ./build.sh $1 $2"
