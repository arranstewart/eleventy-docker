
.PHONY: docker-build docker-shell print-build-args \
	default build \
	print-docker-hub-image

SHELL=bash

default:
	echo pass

METADATA_FILE := METADATA.env

PACKAGE_DIR=/opt/site

# e.g. adstewart
IMAGE_NAMESPACE := $(shell grep '^IMAGE_NAMESPACE=' $(METADATA_FILE) | cut -d= -f2-)

# e.g. 1.01
IMAGE_VERSION := $(shell grep '^IMAGE_VERSION=' $(METADATA_FILE) | cut -d= -f2-)

# e.g. eleventy
IMAGE_NAME    := $(shell grep '^IMAGE_NAME=' $(METADATA_FILE) | cut -d= -f2-)



# quick and dirty build

TARGET_PLATFORMS = linux/amd64,linux/arm64
#TARGET_PLATFORMS = linux/amd64


# uses the builder `multiarch-builder` - we assume
# it's been created as per the README.
docker-build:
	docker buildx build \
		--progress=plain \
		--builder=multiarch-builder \
		--cache-from $(IMAGE_NAMESPACE)/$(IMAGE_NAME):$(IMAGE_VERSION) \
		--cache-from $(IMAGE_NAMESPACE)/$(IMAGE_NAME):latest \
		--platform $(TARGET_PLATFORMS) \
		-f Dockerfile \
		-t $(IMAGE_NAMESPACE)/$(IMAGE_NAME):$(IMAGE_VERSION) \
		-t $(IMAGE_NAMESPACE)/$(IMAGE_NAME):latest \
		--push \
		.

CTR_NAME=eleventy-ctr

REMOVE_AFTER=--rm

#PLATFORM = linux/amd64
PLATFORM = linux/arm64

docker-shell:
	-docker rm -f $(CTR_NAME)
	docker -D run $(REMOVE_AFTER) -it \
		--name $(CTR_NAME) \
		--platform $(PLATFORM) \
		-p 8080:8080 \
		-v $$HOME/dev/:/home/dev \
		-v $$PWD:/work --workdir=/work \
		--entrypoint sh \
		$(IMAGE_NAMESPACE)/$(IMAGE_NAME):$(IMAGE_VERSION)



