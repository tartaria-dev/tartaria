#!/usr/bin/env bash
# commands for installing main arch packages

echo "::group::===========================> Install packages"

set -ouex pipefail

# based on image flavor, install arch/cachy kernel and/or nvidia-open drivers
if [[ "$IMAGE_FLAVOR" == "arch" ]]; then
    KERN_PKG="linux"
    CACHY_PKGS=" "
    NVIDIA_PKGS=" "
    readonly KERN_PKG
    readonly CACHY_PKGS
    readonly NVIDIA_PKGS
elif [[ "$IMAGE_FLAVOR" == "arch-nvidia" ]]; then
    KERN_PKG="linux"
    CACHY_PKGS=" "
    NVIDIA_PKGS="nvidia-open nvidia-utils"
    readonly KERN_PKG
    readonly CACHY_PKGS
    readonly NVIDIA_PKGS
elif [[ "$IMAGE_FLAVOR" == "cachy" ]]; then
    KERN_PKG="cachyos/linux-cachyos"
    CACHY_PKGS="cachyos/scx-manager cachyos/scx-scheds"
    NVIDIA_PKGS=" "
    readonly KERN_PKG
    readonly CACHY_PKGS
    readonly NVIDIA_PKGS
elif [[ "$IMAGE_FLAVOR" == "cachy-nvidia" ]]; then
    KERN_PKG="cachyos/linux-cachyos-nvidia-open"
    CACHY_PKGS="cachyos/scx-manager cachyos/scx-scheds"
    NVIDIA_PKGS="cachyos/nvidia-open cachyos/nvidia-utils"
    readonly KERN_PKG
    readonly CACHY_PKGS
    readonly NVIDIA_PKGS
fi

# define packages to install
declare -a packages=(
    # ========> system
    base
    bootc/uupd
    $KERN_PKG
    chaotic-aur/bootc
    cpio
    dbus
    dbus-glib
    dracut
    efibootmgr
    linux-firmware
    ostree
    shadow
    shim
    skopeo
    udev

    # ========> cli
    bash
    bash-completion
    binutils
    curl
    gcc
    git
    glibc-locales
    jq
    less
    lsof
    man-db
    nano
    openssh
    powertop
    python3
    tar
    unzip
    vim
    wget

    # ========> filesystems
    btrfs-progs
    dosfstools
    e2fsprogs
    erofs-utils
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
    xfsprogs

    # ========> hardware
    acpid
    amd-ucode
    apparmor
    bluez
    bluez-utils
    cups
    cups-browsed
    ddcutil
    intel-media-driver
    intel-ucode
    iio-sensor-proxy
    lm_sensors
    libva-intel-driver
    libva-mesa-driver
    $NVIDIA_PKGS
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

    # ========> containers
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
    cage
    chaotic-aur/bibata-cursor-theme
    chaotic-aur/darkly-qt6-git
    chaotic-aur/matugen-git
    chaotic-aur/noctalia-shell
    chaotic-aur/opentabletdriver
    chezmoi
    cliphist
    dgop
    espeak-ng
    evolution-data-server
    glycin
    gnome-keyring
    greetd
    greetd-regreet
    incron
    libappindicator
    niri
    orca
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

    # ========> applications
    ark
    chaotic-aur/bazaar-git
    chaotic-aur/distroshelf
    chaotic-aur/qt6ct-kde
    chaotic-aur/valent-git
    chaotic-aur/zen-browser-bin
    $CACHY_PKGS
    decibels
    flatseal
    frameworkintegration
    gnome-text-editor
    gpu-screen-recorder
    hplip
    kitty
    loupe
    mission-center
    nautilus
    showtime
    sysprof
)

# install packages in one go
pacman -Sy --noconfirm "${packages[@]}"
pacman -U --noconfirm /packages/mainsys/*.pkg.tar.zst >/dev/null
