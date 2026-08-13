#!/usr/bin/env bash
# install system apps

echo "::group::===========================> Install system apps"

set -ouex pipefail

# define sysapps to install
declare -a sysapps=(
    app.zen_browser.zen
    org.kde.ark
    org.gnome.baobab
    org.gnome.Decibels
    org.gnome.Calculator
    org.gnome.Calendar
    org.gnome.Music
    org.gnome.TextEditor
    org.gnome.Weather
    io.gitlab.adhami3310.Impression
    org.gnome.Loupe
    io.missioncenter.MissionCenter
    org.gnome.Papers
    org.gnome.World.Secrets
    org.gnome.Showtime
    org.mozilla.thunderbird
)

# create sysapp dirs
mkdir -p /tmp/sysapps /usr/lib/flatpak-sysapps{,dsk-src}

# download flatpaks
flatpak remote-add --installation=sysapps --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install --installation=sysapps -y flathub "${sysapps[@]}" >/dev/null

# store flatpaks
flatpak create-usb --installation=sysapps /usr/lib/flatpak-sysapps/dsk-src "${sysapps[@]}" >/dev/null
mkfs.erofs -zzstd,12 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L sysapps /usr/lib/flatpak-sysapps/flatpak-sysapps.dsk /usr/lib/flatpak-sysapps/dsk-src >/dev/null

# cleanup
rm -rf /usr/lib/flatpak-sysapps/dsk-src /etc/flatpak/

echo "::endgroup::"
