#!/bin/sh
# install extra packages

set -ouex pipefail

# install cli tools
pacman -S --noconfirm \
    atuin \
    bash \
    bash-completion \
    curl \
    fastfetch \
    gcc \
    git \
    glibc-locales \
    jq \
    less \
    lsof \
    make \
    man-db \
    nano \
    openssh \
    patchelf \
    powertop \
    rsync \
    starship \
    tar \
    tree \
    unzip \
    nvim \
    wget