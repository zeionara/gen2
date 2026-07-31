#!/bin/bash

set -euo pipefail

# config

rm -rf .config

mkdir -p .config/hypr
cp /home/$USER/.config/hypr/* ./.config/hypr/

mkdir .config/alacritty
cp /home/$USER/.config/alacritty/* ./.config/alacritty/

# portage

rm -rf portage

mkdir portage
cd portage

mkdir repos.conf
cp /etc/portage/repos.conf/* ./repos.conf/

if test -d /etc/portage/package.license; then
  mkdir package.license
  cp /etc/portage/package.license/* ./package.license/
fi

if test -d /etc/portage/package.mask; then
  mkdir package.mask
  cp /etc/portage/package.mask/* ./package.mask/
fi

mkdir package.accept_keywords
cp /etc/portage/package.accept_keywords/* ./package.accept_keywords/

mkdir package.use
cp /etc/portage/package.use/* ./package.use/

cp /etc/portage/make.conf ./
cp /var/lib/portage/world ./

qlist -Iv > ./qlist.txt
