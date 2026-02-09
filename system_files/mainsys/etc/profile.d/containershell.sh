#!/usr/bin/env bash

checkserv() {
    if [[ "$1" == "-u"; then ]];
        local SERVICE="$2"
        local ARG="--user"
    else
        local SERVICE="$1"
        local ARG=""
    fi

    local ACTIVE=$(systemctl is-active "$SERVICE" $ARG 2>/dev/null)

    if [ "$ACTIVE" = "active" ]; then
        echo "active"
    elif [ "$ACTIVE" = "inactive" ]; then
        FAILED=$(systemctl is-failed "$SERVICE" $ARG 2>/dev/null)
        if [ "$FAILED" = "failed" ]; then
            echo "failed"
        else
            echo "inactive"
        fi
    else
        echo "state unknown"
    fi
}

if [[ $- == *i* ]]; then
    if [[ "$TERM" == "linux" ]]; then
        echo "Detetcted TTY, entering host shell."
    else
        if [[ "$EUID" != "0" ]]; then
            if [[ "$(checkserv subsystem-stores)" == "active" ]]; then
                if [[ "$(checkserv -u subsystem)" == "active" ]];
                    podman exec -u $(id -u) -it subsystem /bin/fish
                elif [[ "$(checkserv -u subsystem)" == "inactive" ]]; then
                    systemctl --user start subsystem
                    [[ "$?" != "0" ]] && echo "Subsystem failed to start!" && echo "Dropping into host shell." && exec /usr/bin/sh
                else
                    echo "Subsystem failed to start!"
                    echo "Dropping into local shell."
                    exec /usr/bin/sh
                fi
            else
                echo "Subsystem store management has failed to start!"
                echo "Dumping service state."
                systemctl status subsystem-stores --no-pager
                echo "Entering host shell."
                exec /usr/bin/sh
            fi
        else
            echo "Detected root user, entering host shell."
        fi
    fi
fi

unset checkserv