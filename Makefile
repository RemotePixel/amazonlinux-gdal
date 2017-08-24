
SHELL = /bin/bash

all: build push

build:
	docker build -f Dockerfile --tag amazonlinux-gdal:latest .

shell:
	docker run \
		--name amazonlinux-gdal  \
		--volume $(shell pwd)/:/data \
		--rm \
		-it \
		amazonlinux-gdal:latest /bin/bash

push:
	docker tag amazonlinux-gdal:latest remotepixel/amazonlinux-gdal:latest
	docker push remotepixel/amazonlinux-gdal:latest


clean:
	docker stop amazonlinux-gdal
	docker rm amazonlinux-gdal
