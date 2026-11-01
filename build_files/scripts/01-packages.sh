#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

echo "::group::===========================> Install system packages"

# setup
source /config/00-functions
set -ouex pipefail

## Non-AUR packages

# import package list as an array
mapfile -t packages < <(grep -vE '^[[:space:]]*(#|$)' /config/01-sys-pkgs)

# based on image flavor, install arch/cachy kernel and noctalia/dux shell
case "$IMAGE_FLAVOR" in
    arch-maraska|arch-berbere)
        packages+=("linux" "noctalia" "noctalia-greeter")
        ;;
    arch-saffron|arch-amchoor)
        packages+=("linux" "dux-shell" "dux-gop" "dux-search-bin" "qt6-multimedia")
        ;;
    cachy-maraska|cachy-berbere)
        packages+=("linux-cachyos-bore" "scx-scheds" "scx-manager" "noctalia" "noctalia-greeter")
        ;;
    cachy-saffron|cachy-amchoor)
        packages+=("linux-cachyos-bore" "scx-scheds" "scx-manager" "dux-shell" "dux-gop" "dux-search-bin" "qt6-multimedia")
        ;;
esac

# install non-AUR packages
retry pacman -S --noconfirm --needed "${packages[@]}" >/dev/null
retry pacman -S --noconfirm --needed libva-mesa-driver >/dev/null

## AUR packages

# create build user
useradd -m builder
mkdir -p /etc/sudoers.d
echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder

# clone yay-bin and install it
retry runuser -u builder -- bash -c "git clone https://aur.archlinux.org/yay-bin.git /home/builder/yay-bin" >/dev/null
retry runuser -u builder -- bash -c "cd /home/builder/yay-bin && makepkg -si --noconfirm" >/dev/null
rm -rf /home/builder/yay-bin

# install AUR packages
if ! retry runuser -u builder -- bash -c "xargs -a /config/02-aur-pkgs yay -S --noconfirm --needed >/tmp/build/yay.log 2>&1"; then
    cat /tmp/build/yay.log
    exit 1
fi

# install dux-greeter if saffron/amchoor
if [[ "$IMAGE_FLAVOR" == *saffron || "$IMAGE_FLAVOR" == *amchoor ]]; then
    if ! retry runuser -u builder -- bash -c "yay -S --noconfirm --needed dux-greeter >/tmp/build/yay.log 2>&1"; then
        cat /tmp/build/yay.log
        exit 1
    fi
fi 

# cleanup
userdel builder
rm -f /tmp/build/yay.log

echo "::endgroup::"
