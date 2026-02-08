#!/usr/bin/env bash

if [[ $- == *i* ]]; then
    if [[ "$TERM" == "linux" ]]; then
        echo "Detetcted TTY, entering host shell."
    else
        if [[ "$EUID" != "0" ]]; then
            pkexec /usr/libexec/enter-subsystem "$(id -u)"
        else
            echo "Detected root user, entering host shell."
        fi
    fi
fi