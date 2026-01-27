#!/bin/sh
# setup subsystem rootfs

echo "::group::===========================> Perform subsystem installation"

set -ouex pipefail

# enter workdir and create subsys dir
mkdir -p /workdir /subsys
cd /workdir

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
PACARGS="--root /rootfs --config /rootfs/etc/pacman.conf --disable-sandbox"

# temporarily add fakeroot library to rootfs
mkdir -p "/rootfs$(dirname "$FAKEROOTLIB")"
cp -f "$FAKEROOTLIB" "/rootfs$FAKEROOTLIB"

# initialize pacman keys/mirrors
echo "Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch" > /rootfs/etc/pacman.d/mirrorlist
fakeroot pacman-key --gpgdir /rootfs/etc/pacman.d/gnupg --init
fakeroot pacman-key --gpgdir /rootfs/etc/pacman.d/gnupg \
                    --config /rootfs/etc/pacman.conf \
                    --populate archlinux

# update and install core system packages
fakeroot pacman $PACARGS -Syq --noconfirm
fakeroot pacman $PACARGS -Sq --noconfirm \
    base \
    dbus \
    util-linux \
    glibc \
    shadow \

# install essential cli packages
fakeroot pacman $PACARGS -Sq --noconfirm \
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
    nvim \
    starship \
    vim \

# cleanup pacman cache
fakeroot pacman $PACARGS -Scc --noconfirm
rm -rf /rootfs/var/cache/pacman/pkg/*
rm -rf /rootfs/var/lib/pacman/sync/*

# generate locales
echo -e "en_US.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8\nja_JP.UTF-8 UTF-8\nes_ES.UTF-8 UTF-8" > /rootfs/etc/locale.gen
fakeroot chroot /rootfs locale-gen

# update dynamic linker cache
fakeroot chroot /rootfs ldconfig

# configure bash prompt
echo -e '\neval "$(starship init bash)"\neval "$(atuin init bash)"' >> /rootfs/etc/bash.bashrc

# add os-release files
cp -f /usr/lib/os-release /rootfs/usr/lib/os-release
cp -f /etc/os-release /rootfs/etc/os-release

# fix roothome
fakeroot chroot /rootfs ln -sT /root /etc/subsystem-conf

# build cleanup
rm -f "/rootfs$FAKEROOTLIB"
rm -rf /rootfs/home/* /rootfs/var/log/* /rootfs/tmp/* /rootfs/var/tmp/*

# create disk image of rootfs
fakeroot sh -c '
    find /rootfs -user 0 -exec chown -h 767 {} +
    find /rootfs -group 0 -exec chgrp -h 767 {} +
    mkfs.erofs -zlz4hc,12 -E all-fragments,fragdedupe=inode -L subsystem /usr/lib/subsystem/subsystem.dsk /rootfs > /dev/null
'

# finish subsys conf setup
ln -sT /etc/subsystem-conf/.config/containers/systemd/subsystem.container /etc/subsystem-conf/subsystem.container

# set correct ownership of subsystem dirs
chown -R 767:767 /usr/lib/subsystem/ /etc/subsystem-conf/
chmod -R 744 /usr/lib/subsystem/ /etc/subsystem-conf/

# cleanup
cd /
rm -rf /workdir /rootfs

echo "::endgroup::"
