#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-only

# once upon a time
set -oue pipefail

# clear term
clear

# define variants and their tags
bases=( "Arch" "CachyOSv3" )
tags=("arch-saffron" "arch-mahleb" "cachy-saffron" "cachy-mahleb")
names=("Arch-Saffron" "Arch-Mahleb" "CachyOSv3-Saffron" "CachyOSv3-Mahleb")

# define clanup step
cleanup() {
    podman rmi -fi ghcr.io/sigstore/cosign/cosign:v3.1.3
    podman rmi -fi ghcr.io/oras-project/oras:v1.3.4
    trap - ERR
}

# read user answer (base selection)
while true; do
    echo "[---] ISO Selection"
    echo "[---] What base of Tartaria do you want? (enter the corresponding number)"
    echo
    for i in "${!bases[@]}"; do
        printf "[-%d-] %s\n" "$((i + 1))" "${bases[$i]}"
    done
    echo
    read -n 1 -p "[-?-] >> " base_answer

    if (( base_answer < 1 || base_answer > ${#bases[@]} )); then
        echo -e "\n[!!!] Invalid choice. Please try again."
        sleep 1
        clear
    else
        break
    fi
done
clear

# read user answer (NVIDIA drivers)
while true; do
    echo "[---] ISO Selection"
    echo "[---] Do you need preinstalled NVIDIA drivers? (enter the corresponding number)"
    echo
    options=( "Yes" "No" )
    for i in "${!options[@]}"; do
        printf "[-%d-] %s\n" "$((i + 1))" "${options[$i]}"
    done
    echo
    read -n 1 -p "[-?-] >> " nvidia_answer

    if (( nvidia_answer < 1 || nvidia_answer > ${#options[@]} )); then
        echo -e "\n[!!!] Invalid choice. Please try again."
        sleep 1
        clear
    else
        break
    fi
done
clear

# prepare download dir & pull images
echo "[1/2] Preparing."
trap 'cleanup && echo && echo "[!!!] Something went wrong during preperation. Please re-run this script."' ERR
rm -rf "$HOME"/Downloads/tartaria-iso
mkdir -p "$HOME"/Downloads/tartaria-iso
podman pull ghcr.io/sigstore/cosign/cosign:v3.1.3
podman pull ghcr.io/oras-project/oras:v1.3.4
clear

# download iso
idx=$(( (base_answer - 1) * 2 + (nvidia_answer - 1) ))
tag="${tags[$idx]}"
name="${names[$idx]}"

echo "[2/2] Downloading ${name} ISO."
echo "[-i-] Please do not interrupt the download process. This may take a while."
trap 'cleanup && echo && echo "[!!!] ISO did not pass verification. Report this issue immediately."' ERR
podman run -it --rm ghcr.io/sigstore/cosign/cosign:v3.1.3 verify \
  "ghcr.io/tartaria-dev/tartaria-iso:${tag}" \
  --certificate-identity="https://github.com/tartaria-dev/tartaria/.github/workflows/build-iso.yml@refs/heads/live" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" >/dev/null
trap 'cleanup && echo && echo "[!!!] ISO failed to download. Check your connection and re-run this script."' ERR
podman run -it --rm -v "$HOME"/Downloads/tartaria-iso:/workspace ghcr.io/oras-project/oras:v1.3.4 \
    pull "ghcr.io/tartaria-dev/tartaria-iso:${tag}"
mv "$HOME"/Downloads/tartaria-iso/iso/tartaria-${tag}.iso "$HOME"/Downloads/tartaria-iso/tartaria.iso
rmdir "$HOME"/Downloads/tartaria-iso/iso

# cleanup
echo "[---] Cleaning up."
cleanup
clear

# finalize
echo "[-i-] Success!"
echo "[-i-] Your downloaded ISO is located at '$HOME/Downloads/tartaria-iso/tartaria.iso'."