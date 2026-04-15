#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

# constants
SUBSYS_ID=$(echo -n "$(cat /etc/machine-id)$USER" | sha256sum | awk '{print $1}')
readonly SUBSYS_ID

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

# tell user we're doing stuff
echo "[---] Starting up..."

# if it exists, clean out the previous failure log
if [[ -f "$HOME/.subsystem-failure" ]]; then
    rm -f "$HOME/.subsystem-failure"
fi

# check if subsystem is active and exec into subsystem, otherwise fail
if [[ "$(systemctl --user is-failed subsystem)" == "activating" ]]; then
    if ! podman exec -u "$(id -u)" -it "subsystem-$SUBSYS_ID" /bin/zsh -c "echo"; then
        cat <<EOF
Oops,

Something went wrong and your subsystem isn't
accessible via an interactive shell right now.
Returning to host shell (bash).

EOF
    else
        podman exec -u "$(id -u)" -it "subsystem-$SUBSYS_ID" /bin/zsh
    fi
else
    journalctl --user --no-pager -lxeu subsystem > "$HOME/.subsystem-failure"
    cat <<EOF
Oops,

Your subsystem has failed to start.
Logs have been stored in ~/.subsystem-failure.
Returning to host shell (bash).

EOF
fi
