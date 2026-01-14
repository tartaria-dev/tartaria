#!/bin/sh
# miscellaneous stuff

echo "::group::===========================> Miscellaneous tasks"

set -ouex pipefail

# manually add greetd user due to rebase issues
useradd -M -G video,input -s /usr/bin/nologin greeter || true

# install Colloid icon theme
git clone https://github.com/vinceliuice/Colloid-icon-theme
cd Colloid-icon-theme
bash ./install.sh -s catppuccin -t grey -n colloid-icons -d /usr/share/icons
cd ..
rm -rf Colloid-icon-theme

# setup systemd-resolved
systemctl preset systemd-resolved.service

# setup oh-my-posh prompt
echo 'eval "$(starship init bash)"' >> /etc/bash.bashrc

# set default niri config
install -d /etc/niri/
ln -sT /usr/share/tartaria/cherries/dot_config/niri/config.kdl /etc/niri/config.kdl

# apply gschema overrides
glib-compile-schemas /usr/share/glib-2.0/schemas

# package cleanup
rm -rf /packages

echo "::endgroup::"
