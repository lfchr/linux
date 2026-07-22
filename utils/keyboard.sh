#!/bin/bash

set -euxo pipefail

files=$(realpath $(dirname $0)/../files)

for list in 'base' 'evdev'; do
  sed -i -e '/^  <\/layoutList>/i\
    <layout>\
      <configItem>\
        <name>customen</name>\
        <shortDescription>en</shortDescription>\
        <description>English (Custom)</description>\
        <countryList>\
          <iso3166Id>SE</iso3166Id>\
          <iso3166Id>GB</iso3166Id>\
          <iso3166Id>US</iso3166Id>\
        </countryList>\
        <languageList>\
          <iso639Id>eng</iso639Id>\
        </languageList>\
      </configItem>\
      <variantList/>\
    </layout>\
    <layout>\
      <configItem>\
        <name>customsv</name>\
        <shortDescription>sv</shortDescription>\
        <description>Swedish (Custom)</description>\
        <countryList>\
          <iso3166Id>SE</iso3166Id>\
          <iso3166Id>GB</iso3166Id>\
          <iso3166Id>US</iso3166Id>\
        </countryList>\
        <languageList>\
          <iso639Id>swe</iso639Id>\
        </languageList>\
      </configItem>\
      <variantList/>\
    </layout>' \
  /usr/share/xkeyboard-config-2/rules/$list.xml
  
  sed -i -e '/^! layout/a\
  customen        English (Custom)\
  customsv        Swedish (Custom)' \
  /usr/share/xkeyboard-config-2/rules/$list.lst
done

# see src.fedoraproject.org/rpms/kbd/blob/rawhide/f/kbd.spec

dnf in -y console-setup

mkdir /tmp/ckbcomp_custom_layouts/

for layout in 'customen' 'customsv'; do
    ckbcomp -rules base "$layout" \
    | gzip > /usr/lib/kbd/keymaps/xkb/$layout.map.gz
done

dnf history undo last -y
