#!/usr/bin/env bash
# commands for installing main system packages

echo "::group::===========================> Install system packages"

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
    KERN_PKG="linux-cachyos"
    CACHY_PKGS="scx-manager scx-scheds"
    NVIDIA_PKGS=" "
    readonly KERN_PKG
    readonly CACHY_PKGS
    readonly NVIDIA_PKGS
elif [[ "$IMAGE_FLAVOR" == "cachy-nvidia" ]]; then
    KERN_PKG="linux-cachyos-nvidia-open"
    CACHY_PKGS="scx-manager scx-scheds"
    NVIDIA_PKGS="nvidia-utils"
    readonly KERN_PKG
    readonly CACHY_PKGS
    readonly NVIDIA_PKGS
fi

# define packages to install
declare -a packages=(
    # ========> system
    base
    bootc/bootc
    bootc/uupd
    $KERN_PKG
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
    rsync
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
    fprintd
    intel-media-driver
    intel-ucode
    iio-sensor-proxy
    lm_sensors
    libva-intel-driver
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
    crun
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
    chezmoi
    cliphist
    dgop
    espeak-ng
    evolution-data-server
    frameworkintegration
    glycin
    gnome-keyring
    gpu-screen-recorder
    greetd
    greetd-regreet
    inotify-tools
    libappindicator
    niri
    noctalia
    orca
    orchis-theme
    shared-mime-info
    tuned
    tuned-ppd
    wl-clip-persist
    wlsunset
    $CACHY_PKGS
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    xdg-user-dirs
    xdg-utils

    # ========> apps
    ark
    bazaar
    flatseal
    hplip
    kitty
    nautilus
    sysprof
)

# install packages in one go
pacman -S --noconfirm --needed "${packages[@]}" >/dev/null
pacman -S --noconfirm --needed libva-mesa-driver >/dev/null
pacman -U --noconfirm --needed /packages/mainsys/*.pkg.tar.zst >/dev/null

echo "::endgroup::"
