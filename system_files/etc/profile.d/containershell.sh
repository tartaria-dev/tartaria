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
Changes you make to this environment besides changes to your home
directory will be wiped on system reboot/shutdown and user logout.
Commands relating to container management (distrobox, docker, podman)
are linked into this environment, so they can be run without issue.

To edit startup commands for this environment, run:
nano ~/.config/subsystem/ignition

To suppress this lovely notice, execute:
touch ~/.config/subsystem/suppress-notice

To see how to execute/link/unlink commands from the host, execute:
synergy --help

EOF
}

errmsg() {
    journalctl --user --no-pager -lxeu subsystem > "$HOME/.subsystem-failure"
    cat <<EOF
Oops,

Your containerized environment failed to start.
Logs have been stored in ~/.subsystem-failure.
Don't worry - a reboot should fix things.
For now, here's a regular shell on the host - be careful.

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

# if it exists, clean out the previous failure log
if [[ -f "$HOME/.subsystem-failure" ]]; then
    rm -f "$HOME/.subsystem-failure"
fi

# check if subsystem is active and exec into subsystem, otherwise fail
if [[ "$(systemctl --user is-failed subsystem)" == "active" ]]; then
    first-time
    exec podman exec -u "$(id -u)" -it "subsystem-$SUBSYS_ID" /bin/fish
else
    if ! systemctl --user start subsystem >/dev/null 2>&1; then
        errmsg
        return
    else
        first-time
        exec podman exec -u "$(id -u)" -it "subsystem-$SUBSYS_ID" /bin/fish
    fi
fi
