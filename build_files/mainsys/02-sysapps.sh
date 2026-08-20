#!/usr/bin/env bash
# commands for installing system apps (flatpaks)

echo "::group::===========================> Install system apps"

set -ouex pipefail

# create dirs
mkdir -p /usr/lib/flatpak-sysapps/src

# add flathub remote
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --collection-id=org.flathub.Stable flathub

# install apps
flatpak install -y flathub $(</etc/.sysapps.list) >/dev/null

# setup flatpak repo
curl -Lo /usr/lib/flatpak-sysapps/flathub.flatpakrepo https://flathub.org/repo/flathub.flatpakrepo
flatpak create-usb /usr/lib/flatpak-sysapps/src $(</etc/.sysapps.list) >/dev/null

# compress flatpak repo
mkfs.erofs -zzstd,9 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L sysapps /usr/lib/flatpak-sysapps/flatpak-sysapps.dsk /usr/lib/flatpak-sysapps/src >/dev/null

# cleanup
rm -rf /usr/lib/flatpak-sysapps/src

echo "::endgroup::"
