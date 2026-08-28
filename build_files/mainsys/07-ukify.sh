#!/usr/bin/env bash
# setup UKI stuffs

echo "::group::===========================> Build UKI"

set -ouex pipefail

# create necessary dirs
mkdir -p /out /var/tmp

# set vars
kver=$(ls /kernel)

# install needed tools
pacman -S --noconfirm --needed systemd-ukify sbsigntools

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

# export DER copy
openssl x509 -in /run/secrets/secureboot_cert -outform DER -out /out/secureboot.der

# cleanup
rm -rf /var/tmp
