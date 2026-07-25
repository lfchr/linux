#!/bin/bash

set -euxo pipefail

sed -i 's/2.fedora.pool.ntp.org/2.debian.pool.ntp.org/' /etc/chrony.conf

# disable all rpm repositories so they don’t show up in gnome software
cat > /usr/share/dnf5/repos.override.d/00-disable-all.repo << 'EOF'
[*]
enabled = false
baseurl =
metalink =
EOF

dnf clean all

echo 'NoDisplay=true' >> /usr/share/applications/org.freedesktop.MalcontentControl.desktop

rm -f \
/usr/lib/systemd/system/bootc-fetch-apply-updates.timer \
/usr/lib/systemd/system/bootc-fetch-apply-updates.service

systemctl set-default graphical.target
systemctl preset-all --system
systemctl preset-all --global

glib-compile-schemas /usr/share/glib-2.0/schemas

sed -i "s|^EFIDIR=.*|EFIDIR=\"fedora\"|" /usr/sbin/grub2-switch-to-blscfg

sed -i 's/timeout_style=menu/timeout_style=hidden/g' /usr/lib/bootupd/grub2-static/grub-static-pre.cfg
