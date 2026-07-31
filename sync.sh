#!/bin/bash

set -euo pipefail

# services

if test -d init.d; then
  rm -rf init.d
fi

mkdir init.d
cp /etc/init.d/* ./init.d/

if test -d conf.d; then
  rm -rf conf.d
fi

mkdir conf.d
cp /etc/conf.d/* ./conf.d/

# config

rm -rf .config

if test -d .config/hypr; then
  mkdir -p .config/hypr
  cp /home/$USER/.config/hypr/* ./.config/hypr/
fi

if test -d .config/alacritty; then
  mkdir .config/alacritty
  cp /home/$USER/.config/alacritty/* ./.config/alacritty/
fi

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
