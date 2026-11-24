#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-only

### setup

set -oue pipefail

### declare arrays

bases=( "Arch" "CachyOSv3" )
names=("Arch-Saffron" "Arch-Maraska" "CachyOSv3-Saffron" "CachyOSv3-Maraska")
tags=("arch-saffron" "arch-maraska" "cachy-saffron" "cachy-maraska")

### user questions

dl_askbase() {
    while true; do
        echo "[---] ISO Selection"
        echo -e "[---] What base of Tartaria do you want? (enter the corresponding number)\n"

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
}

dl_askshell() {
    while true; do
        echo "[---] ISO Selection"
        echo -e "[---] Do you want Dux Shell or Noctalia? (enter the corresponding number)\n"

        options=( "Dux Shell" "Noctalia" )

        for i in "${!options[@]}"; do
            printf "[-%d-] %s\n" "$((i + 1))" "${options[$i]}"
        done

        echo
        read -n 1 -p "[-?-] >> " shell_answer
    
        if (( shell_answer < 1 || shell_answer > ${#options[@]} )); then
            echo -e "\n[!!!] Invalid choice. Please try again."
            sleep 1
            clear
        else
            break
        fi
    done

    clear
}

### download stuff

dl_depcheck() {
    if ! command -v podman >/dev/null; then
        echo "[!!!] Podman is not installed on this system, please install it."
        exit 1
    fi

    clear
}

dl_initvars() {
    idx=$(( (base_answer - 1) * 2 + (shell_answer - 1) ))
    tag="${tags[$idx]}"
    name="${names[$idx]}"
}

dl_prepare() {
    echo "[1/2] Preparing."

    trap 'dl_clean && echo -e "\n[!!!] Something went wrong during preperation. Please re-run this script."' ERR

    rm -rf "$HOME"/Downloads/tartaria-iso
    mkdir -p "$HOME"/Downloads/tartaria-iso

    podman pull ghcr.io/sigstore/cosign/cosign:v3.1.3
    podman pull ghcr.io/oras-project/oras:v1.3.4

    clear
}

dl_pulliso() {
    echo "[2/2] Downloading ${name} ISO."
    echo "[-i-] Please do not interrupt the download process. This may take a while."

    trap 'dl_clean && echo -e "\n[!!!] ISO did not pass verification. Report this issue immediately."' ERR

    podman run -it --rm ghcr.io/sigstore/cosign/cosign:v3.1.3 verify \
      "ghcr.io/tartaria-dev/tartaria-iso:${tag}" \
      --certificate-identity="https://github.com/tartaria-dev/tartaria/.github/workflows/build-iso.yml@refs/heads/live" \
      --certificate-oidc-issuer="https://token.actions.githubusercontent.com" >/dev/null

    trap 'dl_clean && echo "\n[!!!] ISO failed to download. Check your connection and re-run this script."' ERR

    podman run -it --rm -v "$HOME"/Downloads/tartaria-iso:/workspace ghcr.io/oras-project/oras:v1.3.4 \
        pull "ghcr.io/tartaria-dev/tartaria-iso:${tag}"

    mv "$HOME"/Downloads/tartaria-iso/iso/tartaria-${tag}.iso "$HOME"/Downloads/tartaria-iso/tartaria.iso
    rmdir "$HOME"/Downloads/tartaria-iso/iso

    dl_clean

    clear
}

dl_clean() {
    podman rmi -fi ghcr.io/sigstore/cosign/cosign:v3.1.3
    podman rmi -fi ghcr.io/oras-project/oras:v1.3.4

    trap - ERR
}

### main logic

main() {
    dl_depcheck
    
    dl_askbase
    dl_askshell

    dl_initvars
    dl_prepare
    dl_pulliso

    echo "[-i-] Success!"
    echo "[-i-] Your downloaded ISO is located at '$HOME/Downloads/tartaria-iso/tartaria.iso'."
}

main
