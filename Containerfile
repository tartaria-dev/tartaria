# chunky
ARG CHUNKAH_CONFIG_STR

# base image
FROM archlinux:latest

# load in main build/system files
COPY system_files /
COPY build_files /build/

# fetch Brew, Cherries (our lovely dotfiles), and our AUR pkgs
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /
COPY --from=ghcr.io/tartaria-dev/cherries:latest / /usr/share/tartaria/cherries/
COPY --from=ghcr.io/tartaria-dev/packages:latest / /packages/

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

# lint bootc image
RUN bootc container lint

# rechunk image
FROM quay.io/coreos/chunkah AS chunkah
ARG CHUNKAH_CONFIG_STR
RUN --mount=from=builder,src=/,target=/chunkah,ro \
    --mount=type=bind,target=/run/src,rw \
        chunkah build > /run/src/out.ociarchive

# shrimple
FROM oci-archive:out.ociarchive
ENTRYPOINT ["git"]
