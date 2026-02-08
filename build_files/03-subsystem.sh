#!/bin/sh
# install subsystem container rootfs using mkosi

echo "::group::===========================> Perform subsystem installation"

set -ouex pipefail

# generate work directory and rootfs mountpoint
mkdir -p /workdir
cd /workdir
cp -f /build/extra/* .

# set rootfs path
ROOTFS="/workdir/output/subsystem"

# build arch rootfs
mkosi build

# generate locales
echo -e "en_US.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8\nja_JP.UTF-8 UTF-8\nes_ES.UTF-8 UTF-8" > "$ROOTFS/etc/locale.gen"
fakeroot chroot "$ROOTFS" locale-gen

# update dynamic linker cache
fakeroot chroot "$ROOTFS" ldconfig

# setup fish prompt
mkdir -p /etc/fish
echo -e '\nif status is-interactive\n    starship init fish | source\n    atuin init fish | source\nend' >> "$ROOTFS/etc/fish/config.fish"

# copy os-release files from host
cp -f /usr/lib/os-release "$ROOTFS/usr/lib/os-release"
cp -f /etc/os-release "$ROOTFS/etc/os-release"

# disable pacman sandboxing
sed -i 's/^#DisableSandbox/DisableSandbox/' "$ROOTFS/etc/pacman.conf"

# cleanup rootfs before rootfs image generation
rm -rf "$ROOTFS/home/"* "$ROOTFS/var/log/"* "$ROOTFS/tmp/"* "$ROOTFS/var/tmp/"* "$ROOTFS/boot" "$ROOTFS/efi" "$ROOTFS/init" "$ROOTFS/.gnupg"

# create disk image of rootfs
mkdir -p /usr/lib/subsystem
mkfs.erofs -zlz4hc,12 -E all-fragments,fragdedupe=inode -L subsystem /usr/lib/subsystem/subsystem.dsk "$ROOTFS" > /dev/null

# cleanup
cd /
rm -rf /workdir

echo "::endgroup::"