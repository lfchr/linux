#!/bin/bash

set -euxo pipefail

cat > /usr/share/gnome-initial-setup/vendor.conf << 'EOF'
[pages]
skip=software
EOF

# disable all rpm repositories so they don’t show up in gnome software
for repo in /etc/yum.repos.d/*; do
	sed -i 's/enabled=1/enabled=0/g' $repo
done

systemctl set-default graphical.target
systemctl preset-all --system
systemctl preset-all --global

glib-compile-schemas /usr/share/glib-2.0/schemas

sed -i "s|^EFIDIR=.*|EFIDIR=\"fedora\"|" /usr/sbin/grub2-switch-to-blscfg

sed -i 's/timeout_style=menu/timeout_style=hidden/g' /usr/lib/bootupd/grub2-static/grub-static-pre.cfg
