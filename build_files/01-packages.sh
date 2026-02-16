#!/usr/bin/env bash
# commands for installing main arch packages

echo "::group::===========================> Perform system package installations"

set -ouex pipefail

declare -a packages=(
    # ========> system
    base
    chaotic-aur/bootc
    cpio
    dracut
    cachyos/linux-cachyos-bore
    linux-firmware
    ostree
    skopeo
    dbus
    dbus-glib
    glib2
    ostree
    shadow

    # ========> cli essentials
    bash
    bash-completion
    bootc/uupd
    binutils
    curl
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
    usbutils
    wget

    # ========> cli extras
    chezmoi
    fastfetch
    git
    powertop
    python3
    vim

    # ========> filesystems
    btrfs-progs
    dosfstools
    e2fsprogs
    erofs-utils
    exfatprogs
    f2fs-tools
    fuse-overlayfs
    gpart
    gparted
    jfsutils
    mtools
    mkosi
    nilfs-utils
    ntfs-3g
    xfsprogs
    udftools

    # ========> drivers
    acpid
    amd-ucode
    apparmor
    ddcutil
    efibootmgr
    iio-sensor-proxy
    intel-media-driver
    intel-ucode
    cachyos/lib32-vulkan-radeon
    libva-intel-driver
    libva-mesa-driver
    lm_sensors
    mesa
    mesa-utils
    shim
    vpl-gpu-rt
    vulkan-icd-loader
    vulkan-intel
    vulkan-radeon
    xf86-video-amdgpu
    zram-generator

    # ========> pipewire
    alsa-firmware
    linux-firmware-intel
    pipewire
    pipewire-audio
    pipewire-ffado
    pipewire-libcamera
    pipewire-pulse
    pipewire-zeroconf
    sof-firmware
    wireplumber

    # ========> network
    firewalld
    libmtp
    networkmanager
    nss-mdns
    samba
    smbclient
    udiskie
    udisks2

    # ========> bluetooth
    bluez
    bluez-utils

    # ========> containerization
    distrobox
    docker
    docker-buildx
    docker-compose
    flatpak
    podman
    podman-compose

    # ========> media
    ffmpeg
    ffmpegthumbs
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    libglvnd
    librsvg
    mpv-mpris
    playerctl
    plymouth
    wayland-utils
    xwayland-satellite

    # ========> fonts
    gnu-free-fonts
    gsfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    ttf-arphic-uming
    ttf-baekmuk
    ttf-croscore
    ttf-dejavu
    ttf-droid
    ttf-ibm-plex
    ttf-overpass
    unicode-emoji
    wqy-microhei

    # ========> interface
    accountsservice
    archlinux-xdg-menu
    brightnessctl
    chaotic-aur/bibata-cursor-theme
    chaotic-aur/matugen-git
    chaotic-aur/noctalia-shell
    chaotic-aur/opentabletdriver
    cliphist
    chaotic-aur/darkly-qt6-git
    dgop
    evolution-data-server
    glycin
    gnome-keyring
    greetd
    greetd-regreet
    incron
    libappindicator
    niri
    orchis-theme
    polkit-kde-agent
    quickshell
    shared-mime-info
    tuned
    tuned-ppd
    wl-clip-persist
    wlsunset
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    xdg-user-dirs
    xdg-utils

    # ========> accessibility
    espeak-ng
    orca

    # ========> printers
    cups
    cups-browsed
    hplip

    # ========> apps
    ark
    chaotic-aur/bazaar-git
    chaotic-aur/distroshelf
    chaotic-aur/qt6ct-kde
    chaotic-aur/valent-git
    chaotic-aur/zen-browser-bin
    decibels
    frameworkintegration
    gnome-calculator
    gnome-calendar
    gnome-music
    gnome-text-editor
    gnome-weather
    gpu-screen-recorder
    impression
    kitty
    loupe
    mission-center
    nautilus
    papers
    cachyos/scx-manager
    cachyos/scx-scheds
    secrets
    showtime
    sysprof
)

pacman -Syq --noconfirm "${packages[@]}" > /dev/null
pacman -U --noconfirm /packages/*.pkg.tar.zst > /dev/null
