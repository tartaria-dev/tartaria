#!/usr/bin/env bash
# extra important stuff

set -ouex pipefail

# set correct permissions on polkit rules dir
chmod 750 /etc/polkit-1
chgrp -R polkitd /etc/polkit-1

# fix ttys not starting correctly
ln -sT /usr/lib/systemd/system/getty@.service /usr/lib/systemd/system/autovt@.service

# configure useradd defaults
sed -i 's|^HOME=.*|HOME=/var/home|' "/etc/default/useradd"

# set plymouth theme
sed -i 's/bgrt/red_loader/g' /usr/share/plymouth/plymouthd.defaults

# remove any .pacnew files
find /etc/ -name "*.pacnew" -type f -delete

# disable uupd distrobox updates
sed -i 's|uupd|& --disable-module-distrobox|' /usr/lib/systemd/system/uupd.service

# pick random gender flag and set it as default face
cp "/usr/share/tartaria/faces/face-$(shuf -i 1-10 -n 1).png" /usr/share/tartaria/faces/default-face.png

# fix os-release files
rm -f /etc/os-release
sed -i "s/Arch/Tartaria ($IMAGE_VARIANT)/g" /usr/lib/os-release
ln -sT /usr/lib/os-release /etc/os-release

# install default icon theme
git clone https://github.com/vinceliuice/MacTahoe-icon-theme
cd MacTahoe-icon-theme
bash ./install.sh -t grey -n default-icons -d /usr/share/icons
cd ..
rm -rf MacTahoe-icon-theme

# set default niri config
install -d /etc/niri/
ln -sT /usr/share/tartaria/cherries/dot_config/niri/config.kdl /etc/niri/config.kdl

# apply gschema overrides
glib-compile-schemas /usr/share/glib-2.0/schemas

# move /opt into /usr so it gets preserved
rm -rf /usr/opt
mv /opt /usr

echo "::endgroup::"
