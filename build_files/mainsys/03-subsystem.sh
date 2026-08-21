#!/usr/bin/env bash
# install subsystem

echo "::group::===========================> Install subsystem"

set -ouex pipefail

# fetch host-spawn binary
mkdir -p /mkosi/mkosi.extra/usr/libexec
wget -q https://github.com/1player/host-spawn/releases/download/v1.6.2/host-spawn-x86_64 -O /mkosi/mkosi.extra/usr/libexec/host-spawn
chmod +x /mkosi/mkosi.extra/usr/libexec/host-spawn

# build arch rootfs
if ! mkosi build --directory="/mkosi" --environment="IMAGE_VARIANT=$IMAGE_VARIANT" >/tmp/mkosi.log 2>&1; then
    tail -n 200 /tmp/mkosi.log
    exit 1
fi

# compress rootfs
mkdir -p /usr/lib/subsystem/rootfs
mkfs.erofs -zzstd,5 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L rootfs /usr/lib/subsystem/rootfs/rootfs.dsk /mkosi/output/image >/dev/null

# cleanup
rm -rf /mkosi

echo "::endgroup::"
