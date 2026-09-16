#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

echo "::group::===========================> Configure system"

# setup
source /config/00-functions
set -ouex pipefail

# system
systemctl enable \
    apparmor.service \
    bluetooth.service \
    brew-setup.service \
    cups-browsed.service \
    cups.socket \
    firewalld.service \
    greetd.service \
    home.mount \
    install-flatpak-sysapps.service \
    kdeconnect-firewalld-bypass.service \
    mnt.mount \
    mok-enroll.service \
    NetworkManager.service \
    opt.mount \
    pick-cherries.timer \
    polkit.service \
    rechunker-group-fix.service \
    refresh-font-cache.service \
    root.mount \
    srv.mount \
    subsystem-filesystemd.service \
    sync-greeter-configs.service \
    tuned-ppd.service \
    tuned.service \
    usr-share-tartaria-cherries.mount \
    uupd.timer

# system-preset
systemctl preset \
    home.mount \
    install-flatpak-sysapps.service \
    kdeconnect-firewalld-bypass.service \
    mnt.mount \
    mok-enroll.service \
    opt.mount \
    root.mount \
    srv.mount \
    subsystem-filesystemd.service \
    systemd-resolved.service

# user
systemctl --global enable \
    chezmoi-init.service \
    chezmoi-update.timer \
    flathub-user.service \
    noctalia-shell.service \
    refresh-font-cache.service \
    subsystem-containerd.service \
    udiskie.service \
    wl-clip-persist.service
    
# user-preset
systemctl preset --global \
    chezmoi-init.service \
    chezmoi-update.timer \
    flathub-user.service \
    noctalia-shell.service \
    refresh-font-cache.service \
    subsystem-containerd.service \
    udiskie.service \
    wl-clip-persist.service

# user-wants for Niri
systemctl add-wants --global niri.service \
    noctalia-shell.service \
    udiskie.service
