#!/bin/bash

set -euxo pipefail

# remove some of the logo images. i decided this was better than removing
# the package ‘fedora-logos’ and replacing it with something like ‘generic-logos’.
rm -f \
/etc/favicon.png \
/usr/share/plymouth/themes/spinner/watermark.png \
/usr/share/pixmaps/fedora* \
/usr/share/pixmaps/system-logo-white.png \
/usr/share/icons/hicolor/*/apps/fedora-logo-icon.png \
/usr/share/icons/hicolor/*/places/start-here.png \
/usr/share/icons/hicolor/scalable/*/start-here.svg \
/usr/share/icons/hicolor/scalable/apps/xfce4_xicon1.svg \
/usr/share/glib-2.0/schemas/*fedora.gschema.override \
/usr/share/glib-2.0/schemas/org.gnome.login-screen.gschema.override \
/usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override

# make sure only directories that only contain logos are removed
rm -rfv \
/usr/share/fedora-logos \
/usr/share/anaconda \
/usr/share/kde4 \
/usr/share/icons/Bluecurve \
/usr/share/icons/oxygen \
/usr/share/icewm \
/usr/share/pixmaps/bootloader
