#!/bin/bash

set -euxo pipefail

# description is used by makefile

OS_NAME="Linux"
OS_DESCRIPTION="Bootable Linux desktop container image"
OS_VERSION="$(date +%y.%m.%d)"
OS_BUILD="$(date -u +%H)F$(rpm -E %fedora)"

# www.freedesktop.org/software/systemd/man/259/os-release.html

cat > /usr/lib/os-release << EOF
NAME="$OS_NAME"
ID=linux
ID_LIKE=fedora
PRETTY_NAME="$OS_NAME $OS_VERSION"
VARIANT="desktop"
VARIANT_ID=desktop
VERSION="$OS_VERSION"
VERSION_ID="$OS_VERSION"
IMAGE_VERSION="$OS_BUILD"
RELEASE_TYPE="stable"
HOME_URL="https://github.com/lfchr/linux"
BUG_REPORT_URL="https://gitlab.com/fedora/bootc/base-images/-/work_items"
ANSI_COLOR="1;33"
VENDOR_NAME="lfchr"
DEFAULT_HOSTNAME="linux-????"
EOF

cat > /usr/lib/issue << EOF
$OS_NAME $OS_VERSION (build $OS_BUILD) \l

EOF
