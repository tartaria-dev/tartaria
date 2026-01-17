#!/bin/sh
# configure important system services

echo "::group::===========================> Configure systemd services"

set -ouex pipefail

# system
systemctl enable \
    polkit.service \
    NetworkManager.service \
    tuned.service \
    tuned-ppd.service \
    firewalld.service \
    greetd.service \
    rechunker-group-fix.service \
    kdeconnect-firewalld-bypass.service \
    refresh-font-cache.service \
    cups.socket \
    cups-browsed.service \
    brew-setup.service \
    bluetooth.service \
    uupd.timer \
    pick-cherries.timer \
    usr-share-tartaria-cherries.mount

# system-preset
systemctl preset \
    systemd-resolved.service

# user
systemctl --global enable \
    wl-clip-persist.service \
    udiskie.service \
    opentabletdriver.service \
    flathub-user.service \
    noctalia-shell.service \
    chezmoi-init.service \
    chezmoi-update.timer \
    post-chezmoi-update.service
    
# user-preset
systemctl preset --global \
    udiskie \
    flathub-user \
    chezmoi-init \
    chezmoi-update \
    post-chezmoi-update

# user-wants for Niri
systemctl add-wants --global niri.service \
    noctalia-shell.service \
    udiskie.service \

echo "::endgroup::"
