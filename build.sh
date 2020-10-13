#!/usr/bin/env bash

set -e

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" || $# -gt 2 ]]; then
  echo "Usage: $0 <version> [--upload]"
  exit 1
fi

b_echo() {
  # shellcheck disable=SC2145
  echo "[build_env] $@"
}

version="$1"
upload="$2"
isolation=chroot # TODO: expose
prefix="aimmspro"

if [ "$upload" != "" ] ; then
  if [ "$upload" != "--upload" ]; then
    b_echo "ERROR: invalid argument: $upload"
    exit 1
  fi
  b_echo "Upload requested"
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

pushd "$script_dir"

image_exists() {
  local pfx_img_name="localhost/$1"

  for img in $(buildah images --format "{{.Name}}"); do
    if [ "$img" == "$pfx_img_name" ]; then
      echo 1
      return
    fi
  done
  echo 0
}

run_stage() {
  img_name="$1"
  pfx_img_name="$prefix/$img_name"

  # shellcheck disable=SC2046
  if [ "$(image_exists "$pfx_img_name")" == "0" ]; then
    b_echo "Building $pfx_img_name..."
    buildah bud --isolation "$isolation" \
                -v "$script_dir/assets:/assets:ro,Z" \
                --build-arg VERSION="$version" \
                -t "$pfx_img_name" -f "./stages/$img_name.dockerfile"

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

run_stage "devenv-essentials"
run_stage "devenv-native-base"
run_stage "devenv-native"
run_stage "devenv-native-ssh-server"
run_stage "devenv-cloud"

b_echo "Done"
popd # script_dir
