#!/usr/bin/env bash

if [[ $# -lt 2 || "$1" == "-h" || "$1" == "--help" || $# -gt 2 ]]; then
  echo "Usage: $0 <buildah container name> <command>"
  echo " e.g.: $0 build build_env.sh 1.5"
  exit 1
fi


container=$1
shift

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

mnt=$(buildah mount $container)
cp /etc/resolv.conf $mnt/etc/
mkdir -p $mnt/host
mount --bind $script_dir $mnt/tmp/host

chroot $mnt/host "@$"
umount $mnt/host
