#!/usr/bin/env bash

# SPDX-License-Identifier: GPL-3.0-only
#
# This file is part of the Tartaria project:
#    https://github.com/tartaria-dev/tartaria
#
# Copyright (C) 2026 Tartaria Developers
#
# Tartaria is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3
# as published by the Free Software Foundation.
#
# Tartaria is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Tartaria; if not, see <http://www.gnu.org/licenses/>.

# utilities
first-time() {
    if [[ -f ~/.config/subsystem/suppress-notice ]]; then
        return
    fi

    cat <<EOF
Hello there!

Your shell is currently running inside a containerized environment.
Whatever you do inside this environment won't affect your host system.
Well, besides changes to your home directory - those definitely stick.

To suppress this lovely notice, please run the following:
touch ~/.config/containershell/suppress-notice

To run commands on the host, run the following:
sysexec (--root) [COMMAND]

The following commands are available in this environment and execute on the host:
"ostree", "bootc", "podman", "distrobox", "docker"

EOF
}

warn() {
    cat <<EOF
Hello there!

Your shell has not been fully set up yet. How unfortunate!
Don't worry, just reboot and your shell will be all nice and fancy for you.

For now, you will be dropped into a shell on the host.
Please be aware that your actions can damage your system.

EOF
}

errmsg() {
    if [[ "$1" == "store" ]]; then
        local subject="Subsystem store management"
        systemctl status subsystem-stores -l --no-pager > "$HOME/.containershell-failure"
    elif [[ "$1" == "subsystem" ]]; then
        local subject="Subsystem"
        systemctl --user status "subsystem-$MACHINE_ID" -l --no-pager > "$HOME/.containershell-failure"
    fi
    cat <<EOF
$subject has failed to start.
Logs have been stored in $HOME/.containershell-failure.
Entering host shell.
EOF
}

# constants
MACHINE_ID=$(cat /etc/machine-id)
SUBSYSTEM_STATUS=$(systemctl --user is-failed "subsystem-$MACHINE_ID")
STORE_STATUS=$(systemctl is-failed subsystem-stores)
STORE="/var/lib/subsystem/$USER"
readonly MACHINE_ID
readonly SUBSYSTEM_STATUS
readonly STORE_STATUS
readonly STORE

# check if the shell is interactive, if we are in a TTY, or if we are root
if [[ $- != *i* ]]; then
    return
elif [[ "$TERM" == "linux" ]]; then
    echo "Detetcted TTY, entering host shell."
    return
elif [[ "$EUID" == "0" ]]; then
    echo "Detected root user, entering host shell."
    return
fi

# if it exists, clean out the previous failure log
if [[ -f "$HOME/.containershell-failure" ]]; then
    rm -f "$HOME/.containershell-failure"
fi

# check if subsystem store setup has properly completed, fail if it hasn't
if [[ "$STORE_STATUS" != "active" ]]; then
    errmsg store
    return  
elif [[ ! -d "/var/lib/subsystem/$USER" ]]; then
    warn
    return
elif ! findmnt "$STORE/.base" >/dev/null || ! findmnt "$STORE/store" >/dev/null; then
    errmsg store
    return
fi

# check if subsystem is active and exec into subsystem, otherwise fail
if [[ "$SUBSYSTEM_STATUS" == "active" ]]; then
    first-time
    exec podman exec -it subsystem /bin/fish
else
    if ! systemctl --user start "subsystem-$MACHINE_ID" >/dev/null; then
        errmsg subsystem
        return
    else
        first-time
        exec podman exec -it subsystem /bin/fish
    fi
fi
