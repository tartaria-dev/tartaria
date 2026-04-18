#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only

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

# hand off control
exec /usr/lib/subsystem/bin/shell
