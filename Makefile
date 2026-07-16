IMAGE_NAME ?= localhost/linux:latest
BASE_IMAGE := quay.io/fedora/fedora-bootc:44
CHUNKAH := quay.io/coreos/chunkah:latest

BASE_DIGEST = $(shell \
	podman image inspect \
		--format '{{ .Digest }}' \
		$(BASE_IMAGE) \
)
IMAGE_CREATED = $(shell \
	date --iso-8601=minutes \
)
IMAGE_VERSION = $(shell \
	podman run \
		--rm --env "BUILD=$$(sed -n 's/^BUILD=//p' scripts/os-release.sh)" \
		$(BASE_IMAGE) \
		sh -c 'eval echo $$BUILD' \
)

image:
	podman pull $(BASE_IMAGE)
	podman pull $(CHUNKAH)
	
	podman build \
		--tag $(IMAGE_NAME) \
		--skip-unused-stages=false \
		--volume $$(pwd):/run/src \
		--security-opt=label=disable \
		--build-arg=IMAGE_CREATED="$(IMAGE_CREATED)" \
		--build-arg=IMAGE_VERSION="$(IMAGE_VERSION)" \
		--build-arg=IMAGE_BASE_DIGEST="$(BASE_DIGEST)" \
		--build-arg=IMAGE_BASE_NAME="$(BASE_IMAGE)" \
		--build-arg=CHUNKAH="$(CHUNKAH)" \
		.
