#!/usr/bin/env bash
# install system apps

echo "::group::===========================> Install system apps"

set -ouex pipefail

# create sysapp store dir
mkdir -p /usr/lib/flatpak-sysapps

# compress flatpak store
mkfs.erofs -zzstd,12 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L sysapps /usr/lib/flatpak-sysapps/flatpak-sysapps.dsk /sysapps >/dev/null

# cleanup
rm -rf /etc/flatpak/ /sysapps

echo "::endgroup::"
