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
    NetworkManager.service \
    polkit.service \
    incrond.service \
    rechunker-group-fix.service \
    refresh-font-cache.service \
    subsystem-config.service \
    tuned-ppd.service \
    tuned.service \
    usr-share-tartaria-cherries.mount \
    uupd.timer \
    pick-cherries.timer

# system-preset
systemctl preset \
    systemd-resolved.service \
    subsystem-config.service \
    kdeconnect-firewalld-bypass.service

# user
systemctl --global enable \
    chezmoi-init.service \
    chezmoi-update.timer \
    flathub-user.service \
    noctalia-shell.service \
    opentabletdriver.service \
    udiskie.service \
    subsystem.service \
    wl-clip-persist.service
    
# user-preset
systemctl preset --global \
    chezmoi-init.service \
    chezmoi-update.timer \
    flathub-user.service \
    noctalia-shell.service \
    udiskie.service \
    subsystem.service \
    wl-clip-persist.service

# user-wants for Niri
systemctl add-wants --global niri.service \
    noctalia-shell.service \
    udiskie.service
