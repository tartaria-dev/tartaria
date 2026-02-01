#!/bin/bash
# subsystem postinstall script

# install packages from host
pacman -U /packages/*.pkg.tar.zst --noconfirm
