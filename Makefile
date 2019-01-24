
SHELL = /bin/bash
TAG = 2.4.0

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
		--name lambda \
		-itd amazonlinux-gdal:${TAG} /bin/bash
	docker exec -it lambda bash -c 'ldd /var/task/lib/libgdal.so'
	docker exec -it lambda bash -c 'readelf -d /var/task/lib/libgdal.so'
	docker stop lambda
	docker rm lambda

push:
	docker build -f Dockerfile --tag amazonlinux-gdal:${TAG} .
	docker tag amazonlinux-gdal:${TAG} remotepixel/amazonlinux-gdal:${TAG}
	docker push remotepixel/amazonlinux-gdal:${TAG}

clean:
	docker stop amazonlinux
	docker rm amazonlinux
