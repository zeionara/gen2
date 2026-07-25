#!/bin/bash

set -euo pipefail

rm -rf portage

mkdir portage

cd portage

mkdir package.license
cp /etc/portage/package.license/* ./package.license/

mkdir package.mask
cp /etc/portage/package.mask/* ./package.mask/

mkdir package.accept_keywords
cp /etc/portage/package.accept_keywords/* ./package.accept_keywords/

mkdir package.use
cp /etc/portage/package.use/* ./package.use/

cp /etc/portage/make.conf ./
