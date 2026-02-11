#!/usr/bin/env bash

echo -e "Initializing.\n"

checkserv() {
    local SERVICE="$1"
    local ACTIVE
    local FAILED
    local ARG=""

    ACTIVE=$(systemctl is-active "$SERVICE" $ARG 2>/dev/null)
    FAILED=$(systemctl is-failed "$SERVICE" $ARG 2>/dev/null)
    
    if [[ "$1" == "-u" ]]; then
        SERVICE="$2"
        ARG="--user"
    fi

    if [[ "$ACTIVE" = "active" ]]; then
        echo "active"
        return
    elif [[ "$ACTIVE" != "active" ]]; then
        echo "inactive"
        return
    elif [[ "$FAILED" = "failed" ]]; then
        echo "failed"
        return
    else
        echo "inactive"
        return
    fi
}

first-time() {
    if [[ -f ~/.config/subsystem/suppress-notice ]]; then
        return
    fi

    echo "Hello there!"
    echo "Your shell is currently running inside a containerized environment."
    echo "Whatever you do inside this environment won't affect your host system."
    echo "Well, besides changes to your home directory - those definitely stick."
    echo "To suppress this lovely notice, please run the following:"
    echo "'touch ~/.config/subsystem/suppress-notice'"
    echo ""
}

MACHINE_ID=$(cat /etc/machine-id)
SUBSYSTEM_STATUS=$(checkserv -u "subsystem-$MACHINE_ID")
readonly MACHINE_ID
readonly SUBSYSTEM_STATUS

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

# check if subsystem store setup has completed
if [[ "$(checkserv subsystem-stores)" != "active" ]]; then
    echo "Subsystem store management has failed to start!"
    echo "Dumping service state."
    systemctl status subsystem-stores --no-pager
    echo "Entering host shell."
    return
fi

# check if subsystem itself is active
if [[ "$SUBSYSTEM_STATUS" == "active" ]]; then
    first-time
    exec podman exec -u "$(id -u)" -it subsystem /bin/fish
elif [[ "$SUBSYSTEM_STATUS" != "active" ]]; then
    if ! systemctl --user start "subsystem-$MACHINE_ID"; then
        echo "Subsystem failed to start!"
        echo "Dumping service state."
        systemctl --user status subsystem --no-pager
        echo "Dropping into host shell."
        return
    else
        first-time
        exec podman exec -u "$(id -u)" -it subsystem /bin/fish
    fi
else
    echo "Subsystem has failed to start/is in an unknown state!"
    echo "Dumping service state."
    systemctl --user status subsystem --no-pager
    echo "Dropping into host shell."
    return
fi
