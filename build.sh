#!/usr/bin/env bash

set -e

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" || $# -gt 3 ]]; then
  echo "Usage: $0 <version> [--rootless] [--upload]"
  exit 1
fi

b_echo() {
  # shellcheck disable=SC2145
  echo "[build_env] $@"
}

version="$1"

if [[ "$2" == "--rootless" || "$3" == "--rootless" ]]; then
    isolation=rootless
else
    isolation=chroot
fi

b_echo "Using isolation: $isolation"

prefix="aimmspro"

if [[ "$2" == "--upload" || "$3" == "--upload" ]]; then
  upload=1
  b_echo "Upload requested"
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

pushd "$script_dir"

image_exists() {
  local pfx_img_name="localhost/$1"

  for img in $(buildah images --format "{{.Name}}:{{.Tag}}"); do
    if [ "$img" == "$pfx_img_name:$version" ]; then
      echo 1
      return
    fi
  done
  echo 0
}

build_image() {
  img_name="$1"
  pfx_img_name="$prefix/$img_name"

  # shellcheck disable=SC2046
  if [ "$(image_exists "$pfx_img_name")" == "0" ]; then
    b_echo "Building $pfx_img_name..."
    buildah bud --runtime crun --isolation "$isolation" \
                -v "$script_dir/$img_name:/install:ro,Z" \
                --build-arg VERSION="$version" \
                -t "$pfx_img_name" -f "$img_name/Dockerfile"

    buildah tag "$pfx_img_name:latest" "$pfx_img_name:$version"
  else
      b_echo "Skipping $1"
  fi

  if [[ "$upload" != "" && $(image_exists "$pfx_img_name") -eq 1 ]]; then
    b_echo "Uploading $pfx_img_name..."

    buildah push "$pfx_img_name:$version"
    buildah push "$pfx_img_name:latest"
  fi
}

build_image "devenv-essentials"
#build_image "devenv-cloud"
#build_image "devenv-native-base"
#build_image "devenv-native"
#build_image "devenv-native-ssh-server"

b_echo "Done"
popd # script_dir
