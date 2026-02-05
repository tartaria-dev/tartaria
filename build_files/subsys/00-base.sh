#!/bin/sh
# prepare base image

echo "::group::===========================> Perform build preparation"

set -oux pipefail

# update base image
pacman -Syuq --noconfirm

echo "::endgroup::"
