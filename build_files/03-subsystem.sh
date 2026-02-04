#!/bin/sh
# build and store subsystem container image

echo "::group::===========================> Perform subsystem installation"

set -ouex pipefail

# generate work directory
mkdir -p /workdir
cd /workdir
cp -f /build/extra/* .

# build subsystem tarball
mkosi build

# copy os-release files from host
cp -f /usr/lib/os-release "$ROOTFS/usr/lib/os-release"
cp -f /etc/os-release "$ROOTFS/etc/os-release"

# create subsystem image storage
mkdir -p /usr/lib/subsystem
chmod 755 /usr/lib/subsystem

# import image into subsystem storage
podman --root /usr/lib/subsystem import subsystem.tar subsystem:latest

# cleanup
cd /
rm -rf /workdir

echo "::endgroup::"