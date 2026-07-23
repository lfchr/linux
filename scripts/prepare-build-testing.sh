#!/bin/bash

set -euxo pipefail

files=$(realpath $(dirname $0)/../files)
scripts=$(realpath $(dirname $0))

sed -i -e '/^dnf in/a\
${testing[@]} \\' \
$scripts/rpm-packages.sh

sed -i -e '/^OS_VERSION/ s/"$/ testing"/' \
    -e 's/stable/development/g' \
$scripts/os-release.sh

sed -i -e '/^groups=(/a\
    "testing"' \
$scripts/flatpak.sh

rm -f $files/usr/lib/dracut/dracut.conf.d/30-intel.conf
