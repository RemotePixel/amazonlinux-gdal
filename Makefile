SHELL = /bin/bash
TAG = 2.4.0
IMAGE := ${DOCKER_USERNAME}/amazonlinux-gdal:${TAG}

all: build push

build:
	docker build -f Dockerfile -t ${IMAGE} .

shell:
	docker run --name amazonlinux --volume $(shell pwd)/:/data --rm  -it ${IMAGE} /bin/bash

debug-gdal: build
	docker run \
		--name amazonlinux \
		-itd amazonlinux-gdal:${TAG} /bin/bash
	docker exec -it amazonlinux bash -c 'ldd /var/task/lib/libgdal.so'
	docker exec -it amazonlinux bash -c 'readelf -d /var/task/lib/libgdal.so'
	docker stop amazonlinux
	docker rm amazonlinux

test:
	docker run ${IMAGE} bash -c "gdalinfo --version | grep '${TAG}'"
	docker run ${IMAGE} bash -c "gdalinfo --formats | grep 'JP2OpenJPEG'"

push:
	docker push ${IMAGE}

clean:
	docker stop amazonlinux
	docker rm amazonlinux
