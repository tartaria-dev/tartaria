#!/bin/sh
# install subsystem container rootfs using mkosi

echo "::group::===========================> Perform subsystem installation"

set -ouex pipefail

# generate work directory and rootfs mountpoint
mkdir -p /workdir
cd /workdir
cp -f /build/subsystem/* .

# set rootfs path
ROOTFS="/workdir/output/subsystem"

# build arch rootfs
mkosi build

# copy os-release files from host
cp -f /usr/lib/os-release "$ROOTFS/usr/lib/os-release"
cp -f /etc/os-release "$ROOTFS/etc/os-release"

# cleanup rootfs before rootfs image generation
rm -rf "$ROOTFS"/home/* "$ROOTFS"/tmp/* "$ROOTFS"/var/tmp/* "$ROOTFS"/var/cache/apk/* "$ROOTFS"/boot "$ROOTFS"/efi "$ROOTFS"/init "$ROOTFS"/.gnupg

# create disk image of rootfs
mkdir -p /usr/lib/subsystem
mksquashfs "$ROOTFS" /usr/lib/subsystem/base.dsk -comp lz4 -Xhc -b 128K -no-xattrs -noappend -always-use-fragments > /dev/null

# cleanup
cd /
rm -rf /workdir

echo "::endgroup::"
