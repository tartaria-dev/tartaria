#!/bin/sh
# setup subsystem rootfs
# ts took 3 hours to make bro im genuinely gonna crash out

echo "::group::===========================> Subsystem creation"

set -ouex pipefail

# download arch rootfs tarball and signature
curl -JLO https://archive.archlinux.org/iso/2026.01.01/archlinux-bootstrap-x86_64.tar.zst
curl -JLO https://archive.archlinux.org/iso/2026.01.01/archlinux-bootstrap-x86_64.tar.zst.sig

# verify arch rootfs tarball signature with arch key
gpg --keyserver keyserver.ubuntu.com --recv-keys 9741E8AC
gpg --verify --keyserver keyserver.ubuntu.com --keyserver-options auto-key-retrieve archlinux-bootstrap-x86_64.tar.zst.sig archlinux-bootstrap-x86_64.tar.zst

# extract and prepare rootfs
fakeroot tar --numeric-owner -xpf archlinux-bootstrap-x86_64.tar.zst
mv root.x86_64 /rootfs

# configure environment
FAKEROOTLIB=$(find /usr/lib -name "libfakeroot.so" | head -n 1)
mkdir -p "/rootfs$(dirname "$FAKEROOTLIB")"
cp -f "$FAKEROOTLIB" "/rootfs$FAKEROOTLIB"

# initialize pacman keys/mirrors in rootfs
echo "Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch" > /rootfs/etc/pacman.d/mirrorlist
fakeroot pacman-key --gpgdir /rootfs/etc/pacman.d/gnupg --init
fakeroot pacman-key --gpgdir /rootfs/etc/pacman.d/gnupg \
                    --config /rootfs/etc/pacman.conf \
                    --populate archlinux

# update rootfs and install base packages
fakeroot pacman -r /rootfs -Sy --noconfirm
fakeroot pacman -r /rootfs -S --noconfirm \
    base \
    base-devel

# install needed cli packages into the rootfs
fakeroot pacman -r /rootfs -S --noconfirm \
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

# cleanup pacman cache
fakeroot pacman -r /rootfs -Scc --noconfirm
rm -rf /rootfs/var/cache/pacman/pkg/*
rm -rf /rootfs/var/lib/pacman/sync/*

# set locale to en_US by default
echo "en_US.UTF-8 UTF-8" > /rootfs/etc/locale.gen
fakeroot chroot /rootfs locale-gen

# extra subsystem configuration
echo -e '\neval "$(starship init bash)"\neval "$(atuin init bash)"' >> /rootfs/etc/bash.bashrc

# build cleanup
rm -f "/rootfs$FAKEROOTLIB"

# finalize subsystem build and create disk image
fakeroot mkfs.erofs -zlz4hc,12 -E all-fragments,fragdedupe=inode -L subsystem /usr/lib/subsystem/subsystem.dsk /rootfs

# post build cleanup
rm -rf /rootfs

echo "::endgroup::"
