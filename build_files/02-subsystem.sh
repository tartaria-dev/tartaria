#!/usr/bin/env bash
# install subsystem container store

echo "::group::===========================> Install subsystem"

set -ouex pipefail

# generate work directory
mkdir -p /workdir
cd /workdir
cp -rf /build/extra/* .

# fetch host-spawn binary
mkdir -p mkosi.extra/usr/libexec/
wget -q https://github.com/1player/host-spawn/releases/download/v1.6.2/host-spawn-x86_64 -O mkosi.extra/usr/libexec/host-spawn
chmod +x mkosi.extra/usr/libexec/host-spawn

# build arch rootfs
mkosi build

# compress rootfs
mkdir -p /usr/lib/subsystem/rootfs
mksquashfs /workdir/output/rootfs /usr/lib/subsystem/rootfs/base.dsk -comp zstd -Xcompression-level 19 -b 128K -noappend -always-use-fragments > /dev/null

# cleanup
cd /
rm -rf /workdir

echo "::endgroup::"
