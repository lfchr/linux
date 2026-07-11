# usage:
# podman build --tag localhost/linux --skip-unused-stages=false --volume $(pwd):/run/src --security-opt=label=disable .

FROM scratch as baseconfig
COPY files /files/
COPY scripts /scripts/

FROM quay.io/fedora/fedora-bootc:44 AS rootfs
RUN --mount=type=tmpfs,target=/run \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var \
    --mount=type=bind,from=baseconfig,src=/files,target=/run/files \
    --mount=type=bind,from=baseconfig,src=/scripts,target=/run/scripts \
    /run/scripts/prepare-rootfs.sh

RUN bootc container lint --fatal-warnings --no-truncate

FROM quay.io/coreos/chunkah AS chunkah
RUN --mount=from=rootfs,src=/,target=/chunkah,ro \
    --mount=type=bind,target=/run/src,rw \
    chunkah build \
        --max-layers 256 \
        --prune /sysroot/ \
        --label ostree.commit- \
        --label ostree.final-diffid- \
        --output oci:/run/src/out
	
FROM oci:out AS final
LABEL containers.bootc=1
ENV container=oci
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
