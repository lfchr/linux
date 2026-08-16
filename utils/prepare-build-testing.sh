#!/bin/bash

set -euxo pipefail

files=$(realpath $(dirname $0)/../files)
scripts=$(realpath $(dirname $0)/../scripts)

sed -i -e '/^dnf in/a\
${testing[@]} \\' \
$scripts/packages/rpm.sh

sed -i -e 's/^dnf in/dnf in --skip-unavailable/' \
$scripts/packages/rpm.sh

sed -i -e '/^groups=(/a\
    "testing"' \
$scripts/packages/flatpak.sh

rm -f $files/usr/lib/dracut/dracut.conf.d/30-intel.conf
