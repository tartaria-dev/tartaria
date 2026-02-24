#!/usr/bin/env bash
# install subsystem

echo "::group::===========================> Install subsystem"

set -ouex pipefail

# generate work directory
mkdir -p /workdir
cd /workdir
cp -rf /build/extra/* .

# fetch host-spawn binary
wget -q https://github.com/1player/host-spawn/releases/download/v1.6.2/host-spawn-x86_64 -O mkosi.extra/usr/libexec/host-spawn
chmod +x mkosi.extra/usr/libexec/host-spawn

# build arch rootfs
mkosi build

# compress rootfs
mkdir -p /usr/lib/subsystem/rootfs
mkfs.erofs -zlz4hc,12 -E all-fragments,fragdedupe=inode -L rootfs /usr/lib/subsystem/rootfs/rootfs.dsk /workdir/output/rootfs >/dev/null

# cleanup
cd /
rm -rf /workdir

echo "::endgroup::"
