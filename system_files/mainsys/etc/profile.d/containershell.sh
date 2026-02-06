#!/usr/bin/env bash

if [[ $- == *i* ]]; then
    if [[ "$TERM" == "linux" ]]; then
        echo "Detetcted TTY, entering host shell."
    else
        if [[ "$EUID" != "0" ]]; then
            if [[ -z $(distrobox ls | grep subsystem) ]]; then
                distrobox-create -i subsystem:latest -n subsystem --hostname subsystem -Y
                exec distrobox-enter subsystem
            else
                exec distrobox-enter subsystem
            fi
        else
            echo "Detected root user, entering host shell."
        fi
    fi
fi