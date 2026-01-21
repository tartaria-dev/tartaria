#!/bin/sh
# setup subsystem rootfs

echo "::group::===========================> Subsystem creation"

set -ouex pipefail

# install erofs-utils
pacman -S --noconfirm erofs-utils

# enter workdir
mkdir -p /workdir
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
fakeroot pacman $PACARGS -Sy --noconfirm
fakeroot pacman $PACARGS -S --noconfirm \
    base \
    systemd \
    dbus \
    util-linux \
    glibc \
    libseccomp \
    shadow \

# install essential cli packages
fakeroot pacman $PACARGS -S --noconfirm \
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
fakeroot pacman $PACARGS -Scc --noconfirm
rm -rf /rootfs/var/cache/pacman/pkg/*
rm -rf /rootfs/var/lib/pacman/sync/*

# generate locale
echo "en_US.UTF-8 UTF-8" > /rootfs/etc/locale.gen
fakeroot chroot /rootfs locale-gen

# update dynamic linker cache
fakeroot chroot /rootfs ldconfig

# configure bash prompt
echo -e '\neval "$(starship init bash)"\neval "$(atuin init bash)"' >> /rootfs/etc/bash.bashrc

# add os-release files
cp -f /usr/lib/os-release /rootfs/usr/lib/os-release
cp -f /etc/os-release /rootfs/etc/os-release

# compatibility with host's homedir config
fakeroot ln -sT /rootfs/home /rootfs/var/home

# build cleanup
rm -f "/rootfs$FAKEROOTLIB"
rm -rf /rootfs/home/*

# create disk image of rootfs
fakeroot mkfs.erofs -zlz4hc,12 -E all-fragments,fragdedupe=inode -L subsystem /usr/lib/subsystem/subsystem.dsk /rootfs

# create subsystem directory and setup subsys home
mkdir -p /subsys
ln -sT /etc/subsystem-conf/.config/containers/systemd/subsystem.container /etc/subsystem-conf/subsystem.container
chown -R subsys:subsys /etc/subsystem-conf

# create subsystem user
useradd -r -m -d /etc/subsystem-conf -s /bin/bash subsys
echo "subsys:100000:65536" | tee -a /etc/subuid
echo "subsys:100000:65536" | tee -a /etc/subgid

echo "::endgroup::"
