#!/bin/sh
# extra important stuff

echo "::group::===========================> Miscellaneous tasks"

set -ouex pipefail

# manually add greetd user due to rebase issues
useradd -M -G video,input -s /usr/bin/nologin greeter || true

# install default icon theme
git clone https://github.com/vinceliuice/WhiteSur-icon-theme
cd WhiteSur-icon-theme
bash ./install.sh -t grey -n default-icons -d /usr/share/icons
cd ..
rm -rf WhiteSur-icon-theme

# setup systemd-resolved
systemctl preset systemd-resolved.service

# setup oh-my-posh prompt
echo 'eval "$(starship init bash)"' >> /etc/bash.bashrc

# set default niri config
install -d /etc/niri/
ln -sT /usr/share/tartaria/cherries/dot_config/niri/config.kdl /etc/niri/config.kdl

# apply gschema overrides
glib-compile-schemas /usr/share/glib-2.0/schemas

# setup subsystem root
# yes, non-fhs compliant - cry :67:
mkdir -p /subsystem
for dir in dev home mnt opt proc run srv sys tmp usr; do mkdir -p "/subsystem/$dir"; done
for dir in bin etc include lib lib32 libexec share src; do mkdir -p "/subsystem/usr/$dir"; done
for dir in var etc root usr/local; do cp -rfa "/$dir" "/subsystem/$dir"; done
for dir in lib lib64; do ln -sT /subsystem/usr/lib "/subsystem/$dir"; done
for dir in bin sbin; do ln -sT /subsystem/usr/bin "/subsystem/$dir"; done
ln -sT /subsystem/usr/lib /subsystem/usr/lib64

# apply important changes to subsystem etc
echo "subsystem" > /subsystem/etc/hostname
echo "" > /subsystem/etc/machine-id
echo "" > /subsystem/etc/fstab
rm -f /subsystem/etc/resolv.conf

# package cleanup
rm -rf /packages

echo "::endgroup::"
