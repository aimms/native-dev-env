#!/bin/bash

if [ ! -e build ]; then
    mkdir build
fi

if [ -z "$1" ] ; then
   build_type=Release
else
   build_type=$1
fi

./install_deps.sh $build_type

pushd .
cd build
echo "BUILD CONFIGURATION: $build_type"
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=$build_type

cpu_core_count=$(grep -c '^processor' /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
ninja  -j$cpu_core_count install
popd
