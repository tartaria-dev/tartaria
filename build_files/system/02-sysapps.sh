#!/usr/bin/env bash
# commands for installing system apps (flatpaks)

echo "::group::===========================> Install system apps"

# setup
source /build/conf/00-functions
set -ouex pipefail

# create dirs
mkdir -p /usr/lib/flatpak-sysapps/src

# move flatpak system apps list to /etc
cp /build/conf/03-flatpaks /etc/.sysapps.list

# add flathub remote
retry flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
retry flatpak remote-modify --collection-id=org.flathub.Stable flathub

# install apps
retry flatpak install -y flathub $(</etc/.sysapps.list) >/dev/null

# setup flatpak repo
retry curl -Lo /usr/lib/flatpak-sysapps/flathub.flatpakrepo https://flathub.org/repo/flathub.flatpakrepo
retry flatpak create-usb /usr/lib/flatpak-sysapps/src $(</etc/.sysapps.list) >/dev/null

# compress flatpak repo
retry mkfs.erofs -zzstd,10 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L sysapps /usr/lib/flatpak-sysapps/flatpak-sysapps.dsk /usr/lib/flatpak-sysapps/src >/dev/null

# cleanup
rm -rf /usr/lib/flatpak-sysapps/src

echo "::endgroup::"
