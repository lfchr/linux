ARG base_image
ARG chunkah

FROM scratch AS baseconfig
COPY files /files/
COPY scripts /scripts/

FROM $base_image AS rootfs
RUN --mount=type=tmpfs,target=/run \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var \
    --mount=type=bind,from=baseconfig,src=/files,target=/run/files \
    --mount=type=bind,from=baseconfig,src=/scripts,target=/run/scripts \
    /run/scripts/prepare-rootfs.sh

RUN bootc container lint --no-truncate

FROM $chunkah AS chunkah
RUN --mount=from=rootfs,src=/,target=/chunkah,ro \
    --mount=type=bind,target=/run/src,rw \
    chunkah build \
        --max-layers 256 \
        --prune /sysroot/ \
        --label ostree.commit- \
        --label ostree.final-diffid- \
        --output oci:/run/src/out

FROM oci:out AS final

ARG oci_created
ARG oci_url
ARG oci_source
ARG oci_version
ARG oci_vendor
ARG oci_licenses
ARG oci_title
ARG oci_description
ARG oci_base_digest
ARG oci_base_name

LABEL containers.bootc=1
LABEL org.opencontainers.image.created="$oci_created"
LABEL org.opencontainers.image.url="$oci_url"
LABEL org.opencontainers.image.source="$oci_source"
LABEL org.opencontainers.image.version="$oci_version"
LABEL org.opencontainers.image.vendor="$oci_vendor"
LABEL org.opencontainers.image.licenses="$oci_licenses"
LABEL org.opencontainers.image.title="$oci_title"
LABEL org.opencontainers.image.description="$oci_description"
LABEL org.opencontainers.image.base.digest="$oci_base_digest"
LABEL org.opencontainers.image.base.name="$oci_base_name"

ENV container=oci
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
