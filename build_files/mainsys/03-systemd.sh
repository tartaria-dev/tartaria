#!/bin/sh
# configure important system services

echo "::group::===========================> Perform system configuration"

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
    rechunker-group-fix.service \
    refresh-font-cache.service \
    tuned-ppd.service \
    tuned.service \
    usr-share-tartaria-cherries.mount \
    uupd.timer \
    pick-cherries.timer

# system-preset
systemctl preset \
    systemd-resolved.service

# user
systemctl --global enable \
    subsystem-store.service \
    chezmoi-init.service \
    chezmoi-update.timer \
    flathub-user.service \
    noctalia-shell.service \
    opentabletdriver.service \
    post-chezmoi-update.service \
    udiskie.service \
    wl-clip-persist.service
    
# user-preset
systemctl preset --global \
    chezmoi-init \
    chezmoi-update \
    flathub-user \
    post-chezmoi-update \
    udiskie

# user-wants for Niri
systemctl add-wants --global niri.service \
    noctalia-shell.service \
    udiskie.service
