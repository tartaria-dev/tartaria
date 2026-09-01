#!/usr/bin/env bash
# commands for installing main system packages

echo "::group::===========================> Install system packages"

set -ouex pipefail

## Non-AUR packages

# import package list as an array
mapfile -t packages < <(grep -vE '^[[:space:]]*(#|$)' /build/conf/01-sys-pkgs)

# based on image flavor, install arch/cachy kernel and/or nvidia-open drivers
case "$IMAGE_FLAVOR" in
    arch-berbere|arch-mahleb)
        packages+=("linux")
        ;;
    arch-amchoor|arch-saffron)
        packages+=("linux" "nvidia-open" "nvidia-utils")
        ;;
    cachy-berbere|cachy-mahleb)
        packages+=("linux-cachyos" "scx-scheds" "scx-manager")
        ;;
    cachy-amchoor|cachy-saffron)
        packages+=("linux-cachyos-nvidia-open" "linux-cachyos" "scx-scheds" "scx-manager" "nvidia-utils")
        ;;
esac

# install non-AUR packages
pacman -S --noconfirm --needed "${packages[@]}" >/dev/null
pacman -S --noconfirm --needed libva-mesa-driver >/dev/null

## AUR packages

# create build user
useradd -m builder
mkdir -p /etc/sudoers.d
echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder

# clone yay-bin and install it
runuser -u builder -- bash -c "git clone https://aur.archlinux.org/yay-bin.git /home/builder/yay-bin" >/dev/null
runuser -u builder -- bash -c "cd /home/builder/yay-bin && makepkg -si --noconfirm" >/dev/null
rm -rf /home/builder/yay-bin

# install AUR packages
if ! runuser -u builder -- bash -c "xargs -a /build/conf/02-aur-pkgs yay -S --noconfirm --needed" >/tmp/yay.log 2>&1; then
    tail -n 200 /tmp/yay.log
    exit 1
fi

# cleanup
pacman -Rns --noconfirm base-devel
rm -f /tmp/yay.log

echo "::endgroup::"
