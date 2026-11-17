#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

### script setup

source /config/00-functions
set -ouex pipefail

### system packages

syspkgs_setup() {
    mapfile -t packages < <(grep -vE '^[[:space:]]*(#|$)' /config/02-sys-pkgs)
    
    case "$IMAGE_FLAVOR" in
        arch-maraska|arch-berbere)
            packages+=("linux" "noctalia" "noctalia-greeter")
            ;;
        arch-saffron|arch-amchoor)
            packages+=("linux" "dux-shell" "dux-gop" "qt6-multimedia")
            ;;
        cachy-maraska|cachy-berbere)
            packages+=("linux-cachyos-bore" "scx-scheds" "scx-manager" "noctalia" "noctalia-greeter")
            ;;
        cachy-saffron|cachy-amchoor)
            packages+=("linux-cachyos-bore" "scx-scheds" "scx-manager" "dux-shell" "dux-gop" "qt6-multimedia")
            ;;
    esac
}

syspkgs_install() {
    retry pacman -Syu --noconfirm --needed "${packages[@]}" >/dev/null
    retry pacman -S --noconfirm --needed libva-mesa-driver >/dev/null

    unset packages
}

### AUR packages

aurpkgs_setup() {
    mapfile -t packages < <(grep -vE '^[[:space:]]*(#|$)' /config/03-aur-pkgs)

    if [[ "$IMAGE_FLAVOR" == *saffron || "$IMAGE_FLAVOR" == *amchoor ]]; then
        packages+=("dux-greeter" "dux-search-bin")
    fi
    
    useradd -m builder

    mkdir -p /etc/sudoers.d
    echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder
    
    retry runuser -u builder -- bash -c "git clone https://aur.archlinux.org/yay-bin.git /home/builder/yay-bin" >/dev/null
    retry runuser -u builder -- bash -c "cd /home/builder/yay-bin && makepkg -si --noconfirm" >/dev/null

    rm -rf /home/builder/yay-bin
}

aurpkgs_install() {
    if ! retry runuser -u builder -- bash -c "yay -S --noconfirm --needed ${packages[*]} >/output/logs/yay.log 2>&1"; then
        cat /output/logs/yay.log
        exit 1
    fi

    unset packages
}

### main logic

main() {
    echo "::group::===========================> Install system packages"

    syspkgs_setup
    syspkgs_install

    aurpkgs_setup
    aurpkgs_install

    script_cleanup

    echo "::endgroup::"
}

main
