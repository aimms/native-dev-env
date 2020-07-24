#! /bin/bash

if [ "$#" -ne 1 ]; then
    echo "$0 <profile_name>"
    exit 1
fi

mkdir -p ~/.conan/profiles
cp $1 ~/.conan/profiles/

echo "Done"
