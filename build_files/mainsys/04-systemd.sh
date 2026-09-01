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
    install-flatpak-sysapps.service \
    kdeconnect-firewalld-bypass.service \
    libvirtd.service \
    mok-enroll.service \
    NetworkManager.service \
    pick-cherries.timer \
    polkit.service \
    rechunker-group-fix.service \
    refresh-font-cache.service \
    subsystem-filesystemd.service \
    sync-greeter-configs.service \
    tuned-ppd.service \
    tuned.service \
    usr-share-tartaria-cherries.mount \
    uupd.timer

# system-preset
systemctl preset \
    install-flatpak-sysapps.service \
    kdeconnect-firewalld-bypass.service \
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
    subsystem-containerd.service \
    udiskie.service \
    wl-clip-persist.service

# user-wants for Niri
systemctl add-wants --global niri.service \
    noctalia-shell.service \
    udiskie.service
