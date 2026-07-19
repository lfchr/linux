#!/bin/bash

set -ex

# before running, set up the following disk layout:
# partiton  size    mountpoint      filesystem
# 1         512mib  /mnt/boot/efi/  fat32
# 2         1.5gib  /mnt/boot/      ext4
# 3         all     /mnt/           btrfs

tag='ghcr.io/lfchr/linux:latest'

podman pull $tag
podman run \
    --rm \
    --privileged \
    --pid=host \
    --ipc=host \
    --security-opt label=type:unconfined_t \
    -v /var/lib/containers:/var/lib/containers \
    -v /dev:/dev \
    -v /:/run/host \
    $tag \
        bootc install to-filesystem \
            --source-imgref=registry:$tag \
            --skip-finalize \
            /run/host/mnt/

sync
umount /mnt/boot/efi
umount /mnt/boot
umount /mnt

