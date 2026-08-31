#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-only

# once upon a time
set -oue pipefail

# clear term
clear

# define variants and their tags
variant_names=("Arch-Bebere" "Arch-Amchoor" "Arch-Mahleb" "Arch-Saffron" "CachyOSv3-Bebere" "CachyOSv3-Amchoor" "CachyOSv3-Mahleb" "CachyOSv3-Saffron")
variant_tags=("stable-arch-berbere" "stable-arch-amchoor" "stable-arch-mahleb" "stable-arch-saffron" "stable-cachy-berbere" "stable-cachy-amchoor" "stable-cachy-mahleb" "stable-cachy-saffron")

# read user answer
while true; do
    echo "[---] ISO Selection"
    echo "[---] Select a variant of Tartaria to download (enter the corresponding number)."
    echo "[---] The variant you choose for the ISO will be the one installed."
    echo "[---] If you do not know what variant to choose, reread the Variants section of the README in the Tartaria github repo."
    echo
    for i in "${!variant_names[@]}"; do
        printf "[-%d-] %s\n" "$((i + 1))" "${variant_names[$i]}"
    done
    echo
    read -n 1 -p "[-?-] >> " answer

    if (( answer < 1 || answer > ${#variant_names[@]} )); then
        echo -e "\n[!!!] Invalid choice. Please try again."
        sleep 1
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
idx=$((answer - 1))
tag="${variant_tags[$idx]}"
name="${variant_names[$idx]}"

echo "[2/2] Downloading ${name} ISO."
echo "[-i-] Please do not interrupt the download process. This may take a while."
podman run -it --rm -v "$HOME"/Downloads/tartaria-iso:/workspace ghcr.io/oras-project/oras:main \
    pull "ghcr.io/tartaria-dev/tartaria-iso:${tag}"
mv "$HOME"/Downloads/tartaria-iso/iso/tartaria-${tag}.iso "$HOME"/Downloads/tartaria-iso/tartaria.iso
rmdir "$HOME"/Downloads/tartaria-iso/iso

# cleanup
echo "[---] Cleaning up."
podman rmi ghcr.io/oras-project/oras:main
clear

# finalize
echo "[-i-] Success!"
echo "[-i-] Your downloaded ISO is located at '$HOME/Downloads/tartaria-iso/tartaria.iso'."