#!/bin/bash

set -euxo pipefail

curl -L https://dl.flathub.org/repo/flathub.flatpakrepo -o /usr/share/flatpak/remotes.d/flathub.flatpakrepo

mandatory=(
    "org.gnome.baobab"
    "org.gnome.Calculator"
    "org.gnome.Calendar"
    "org.gnome.Characters"
    "org.gnome.clocks"
    "org.gnome.Decibels"
    "org.gnome.font-viewer"
    "org.gnome.Logs"
    "org.gnome.Loupe"
    "org.gnome.Papers"
    "org.gnome.Showtime"
    "org.gnome.TextEditor"
    "org.gnome.Weather"
    "app.devsuite.Ptyxis"
    "net.nokyan.Resources"
    "org.mozilla.firefox"
)

default=(
    "org.gnome.NautilusPreviewer"
    "dev.deedles.Trayscale"
    "ca.desrt.dconf-editor"
    "page.tesk.Refine"
)

groups=(
    "mandatory"
    "default"
)

for group in ${groups[@]}
do
    declare -n apps="$group"
    for app in ${apps[@]}
    do
        echo "[Flatpak Preinstall $app]" >> /usr/share/flatpak/preinstall.d/$group.preinstall
        echo "Branch=stable" >> /usr/share/flatpak/preinstall.d/$group.preinstall
        echo "IsRuntime=false" >> /usr/share/flatpak/preinstall.d/$group.preinstall
        echo "" >> /usr/share/flatpak/preinstall.d/$group.preinstall
    done
done
