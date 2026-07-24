#!/bin/bash

set -euxo pipefail

files=$(realpath $(dirname $0)/../files)
scripts=$(realpath $(dirname $0))

$scripts/packages/rpm-packages.sh
$scripts/packages/flatpak.sh

cp -Rfv $files/* /

$scripts/remove-fedora-branding.sh
$scripts/os-release.sh
$scripts/mimeapps.sh
$scripts/keyboard.sh

$scripts/finalize.sh
$scripts/rebuild-initrd.sh
