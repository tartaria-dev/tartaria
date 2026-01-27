#!/bin/sh
# finalize image build

echo "::group::===========================> Finalize image build"

set -ouex pipefail

# Generate initramfs with dracut
KERNEL_VERSION="$(basename "$(find /usr/lib/modules -maxdepth 1 -type d | grep -v -E "\.img$" | tail -n 1)")"
dracut --force --no-hostonly --reproducible --zstd --verbose --kver "$KERNEL_VERSION" "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"

# Arrange filesystem for bootc and image-based systems
# See https://bootc-dev.github.io/bootc/filesystem.html
sed -i 's|^HOME=.*|HOME=/var/home|' "/etc/default/useradd"
rm -rf /boot /tmp/* /home /root /usr/local /srv /mnt /var /usr/opt /build /packages /usr/lib/sysimage/log /usr/lib/sysimage/cache/pacman/pkg
mkdir -p /sysroot /boot /usr/lib/ostree /var
ln -sT sysroot/ostree /ostree
ln -sT var/roothome /root
ln -sT var/srv /srv
ln -sT var/mnt /mnt
ln -sT var/opt /opt
ln -sT var/home /home
ln -sT ../var/usrlocal /usr/local
mv /opt /usr/

echo "::endgroup::"