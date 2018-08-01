
SHELL = /bin/bash

all: build push

build:
	docker build -f Dockerfile --tag amazonlinux-gdal:2.3.1 .

shell:
	docker run \
		--name amazonlinux \
		--volume $(shell pwd)/:/data \
		--rm \
		-it \
		amazonlinux-gdal:2.3.1 /bin/bash

push:
	docker tag amazonlinux-gdal:2.3.1 remotepixel/amazonlinux-gdal:2.3.1
	docker push remotepixel/amazonlinux-gdal:2.3.1


clean:
	docker stop amazonlinux
	docker rm amazonlinux
