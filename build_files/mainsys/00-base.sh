#!/bin/sh
# prepare image and install base packages

echo "::group::===========================> Perform image build preparation"

set -oux pipefail

# move /var directories to /usr/lib/sysimage for bootc usroverlay compatibility
grep "= */var" /etc/pacman.conf | sed "/= *\/var/s/.*=// ; s/ //" | \
    xargs -n1 sh -c \
        'mkdir -p "/usr/lib/sysimage/$(dirname $(echo $1 | sed "s@/var/@@"))" && \
         mv -v "$1" "/usr/lib/sysimage/$(echo "$1" | sed "s@/var/@@")"' ''

set -e

# update pacman config
sed -i \
    -e "/= *\/var/ s/^#//" \
    -e "s@= */var@= /usr/lib/sysimage@g" \
    -e "/DownloadUser/d" \
    /etc/pacman.conf

# initialize database and install base packages
pacman -Syuq --noconfirm
pacman -Syq --noconfirm reflector
pacman -Syq --noconfirm base dracut linux-cachyos linux-firmware ostree btrfs-progs e2fsprogs xfsprogs dosfstools skopeo dbus dbus-glib glib2 ostree shadow
pacman -S --clean --noconfirm

echo "::endgroup::"
