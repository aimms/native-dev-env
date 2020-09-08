#!/usr/bin/env bash

container=$1
payload=$2

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

mnt=$(buildah mount $container)
cp /etc/resolv.conf $mnt/etc/
mkdir -p $mnt/tmp/host
mount --bind $script_dir $mnt/tmp/host

chroot $mnt /tmp/host/$payload
umount $mnt/tmp/host
rm -rf $mnt/tmp/host
