#!/usr/bin/env bash

set -e

if [[  "$1" == "-h" || "$1" == "--help" || $# -gt 1  ]]; then
    echo "Usage: $0 <version>"
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

pushd "$script_dir" || exit

if [ "$1" != "" ]; then
	version="$1"
else
  version="latest"
fi

isolation=chroot # TODO: take from input

b_echo(){
  # shellcheck disable=SC2145
  echo "[build_env] $@"
}

b_echo "Building devenv images"

image_exists(){
  local image=$1

  for img in $(buildah images --format "{{.Name}}")
  do
    if [[ "$img" == "localhost/$image" ]]; then
      echo 1
      return
    fi
  done

  echo 0
}

run_stage(){
    img_name="$1"
    # shellcheck disable=SC2046
    if [ $(image_exists "$img_name") -eq 0 ]; then
     buildah bud --isolation $isolation -v "$script_dir:/assets:ro,Z" -f "./stages/$img_name.dockerfile"
    fi

    if [[ "$version" != "latest" && $(image_exists $1) -eq 1 ]]; then
      b_echo "Uploading $img_name"
      buildah tag "$img_name" "$img_name:latest"
      buildah tag "$img_name" "$img_name:$version"
      buildah push "$img_name:$version"
      buildah push "$img_name:latest"
    fi
}

run_stage "devenv-essentials"
run_stage "devenv-native-base"
run_stage "devenv-native"
run_stage "devenv-native-ssh-server"
run_stage "devenv-cloud"

b_echo "Done"
popd # script_dir
