#!/usr/bin/env bash
# install subsystem

echo "::group::===========================> Install subsystem"

# setup
source /build/conf/00-functions
set -ouex pipefail

# create output dir
mkdir -p /output

# build arch rootfs
if ! retry mkosi build --force --directory="/mkosi" --environment="IMAGE_VARIANT=$IMAGE_VARIANT" >/tmp/mkosi.log 2>&1; then
    cat /tmp/build/mkosi.log
    exit 1
fi

# install extra pkgs
if ! retry runuser -u builder -- bash -c "xargs -a /mkosi/conf/01-aur-pkgs yay -S --noconfirm --needed --root=/output/image/" >/tmp/yay.log 2>&1; then
    cat /tmp/build/yay.log
    exit 1
fi

# install host-spawn
mkdir -p /output/image/usr/libexec
retry wget -q https://github.com/1player/host-spawn/releases/download/v1.6.2/host-spawn-x86_64 -O /output/image/usr/libexec/host-spawn
chmod +x /output/image/usr/libexec/host-spawn

# compress rootfs
mkdir -p /usr/lib/subsystem/rootfs
retry mkfs.erofs -zzstd,5 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L rootfs /usr/lib/subsystem/rootfs/rootfs.dsk /output/image >/dev/null

# cleanup
pacman -Rns --noconfirm yay-bin
userdel builder
rm -rf /output /tmp/mkosi.log /tmp/yay.log

echo "::endgroup::"
