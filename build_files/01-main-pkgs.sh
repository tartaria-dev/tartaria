#!/bin/sh
# commands for installing main arch packages

echo "::group::===========================> Install main packages"

set -ouex pipefail

# cli essentials
pacman -S --noconfirm \
    bash \
    bash-completion \
    binutils \
    curl \
    gcc \
    glibc-locales \
    jq \
    less \
    lsof \
    man-db \
    nano \
    openssh \
    patchelf \
    rsync \
    tar \
    tree \
    udev \
    unzip \
    usbutils \
    wget

# cli extras
pacman -S --noconfirm \
    atuin \
    cava \
    chezmoi \
    fastfetch \
    git \
    java-runtime-common \
    powertop \
    python3 \
    starship \
    vim \


# filesystems
pacman -S --noconfirm \
    erofs-utils \
    exfatprogs \
    f2fs-tools \
    gpart \
    gparted \
    jfsutils \
    mtools \
    nilfs-utils \
    ntfs-3g \
    udftools

# drivers
pacman -S --noconfirm \
    acpid \
    amd-ucode \
    apparmor \
    ddcutil \
    efibootmgr \
    iio-sensor-proxy \
    intel-media-driver \
    intel-ucode \
    lib32-vulkan-radeon \
    libva-intel-driver \
    libva-mesa-driver \
    lm_sensors \
    mesa \
    mesa-utils \
    shim \
    vpl-gpu-rt \
    vulkan-icd-loader \
    vulkan-intel \
    vulkan-radeon \
    xf86-video-amdgpu \
    zram-generator

# pipewire
pacman -S --noconfirm \
    alsa-firmware \
    lib32-pipewire \
    linux-firmware-intel \
    pipewire \
    pipewire-audio \
    pipewire-ffado \
    pipewire-libcamera \
    pipewire-pulse \
    pipewire-zeroconf \
    sof-firmware \
    wireplumber

# network
pacman -S --noconfirm \
    firewalld \
    libmtp \
    networkmanager \
    nss-mdns \
    samba \
    smbclient \
    udiskie \
    udisks2

# bluetooth
pacman -S --noconfirm \
    bluez \
    bluez-utils

# containerization
pacman -S --noconfirm \
    flatpak \
    distrobox \
    docker \
    podman

# media
pacman -S --noconfirm \
    ffmpeg \
    ffmpegthumbs \
    gst-libav \
    gst-plugins-bad \
    gst-plugins-base \
    gst-plugins-good \
    gst-plugins-ugly \
    libglvnd \
    librsvg \
    mpv-mpris \
    playerctl \
    plymouth \
    wayland-utils \
    xwayland-satellite

# fonts
pacman -S --noconfirm \
    gnu-free-fonts \
    gsfonts \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    noto-fonts-extra \
    ttf-arphic-uming \
    ttf-baekmuk \
    ttf-croscore \
    ttf-dejavu \
    ttf-droid \
    ttf-ibm-plex \
    ttf-overpass \
    unicode-emoji \
    wqy-microhei

# interface
pacman -S --noconfirm \
    accountsservice \
    archlinux-xdg-menu \
    brightnessctl \
    cliphist \
    dgop \
    evolution-data-server \
    glycin \
    greetd \
    greetd-regreet \
    libappindicator \
    niri \
    orchis-theme \
    polkit-kde-agent \
    quickshell \
    shared-mime-info \
    tuned \
    tuned-ppd \
    wl-clip-persist \
    wlsunset \
    xdg-desktop-portal \
    xdg-desktop-portal-gnome \
    xdg-user-dirs \
    xdg-utils

# accessibility
pacman -S --noconfirm \
    espeak-ng \
    orca

# printer
pacman -S --noconfirm \
    cups \
    cups-browsed \
    hplip

# apps
pacman -S --noconfirm \
    ark \
    decibels \
    frameworkintegration \
    gnome-calculator \
    gnome-calendar \
    gnome-disk-utility \
    gnome-music \
    gnome-text-editor \
    gnome-weather \
    gpu-screen-recorder \
    impression \
    kitty \
    loupe \
    mission-center \
    nautilus \
    papers \
    scx-manager \
    scx-scheds \
    secrets \
    showtime \
    sysprof

echo "::endgroup::"
