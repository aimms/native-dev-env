#!/bin/bash


if [ -z "$1" ] ; then
    echo "Usage: $0 <result image tag>"
    exit 1
fi

docker run -v`pwd`:/code -it $1:latest
