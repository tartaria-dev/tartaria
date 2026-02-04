#!/bin/sh
# build and store subsystem container image

echo "::group::===========================> Perform subsystem installation"

set -ouex pipefail

# generate work directory
mkdir -p /workdir
cd /workdir
cp -f /build/extra/* .

# add extra files
mkdir -p mkosi.extra
cp -f /usr/lib/os-release mkosi.extra/usr/lib/os-release
cp -f /etc/os-release mkosi.extra/etc/os-release

# build subsystem tarball
mkosi build

# create subsystem image storage
mkdir -p /usr/lib/subsystem
chmod 755 /usr/lib/subsystem

# import image into subsystem storage
podman --root /usr/lib/subsystem import subsystem.tar subsystem:latest

# cleanup
cd /
rm -rf /workdir

echo "::endgroup::"