#!/usr/bin/env bash
# setup UKI stuffs

echo "::group::===========================> Create Signed UKI"

# setup
source /build/conf/00-functions
set -ouex pipefail

# create necessary dirs
mkdir -p /out /var/tmp

# set vars
kver=$(ls /kernel)

# install needed tools
retry pacman -S --noconfirm --needed systemd-ukify sbsigntools

# create UKI
bootc container ukify \
    --rootfs /target \
    --kernel-dir "/kernel/${kver}" \
    -- \
    --output "/out/${kver}.efi" \
    --signtool sbsign \
    --secureboot-private-key /run/secrets/secureboot_key \
    --secureboot-certificate /run/secrets/secureboot_cert

# sign systemd-boot
sbsign \
    --key /run/secrets/secureboot_key \
    --cert /run/secrets/secureboot_cert \
    --output /out/grubx64.efi \
    /target/usr/lib/systemd/boot/efi/systemd-bootx64.efi

# cleanup
rm -rf /var/tmp

echo "::endgroup::"
