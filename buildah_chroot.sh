#!/usr/bin/env bash

os=ubuntu:20.04

buildah unshare cat <<-script
        build=$(buildah from $os)
        mnt=$(buildah share $build)
        cp /etc/resolv.conf $mnt/etc/

        cat << EOF | chroot $mnt
          $1
        EOF

script