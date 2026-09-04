#!/usr/bin/env bash
# sign NVIDIA kernel modules (-saffron)

echo "::group::===========================> Sign NVIDIA modules"

# setup
source /build/conf/00-functions
set -ouex pipefail

# if image spice is not saffron, skip
if [[ "$IMAGE_FLAVOR" != *saffron ]]; then
    echo "Skipping, image spice is not 'saffron'."
    exit 0
fi

# set kernel version
KERNEL_VERSION="$(basename "$(find /usr/lib/modules -maxdepth 1 -type d | grep -v -E "\.img$" | tail -n 1)")"

# define headers package
case "$IMAGE_FLAVOR" in
    arch*)  
        headers="linux-headers"
        ;;
    cachy*)
        headers="linux-cachyos-headers"
        ;;
esac

# install headers
retry pacman -S --noconfirm --needed "$headers"

# sign nvidia kernel modules
while IFS= read -r -d '' mod; do
    orig="$mod"
    case "$mod" in
        *.zst) zstd -d --rm "$mod"; mod="${mod%.zst}" ;;
        *.xz)  xz -d --rm "$mod";   mod="${mod%.xz}" ;;
    esac

    /usr/lib/modules/${KERNEL_VERSION}/build/scripts/sign-file sha256 /run/secrets/module_key /run/secrets/module_cert "$mod"

    case "$orig" in
        *.zst) zstd --rm "$mod" ;;
        *.xz)  xz --rm "$mod" ;;
    esac
done < <(find "/usr/lib/modules/${KERNEL_VERSION}" -name 'nvidia*.ko*' -print0)

# remove headers
pacman -Rns --noconfirm "$headers"

# regenerate initramfs with dracut
DRACUT_NO_XATTR=1 dracut --force --no-hostonly --reproducible --zstd --verbose --kver "$KERNEL_VERSION" --add-drivers "nvidia nvidia_modeset nvidia_uvm nvidia_drm" "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"

# export DER copy into the rootfs so it is inherited by split -> final
mkdir -p /usr/share/tartaria/certs
openssl x509 -in /run/secrets/module_cert -outform DER -out /usr/share/tartaria/certs/modules.der

echo "::endgroup::"
