#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

### script setup

source /config/00-functions
set -ouex pipefail

### final stuffs

final_geninit() {
    local KERNEL_VERSION
    
    KERNEL_VERSION="$(basename "$(find /usr/lib/modules -maxdepth 1 -type d | grep -v -E "\.img$" | tail -n 1)")"
    DRACUT_NO_XATTR=1 dracut --force --no-hostonly --reproducible --zstd --verbose --kver "$KERNEL_VERSION" "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
}

final_sortrfs() {
    ## arrange filesystem for bootc and image-based systems,
    ## see https://bootc-dev.github.io/bootc/filesystem.html
    
    rm -rf /{boot,home,root,srv,mnt,var,opt,output}
    rm -rf /usr/lib/sysimage/{log,cache/pacman/pkg}

    mkdir -p /sysroot /boot /usr/lib/ostree /var /home /root /opt /mnt /srv

    ln -sT sysroot/ostree /ostree
}

### main logic

main() {
    echo "::group::===========================> Finalize image build"

    final_geninit
    final_sortrfs

    echo "::endgroup::"
}

main
