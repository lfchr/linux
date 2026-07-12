#!/bin/bash

set -euxo pipefail

rm /usr/share/applications/mimeapps.list
cp /usr/share/applications/gnome-mimeapps.list /usr/share/applications/mimeapps.list

sed -i 's/org.gnome.Builder.desktop/org.gnome.TextEditor.desktop/g' /usr/share/applications/mimeapps.list
sed -i 's/org.gnome.Epiphany.desktop/org.mozilla.firefox.desktop/g' /usr/share/applications/mimeapps.list
