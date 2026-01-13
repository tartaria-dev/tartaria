#!/bin/sh
# prepare base image

set -ouex pipefail

# update base image
pacman -Syu --noconfirm

# add base packages
pacman -S --noconfirm \
    base \
    base-devel
