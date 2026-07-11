#!/bin/bash

set -euxo pipefail

kver=$(ls /usr/lib/modules)

dracut --verbose --force \
    --kver "$kver" \
    "/usr/lib/modules/$kver/initramfs.img"

chmod 0600 "/lib/modules/$kver/initramfs.img"
