#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

# setup
source /config/00-functions
set -ouex pipefail

# preconfigure basic system settings
echo "uninitialized" > /etc/machine-id
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# re-enable pacman network sandbox
sed -i '/DisableSandboxNetwork/d' /etc/pacman.conf

# set correct permissions on polkit rules dir
chmod 750 /etc/polkit-1/rules.d
chown -R root:polkitd /etc/polkit-1/rules.d

# remove base-devel, keep sudo
pacman -Rns --noconfirm base-devel cmake extra-cmake-modules
retry pacman -S --noconfirm --needed sudo

# fix ttys not starting correctly
ln -sT /usr/lib/systemd/system/getty@.service /usr/lib/systemd/system/autovt@.service

# fix ttyname err noise in synergy
sed -i '1s|/usr/bin/tty )|/usr/bin/tty 2>/dev/null )|' /etc/profile.d/gpm.sh

# configure useradd defaults
sed -i 's|^HOME=.*|HOME=/var/home|' "/etc/default/useradd"

# set plymouth theme
plymouth-set-default-theme tartaria

# remove any .pacnew files
find /etc/ -name "*.pacnew" -type f -delete

# disable uupd distrobox updates
sed -i 's|uupd|& --disable-module-distrobox|' /usr/lib/systemd/system/uupd.service

# pick random gender flag and set it as default face
cp "/usr/share/tartaria/faces/face-$(shuf -i 1-10 -n 1).png" /usr/share/tartaria/faces/default-face.png

# install default icon theme
retry git clone https://github.com/vinceliuice/MacTahoe-icon-theme
bash ./MacTahoe-icon-theme/install.sh -t grey -n default-icons -d /usr/share/icons
rm -rf MacTahoe-icon-theme

# set default niri config
install -d /etc/niri/
ln -sT /usr/share/tartaria/cherries/dot_config/niri/config.kdl /etc/niri/config.kdl

# install flatpak's preinstall file
mkdir -p /usr/share/flatpak/preinstall.d
cp /config/03-flatpaks /usr/share/flatpak/preinstall.d/sysapps.preinstall

# apply gschema overrides
glib-compile-schemas /usr/share/glib-2.0/schemas

# install host-spawn
retry wget -q https://github.com/1player/host-spawn/releases/download/v1.6.2/host-spawn-x86_64 -O /usr/lib/subsystem/bin/host-spawn
chmod +x /usr/lib/subsystem/bin/host-spawn

# configure dotfiles
cp -r /cherries/shared/* /usr/share/tartaria/cherries/
if [[ "$IMAGE_FLAVOR" == *maraska || "$IMAGE_FLAVOR" == *berbere ]]; then
    cp -r /cherries/noctalia/* /usr/share/tartaria/cherries/
elif [[ "$IMAGE_FLAVOR" == *saffron || "$IMAGE_FLAVOR" == *amchoor ]]; then
    cp -r /cherries/duxshell/* /usr/share/tartaria/cherries/
fi

# configure greeter cmd
if [[ "$IMAGE_FLAVOR" == *maraska || "$IMAGE_FLAVOR" == *berbere ]]; then
    sed -i "s|PLACEHOLDER|env XCURSOR_THEME=Bibata-Original-Ice XCURSOR_SIZE=28 /usr/bin/noctalia-greeter-session -- --session niri|g" /{etc/greetd,usr/share/greeter-defaults}/config.toml
elif [[ "$IMAGE_FLAVOR" == *saffron || "$IMAGE_FLAVOR" == *amchoor ]]; then
    sed -i "s|PLACEHOLDER|env XCURSOR_THEME=Bibata-Original-Ice XCURSOR_SIZE=28 /usr/bin/dms-greeter --command niri|g" /{etc/greetd,usr/share/greeter-defaults}/config.toml
fi

# export secureboot cert for saffron/maraska
if [[ "$IMAGE_VARIANT" == *saffron || "$IMAGE_VARIANT" == *maraska ]]; then
    mkdir -p /usr/share/tartaria/certs
    openssl x509 -in /run/secrets/secureboot_cert -outform DER -out /usr/share/tartaria/certs/secureboot.der
fi

echo "::endgroup::"
