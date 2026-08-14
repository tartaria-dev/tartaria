#!/usr/bin/env bash
# commands for installing system apps (flatpaks)

echo "::group::===========================> Install system apps"

set -ouex pipefail

# create flatpak repo
mkdir -p /sysapps
flatpak create-usb /sysapps "$(</etc/.sysapps-list)" >/dev/null

# compress flatpak repo
mkdir -p /usr/lib/flatpak-sysapps
mkfs.erofs -zzstd,9 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L sysapps /usr/lib/flatpak-sysapps/flatpak-sysapps.dsk /sysapps >/dev/null

# cleanup
rm -rf /sysapps

echo "::endgroup::"
