#!/bin/bash

set -euxo pipefail

files=$(realpath $(dirname $0)/../files)
scripts=$(realpath $(dirname $0)/../scripts)
utils=$(realpath $(dirname $0))

sed -i -e '/^dnf in/a\
${testing[@]} \\' \
$scripts/packages/rpm.sh

sed -i -e '/^OS_VERSION/ s/"$/ testing"/' \
    -e 's/stable/development/g' \
$utils/os-release.sh

sed -i -e '/^groups=(/a\
    "testing"' \
$scripts/packages/flatpak.sh

rm -f $files/usr/lib/dracut/dracut.conf.d/30-intel.conf
