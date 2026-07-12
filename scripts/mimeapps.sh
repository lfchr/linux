#!/bin/bash

set -euxo pipefail

rm /usr/share/applications/mimeapps.list
curl -L https://gitlab.gnome.org/GNOME/gnome-session/-/raw/gnome-50/data/gnome-mimeapps.list -o /usr/share/applications/mimeapps.list

sed -i 's/org.gnome.Builder.desktop/org.gnome.TextEditor.desktop/g' /usr/share/applications/mimeapps.list
sed -i 's/org.gnome.Epiphany.desktop/org.mozilla.firefox.desktop/g' /usr/share/applications/mimeapps.list
