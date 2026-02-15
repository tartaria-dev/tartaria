# base image for main image
FROM archlinux:latest

# load in main build/system files
COPY system_files /
COPY build_files /build/

# fetch Brew
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /

# fetch Cherries precompiled AUR packages
COPY --from=ghcr.io/tartaria-dev/packages:latest /system_files/ /packages/
COPY --from=ghcr.io/tartaria-dev/cherries:latest /system_files/ /usr/share/tartaria/cherries/

# run main build scripts
RUN --mount=type=tmpfs,dst=/tmp \
    bash /build/00-base.sh && \
    bash /build/01-main-pkgs.sh && \
    bash /build/02-aur-pkgs.sh && \
    bash /build/03-subsystem.sh && \
    bash /build/04-systemd.sh && \
    bash /build/05-extras.sh && \
    bash /build/06-finalize.sh

# proper labeling for bootc images, see https://bootc-dev.github.io/bootc/bootc-images.html#standard-metadata-for-bootc-compatible-images
LABEL containers.bootc=1

# lint bootc image, don't remove
RUN bootc container lint
