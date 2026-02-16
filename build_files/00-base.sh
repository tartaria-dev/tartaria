#!/usr/bin/env bash
# prepare base image

echo "::group::===========================> Perform image build preparation"

set -oux pipefail

# move /var directories to /usr/lib/sysimage for bootc usroverlay compatibility
grep "= */var" /etc/pacman.conf | sed "/= *\/var/s/.*=// ; s/ //" | \
    xargs -n1 sh -c \
        'mkdir -p "/usr/lib/sysimage/$(dirname $(echo $1 | sed "s@/var/@@"))" && \
         mv -v "$1" "/usr/lib/sysimage/$(echo "$1" | sed "s@/var/@@")"' '' > /dev/null

set -e

# update pacman config
sed -i \
    -e "/= *\/var/ s/^#//" \
    -e "s@= */var@= /usr/lib/sysimage@g" \
    -e "/DownloadUser/d" \
    /etc/pacman.conf

# init keys
pacman-key --init
pacman -Sy

# add cachyos repo
pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key F3B607488DB35A47
pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-keyring-20240331-1-any.pkg.tar.zst' --noconfirm > /dev/null
pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-mirrorlist-22-1-any.pkg.tar.zst' --noconfirm > /dev/null
echo -e '\n[cachyos]\nInclude = /etc/pacman.d/cachyos-mirrorlist' >> /etc/pacman.conf

# add chaotic AUR repo
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm > /dev/null
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm > /dev/null
echo -e '\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf

# add heck's bootc repo
pacman-key --recv-key 5DE6BF3EBC86402E7A5C5D241FA48C960F9604CB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 5DE6BF3EBC86402E7A5C5D241FA48C960F9604CB
echo -e '\n[bootc]\nSigLevel = Required\nServer=https://github.com/hecknt/arch-bootc-pkgs/releases/download/$repo' >> /etc/pacman.conf

# perform system update
pacman -Syuq --noconfirm

echo "::endgroup::"
