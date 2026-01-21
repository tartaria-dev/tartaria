#!/bin/sh
# commands for installing misc packages (AUR, Chaotic AUR, bootc)

echo "::group::===========================> Perform AUR package installations"

set -ouex pipefail

# setup Chaotic AUR
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --init && pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
echo -e '[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf

# setup Heck's bootc repo
pacman-key --recv-key 5DE6BF3EBC86402E7A5C5D241FA48C960F9604CB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 5DE6BF3EBC86402E7A5C5D241FA48C960F9604CB
echo -e '[bootc]\nSigLevel = Required\nServer=https://github.com/hecknt/arch-bootc-pkgs/releases/download/$repo' >> /etc/pacman.conf

pacman -Syqq --noconfirm

# install Chaotic AUR / bootc / local packages
pacman -Sqq --noconfirm \
    bootc/uupd \
    chaotic-aur/bazaar-git \
    chaotic-aur/bibata-cursor-theme \
    chaotic-aur/bootc \
    chaotic-aur/darkly-qt6-git \
    chaotic-aur/distroshelf \
    chaotic-aur/jetbrains-toolbox \
    chaotic-aur/matugen-git \
    chaotic-aur/noctalia-shell \
    chaotic-aur/opentabletdriver \
    chaotic-aur/qt6ct-kde \
    chaotic-aur/ttf-symbola \
    chaotic-aur/ttf-twemoji \
    chaotic-aur/valent-git \
    chaotic-aur/zen-browser-bin

for pkg in /packages/*; do
    pacman -U --noconfirm "$pkg"
done

echo "::endgroup::"
