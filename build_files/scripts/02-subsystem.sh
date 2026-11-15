#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

echo "::group::===========================> Install subsystem"

# setup
source /config/00-functions
set -ouex pipefail

# setup os-release
rm -f /etc/os-release
sed -i "s/placeholder_name/Tartaria v3.0.0 Hades/g" /usr/lib/os-release
sed -i "s/placeholder_date/$(date +%F.%H%M%S%N)/g" /usr/lib/os-release
sed -i "s/placeholder_id/$IMAGE_VARIANT/g" /usr/lib/os-release
ln -sT /usr/lib/os-release /etc/os-release

# create dirs
mkdir -p /usr/lib/subsystem/segments

# build dummy arch rootfs - provides minimal /var
if ! retry bash -c "mkosi build --force --directory='/mkosi' --environment=\"IMAGE_VARIANT=$IMAGE_VARIANT\" >/tmp/build/mkosi.log 2>&1"; then
    cat /tmp/build/mkosi.log
    exit 1
fi

# compress /etc
mkfs.erofs -zzstd,19 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L etc /usr/lib/subsystem/segments/etc.dsk /etc >/dev/null

# compress /var
mkfs.erofs -zzstd,19 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L var /usr/lib/subsystem/segments/var.dsk /output/image/var >/dev/null

# cleanup
rm -rf /output /tmp/build/mkosi.log

echo "::endgroup::"
