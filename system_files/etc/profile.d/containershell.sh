#!/usr/bin/env bash

checkserv() {
    local SERVICE="$1"
    local ACTIVE
    local FAILED
    local ARG=""

    ACTIVE=$(systemctl is-active "$SERVICE" "$ARG" 2>/dev/null)
    FAILED=$(systemctl is-failed "$SERVICE" "$ARG" 2>/dev/null)
    
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

    cat <<EOF
Hello there!

Your shell is currently running inside a containerized environment.
Whatever you do inside this environment won't affect your host system.
Well, besides changes to your home directory - those definitely stick.

To suppress this lovely notice, please run the following:"
'touch ~/.config/subsystem/suppress-notice'"

To access basic system management utilities, run 'tart'.

EOF
}

warn() {
    cat <<EOF
Hello there!

Your shell has not been fully set up yet. How unfortunate!
Don't worry, just reboot and your shell will be all nice and fancy for you.

For now, you will be dropped into a shell on the host.
Please be aware that your actions can damage your system.

EOF
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
    echo "Oops, subsystem store management has failed to start!"
    echo "Dumping store management state."
    systemctl status subsystem-stores --no-pager
    echo "Entering host shell."
    return
fi

# check if we have a subsystem store set up
if [[ ! -d "/var/lib/subsystem/$USER" ]]; then
    warn
    return
fi

# check if subsystem itself is active
if [[ "$SUBSYSTEM_STATUS" == "active" ]]; then
    first-time
    exec podman exec -u "$(id -u)" -it subsystem /bin/fish
elif [[ "$SUBSYSTEM_STATUS" != "active" ]]; then
    if ! systemctl --user start "subsystem-$MACHINE_ID"; then
        echo "Oops, your subsystem failed to start!"
        echo "Dumping subsystem state."
        systemctl --user status subsystem --no-pager
        echo "Entering host shell."
        return
    else
        first-time
        exec podman exec -u "$(id -u)" -it subsystem /bin/fish
    fi
else
    echo "Oops, your subsystem has failed to start/is in an unknown state!"
    echo "Dumping subsystem state."
    systemctl --user status subsystem --no-pager
    echo "Entering host shell."
    return
fi
