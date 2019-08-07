SHELL = /bin/bash
PY_VERSION = 3.7
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
LAYER_PACKAGE := amazonlinux-${TAG}-layer.zip

lambda-layer-build:
	docker build -f Dockerfile -t ${LAYER_BUILD} --build-arg prefix=/opt .

lambda-layer-shell: lambda-layer-build container-clean
	docker run --name amazonlinux --volume $(shell pwd)/:/data --rm  -it ${LAYER_BUILD} /bin/bash

lambda-layer-package: lambda-layer-build container-clean
	docker run --name amazonlinux -itd ${LAYER_BUILD} /bin/bash
	docker exec -it amazonlinux bash -c 'mkdir -p $${PREFIX}/python/lib/python${PY_VERSION}/site-packages'
	docker exec -it amazonlinux bash -c 'rsync -a /var/lang/lib/python${PY_VERSION}/site-packages/ $${PREFIX}/python/lib/python${PY_VERSION}/site-packages/'
	docker exec -it amazonlinux bash -c 'cd $${PREFIX} && zip -r9 --symlinks /tmp/package.zip python'
	docker exec -it amazonlinux bash -c 'cd $${PREFIX} && zip -r9 --symlinks /tmp/package.zip lib/*.so*'
	docker exec -it amazonlinux bash -c 'cd $${PREFIX} && zip -r9 --symlinks /tmp/package.zip lib64/*.so*'
	docker exec -it amazonlinux bash -c 'cd $${PREFIX} && zip -r9 --symlinks /tmp/package.zip bin'
	docker exec -it amazonlinux bash -c 'cd $${PREFIX} && zip -r9 /tmp/package.zip share'
	docker cp amazonlinux:/tmp/package.zip ${LAYER_PACKAGE}
	docker stop amazonlinux && docker rm amazonlinux

