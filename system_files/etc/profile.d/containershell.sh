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

# constants
SUBSYS_ID=$(echo -n "$(cat /etc/machine-id)$USER" | sha256sum | awk '{print $1}')
readonly SUBSYS_ID

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

To see how to run commands on the host, run the following:
sysexec --help

EOF
}

warn() {
    cat <<EOF
Oops,

We can't start your containerized environment right now.
Don't worry - a reboot should fix things.
For now, here's a regular shell on the host - be careful.

EOF
}

errmsg() {
    systemctl --user status subsystem -l --no-pager > "$HOME/.containershell-failure"
    cat <<EOF
The subsystem has failed to start.
Logs have been stored in $HOME/.containershell-failure.
Entering host shell.
EOF
}

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

# if it doesn't exist, create the configuration dir
if [[ ! -d "$HOME/.config/containershell" ]]; then
    mkdir -p "$HOME/.config/containershell"
fi

# if it exists, clean out the previous failure log
if [[ -f "$HOME/.containershell-failure" ]]; then
    rm -f "$HOME/.containershell-failure"
fi

# check if subsystem is active and exec into subsystem, otherwise fail
if [[ "$(systemctl --user is-failed subsystem)" == "active" ]]; then
    first-time
    exec podman exec -u "$(id -u)" -it "subsystem-$SUBSYS_ID" /bin/fish
else
    if ! systemctl --user start subsystem >/dev/null; then
        errmsg
        return
    else
        first-time
        exec podman exec -u "$(id -u)" -it "subsystem-$SUBSYS_ID" /bin/fish
    fi
fi
