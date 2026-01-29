#!/bin/bash
# install subsystem container rootfs using mkosi

echo "::group::===========================> Perform subsystem installation"

set -ouex pipefail

# generate work directory
mkdir -p /workdir
cd /workdir
cp -f /build/extra/mkosi.conf ./mkosi.conf

# set rootfs path
ROOTFS="/workdir/output/subsystem"

# build arch rootfs
mkosi build

# generate locales
echo -e "en_US.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8\nja_JP.UTF-8 UTF-8\nes_ES.UTF-8 UTF-8" > "$ROOTFS/etc/locale.gen"
fakeroot chroot "$ROOTFS" locale-gen

# update dynamic linker cache
fakeroot chroot "$ROOTFS" ldconfig

# configure bash prompt
echo -e '\neval "$(starship init bash)"\neval "$(atuin init bash)"' >> "$ROOTFS/etc/bash.bashrc"

# copy os-release files from host
cp -f /usr/lib/os-release "$ROOTFS/usr/lib/os-release"
cp -f /etc/os-release "$ROOTFS/etc/os-release"

# fix root home in rootfs
ln -sfT /root "$ROOTFS/etc/subsystem-conf"

# disable pacman sandboxing
sed -i 's/^#DisableSandbox/DisableSandbox/' "$ROOTFS/etc/pacman.conf"

# cleanup rootfs before rootfs image generation
rm -rf "$ROOTFS/home/"* "$ROOTFS/var/log/"* "$ROOTFS/tmp/"* "$ROOTFS/var/tmp/"*

# create disk image of rootfs
mkfs.erofs -zlz4hc,12 -E all-fragments,fragdedupe=inode -L subsystem /usr/lib/subsystem/subsystem.dsk "$ROOTFS" > /dev/null

# create config symlink for ease of access
ln -sfT /etc/subsystem-conf/.config/containers/systemd/subsystem.container /etc/subsystem-conf/subsystem.container

# set correct ownership of subsystem dirs
chown -R 767:767 /usr/lib/subsystem/ /etc/subsystem-conf/

# cleanup
cd /
rm -rf /workdir


echo "::endgroup::"
