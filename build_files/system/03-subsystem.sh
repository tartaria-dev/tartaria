#!/usr/bin/env bash
# install subsystem

echo "::group::===========================> Install subsystem"

# setup
source /build/conf/00-functions
set -ouex pipefail

# create dirs
mkdir -p /usr/lib/subsystem/segments

# compress /etc
retry mkfs.erofs -zzstd,15 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L etc /usr/lib/subsystem/segments/etc.dsk /etc >/dev/null

# compress /var
retry mkfs.erofs -zzstd,15 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L var /usr/lib/subsystem/segments/var.dsk /var >/dev/null

echo "::endgroup::"
