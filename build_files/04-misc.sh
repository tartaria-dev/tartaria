#!/bin/sh
# miscellaneous stuff

echo "::group::===========================> Miscellaneous tasks"

set -ouex pipefail

# manually add greetd user due to rebase issues
useradd -M -G video,input -s /usr/bin/nologin greeter || true

# generate static Inter font weights for initramfs
mkdir -p /usr/share/fonts/inter-static
python /ctx/extra/generate-static-inter-fonts.py

# install Maple Mono
mkdir -p "/usr/share/fonts/Maple Mono"
curl --retry 5 --retry-all-errors -fsSL https://github.com/subframe7536/maple-font/releases/download/v7.9/MapleMono-Variable.zip -o /tmp/maple.zip
unzip -q /tmp/maple.zip -d "/usr/share/fonts/Maple Mono"
rm -f /tmp/maple.zip

# setup systemd-resolved
systemctl preset systemd-resolved.service

# refresh font cache
fc-cache --force --really-force --system-only --verbose

# setup oh-my-posh prompt
echo 'eval "$(starship init bash)"' >> /etc/bash.bashrc

# set default niri config
install -d /etc/niri/
cp -f /usr/share/tartaria/cherries/dot_config/niri/config.kdl /etc/niri/config.kdl

# apply gschema overrides
glib-compile-schemas /usr/share/glib-2.0/schemas

# package cleanup
rm -rf /packages

echo "::endgroup::"
