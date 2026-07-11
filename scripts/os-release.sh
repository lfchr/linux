#!/bin/bash

set -euxo pipefail

. /usr/lib/os-release

BUILD="$(date +%y.%m.%d)$(rpm -E %dist)"
VERSION="26.08"

cat > /usr/lib/os-release << EOF
NAME="Linux"
PRETTY_NAME="Linux"
VERSION="$VERSION"
VERSION_ID=$VERSION
IMAGE_VERSION="$BUILD"
RELEASE_TYPE=stable
DEFAULT_HOSTNAME="linux-????"
HOME_URL="https://kernel.org"
BUG_REPORT_URL="https://gitlab.com/fedora/bootc/base-images/-/work_items"
ID=linux
ID_LIKE=$ID
VARIANT="desktop"
VARIANT_ID=desktop
SUPPORT_END=$SUPPORT_END
EOF
