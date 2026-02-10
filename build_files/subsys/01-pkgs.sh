#!/bin/sh
# commands for installing main arch packages

echo "::group::===========================> Perform package installations"

set -ouex pipefail

declare -a packages=(
    # ========> system
    base
    dbus
    dbus-glib
    glib2
    shadow

    # ========> cli essentials
    binutils
    curl
    fish
    gcc
    glibc-locales
    jq
    less
    lsof
    man-db
    nano
    openssh
    patchelf
    rsync
    tar
    tree
    udev
    unzip
    wget

    # ========> cli extras
    atuin
    cava
    chezmoi
    fastfetch
    git
    python3
    starship
    neovim
    vim
)

pacman -Syq --noconfirm "${packages[@]}"

echo "::endgroup::"