#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

### script setup

source /config/00-functions
set -ouex pipefail

### system configuration

config_system() {
    echo "uninitialized" > /etc/machine-id
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime

    ln -sT /usr/lib/systemd/system/getty@.service /usr/lib/systemd/system/autovt@.service
    
    sed -i '/DisableSandboxNetwork/d' /etc/pacman.conf
    sed -i '1s|/usr/bin/tty )|/usr/bin/tty 2>/dev/null )|' /etc/profile.d/gpm.sh
    sed -i 's|uupd|& --disable-module-distrobox|' /usr/lib/systemd/system/uupd.service
    sed -i 's|^HOME=.*|HOME=/var/home|g' "/etc/default/useradd"
    sed -i 's|/var/cache/fontconfig|/usr/lib/fontconfig/cache|g' /etc/fonts/fonts.conf
    
    pacman -Rns --noconfirm cmake extra-cmake-modules mkosi
    find /etc/ -name "*.pacnew" -type f -delete

    mkdir -p /usr/lib/fontconfig/cache
    fc-cache -rsfv
    
    chmod 750 /etc/polkit-1/rules.d
    chown -R root:polkitd /etc/polkit-1/rules.d
    
    chmod 0440 /etc/sudoers.d/00-give-wheel-rights
    visudo -cf /etc/sudoers.d/00-give-wheel-rights
}

config_services() {
    mkdir -p /usr/lib/systemd/system-preset
    cp /config/06-sys-servs /usr/lib/systemd/system-preset/00-tartaria.preset

    mkdir -p /usr/lib/systemd/user-preset
    cp /config/07-usr-servs /usr/lib/systemd/user-preset/00-tartaria.preset
    echo "disable *" | tee -a /usr/lib/systemd/user-preset/99-default.preset

    systemctl preset-all
    systemctl --global preset-all

    systemctl add-wants --global niri.service \
        desktop-shell.service \
        udiskie.service
}

config_branding() {
    plymouth-set-default-theme tartaria

    cp "/usr/share/tartaria/faces/face-$(shuf -i 1-10 -n 1).png" /usr/share/tartaria/faces/default-face.png
    
    retry git clone https://github.com/vinceliuice/MacTahoe-icon-theme
    bash ./MacTahoe-icon-theme/install.sh -t grey -n default-icons -d /usr/share/icons

    rm -rf MacTahoe-icon-theme
}

config_dsession() {    
    cp -r /cherries/shared/* /usr/share/tartaria/cherries/

    if [[ "$IMAGE_FLAVOR" == *maraska || "$IMAGE_FLAVOR" == *berbere ]]; then
        cp -r /cherries/noctalia/* /usr/share/tartaria/cherries/
    elif [[ "$IMAGE_FLAVOR" == *saffron || "$IMAGE_FLAVOR" == *amchoor ]]; then
        cp -r /cherries/duxshell/* /usr/share/tartaria/cherries/
    fi

    install -d /etc/niri/
    ln -sT /usr/share/tartaria/cherries/dot_config/niri/config.kdl /etc/niri/config.kdl

    mkdir -p /etc/greetd
    
    if [[ "$IMAGE_FLAVOR" == *maraska || "$IMAGE_FLAVOR" == *berbere ]]; then
        cp -r /usr/share/greeter-defaults/noctalia/config.toml /etc/greetd/
        cp -a /usr/share/greeter-defaults/noctalia/sync.toml /var/lib/noctalia-greeter/
    elif [[ "$IMAGE_FLAVOR" == *saffron || "$IMAGE_FLAVOR" == *amchoor ]]; then
        cp -a /usr/share/greeter-defaults/duxshell/config.toml /etc/greetd/
    fi
}

config_tooling() {
    mkdir -p /usr/share/flatpak/preinstall.d
    cp /config/01-flatpaks /usr/share/flatpak/preinstall.d/sysapps.preinstall

    glib-compile-schemas /usr/share/glib-2.0/schemas

    retry wget -q https://github.com/1player/host-spawn/releases/download/v1.6.2/host-spawn-x86_64 -O /usr/lib/subsystem/bin/host-spawn
    chmod +x /usr/lib/subsystem/bin/host-spawn
}

config_secboot() {
    if [[ "$IMAGE_VARIANT" == *saffron || "$IMAGE_VARIANT" == *maraska ]]; then
        mkdir -p /usr/share/tartaria/certs
        openssl x509 -in /run/secrets/secureboot_cert -outform DER -out /usr/share/tartaria/certs/secureboot.der
    fi
}

### main logic

main() {
    echo "::group::===========================> Configure system"

    config_system
    config_services
    config_branding
    config_dsession
    config_tooling
    config_secboot

    script_cleanup
    
    echo "::endgroup::"
}

main
