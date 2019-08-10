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
	docker push ${DOCKER_USERNAME}/${BUILD}

container-clean:
	docker stop amazonlinux > /dev/null 2>&1 || true
	docker rm amazonlinux > /dev/null 2>&1 || true

# ---
# lambda layer build and package using /opt

LAYER_BUILD = ${BUILD}-layer
LAYER_PACKAGE := amazonlinux-${TAG}-layer

lambda-layer-build:
	docker build -f Dockerfile -t ${LAYER_BUILD} --build-arg prefix=/opt .

lambda-layer-shell: lambda-layer-build container-clean
	docker run --name amazonlinux --volume $(shell pwd)/:/data --rm -it ${LAYER_BUILD} /bin/bash

lambda-layer-test: lambda-layer-build
	docker run --volume $(shell pwd)/:/data --rm -it ${LAYER_BUILD} /bin/bash -c '/data/tests/test.sh'

lambda-layer-package: lambda-layer-build container-clean
	docker run --name amazonlinux \
		-e PREFIX=${PREFIX} \
		-e PY_VERSION=${PY_VERSION} \
		-e LAYER_PACKAGE=${LAYER_PACKAGE} \
		-itd ${LAYER_BUILD} /bin/bash
	docker cp package_lambda_layer.sh amazonlinux:/tmp/package_lambda_layer.sh
	docker exec -it amazonlinux bash -c '/tmp/package_lambda_layer.sh'
	mkdir -p ./packages
	docker cp amazonlinux:/tmp/${LAYER_PACKAGE}_libs.zip ./packages/
	docker cp amazonlinux:/tmp/${LAYER_PACKAGE}_python.zip ./packages/
	docker stop amazonlinux && docker rm amazonlinux

