#!/usr/bin/env bash
# configure important system services

echo "::group::===========================> Configure system"

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
    kdeconnect-firewalld-bypass.service \
    install-flatpak-sysapps.service \
    mok-enroll.service \
    NetworkManager.service \
    polkit.service \
    pick-cherries.timer \
    rechunker-group-fix.service \
    refresh-font-cache.service \
    tuned-ppd.service \
    tuned.service \
    uupd.timer \
    usr-share-tartaria-cherries.mount \
    sync-greeter-configs.service \
    subsystem-filesystemd.service

# system-preset
systemctl preset \
    kdeconnect-firewalld-bypass.service \
    install-flatpak-sysapps.service \
    mok-enroll.service \
    subsystem-filesystemd.service \
    systemd-resolved.service

# user
systemctl --global enable \
    chezmoi-init.service \
    chezmoi-update.timer \
    flathub-user.service \
    noctalia-shell.service \
    opentabletdriver.service \
    subsystem-containerd.service \
    udiskie.service \
    wl-clip-persist.service
    
# user-preset
systemctl preset --global \
    chezmoi-init.service \
    chezmoi-update.timer \
    flathub-user.service \
    noctalia-shell.service \
    subsystem-containerd.service \
    udiskie.service \
    wl-clip-persist.service

# user-wants for Niri
systemctl add-wants --global niri.service \
    noctalia-shell.service \
    udiskie.service
