#!/usr/bin/env bash

if [[ $# -lt 3 || "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: $0 <buildah existing container name> <script_dir> <relative script path> <script arguments>"
  exit 1
fi

container=$1
shift
script_dir=$1
shift
payload=$1
shift

mnt=$(buildah mount $container)
cp /etc/resolv.conf $mnt/etc/
mkdir -p $mnt/host
mount --bind $script_dir $mnt/host

chroot $mnt /host/$payload "$@"
umount $mnt/host
buildah unmount $container
