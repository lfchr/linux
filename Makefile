IMAGE_NAME ?= localhost/linux:latest
BASE_IMAGE_REPO ?= quay.io/fedora/fedora-bootc
BASE_IMAGE_TAG ?= 44
CHUNKAH ?= quay.io/coreos/chunkah:latest

BASE_DIGEST := $(shell \
	skopeo inspect docker://$(BASE_IMAGE_REPO):$(BASE_IMAGE_TAG) \
	| jq '.Digest' \
	| sed -e 's/"//g' \
)

BASE_IMAGE = $(BASE_IMAGE_REPO)@$(BASE_DIGEST)

IMAGE_URL = $(shell \
	podman run --rm \
		--volume $$(pwd):/run/src:ro \
		--security-opt=label=disable \
		$(BASE_IMAGE_REPO)@$(BASE_DIGEST) \
		sh -c ' \
			set -a; \
			source <(cat /run/src/scripts/os-release.sh | grep "^HOME_URL="); \
			echo "$$HOME_URL" \
		' \
)
IMAGE_SOURCE = $(IMAGE_URL)
IMAGE_VENDOR = $(shell \
	podman run --rm \
		--volume $$(pwd):/run/src:ro \
		--security-opt=label=disable \
		$(BASE_IMAGE_REPO)@$(BASE_DIGEST) \
		sh -c ' \
			set -a; \
			source <(cat /run/src/scripts/os-release.sh | grep "^VENDOR_NAME="); \
			echo "$$VENDOR_NAME" \
		' \
)
IMAGE_TITLE = $(shell \
	podman run --rm \
		--volume $$(pwd):/run/src:ro \
		--security-opt=label=disable \
		$(BASE_IMAGE_REPO)@$(BASE_DIGEST) \
		sh -c ' \
			set -a; \
			source <(cat /run/src/scripts/os-release.sh | grep "^OS_NAME="); \
			echo "$$OS_NAME" \
		' \
)
IMAGE_DESCRIPTION = $(shell \
	podman run --rm \
		--volume $$(pwd):/run/src:ro \
		--security-opt=label=disable \
		$(BASE_IMAGE_REPO)@$(BASE_DIGEST) \
		sh -c ' \
			set -a; \
			source <(cat /run/src/scripts/os-release.sh | grep "^OS_DESCRIPTION="); \
			echo "$$OS_DESCRIPTION" \
		' \
)
IMAGE_CREATED = $(shell \
	podman run --rm \
		--volume $$(pwd):/run/src:ro \
		--security-opt=label=disable \
		$(BASE_IMAGE_REPO)@$(BASE_DIGEST) \
		date --iso-8601=minutes \
)
IMAGE_VERSION = $(shell \
	podman run --rm \
		--volume $$(pwd):/run/src:ro \
		--security-opt=label=disable \
		$(BASE_IMAGE_REPO)@$(BASE_DIGEST) \
		sh -c ' \
			set -a; \
			source <(cat /run/src/scripts/os-release.sh | grep "^BUILD="); \
			source <(cat /run/src/scripts/os-release.sh | grep "^OS_VERSION="); \
			echo "$$OS_VERSION (build $$BUILD)" \
		' \
)

image-latest:
	podman build \
		--tag $(IMAGE_NAME) \
		--skip-unused-stages=false \
		--volume $$(pwd):/run/src \
		--security-opt=label=disable \
		\
		--build-arg=base_image="$(BASE_IMAGE)" \
		--build-arg=chunkah="$(CHUNKAH)" \
		\
		--build-arg=oci_created="$(IMAGE_CREATED)" \
		--build-arg=oci_url="$(IMAGE_URL)" \
		--build-arg=oci_source="$(IMAGE_SOURCE)" \
		--build-arg=oci_version="$(IMAGE_VERSION)" \
		--build-arg=oci_vendor="$(IMAGE_VENDOR)" \
		--build-arg=oci_licenses="MIT" \
		--build-arg=oci_title="$(IMAGE_TITLE)" \
		--build-arg=oci_description="$(IMAGE_DESCRIPTION)" \
		--build-arg=oci_base_digest="$(BASE_DIGEST)" \
		--build-arg=oci_base_name="$(BASE_IMAGE_REPO):$(BASE_IMAGE_TAG)" \
		--annotation="containers.bootc=1" \
		--annotation="org.opencontainers.image.created=$(IMAGE_CREATED)" \
		--annotation="org.opencontainers.image.url=$(IMAGE_URL)" \
		--annotation="org.opencontainers.image.source=$(IMAGE_SOURCE)" \
		--annotation="org.opencontainers.image.version=$(IMAGE_VERSION)" \
		--annotation="org.opencontainers.image.vendor=$(IMAGE_VENDOR)" \
		--annotation="org.opencontainers.image.licenses=MIT" \
		--annotation="org.opencontainers.image.title=$(IMAGE_TITLE)" \
		--annotation="org.opencontainers.image.description=$(IMAGE_DESCRIPTION)" \
		--annotation="org.opencontainers.image.base.digest=$(BASE_DIGEST)" \
		--annotation="org.opencontainers.image.base.name=$(BASE_IMAGE_REPO):$(BASE_IMAGE_TAG)" \
		.

image-testing:
	podman build \
		--tag $(IMAGE_NAME) \
		--skip-unused-stages=false \
		--volume $$(pwd):/run/src \
		--security-opt=label=disable \
		\
		--build-arg=base_image="$(BASE_IMAGE)" \
		--build-arg=chunkah="$(CHUNKAH)" \
		\
		--build-arg=oci_created="$(IMAGE_CREATED)" \
		--build-arg=oci_url="$(IMAGE_URL)" \
		--build-arg=oci_source="$(IMAGE_SOURCE)" \
		--build-arg=oci_version="$(IMAGE_VERSION)" \
		--build-arg=oci_vendor="$(IMAGE_VENDOR)" \
		--build-arg=oci_licenses="MIT" \
		--build-arg=oci_title="$(IMAGE_TITLE)" \
		--build-arg=oci_description="$(IMAGE_DESCRIPTION)" \
		--build-arg=oci_base_digest="$(BASE_DIGEST)" \
		--build-arg=oci_base_name="$(BASE_IMAGE_REPO):$(BASE_IMAGE_TAG)" \
		--annotation="containers.bootc=1" \
		--annotation="org.opencontainers.image.created=$(IMAGE_CREATED)" \
		--annotation="org.opencontainers.image.url=$(IMAGE_URL)" \
		--annotation="org.opencontainers.image.source=$(IMAGE_SOURCE)" \
		--annotation="org.opencontainers.image.version=$(IMAGE_VERSION)" \
		--annotation="org.opencontainers.image.vendor=$(IMAGE_VENDOR)" \
		--annotation="org.opencontainers.image.licenses=MIT" \
		--annotation="org.opencontainers.image.title=$(IMAGE_TITLE)" \
		--annotation="org.opencontainers.image.description=$(IMAGE_DESCRIPTION)" \
		--annotation="org.opencontainers.image.base.digest=$(BASE_DIGEST)" \
		--annotation="org.opencontainers.image.base.name=$(BASE_IMAGE_REPO):$(BASE_IMAGE_TAG)" \
		--file=Containerfile.testing \
		.

fast:
	podman build \
		--tag $(IMAGE_NAME) \
		--skip-unused-stages=false \
		--volume $$(pwd):/run/src \
		--security-opt=label=disable \
		--pull=never \
		--build-arg=base_image="$(BASE_IMAGE)" \
		--file=Containerfile.fast \
		.
