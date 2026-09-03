#!/usr/bin/env bash
# extra important stuff

# setup
source /build/conf/00-functions
set -ouex pipefail

# preconfigure basic system settings
echo "uninitialized" > /etc/machine-id
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# re-enable pacman network sandbox
sed -i '/DisableSandboxNetwork/d' /etc/pacman.conf

# set correct permissions on polkit rules dir
chmod 750 /etc/polkit-1/rules.d
chown -R root:polkitd /etc/polkit-1/rules.d

# remove base-devel
pacman -Rns --noconfirm base-devel cmake extra-cmake-modules

# fix ttys not starting correctly
ln -sT /usr/lib/systemd/system/getty@.service /usr/lib/systemd/system/autovt@.service

# configure useradd defaults
sed -i 's|^HOME=.*|HOME=/var/home|' "/etc/default/useradd"

# set plymouth theme
sed -i 's/bgrt/tartaria/g' /usr/share/plymouth/plymouthd.defaults

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
bash ./MacTahoe-icon-theme/install.sh -t grey -n default-icons -d /usr/share/icons
rm -rf MacTahoe-icon-theme

# set default niri config
install -d /etc/niri/
ln -sT /usr/share/tartaria/cherries/dot_config/niri/config.kdl /etc/niri/config.kdl

# apply gschema overrides
glib-compile-schemas /usr/share/glib-2.0/schemas

# hide some desktop entries
sed -i '/^NoDisplay=/d;$aNoDisplay=true' /usr/share/applications/{avahi-discover,bssh,bvnc,lstopo,org.ffado.FfadoMixer,tuned-gui,assistant,designer,linguist,mpv,qdbusviewer,qv4l2,qvidcap,vim}.desktop
update-desktop-database

# move /opt into /usr so it gets preserved
rm -rf /usr/opt
mv /opt /usr

# add nvidia-drm modprobe config for saffron/amchoor
if [[ "$IMAGE_VARIANT" == *saffron || "$IMAGE_VARIANT" == *amchoor ]]; then
    mkdir -p /etc/modprobe.d
    echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia.conf
fi

echo "::endgroup::"
