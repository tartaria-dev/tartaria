#!/usr/bin/env bash
# install subsystem

echo "::group::===========================> Install subsystem"

set -ouex pipefail

# generate work directory
mkdir -p /workdir
cd /workdir
cp -rf /build/extra/* .

# fetch host-spawn binary
mkdir -p mkosi.extra/usr/libexec
wget -q https://github.com/1player/host-spawn/releases/download/v1.6.2/host-spawn-x86_64 -O mkosi.extra/usr/libexec/host-spawn
chmod +x mkosi.extra/usr/libexec/host-spawn

# build arch rootfs
mkosi build --environment "IMAGE_VARIANT=$IMAGE_VARIANT"

# install extra pkgs into rootfs
pacman -U --root /workdir/output/image --noconfirm /packages/subsys/* >/dev/null

# compress rootfs
mkdir -p /usr/lib/subsystem/rootfs
mkfs.erofs -zzstd,4 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L rootfs /usr/lib/subsystem/rootfs/rootfs.dsk /workdir/output/image >/dev/null

# cleanup
cd /
rm -rf /workdir

echo "::endgroup::"
