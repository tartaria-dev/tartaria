#!/usr/bin/env bash
# setup UKI stuffs

echo "::group::===========================> Build UKI"

set -ouex pipefail

# create necessary dirs
mkdir -p /out

# set vars
kver=$(ls /kernel)

# create UKI
bootc container ukify \
    --rootfs /target \
    --kernel-dir "/kernel/${kver}" \
    -- \
    --output "/out/${kver}.efi" \
    --signtool sbsign \
    --secureboot-private-key /run/secrets/secureboot_key \
    --secureboot-certificate /run/secrets/secureboot_cert