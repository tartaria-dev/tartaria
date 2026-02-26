# base image
FROM archlinux:latest

# load in main build/system files
COPY system_files /
COPY build_files /build/

# fetch Brew
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /

# fetch Cherries (our lovely dotfiles)
COPY --from=ghcr.io/tartaria-dev/cherries:latest / /usr/share/tartaria/cherries/

# fetch AUR pkgs for this image build and our subsystem
COPY --from=ghcr.io/tartaria-dev/packages:latest /mainsys/ /packages/
COPY --from=ghcr.io/tartaria-dev/packages:latest /subsys/ /build_files/extra/mkosi.extra/packages/

# run main build scripts
RUN --mount=type=tmpfs,dst=/tmp \
    bash /build/00-base.sh && \
    bash /build/01-packages.sh && \
    bash /build/02-subsystem.sh && \
    bash /build/03-systemd.sh && \
    bash /build/04-extras.sh && \
    bash /build/05-finalize.sh

# proper labeling for bootc images, see https://bootc-dev.github.io/bootc/bootc-images.html#standard-metadata-for-bootc-compatible-images
LABEL containers.bootc=1

# lint bootc image, don't remove
RUN bootc container lint
