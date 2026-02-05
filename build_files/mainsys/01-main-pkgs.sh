#!/bin/sh
# commands for installing main arch packages

echo "::group::===========================> Perform system package installations"

set -ouex pipefail

declare -a packages=(
    # ========> cli essentials
    bash
    bash-completion
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
    exfatprogs
    f2fs-tools
    gpart
    gparted
    jfsutils
    mkosi
    mtools
    nilfs-utils
    ntfs-3g
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
    lib32-vulkan-radeon
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
    lib32-pipewire
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
    cliphist
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
    decibels
    frameworkintegration
    gnome-calculator
    gnome-calendar
    gnome-disk-utility
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
    scx-manager
    scx-scheds
    secrets
    showtime
    sysprof
)

pacman -Syq --noconfirm "${packages[@]}"
