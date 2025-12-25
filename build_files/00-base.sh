#!/bin/sh
# prepare base image, DO NOT MODIFY

set -ouex pipefail

# initialize database and install base packages
pacman -Syu --noconfirm
pacman -Sy --noconfirm reflector
pacman -Sy --noconfirm base dracut linux linux-firmware ostree btrfs-progs e2fsprogs xfsprogs dosfstools skopeo dbus dbus-glib glib2 ostree shadow && pacman -S --clean --noconfirm

echo "::endgroup::"
