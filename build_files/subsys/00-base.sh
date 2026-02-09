#!/bin/sh
# prepare base image

echo "::group::===========================> Perform build preparation"

set -ouex pipefail

# update base image
pacman -Syuq --noconfirm

echo "::endgroup::"
