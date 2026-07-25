#!/bin/bash

set -euxo pipefail

files=$(realpath $(dirname $0)/../files)

COMMIT_DATE=$(date +%FT%TZ -u -d @$(git show --no-patch --format=%ct))
COMMIT_HASH=$(git show --no-patch --format=%H)

version_commit=$(date +%y.%m.%d -u -d $COMMIT_DATE)

# description is used by makefile

OS_NAME="Linux"
OS_DESCRIPTION="Bootable Linux desktop container image"

if [[ $image_tag = "latest" ]]; then
    OS_VERSION="$version_commit"
    OS_VERSION_ID=$OS_VERSION
else
    OS_VERSION="$version_commit $image_tag"
    OS_VERSION_ID="$version_commit-$image_tag"
fi

OS_BUILD=$(TZ='Europe/Stockholm' date +'%F %R %Z' -d $image_created)

# www.freedesktop.org/software/systemd/man/259/os-release.html

cat > $files/usr/lib/os-release << EOF
NAME="$OS_NAME"
ID=linux
ID_LIKE=fedora
PRETTY_NAME="$OS_NAME $OS_VERSION"
VARIANT="desktop"
VARIANT_ID=desktop
VERSION="$OS_VERSION"
VERSION_ID="$OS_VERSION_ID"
IMAGE_VERSION="$OS_BUILD"
RELEASE_TYPE="stable"
HOME_URL="https://github.com/lfchr/linux"
BUG_REPORT_URL="https://gitlab.com/fedora/bootc/base-images/-/work_items"
ANSI_COLOR="1;33"
VENDOR_NAME="lfchr"
VENDOR_URL="https://github.com/lfchr"
DEFAULT_HOSTNAME="linux-????"
DESCRIPTION="$OS_DESCRIPTION"
COMMIT_DATE="$COMMIT_DATE"
COMMIT_HASH="$COMMIT_HASH"
EOF

cat > $files/usr/lib/issue << EOF
$OS_NAME $OS_VERSION (build $OS_BUILD) \l

EOF
