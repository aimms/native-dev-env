#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt update
apt install -y --no-install-recommends fakeroot

fakeroot -- mknod /dev/null c 1 3
fakeroot -- mknod /dev/zero c 1 5
fakeroot -- mknod /dev/random c 1 8
fakeroot -- mknod /dev/urandom c 1 9
