ARG IMAGE_BASE_NAME=overridden
ARG CHUNKAH=overridden

FROM scratch AS baseconfig
COPY files /files/
COPY scripts /scripts/

FROM $IMAGE_BASE_NAME AS rootfs
RUN --mount=type=tmpfs,target=/run \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var \
    --mount=type=bind,from=baseconfig,src=/files,target=/run/files \
    --mount=type=bind,from=baseconfig,src=/scripts,target=/run/scripts \
    /run/scripts/prepare-rootfs.sh

RUN bootc container lint --fatal-warnings --no-truncate

FROM $CHUNKAH AS chunkah
RUN --mount=from=rootfs,src=/,target=/chunkah,ro \
    --mount=type=bind,target=/run/src,rw \
    chunkah build \
        --max-layers 256 \
        --prune /sysroot/ \
        --label ostree.commit- \
        --label ostree.final-diffid- \
        --output oci:/run/src/out

FROM oci:out AS final

ARG IMAGE_CREATED=overridden
ARG IMAGE_VERSION=overridden
ARG IMAGE_BASE_DIGEST=overridden
ARG IMAGE_BASE_NAME=overridden

LABEL containers.bootc=1
LABEL org.opencontainers.image.created="$IMAGE_CREATED"
LABEL org.opencontainers.image.url="https://github.com/lfchr/linux/pkgs/container/linux"
LABEL org.opencontainers.image.source="https://github.com/lfchr/linux"
LABEL org.opencontainers.image.version="$IMAGE_VERSION"
LABEL org.opencontainers.image.vendor="lfchr"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="Linux"
LABEL org.opencontainers.image.description="Bootable Linux desktop container image"
LABEL org.opencontainers.image.base.digest="$IMAGE_BASE_DIGEST"
LABEL org.opencontainers.image.base.name="$IMAGE_BASE_NAME"

ENV container=oci
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
