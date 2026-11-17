#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

### script setup

source /config/00-functions
set -oux pipefail

### build setup

setup_buildlogs() {
    mkdir -p /output/{artifacts,logs}
    chmod 1777 /output/logs
}

setup_pacdirs() {
    grep "= */var" /etc/pacman.conf | sed "/= *\/var/s/.*=// ; s/ //" |
    xargs -n1 sh -c \
        'mkdir -p "/usr/lib/sysimage/$(dirname $(echo $1 | sed "s@/var/@@"))" && \
        mv -v "$1" "/usr/lib/sysimage/$(echo "$1" | sed "s@/var/@@")"' '' >/dev/null

    set -e

    sed -i -e "/= *\/var/ s/^#//" -e "s@= */var@= /usr/lib/sysimage@g" -e "/DownloadUser/d" /etc/pacman.conf

    if [[ $IMAGE_FLAVOR == cachy* ]]; then
        sed -i '/^\[options\]/a DisableSandboxNetwork' /etc/pacman.conf
    fi
}

setup_pacrepos() {
    retry pacman-key --recv-key 5DE6BF3EBC86402E7A5C5D241FA48C960F9604CB --keyserver keyserver.ubuntu.com
    retry pacman-key --lsign-key 5DE6BF3EBC86402E7A5C5D241FA48C960F9604CB

    echo -e '\n[bootc]\nSigLevel = Required\nServer=https://github.com/hecknt/arch-bootc-pkgs/releases/download/$repo' >> /etc/pacman.conf
}

setup_packeys() {
    pacman-key --init

    if [[ $IMAGE_FLAVOR == cachy* ]]; then
        pacman-key --populate archlinux cachyos
    else
        pacman-key --populate archlinux
    fi
}

### main logic

main() {
    echo "::group::===========================> Prepare image build"

    setup_buildlogs

    setup_pacdirs
    setup_pacrepos
    setup_packeys

    script_cleanup

    echo "::endgroup::"
}

main
