IMAGE_REPO ?= localhost/linux
IMAGE_TAG ?= latest

BASE_IMAGE_REPO := quay.io/fedora/fedora-bootc
BASE_IMAGE_TAG ?= 44

CHUNKAH ?= quay.io/coreos/chunkah:latest

BASE_DIGEST := $(shell \
	skopeo inspect docker://$(BASE_IMAGE_REPO):$(BASE_IMAGE_TAG) \
	| jq '.Digest' \
	| sed -e 's/"//g' \
)

BASE_IMAGE := $(BASE_IMAGE_REPO)@$(BASE_DIGEST)

IMAGE_CREATED := $(shell date --iso-8601=minutes)

image:
	image_tag=$(IMAGE_TAG) \
	image_created=$(IMAGE_CREATED) \
	./utils/os-release.sh
	
	if [ $(IMAGE_TAG) = "testing" ]; \
	then ./utils/prepare-build-testing.sh; \
	fi
	
	. files/usr/lib/os-release; \
	podman build \
		--tag $(IMAGE_REPO):$(IMAGE_TAG) \
		--skip-unused-stages=false \
		--volume $$(pwd):/run/src \
		--security-opt=label=disable \
		--build-arg=base_image="$(BASE_IMAGE)" \
		--build-arg=chunkah="$(CHUNKAH)" \
		--build-arg=oci_created="$(IMAGE_CREATED)" \
		--build-arg=oci_url="$$HOME_URL" \
		--build-arg=oci_source="$$HOME_URL" \
		--build-arg=oci_version="$$VERSION (build $$IMAGE_VERSION)" \
		--build-arg=oci_vendor="$$VENDOR_NAME" \
		--build-arg=oci_licenses="MIT" \
		--build-arg=oci_title="$$NAME" \
		--build-arg=oci_description="$$DESCRIPTION" \
		--build-arg=oci_base_digest="$(BASE_DIGEST)" \
		--build-arg=oci_base_name="$(BASE_IMAGE_REPO):$(BASE_IMAGE_TAG)" \
		--annotation="containers.bootc=1" \
		--annotation="org.opencontainers.image.created=$(IMAGE_CREATED)" \
		--annotation="org.opencontainers.image.url=$$HOME_URL" \
		--annotation="org.opencontainers.image.source=$$HOME_URL" \
		--annotation="org.opencontainers.image.version=$$VERSION (build $$IMAGE_VERSION)" \
		--annotation="org.opencontainers.image.vendor=$$VENDOR_NAME" \
		--annotation="org.opencontainers.image.licenses=MIT" \
		--annotation="org.opencontainers.image.title=$$NAME" \
		--annotation="org.opencontainers.image.description=$$DESCRIPTION" \
		--annotation="org.opencontainers.image.base.digest=$(BASE_DIGEST)" \
		--annotation="org.opencontainers.image.base.name=$(BASE_IMAGE_REPO):$(BASE_IMAGE_TAG)" \
		.
