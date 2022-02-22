
.PHONY: docker-build docker-shell print-build-args \
	default build \
	print-docker-hub-image

SHELL=bash

default:
	echo pass

# eleventy

PACKAGE_DIR=/opt/site

# docker

REPO=adstewart

IMAGE_NAME=eleventy

IMAGE_VERSION=1.0.0

CTR_NAME=eleventy-ctr

print-image-name:
	@echo $(IMAGE_NAME)

print-image-version:
	@echo $(IMAGE_VERSION)

print-docker-hub-image:
	@printf '%s' "$(REPO)/$(IMAGE_NAME)"

docker-build:
	docker build \
		-f Dockerfile \
		--build-arg PACKAGE_DIR=$(PACKAGE_DIR) \
		-t $(REPO)/$(IMAGE_NAME):$(IMAGE_VERSION) .

REMOVE_AFTER=--rm

docker-shell:
	-docker rm -f $(CTR_NAME)
	docker -D run --rm -e DISPLAY -it \
		--name $(CTR_NAME) \
		-p 8080:8080 \
		-v $$HOME/dev/:/home/dev \
		-v $$PWD:/work --workdir=/work \
		--entrypoint sh \
		$(REPO)/$(IMAGE_NAME):$(IMAGE_VERSION)

