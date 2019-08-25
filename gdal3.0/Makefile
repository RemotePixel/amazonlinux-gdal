SHELL = /bin/bash
GDAL_VERSION = gdal3.0

baseimage:
	docker build  -f base/Dockerfile -t remotepixel/amazonlinux:${GDAL_VERSION} .

image:
	docker build -f py37/Dockerfile -t remotepixel/amazonlinux:${GDAL_VERSION}-py37 .
	docker build -f py36/Dockerfile -t remotepixel/amazonlinux:${GDAL_VERSION}-py36 .
