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

mkdir package.license
cp /etc/portage/package.license/* ./package.license/

mkdir package.mask
cp /etc/portage/package.mask/* ./package.mask/

mkdir package.accept_keywords
cp /etc/portage/package.accept_keywords/* ./package.accept_keywords/

mkdir package.use
cp /etc/portage/package.use/* ./package.use/

cp /etc/portage/make.conf ./
cp /var/lib/portage/world ./

qlist -Iv > ./qlist.txt
