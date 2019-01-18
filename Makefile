
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

push:
	docker build -f Dockerfile --tag amazonlinux-gdal:${TAG} .
	docker tag amazonlinux-gdal:${TAG} remotepixel/amazonlinux-gdal:${TAG}
	docker push remotepixel/amazonlinux-gdal:${TAG}

clean:
	docker stop amazonlinux
	docker rm amazonlinux
