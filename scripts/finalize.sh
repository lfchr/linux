#!/bin/bash

set -euxo pipefail

cat > /usr/share/gnome-initial-setup/vendor.conf << 'EOF'
[pages]
skip=language;keyboard;privacy;software;parental-controls
EOF

# disable all rpm repositories so they don’t show up in gnome software
for repo in /etc/yum.repos.d/*; do
	sed -i 's/enabled=1/enabled=0/g' $repo
done

echo 'NoDisplay=true' >> /usr/share/applications/org.freedesktop.MalcontentControl.desktop

systemctl set-default graphical.target
systemctl preset-all --system
systemctl preset-all --global

localectl set-locale \
    LANG=en_US.UTF-8 \
    LC_NUMERIC=en_GB.UTF-8 \
    LC_TIME=en_GB.UTF-8 \
    LC_MONETARY=en_GB.UTF-8 \
    LC_PAPER=en_GB.UTF-8 \
    LC_MEASUREMENT=en_GB.UTF-8
localectl set-x11-keymap customsv

glib-compile-schemas /usr/share/glib-2.0/schemas

sed -i "s|^EFIDIR=.*|EFIDIR=\"fedora\"|" /usr/sbin/grub2-switch-to-blscfg

sed -i 's/timeout_style=menu/timeout_style=hidden/g' /usr/lib/bootupd/grub2-static/grub-static-pre.cfg
