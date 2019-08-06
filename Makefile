SHELL = /bin/bash
PY_VERSION = 3.6
GDAL_VERSION = 2.4.2
TAG = gdal${GDAL_VERSION}-py${PY_VERSION}
IMAGE := amazonlinux-gdal
BUILD := ${IMAGE}:${TAG}

all: build push

build:
	docker build -f Dockerfile -t ${BUILD} .

shell: build
	docker run --name amazonlinux --volume $(shell pwd)/:/data --rm  -it ${BUILD} /bin/bash

debug-gdal: build
	docker run --name amazonlinux \
		-itd ${BUILD} /bin/bash
	docker exec -it amazonlinux bash -c 'ldd /var/task/lib/libgdal.so'
	docker exec -it amazonlinux bash -c 'readelf -d /var/task/lib/libgdal.so'
	docker stop amazonlinux
	docker rm amazonlinux

test:
	docker run ${BUILD} bash -c "gdalinfo --version | grep '${GDAL_VERSION}'"
	docker run ${BUILD} bash -c "gdalinfo --formats | grep 'JP2OpenJPEG'"
	docker run ${BUILD} bash -c "python --version | grep '${PY_VERSION}'"

push:
	#docker tag ${IMAGE} ${BUILD}
	docker push ${DOCKER_USERNAME}/${BUILD}

clean:
	docker stop amazonlinux
	docker rm amazonlinux
