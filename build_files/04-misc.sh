#!/bin/sh
# miscellaneous stuff

echo "::group::===========================> Miscellaneous tasks"

set -ouex pipefail

# manually add greetd user due to rebase issues
useradd -M -G video,input -s /usr/bin/nologin greeter || true

# generate static Inter font weights for initramfs
mkdir -p /usr/share/fonts/inter-static
python /ctx/extra/generate-static-inter-fonts.py

# enable ntsync
echo -e 'ntsync' > /etc/modules-load.d/ntsync.conf

# enable bbr3
echo -e 'net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr' > /etc/sysctl.d/99-bbr3.conf

# setup zram
echo -e '[zram0]\nzram-size = min(ram, 8192)\ncompression-algorithm = zstd\nswap-priority = 100' > /usr/lib/systemd/zram-generator.conf
echo "vm.swappiness=10" > /etc/sysctl.d/99-zram-mem.conf
echo 'w /sys/module/zswap/parameters/enabled - - - - 0' > /etc/tmpfiles.d/disable-zswap.conf

# setup systemd-resolved
echo -e 'enable systemd-resolved.service' > /usr/lib/systemd/system-preset/91-resolved-default.preset
echo -e 'L+ /etc/resolv.conf - - - - ../run/systemd/resolve/stub-resolv.conf' > /usr/lib/tmpfiles.d/resolved-default.conf
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

echo "::endgroup::"
