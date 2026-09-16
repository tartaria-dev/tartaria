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
    enable-flathub-repo.service \
    firewalld.service \
    greetd.service \
    home.mount \
    kdeconnect-firewalld-bypass.service \
    mnt.mount \
    mok-enroll.service \
    NetworkManager.service \
    opt.mount \
    pick-cherries.timer \
    polkit.service \
    preinstall-flatpaks.service \
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
    enable-flathub-repo.service \
    home.mount \
    kdeconnect-firewalld-bypass.service \
    mnt.mount \
    mok-enroll.service \
    opt.mount \
    preinstall-flatpaks.service \
    root.mount \
    srv.mount \
    subsystem-filesystemd.service \
    systemd-resolved.service

# user
systemctl --global enable \
    chezmoi-init.service \
    chezmoi-update.timer \
    enable-flathub-repo.service \
    noctalia-shell.service \
    refresh-font-cache.service \
    subsystem-containerd.service \
    udiskie.service \
    wl-clip-persist.service
    
# user-preset
systemctl preset --global \
    chezmoi-init.service \
    chezmoi-update.timer \
    enable-flathub-repo.service \
    noctalia-shell.service \
    refresh-font-cache.service \
    subsystem-containerd.service \
    udiskie.service \
    wl-clip-persist.service

# user-wants for Niri
systemctl add-wants --global niri.service \
    noctalia-shell.service \
    udiskie.service
