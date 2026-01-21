# base image
FROM docker.io/cachyos/cachyos-v3:latest

RUN echo "::group::===========================> Perform image build preperation"

# load in main build/system files
COPY system_files /
COPY build_files /build/

# fetch Brew
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /

# fetch Cherries and fetch precompiled AUR packages
COPY --from=ghcr.io/tartaria-dev/packages:latest /system_files/ /packages/
COPY --from=ghcr.io/tartaria-dev/cherries:latest /system_files/ /usr/share/tartaria/cherries/

# tell dracut to not preserve xattrs for initramfs creation
ENV DRACUT_NO_XATTR=1

# move everything from `/var` to `/usr/lib/sysimage` so behavior around pacman remains the same on `bootc usroverlay`'d systems
RUN grep "= */var" /etc/pacman.conf | sed "/= *\/var/s/.*=// ; s/ //" | xargs -n1 sh -c 'mkdir -p "/usr/lib/sysimage/$(dirname $(echo $1 | sed "s@/var/@@"))" && mv -v "$1" "/usr/lib/sysimage/$(echo "$1" | sed "s@/var/@@")"' '' && \
    sed -i -e "/= *\/var/ s/^#//" -e "s@= */var@= /usr/lib/sysimage@g" -e "/DownloadUser/d" /etc/pacman.conf

# run main build scripts
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    sh /build/00-base.sh && \
    sh /build/01-main-pkgs.sh && \
    sh /build/02-aur-pkgs.sh && \
    sh /build/03-systemd.sh && \
    sh /build/04-subsystem.sh && \
    sh /build/05-extras.sh

# generate initramfs with dracut
RUN printf "systemdsystemconfdir=/etc/systemd/system\nsystemdsystemunitdir=/usr/lib/systemd/system\n" | tee /usr/lib/dracut/dracut.conf.d/30-bootcrew-fix-bootc-module.conf && \
    printf 'hostonly=no\nadd_dracutmodules+=" ostree bootc "' | tee /usr/lib/dracut/dracut.conf.d/30-bootcrew-bootc-modules.conf && \
    sh -c 'export KERNEL_VERSION="$(basename "$(find /usr/lib/modules -maxdepth 1 -type d | grep -v -E "*.img" | tail -n 1)")" && \
    dracut --force --no-hostonly --reproducible --zstd --verbose --kver "$KERNEL_VERSION"  "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"' && \
    echo "::endgroup::" && echo "::group::===========================> Perform fs organization"

# arrange filesystem into a format expected by bootc and image-based systems, see https://bootc-dev.github.io/bootc/filesystem.html
RUN sed -i 's|^HOME=.*|HOME=/var/home|' "/etc/default/useradd" && \
    rm -rf /boot /tmp/* /home /root /usr/local /srv /mnt /var /usr/opt /build /packages /usr/lib/sysimage/log /usr/lib/sysimage/cache/pacman/pkg && \
    mv /opt /usr/ && mkdir -p /sysroot /boot /usr/lib/ostree /var && \
    ln -sT sysroot/ostree /ostree && ln -sT var/roothome /root && ln -sT var/srv /srv && ln -sT var/mnt /mnt && ln -sT var/opt /opt && ln -sT var/home /home && ln -sT ../var/usrlocal /usr/local && \
    echo "::endgroup::"

# proper labeling for bootc images, see https://bootc-dev.github.io/bootc/bootc-images.html#standard-metadata-for-bootc-compatible-images
LABEL containers.bootc=1

# lint bootc image, don't remove
RUN bootc container lint
