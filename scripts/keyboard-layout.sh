#!/bin/bash

set -euxo pipefail

for file in 'base' 'evdev'; do
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
  /usr/share/xkeyboard-config-2/rules/$file.xml
  
  sed -i -e '/^! layout/a\
  customen        English (Custom)\
  customsv        Swedish (Custom)' \
  /usr/share/xkeyboard-config-2/rules/$file.lst
done
