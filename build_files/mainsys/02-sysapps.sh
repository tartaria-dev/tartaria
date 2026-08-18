#!/usr/bin/env bash
# commands for installing system apps (flatpaks)

echo "::group::===========================> Install system apps"

set -ouex pipefail

# create dirs
mkdir -p /sysapps-dsksrc /usr/lib/flatpak-sysapps

# create repo and fetch flathub repofile
flatpak --installation=sysapps create-usb /sysapps-dsksrc $(</configs/system-apps) >/dev/null
curl -Lo /usr/lib/flatpak-sysapps/flathub.flatpakrepo https://flathub.org/repo/flathub.flatpakrepo

# compress flatpak repo
mkfs.erofs -zzstd,9 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L sysapps /usr/lib/flatpak-sysapps/flatpak-sysapps.dsk /sysapps-dsksrc >/dev/null

# cleanup
rm -rf /sysapps-dsksrc /etc/flatpak

echo "::endgroup::"
