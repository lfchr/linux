#!/bin/bash

set -euxo pipefail

files=$(realpath $(dirname $0)/../files)
scripts=$(realpath $(dirname $0))

# install packages

$scripts/rpm-packages.sh

$scripts/remove-fedora-logos.sh
$scripts/os-release.sh

cp $files/misc/bootc-fetch-updates /usr/bin/

# prepare files

## set the main user for the services that need it and copy services:

MAIN_USER=chr

for service in $(ls $files/systemd/services)
do
	sed "s/MAIN_USER/$MAIN_USER/g" $files/systemd/services/$service > /usr/lib/systemd/system/$service
done

## other systemd files:

cp $files/systemd/80-desktop.preset /usr/lib/systemd/system-preset/
cp $files/systemd/zram-generator.conf /usr/lib/systemd/

## dracut:

for conf in $(ls $files/dracut)
do
	cp $files/dracut/$conf /usr/lib/dracut/dracut.conf.d/
done

## gnome gsettings:

for override in $(ls $files/gnome)
do
	cp $files/gnome/$override /usr/share/glib-2.0/schemas/
done

# prepare flatpak

$scripts/flatpak.sh

# copy misc. files

$scripts/mimeapps.sh

cp $files/misc/99-backlight-clamp.rules /usr/lib/udev/rules.d/
cp $files/misc/bootc-kargs.toml /usr/lib/bootc/kargs.d/00-desktop.toml

cp $files/misc/20-connectivity-debian.conf /usr/lib/NetworkManager/conf.d/

cp $files/misc/kbdlayout-custom /usr/share/xkeyboard-config-2/symbols/custom

cp $files/misc/fontconfig-local.conf /etc/fonts/local.conf
cp $files/misc/locale.conf /etc/locale.conf

# final steps

$scripts/finalize.sh

$scripts/rebuild-initrd.sh
