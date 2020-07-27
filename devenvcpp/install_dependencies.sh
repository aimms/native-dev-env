#!/bin/bash


function get_arch_type() {
  if [ "${machine}" == "Mac" ]; then

}


function get_os_name() {
  local unameOut="$(uname -s)"
  case "${unameOut}" in
      Linux*)     local os_name=Linux;;
      Darwin*)    local os_name=Mac;;
      *)          local os_name="UNKNOWN:${unameOut}"
  esac

  if [[ "${os_name}" != "Mac" && "${os_name}" != "Linux" ]]; then
    echo "Error: arch is unsupported: ${unameOut}"
    exit 1
  fi

  echo "Running OS: ${os_name}"

  echo ${os_name}
}

function get_conan_profile() {
  local config=$0

  if [ "${os_name}" == "Mac" ]; then
    local conan_profile="apple_clang_11_cppstd_17_libc++_${config}"
  else
    local conan_profile="clang_cppstd_17_libc++_${config}"
    export CC=/usr/bin/clang
    export CXX=/usr/bin/clang++
  fi

  echo "Using profile: ${conan_profile}"

  echo ${conan_profile}
}

function get_conan_profile_path() {
  local conan_profile=$0

  script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  local conan_profile_path=${script_dir}/conan_profiles/${conan_profile}

  echo ${conan_profile_path}
}

function copy_conan_profile() {
  local conan_profile_path=$0
  echo "Copying conan profile: ${conan_profile_path} to ~/.conan/profiles"
  cp  ${conan_profile_path} ~/.conan/profiles
}

function install_for_config() {
  local config=$0

  local conan_profile=$(get_conan_profile ${config})
  local conan_profile_path=$(get_conan_profile_path ${conan_profile})
  copy_conan_profile ${conan_profile_path}

  echo "Building dependencies for profile: ${conan_profile}"

  conan install . --build=missing -pr=${conan_profile} -s compiler.libcxx=libc++
}

