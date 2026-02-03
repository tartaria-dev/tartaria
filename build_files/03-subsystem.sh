#!/bin/sh
# install subsystem container rootfs using mkosi

echo "::group::===========================> Perform subsystem installation"

set -ouex pipefail

# generate work directory and rootfs mountpoint
mkdir -p /workdir/rootfs
cd /workdir

# install apk-tools
pacman -S --noconfirm apk-tools

# set rootfs path
ROOTFS="/workdir/rootfs"

# fetch alpine edge rootfs
wget https://dl-cdn.alpinelinux.org/alpine/edge/releases/x86_64/alpine-minirootfs-20260127-x86_64.tar.gz
tar xzf alpine-minirootfs-*.tar.gz -C "$ROOTFS"

# add extra repos
echo -e "\nhttps://dl-cdn.alpinelinux.org/alpine/edge/community\nhttps://dl-cdn.alpinelinux.org/alpine/edge/testing" >> "$ROOTFS"/etc/apk/repositories

# update package index
apk --root "$ROOTFS" update

# install packages
apk --root "$ROOTFS" add --no-cache \
    alpine-base \
    shadow \
    util-linux \
    musl-locales \
    musl-locales-lang \
    sudo \
    bash \
    fish \
    atuin \
    atuin-sync \
    binutils \
    curl \
    dbus \
    fastfetch \
    gcc \
    git \
    less \
    libc-utils \
    lsof \
    mandoc \
    nano \
    neovim \
    openssh \
    patchelf \
    rsync \
    starship \
    tar \
    tree \
    unzip \
    vim \
    wget

# setup OpenRC
fakeroot chroot "$ROOTFS" rc-update add dbus default
fakeroot chroot "$ROOTFS" rc-update add syslog boot
fakeroot chroot "$ROOTFS" rc-update add crond default
sed -i 's/^#rc_parallel="NO"/rc_parallel="YES"/' "$ROOTFS"/etc/rc.conf

# basic doas config
cat > "$ROOTFS"/etc/doas.conf << 'EOF'
permit persist :wheel
EOF
chmod 0400 "$ROOTFS"/etc/doas.conf

# update dynamic linker cache
fakeroot chroot "$ROOTFS" ldconfig

# setup fish prompt
mkdir -p "$ROOTFS"/etc/fish
echo -e '\nif status is-interactive\n    starship init fish | source\n    atuin init fish | source\nend' >> "$ROOTFS"/etc/fish/config.fish

# cleanup
apk --root "$ROOTFS" cache clean

# copy os-release files from host
cp -f /usr/lib/os-release "$ROOTFS/usr/lib/os-release"
cp -f /etc/os-release "$ROOTFS/etc/os-release"

# cleanup rootfs before rootfs image generation
rm -rf "$ROOTFS"/home/* "$ROOTFS"/tmp/* "$ROOTFS"/var/tmp/* "$ROOTFS"/var/cache/apk/* "$ROOTFS"/boot "$ROOTFS"/efi "$ROOTFS"/init "$ROOTFS"/.gnupg

# create disk image of rootfs
mkdir -p /usr/lib/subsystem
mksquashfs "$ROOTFS" /usr/lib/subsystem/base.dsk -comp lz4 -Xhc -b 128K -no-xattrs -noappend -always-use-fragments > /dev/null

# cleanup
cd /
rm -rf /workdir
pacman -Rns --noconfirm apk-tools

echo "::endgroup::"
