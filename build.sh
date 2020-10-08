#!/usr/bin/env bash

set -e

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" || $# -gt 2 ]]; then
    echo "Usage: $0 <version> [--upload]"
    exit 1
fi

b_echo(){
  # shellcheck disable=SC2145
  echo "[build_env] $@"
}

upload="$2"
if [[ "$upload" != "" && "$upload" != "--upload" ]];then
  b_echo "ERROR: invalid argument: $upload"
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

pushd "$script_dir" || exit



else
  version="latest"
fi

isolation=chroot # TODO: take from input


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
    b_echo "Checking $img_name..."
    # shellcheck disable=SC2046
    if [ $(image_exists "$img_name") -eq 0 ]; then
     b_echo "Building $img_name..."
     buildah bud --isolation $isolation -v "$script_dir:/assets:ro,Z" --build-arg VERSION="$version" -f "./stages/$img_name.dockerfile"
    fi

    if [[ "$upload" != "" && $(image_exists "$img_name") -eq 1 ]]; then
      b_echo "Uploading $img_name..."
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
