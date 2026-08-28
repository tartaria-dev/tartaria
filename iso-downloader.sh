#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-only

# once upon a time
set -oue pipefail

# clear term
clear

# read user answer
while true; do
    echo "[---] ISO Selection"
    echo "[---] Select an ISO to download (enter the corresponding number)."
    echo "[---] The base you choose here will serve as the base to install when starting the install process, regardless of what spice you select on the image selection page in the installer."
    echo "[---] If you don't know the meaning of 'base' or 'spice' as used here, please go back to the Tartaria GitHub repo and read the 'Variants' section of the README."
    echo -e "\n[-1-] Arch-based ISO"
    echo -e "[-2-] CachyOSv3-based ISO\n"
    read -n 1 -p "[-?-] >> " answer

    if [[ $answer != "1" && $answer != "2" ]]; then
        echo -e "\n[!!!] Invalid choice. Please try again."
        sleep 2
        clear
    else
        break
    fi
done
clear

# prepare download and pull oras container
echo "[1/2] Preparing."
rm -rf "$HOME"/Downloads/tartaria-iso
mkdir -p "$HOME"/Downloads/tartaria-iso
podman pull ghcr.io/oras-project/oras:main
clear

# download iso
if [[ "$answer" == "1" ]]; then
    echo "[2/2] Downloading Arch-based ISO."
    echo "[-i-] Please do not interrupt the download process. This may take a while."
    podman run -it --rm -v "$HOME"/Downloads/tartaria-iso:/workspace ghcr.io/oras-project/oras:main pull ghcr.io/tartaria-dev/tartaria-iso:stable-arch-berbere
    mv "$HOME"/Downloads/tartaria-iso/iso/tartaria-stable-arch.iso "$HOME"/Downloads/tartaria-iso/tartaria.iso
    rmdir "$HOME"/Downloads/tartaria-iso/iso
elif [[ "$answer" == "2" ]]; then
    echo "[2/2] Downloading CachyOSv3-based ISO."
    echo "[-i-] Please do not interrupt the download process. This may take a while."
    podman run -it --rm -v "$HOME"/Downloads/tartaria-iso:/workspace ghcr.io/oras-project/oras:main pull ghcr.io/tartaria-dev/tartaria-iso:stable-cachy-berbere
    mv "$HOME"/Downloads/tartaria-iso/iso/tartaria-stable-cachy.iso "$HOME"/Downloads/tartaria-iso/tartaria.iso
    rmdir "$HOME"/Downloads/tartaria-iso/iso
fi

# cleanup
echo "[---] Cleaning up."
podman rmi ghcr.io/oras-project/oras:main
clear

# finalize
echo "[-i-] Success!"
echo "[-i-] Your downloaded ISO is located at '$HOME/Downloads/tartaria-iso/tartaria.iso'."