
SHELL = /bin/bash
TAG = 2.5.0dev

all: build push

build:
	docker build -f Dockerfile --tag amazonlinux-gdal:${TAG} .

shell:
	docker build -f Dockerfile --tag amazonlinux-gdal:${TAG} .
	docker run \
		--name amazonlinux \
		--volume $(shell pwd)/:/data \
		--rm \
		-it \
		amazonlinux-gdal:${TAG} /bin/bash

debug-gdal: build
	docker run \
		--name amazonlinux \
		-itd amazonlinux-gdal:${TAG} /bin/bash
	docker exec -it amazonlinux bash -c 'ldd /var/task/lib/libgdal.so'
	docker exec -it amazonlinux bash -c 'readelf -d /var/task/lib/libgdal.so'
	docker stop amazonlinux
	docker rm amazonlinux

account=remotepixel
push:
	docker build -f Dockerfile --tag amazonlinux-gdal:${TAG} .
	docker tag amazonlinux-gdal:${TAG} ${account}/amazonlinux-gdal:${TAG}
	docker push ${account}/amazonlinux-gdal:${TAG}

clean:
	docker stop amazonlinux
	docker rm amazonlinux
