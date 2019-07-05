SHELL = /bin/bash
TAG = 2.4.2
IMAGE := ${DOCKER_USERNAME}/amazonlinux-gdal:${TAG}

all: build push

build:
	docker build -f Dockerfile -t amazonlinux-gdal:${TAG} .

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
	docker run amazonlinux-gdal:${TAG} bash -c "gdalinfo --version | grep '${TAG}'"
	docker run amazonlinux-gdal:${TAG} bash -c "gdalinfo --formats | grep 'JP2OpenJPEG'"

push:
	docker tag amazonlinux-gdal:${TAG} ${IMAGE}
	docker push ${IMAGE}

clean:
	docker stop amazonlinux
	docker rm amazonlinux
