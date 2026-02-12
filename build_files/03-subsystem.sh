#!/usr/bin/env bash
# install subsystem container store

echo "::group::===========================> Perform subsystem installation"

set -ouex pipefail

# generate work directory
mkdir -p /workdir
cd /workdir
cp -rf /build/extra/* .

# fetch host-spawn binary
mkdir -p mkosi.extra/usr/bin
curl -fsSL https://github.com/1player/host-spawn/releases/download/v1.6.2/host-spawn-x86_64 -o mkosi.extra/usr/bin/host-spawn
chmod +x mkosi.extra/usr/bin/host-spawn

# build arch rootfs
mkosi build

# import rootfs into false store
mkdir -p /store
podman --root /store import ./output/subsystem.tar.zst subsystem:latest

# compress store
mkdir -p /usr/lib/subsystem-store
mkfs.erofs -zlz4hc,12 -E all-fragments,fragdedupe=inode -L store /usr/lib/subsystem-store/store.dsk /store > /dev/null

# cleanup
cd /
rm -rf /{workdir,store}

echo "::endgroup::"
