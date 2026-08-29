#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

# check if the shell is interactive, if we are in a TTY, or if we are root
if [[ $- != *i* ]]; then
    return
elif [[ "$TERM" == "linux" ]]; then
    echo "Detected TTY, entering host shell."
    return
elif [[ "$EUID" == "0" ]]; then
    echo "Detected root user, entering host shell."
    return
elif [[ "$(cat /proc/cmdline)" == *rd.live.image* ]]; then
    echo "[-i-] Running on a Live ISO."
    echo "[-i-] Subsystem is disabled on Live ISOs. Install to get the full experience."
    return
fi

# hand off control
exec /usr/lib/subsystem/bin/shell
