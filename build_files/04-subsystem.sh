#!/bin/sh
# setup subsystem rootfs

echo "::group::===========================> Subsystem creation"

set -ouex pipefail

# install arch installer tools - pacstrap in particular
pacman -S --noconfirm arch-install-scripts

# create rootfs
mkdir -p /rootfs

# use pacstrap to create the base system
pacstrap -K -c /rootfs \
    base \
    base-devel

# install needed cli packages into the rootfs
pacstrap -c /rootfs \
    bash \
    bash-completion \
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
    wget \
    atuin \
    cava \
    fastfetch \
    git \
    java-runtime-common \
    nvim \
    python3 \
    starship \
    vim \
    yt-dlp

# create subsystem directories for storing disk image
mkdir -p /usr/lib/subsystem{,/rootfs}

# create disk image
truncate -s 1T /usr/lib/subsystem/subsystem.dsk

# apply rootfs to disk image
mkfs.ext4 -d /rootfs /usr/lib/subsystem/subsystem.dsk

# cleanup
pacman -Rns --noconfirm arch-install-scripts
rm -rf /rootfs

echo "::endgroup::"