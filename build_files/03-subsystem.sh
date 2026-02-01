#!/bin/sh
# install subsystem container rootfs using mkosi

echo "::group::===========================> Perform subsystem installation"

set -ouex pipefail

# generate work directory and rootfs mountpoint
mkdir -p /workdir
cd /workdir
cp -f /build/extra/mkosi/* .

# add packages to be installed in rootfs
mkdir -p mkosi.extra/packages
cp -f /packages/blesh-git*.pkg.tar.zst mkosi.extra/packages/

# set rootfs path
ROOTFS="/workdir/output/subsystem"

# build arch rootfs
mkosi build

# install additional packages in rootfs
fakeroot chroot "$ROOTFS" pacman -U --noconfirm /packages/*.pkg.tar.zst
fakeroot chroot "$ROOTFS" rm -rf /packages

# generate locales
echo -e "en_US.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8\nja_JP.UTF-8 UTF-8\nes_ES.UTF-8 UTF-8" > "$ROOTFS/etc/locale.gen"
fakeroot chroot "$ROOTFS" locale-gen

# update dynamic linker cache
fakeroot chroot "$ROOTFS" ldconfig

# configure bash prompt
echo -e '\nsource -- /usr/share/blesh/ble.sh\n\neval "$(starship init bash)"\neval "$(atuin init bash)"' >> "$ROOTFS/etc/bash.bashrc"

# copy os-release files from host
cp -f /usr/lib/os-release "$ROOTFS/usr/lib/os-release"
cp -f /etc/os-release "$ROOTFS/etc/os-release"

# disable pacman sandboxing
sed -i 's/^#DisableSandbox/DisableSandbox/' "$ROOTFS/etc/pacman.conf"

# cleanup rootfs before rootfs image generation
rm -rf "$ROOTFS/home/"* "$ROOTFS/var/log/"* "$ROOTFS/tmp/"* "$ROOTFS/var/tmp/"* "$ROOTFS/boot" "$ROOTFS/efi" "$ROOTFS/init" "$ROOTFS/.gnupg"

# set correct library permissions in rootfs
chmod -R a+rX "$ROOTFS/usr/lib" "$ROOTFS/usr/lib32"

# create disk image of rootfs
mkdir -p /usr/lib/subsystem
mksquashfs "$ROOTFS" /usr/lib/subsystem/base.dsk -comp lz4 -Xhc -b 128K -no-xattrs -noappend -always-use-fragments > /dev/null

# cleanup
cd /
rm -rf /workdir

echo "::endgroup::"
