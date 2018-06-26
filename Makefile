
SHELL = /bin/bash

all: build push

build:
	docker build -f Dockerfile --tag amazonlinux-gdal:2.3.0 .

shell:
	docker run \
		--name amazonlinux-gdal  \
		--volume $(shell pwd)/:/data \
		--rm \
		-it \
		amazonlinux-gdal:2.3.0 /bin/bash

push:
	docker tag amazonlinux-gdal:2.3.0 remotepixel/amazonlinux-gdal:2.3.0
	docker push remotepixel/amazonlinux-gdal:2.3.0


clean:
	docker stop amazonlinux-gdal
	docker rm amazonlinux-gdal
