#!/bin/bash

set -euxo pipefail

files=$(realpath $(dirname $0)/../files)
scripts=$(realpath $(dirname $0))

# install packages

$scripts/rpm-packages.sh

# prepare files

cp -Rfv $files/* /

$scripts/remove-fedora-logos.sh
$scripts/os-release.sh
$scripts/flatpak.sh
$scripts/mimeapps.sh

# final steps

$scripts/finalize.sh

$scripts/rebuild-initrd.sh
