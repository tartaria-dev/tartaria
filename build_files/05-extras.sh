#!/usr/bin/env bash
# extra important stuff

set -ouex pipefail

# remove base-devel since it's not needed
pacman -Rns --noconfirm base-devel

# manually add greetd user due to rebase issues
useradd -M -G video,input -s /usr/bin/nologin greeter || true

# set plymouth theme
sed -i 's/bgrt/red_loader/g' /usr/share/plymouth/plymouthd.defaults

# disable uupd distrobox updates
sed -i 's|uupd|& --disable-module-distrobox|' /usr/lib/systemd/system/uupd.service

# install default icon theme
git clone https://github.com/vinceliuice/WhiteSur-icon-theme
cd WhiteSur-icon-theme
bash ./install.sh -t grey -n default-icons -d /usr/share/icons
cd ..
rm -rf WhiteSur-icon-theme

# set default niri config
install -d /etc/niri/
ln -sT /usr/share/tartaria/cherries/dot_config/niri/config.kdl /etc/niri/config.kdl

# apply gschema overrides
glib-compile-schemas /usr/share/glib-2.0/schemas

echo "::endgroup::"
