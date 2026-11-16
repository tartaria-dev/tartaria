#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-only

### once upon a time
set -oue pipefail

### declare arrays
BASES=( "Arch" "CachyOSv3" )
NAMES=("Arch-Saffron" "Arch-Maraska" "CachyOSv3-Saffron" "CachyOSv3-Maraska")
TAGS=("arch-saffron" "arch-maraska" "cachy-saffron" "cachy-maraska")

### dep check

dl_dep() {
    if ! command -v podman >/dev/null; then
        echo "[!!!] Podman is not installed on this system, please install it."
        exit 1
    fi
}

### user questions

dl_q1() {
    while true; do
        echo "[---] ISO Selection"
        echo -e "[---] What base of Tartaria do you want? (enter the corresponding number)\n"

        for i in "${!BASES[@]}"; do
            printf "[-%d-] %s\n" "$((i + 1))" "${BASES[$i]}"
        done

        echo
        read -n 1 -p "[-?-] >> " base_answer
    
        if (( base_answer < 1 || base_answer > ${#BASES[@]} )); then
            echo -e "\n[!!!] Invalid choice. Please try again."
            sleep 1
            clear
        else
            break
        fi
    done
}

dl_q2() {
    while true; do
        echo "[---] ISO Selection"
        echo -e "[---] Which shell would you like? (enter the corresponding number)\n"

        options=( "Dux Shell" "Noctalia Shell" )

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
}

### download steps

dl_s0() {
    IDX=$(( (base_answer - 1) * 2 + (shell_answer - 1) ))
    TAG="${TAGS[$IDX]}"
    NAME="${NAMES[$IDX]}"
}

dl_s1() {
    echo "[1/2] Preparing."

    trap 'dl_clean && echo && echo "[!!!] Something went wrong during preperation. Please re-run this script."' ERR

    rm -rf "$HOME"/Downloads/tartaria-iso
    mkdir -p "$HOME"/Downloads/tartaria-iso

    podman pull ghcr.io/sigstore/cosign/cosign:v3.1.3
    podman pull ghcr.io/oras-project/oras:v1.3.4
}

dl_s2() {
    echo "[2/2] Downloading ${NAME} ISO."
    echo "[-i-] Please do not interrupt the download process. This may take a while."

    trap 'dl_clean && echo && echo "[!!!] ISO did not pass verification. Report this issue immediately."' ERR

    podman run -it --rm ghcr.io/sigstore/cosign/cosign:v3.1.3 verify \
      "ghcr.io/tartaria-dev/tartaria-iso:${TAG}" \
      --certificate-identity="https://github.com/tartaria-dev/tartaria/.github/workflows/build-iso.yml@refs/heads/live" \
      --certificate-oidc-issuer="https://token.actions.githubusercontent.com" >/dev/null

    trap 'dl_clean && echo && echo "[!!!] ISO failed to download. Check your connection and re-run this script."' ERR

    podman run -it --rm -v "$HOME"/Downloads/tartaria-iso:/workspace ghcr.io/oras-project/oras:v1.3.4 \
        pull "ghcr.io/tartaria-dev/tartaria-iso:${TAG}"

    mv "$HOME"/Downloads/tartaria-iso/iso/tartaria-${TAG}.iso "$HOME"/Downloads/tartaria-iso/tartaria.iso
    rmdir "$HOME"/Downloads/tartaria-iso/iso

    dl_clean
}

dl_clean() {
    podman rmi -fi ghcr.io/sigstore/cosign/cosign:v3.1.3
    podman rmi -fi ghcr.io/oras-project/oras:v1.3.4

    trap - ERR
}

### main logic

main() {
    dl_dep
    clear
    
    dl_q1
    clear

    dl_q2
    clear

    dl_s0

    dl_s1
    clear

    dl_s2
    clear

    echo "[-i-] Success!"
    echo "[-i-] Your downloaded ISO is located at '$HOME/Downloads/tartaria-iso/tartaria.iso'."
}

main
