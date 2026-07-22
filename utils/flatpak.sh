#!/bin/bash

set -euxo pipefail

curl -L 'https://dl.flathub.org/repo/flathub.flatpakrepo' \
     -o '/usr/share/flatpak/remotes.d/flathub.flatpakrepo'

# don’t forget to change Resources’ id when added to gnome’s core apps
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
    "org.gnome.Loupe.HEIC"
    "dev.deedles.Trayscale"
    "io.github.kolunmi.Bazaar"
    "ca.desrt.dconf-editor"
    "page.tesk.Refine"
)

testing=(
    "org.gnome.dspy"
    "com.github.tchx84.Flatseal"
)

groups=(
    "mandatory"
    "default"
)

for group in ${groups[@]}; do
    declare -n apps="$group"
    for app in ${apps[@]}
    do
        cat >> /usr/share/flatpak/preinstall.d/$group.preinstall << EOF
[Flatpak Preinstall $app]
Branch=stable
IsRuntime=false

EOF
    done
done
