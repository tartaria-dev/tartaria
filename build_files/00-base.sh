#!/bin/sh
# prepare base image, DO NOT MODIFY

set -ouex pipefail

# FIXME | Fix an issue with Cachy's docker, pacman -syu fails otherwise https://discuss.cachyos.org/t/cant-update-because-of-linux-firmware-notice/19835
mkdir /usr/lib/sysimage/lib/pacmanlocal -p

# initialize database and install base packages
pacman -Syu --noconfirm
pacman -Sy --noconfirm base dracut linux linux-firmware ostree btrfs-progs e2fsprogs xfsprogs dosfstools skopeo dbus dbus-glib glib2 ostree shadow reflector && pacman -S --clean --noconfirm

echo "::endgroup::"
