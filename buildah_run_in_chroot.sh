#!/usr/bin/env bash

if [[ $# -lt 2 || "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: $0 <buildah existing container name> <relative script path> <script arguments>"
  exit 1
fi

container=$1
shift
payload=$1
shift

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

mnt=$(buildah mount $container)
cp /etc/resolv.conf $mnt/etc/
mkdir -p $mnt/host
mount --bind $script_dir $mnt/host

chroot $mnt /host/$payload fakeroot -- mknod -m 666 /dev/null c 1 3 && \ 
				    mknod -m 666 /dev/zero c 1 5 && \
			            chown root:root /dev/null /dev/zero
chroot $mnt /host/$payload "$@"
umount $mnt/host
buildah unmount $container
