#!/usr/bin/env bash
# commands for installing main arch packages

echo "::group::===========================> Perform system package installations"

set -ouex pipefail

declare -a packages=(
    # ========> system
    base
    cpio
    dbus
    dbus-glib
    dracut
    linux-firmware
    shadow
    udev

    # ========> bootloader & ostree
    chaotic-aur/bootc
    cachyos/linux-cachyos-bore
    efibootmgr
    ostree
    shim
    skopeo

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
    tar
    unzip
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
    e2fs-progs
    erofs-utils
    exfatprogs
    f2fs-tools
    fuse-overlayfs
    gpart
    gparted
    jfsutils
    mkosi
    mtools
    nilfs-utils
    ntfs-3g
    udftools
    xfsprogs

    # ========> drivers & hardware
    acpid
    amd-ucode
    apparmor
    ddcutil
    intel-media-driver
    intel-ucode
    iio-sensor-proxy
    lm_sensors
    multilib/lib32-vulkan-radeon
    libva-intel-driver
    libva-mesa-driver
    vpl-gpu-rt
    vulkan-icd-loader
    vulkan-intel
    vulkan-radeon
    xf86-video-amdgpu
    zram-generator

    # ========> display & graphics
    mesa
    mesa-utils
    wayland-utils
    xwayland-satellite

    # ========> audio
    alsa-firmware
    linux-firmware-intel
    multilib/lib32-pipewire
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

    # ========> containers & virtualization
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
    chaotic-aur/darkly-qt6-git
    chaotic-aur/matugen-git
    chaotic-aur/noctalia-shell
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

    # ========> input devices
    chaotic-aur/opentabletdriver
    patchwel

    # ========> accessibility
    espeak-ng
    orca

    # ========> printing
    cups
    cups-browsed
    hplip

    # ========> applications
    ark
    chaotic-aur/bazaar-git
    chaotic-aur/distroshelf
    chaotic-aur/qt6ct-kde
    chaotic-aur/valent-git
    chaotic-aur/zen-browser-bin
    cachyos/scx-manager
    cachyos/scx-scheds
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
    secrets
    showtime
    sysprof
)

pacman -Syq --noconfirm "${packages[@]}" > /dev/null
pacman -U --noconfirm /packages/*.pkg.tar.zst > /dev/null
