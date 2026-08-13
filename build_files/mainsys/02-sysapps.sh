#!/usr/bin/env bash
# install system apps

echo "::group::===========================> Install system apps"

set -ouex pipefail

# create sysapp dirs
mkdir -p /usr/lib/flatpak-sysapps

# store flatpaks
ls /
exit 1
mkfs.erofs -zzstd,12 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L sysapps /usr/lib/flatpak-sysapps/flatpak-sysapps.dsk /usr/lib/flatpak-sysapps/dsk-src >/dev/null

# cleanup
rm -rf /usr/lib/flatpak-sysapps/dsk-src /etc/flatpak/ /sysapps

echo "::endgroup::"
