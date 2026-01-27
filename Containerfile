# base image
FROM docker.io/cachyos/cachyos-v3:latest

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

# run main build scripts
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    sh /build/00-base.sh && \
    sh /build/01-main-pkgs.sh && \
    sh /build/02-aur-pkgs.sh && \
    sh /build/03-subsystem.sh && \
    sh /build/04-systemd.sh && \
    sh /build/05-extras.sh && \
    sh /build/06-finalize.sh

# proper labeling for bootc images, see https://bootc-dev.github.io/bootc/bootc-images.html#standard-metadata-for-bootc-compatible-images
LABEL containers.bootc=1

# lint bootc image, don't remove
RUN bootc container lint
