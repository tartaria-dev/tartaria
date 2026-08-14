#!/usr/bin/env bash
# commands for installing system apps (flatpaks)

echo "::group::===========================> Install system apps"

set -ouex pipefail

# define apps to install
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
) # note: package list also present in install-flatpak-sysapps.service

# add flathub remote and install pkgs
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install --no-deploy -y flathub "${sysapps[@]}" >/dev/null

# create flatpak repo
mkdir -p /sysapps
flatpak create-usb /sysapps "${sysapps[@]}" >/dev/null

# compress flatpak repo
mkdir -p /usr/lib/flatpak-sysapps
mkfs.erofs -zzstd,9 -C 65536 -E all-fragments,dedupe,fragdedupe=inode -L sysapps /usr/lib/flatpak-sysapps/flatpak-sysapps.dsk /sysapps >/dev/null

# cleanup
rm -rf /sysapps

echo "::endgroup::"
