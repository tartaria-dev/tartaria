#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

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
Changes you make besides those to your homedir won't affect the host.
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
    errmsg
fi
