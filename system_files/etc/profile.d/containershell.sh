#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

# check if the shell is interactive, if we are in a TTY, or if we are root
if [[ $- != *i* ]]; then
    return
elif [[ "$(cat /proc/cmdline)" == *rd.live.image* ]]; then
    echo "[-i-] Running on a Live ISO."
    echo "[-i-] Subsystem is disabled on Live ISOs. Install to get the full experience."
    return
elif [[ "$TERM" == "linux" ]]; then
    echo "[-i-] Detected TTY, entering host shell."
    return
elif [[ "$EUID" == "0" ]]; then
    echo "[-i-] Detected root user, entering host shell."
    return
fi

# hand off control
exec /usr/lib/subsystem/bin/shell
