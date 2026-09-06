#!/usr/bin/env bash
# install subsystem

echo "::group::===========================> Install subsystem"

# setup
source /build/conf/00-functions
set -ouex pipefail

# create dirs
mkdir -p /usr/lib/subsystem/segments

# build dummy arch rootfs - provides minimal /var
if ! retry mkosi build --force --directory="/mkosi" --environment="IMAGE_VARIANT=$IMAGE_VARIANT" >/tmp/mkosi.log 2>&1; then
    cat /tmp/mkosi.log
    exit 1
fi

# compress /etc
retry mkfs.erofs -zzstd,19 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L etc /usr/lib/subsystem/segments/etc.dsk /etc >/dev/null

# compress /var
retry mkfs.erofs -zzstd,19 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L var /usr/lib/subsystem/segments/var.dsk /output/image/var >/dev/null

# cleanup
rm -rf /output /tmp/mkosi.log

echo "::endgroup::"
