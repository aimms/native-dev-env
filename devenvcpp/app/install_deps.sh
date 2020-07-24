#!/bin/bash

if [ ! -e build ]; then
    mkdir build
    #IntelliJ Idea
    mkdir cmake-build-debug
    mkdir cmake-bulid-release
fi

if [ -z "$1" ] ; then
   build_type=Release
else
   build_type=$1
fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ "${machine}" == "Mac" ]; then
  conan_profile="apple_clang_11_cppstd_17_libc++_release"
elif [ "${machine}" == "Linux" ]; then
  conan_profile="clang_cppstd_17_libc++_release"
  export CC=/usr/bin/clang
  export CXX=/usr/bin/clang++
else
  echo "Error: arch is unsupported: ${unameOut}"
  exit 1
fi

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
mkdir -p ~/.conan/profiles
conan_profile_path=${script_dir}/conan_profiles/${conan_profile}
echo "Copying conan profile: ${conan_profile_path} to ~/.conan/profiles"
cp  ${conan_profile_path} ~/.conan/profiles

pushd .
cd build
echo "BUILD CONFIGURATION: $build_type"
conan install .. --build=missing -pr=${conan_profile} -s compiler.libcxx=libc++
popd
