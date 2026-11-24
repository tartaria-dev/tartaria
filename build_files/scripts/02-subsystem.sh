#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

### script setup

source /config/00-functions
set -ouex pipefail

### subsystem build

subsys_prep() {
    mkdir -p /usr/lib/subsystem/segments

    rm -f /etc/os-release
    ln -sT /usr/lib/os-release /etc/os-release

    sed -i "s/placeholder_name/Tartaria v3.0.0 Hades/g" /usr/lib/os-release
    sed -i "s/placeholder_date/$(date +%F.%H%M%S%N)/g" /usr/lib/os-release
    sed -i "s/placeholder_id/$IMAGE_VARIANT/g" /usr/lib/os-release
}

subsys_build() {
    if ! retry bash -c "mkosi build --force --directory='/mkosi' --environment=\"IMAGE_VARIANT=$IMAGE_VARIANT\" >/output/logs/mkosi.log 2>&1"; then
        cat /output/logs/mkosi.log
        exit 1
    fi
}

subsys_dircomp() {
    mkfs.erofs -zzstd,19 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L etc /usr/lib/subsystem/segments/etc.dsk /etc >/dev/null
    mkfs.erofs -zzstd,19 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L var /usr/lib/subsystem/segments/var.dsk /output/artifacts/mkosi/image/var >/dev/null
}

### main logic

main() {
    echo "::group::===========================> Install subsystem"

    subsys_prep
    subsys_build
    subsys_dircomp

    script_cleanup

    echo "::endgroup::"
}

main
