#!/bin/bash

set -euxo pipefail

files=$(realpath $(dirname $0)/../files)
scripts=$(realpath $(dirname $0))

# install packages

sed -e '/^dnf in/a\
${testing[@]} \\' \
$scripts/rpm-packages.sh | bash

# prepare files

cp -Rfv $files/* /

$scripts/remove-fedora-logos.sh

sed -e '/^OS_VERSION/ s/"$/ testing"/' \
    -e 's/stable/development/g' \
    $scripts/os-release.sh | bash

sed -e '/^groups=(/a\
    "testing"' \
$scripts/flatpak.sh | bash

$scripts/mimeapps.sh

# final steps

$scripts/finalize.sh

$scripts/rebuild-initrd.sh
