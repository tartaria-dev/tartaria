#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

echo "::group::===========================> Install subsystem"

# setup
source /config/00-functions
set -ouex pipefail

# install mkosi
retry pacman -S --noconfirm --needed mkosi

# create dirs
mkdir -p /usr/lib/subsystem/segments

# build dummy arch rootfs - provides minimal /var and /etc
if ! retry bash -c "mkosi build --force --directory='/mkosi' --environment=\"IMAGE_VARIANT=$IMAGE_VARIANT\" >/tmp/build/mkosi.log 2>&1"; then
    cat /tmp/build/mkosi.log
    exit 1
fi

# compress /etc
mkfs.erofs -zzstd,19 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L etc /usr/lib/subsystem/segments/etc.dsk /etc >/dev/null

# compress /var
mkfs.erofs -zzstd,19 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L var /usr/lib/subsystem/segments/var.dsk /output/image/var >/dev/null

# cleanup
pacman -Rns --noconfirm mkosi
rm -rf /output /tmp/build/mkosi.log

echo "::endgroup::"
