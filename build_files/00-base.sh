#!/usr/bin/env bash
# prepare base image

echo "::group::===========================> Prepare image build"

set -oux pipefail

# move /var directories to /usr/lib/sysimage for bootc usroverlay compatibility
grep "= */var" /etc/pacman.conf | sed "/= *\/var/s/.*=// ; s/ //" | \
    xargs -n1 sh -c \
        'mkdir -p "/usr/lib/sysimage/$(dirname $(echo $1 | sed "s@/var/@@"))" && \
         mv -v "$1" "/usr/lib/sysimage/$(echo "$1" | sed "s@/var/@@")"' '' >/dev/null

set -e

# update pacman config
sed -i \
    -e "/= *\/var/ s/^#//" \
    -e "s@= */var@= /usr/lib/sysimage@g" \
    -e "/DownloadUser/d" \
    /etc/pacman.conf

# init keys
pacman-key --init
if [[ $IMAGE_FLAVOR == cachy-* ]]; then
    pacman-key --populate archlinux cachyos
else
    pacman-key --populate archlinux
fi

# add heck's bootc repo
pacman-key --recv-key 5DE6BF3EBC86402E7A5C5D241FA48C960F9604CB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 5DE6BF3EBC86402E7A5C5D241FA48C960F9604CB
echo -e '\n[bootc]\nSigLevel = Required\nServer=https://github.com/hecknt/arch-bootc-pkgs/releases/download/$repo' >> /etc/pacman.conf

# perform system update
pacman -Syu --noconfirm >/dev/null

echo "::endgroup::"
