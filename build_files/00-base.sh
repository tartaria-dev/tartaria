#!/bin/sh
# prepare image and install base packages

set -ouex pipefail

# initialize database and install base packages
pacman -Syuq --noconfirm
pacman -Syq --noconfirm reflector
pacman -Syq --noconfirm base dracut linux-cachyos linux-firmware ostree btrfs-progs e2fsprogs xfsprogs dosfstools skopeo dbus dbus-glib glib2 ostree shadow
pacman -S --clean --noconfirm

echo "::endgroup::"
