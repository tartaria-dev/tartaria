#!/usr/bin/env bash
# install subsystem container store

echo "::group::===========================> Install subsystem"

set -ouex pipefail

# generate work directory
mkdir -p /workdir
cd /workdir
cp -rf /build/extra/* .

# fetch host-spawn binary
curl -fsSL https://github.com/1player/host-spawn/releases/download/v1.6.2/host-spawn-x86_64 -o mkosi.extra/usr/libexec/host-spawn
chmod +x mkosi.extra/usr/libexec/host-spawn

# build arch rootfs
mkosi build

# import rootfs into false store
mkdir -p /store
podman --root /store import ./output/image.tar.zst subsystem:latest

# compress store
mkdir -p /usr/lib/subsystem/store
mkfs.erofs -zlz4hc,12 -E all-fragments,fragdedupe=inode -L store /usr/lib/subsystem/store/store.dsk /store > /dev/null

# cleanup
cd /
rm -rf /{workdir,store}

echo "::endgroup::"
