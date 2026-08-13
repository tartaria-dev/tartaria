#!/usr/bin/env bash
# install system apps

echo "::group::===========================> Install system apps"

set -ouex pipefail

# create sysapp dirs
mkdir -p /usr/lib/flatpak-sysapps/dsk-src

# store flatpaks
# !!! package list also present in workflow files & install-flatpak-sysapps.service, modify those aswell if you modify the one below
flatpak create-usb --installation=sysapps /usr/lib/flatpak-sysapps/dsk-src app.zen_browser.zen org.kde.ark org.gnome.baobab org.gnome.Decibels org.gnome.Calculator org.gnome.Calendar org.gnome.Music org.gnome.TextEditor org.gnome.Weather io.gitlab.adhami3310.Impression org.gnome.Loupe io.missioncenter.MissionCenter org.gnome.Papers org.gnome.World.Secrets org.gnome.Showtime org.mozilla.thunderbird >/dev/null
mkfs.erofs -zzstd,12 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L sysapps /usr/lib/flatpak-sysapps/flatpak-sysapps.dsk /usr/lib/flatpak-sysapps/dsk-src >/dev/null

# cleanup
rm -rf /usr/lib/flatpak-sysapps/dsk-src /etc/flatpak/

echo "::endgroup::"
