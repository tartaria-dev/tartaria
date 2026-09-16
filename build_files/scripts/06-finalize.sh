#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

echo "::group::===========================> Finalize image build"

# setup
source /config/00-functions
set -ouex pipefail

# generate initramfs with dracut
KERNEL_VERSION="$(basename "$(find /usr/lib/modules -maxdepth 1 -type d | grep -v -E "\.img$" | tail -n 1)")"

if [[ "$IMAGE_VARIANT" == *saffron || "$IMAGE_VARIANT" == *amchoor ]]; then
    DRACUT_NO_XATTR=1 dracut --force --no-hostonly --reproducible --zstd --verbose --kver "$KERNEL_VERSION" --add-drivers "nvidia nvidia_modeset nvidia_uvm nvidia_drm" "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
else
    DRACUT_NO_XATTR=1 dracut --force --no-hostonly --reproducible --zstd --verbose --kver "$KERNEL_VERSION" "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
fi

## arrange filesystem for bootc and image-based systems,
## see https://bootc-dev.github.io/bootc/filesystem.html

# remove unnecessary dirs
rm -rf /{boot,home,root,srv,mnt,var,opt,usr/local}
rm -rf /usr/lib/sysimage/{log,cache/pacman/pkg}

# recreate necessary dirs
mkdir -p /sysroot /boot /usr/lib/ostree /var /home /root /opt /mnt /srv

# create toplevel symlinks
ln -sT sysroot/ostree /ostree
ln -sT ../var/usrlocal /usr/local

echo "::endgroup::"
