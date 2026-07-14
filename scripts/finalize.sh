#!/bin/bash

set -euxo pipefail

cat > /usr/share/gnome-initial-setup/vendor.conf << 'EOF'
[pages]
skip=software
EOF

# remove all rpm repositories so they don’t show up in gnome software
rm -f /etc/yum.repos.d/*

systemctl set-default graphical.target
systemctl preset-all

glib-compile-schemas /usr/share/glib-2.0/schemas

sed -i "s|^EFIDIR=.*|EFIDIR=\"fedora\"|" /usr/sbin/grub2-switch-to-blscfg

sed -i 's/timeout_style=menu/timeout_style=hidden/g' /usr/lib/bootupd/grub2-static/grub-static-pre.cfg
sed -i 's/timeout=1/timeout=0/g' /usr/lib/bootupd/grub2-static/grub-static-pre.cfg
