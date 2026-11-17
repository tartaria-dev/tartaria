#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

### script setup

source /config/00-functions
set -ouex pipefail

### UKI creation

uki_setup() {
    mkdir -p /out/{uki,boot} /var/tmp
    retry pacman -S --noconfirm --needed systemd-ukify sbsigntools
}

uki_create() {
    local KERNEL_VERSION

    KERNEL_VERSION=$(ls /kernel)
    
    bootc container ukify \
        --rootfs /target \
        --kernel-dir "/kernel/${KERNEL_VERSION}" \
        -- \
        --output "/out/uki/${KERNEL_VERSION}.efi" \
        --signtool sbsign \
        --secureboot-private-key /run/secrets/secureboot_key \
        --secureboot-certificate /run/secrets/secureboot_cert
}

uki_sign() {
    sbsign \
        --key /run/secrets/secureboot_key \
        --cert /run/secrets/secureboot_cert \
        --output /out/boot/grubx64.efi \
        /target/usr/lib/systemd/boot/efi/systemd-bootx64.efi
}

### main logic

main() {
    echo "::group::===========================> Create Signed UKI"

    uki_setup
    uki_create
    uki_sign

    script_cleanup

    echo "::endgroup::"
}

main
