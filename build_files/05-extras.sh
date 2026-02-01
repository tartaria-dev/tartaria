#!/bin/sh
# extra important stuff

set -ouex pipefail

# remove base-devel
pacman -Rns --noconfirm base-devel

# manually add greetd user due to rebase issues
useradd -M -G video,input -s /usr/bin/nologin greeter || true

# add incrond entries
echo "/etc/passwd IN_MODIFY /usr/libexec/subsystem-store-create" | incrontab -

# set plymouth theme
sed -i 's/bgrt/red_loader/g' /usr/share/plymouth/plymouthd.defaults

# disable uupd distrobox updates
sed -i 's|uupd|& --disable-module-distrobox|' /usr/lib/systemd/system/uupd.service

# reconfigure bootc auto update
sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/bootc update --quiet|' /usr/lib/systemd/system/bootc-fetch-apply-updates.service
sed -i 's|^OnUnitInactiveSec=.*|OnUnitInactiveSec=7d\nPersistent=true|' /usr/lib/systemd/system/bootc-fetch-apply-updates.timer

# install default icon theme
git clone https://github.com/vinceliuice/WhiteSur-icon-theme
cd WhiteSur-icon-theme
bash ./install.sh -t grey -n default-icons -d /usr/share/icons
cd ..
rm -rf WhiteSur-icon-theme

# setup bash prompt
echo -e '\neval "$(starship init bash)"\neval "$(atuin init bash)"' >> /etc/bash.bashrc

# set default niri config
install -d /etc/niri/
ln -sT /usr/share/tartaria/cherries/dot_config/niri/config.kdl /etc/niri/config.kdl

# apply gschema overrides
glib-compile-schemas /usr/share/glib-2.0/schemas

echo "::endgroup::"
