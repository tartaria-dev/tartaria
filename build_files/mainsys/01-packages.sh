#!/usr/bin/env bash
# commands for installing main system packages

echo "::group::===========================> Install system packages"

set -ouex pipefail

## Non-AUR packages

# based on image flavor, install arch/cachy kernel and/or nvidia-open drivers
case "$IMAGE_FLAVOR" in
    arch)
        KERN_PKG="linux"
        CACHY_PKGS=""
        NVIDIA_PKGS=""
        ;;
    arch-nvidia)
        KERN_PKG="linux"
        CACHY_PKGS=""
        NVIDIA_PKGS="nvidia-open nvidia-utils"
        ;;
    cachy)
        KERN_PKG="linux-cachyos"
        CACHY_PKGS="scx-manager scx-scheds"
        NVIDIA_PKGS=""
        ;;
    cachy-nvidia)
        KERN_PKG="linux-cachyos-nvidia-open"
        CACHY_PKGS="scx-manager scx-scheds"
        NVIDIA_PKGS="nvidia-utils"
        ;;
esac
readonly KERN_PKG CACHY_PKGS NVIDIA_PKGS

# import package list as an array
mapfile -t packages < <(grep -vE '^[[:space:]]*(#|$)' /build/conf/01-sys-pkgs)
packages+=("$KERN_PKG" $NVIDIA_PKGS $CACHY_PKGS)

# install non-AUR packages
pacman -S --noconfirm --needed "${packages[@]}" >/dev/null
pacman -S --noconfirm --needed libva-mesa-driver >/dev/null

## AUR packages

# create build user
useradd -m builder
mkdir -p /etc/sudoers.d
echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder

# clone yay-bin and install it
su - builder -c "git clone https://aur.archlinux.org/yay-bin.git /home/builder/yay-bin" >/dev/null
su - builder -c "cd /home/builder/yay-bin && makepkg -si --noconfirm" >/dev/null
rm -rf /home/builder/yay-bin

# install AUR packages
if ! su - builder -c "xargs -a /build/conf/02-aur-pkgs yay -S --noconfirm --needed" >/tmp/yay.log 2>&1; then
    tail -n 200 /tmp/yay.log
    exit 1
fi

# cleanup
rm -f /tmp/yay.log

echo "::endgroup::"
