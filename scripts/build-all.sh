#!/bin/bash

build-layer () {
    LAYER_NAME=$1
    echo "Building image with python ${PYTHON_VERSION}"
  	docker build \
      --build-arg PYTHON_VERSION=${PYTHON_VERSION}\
      --build-arg GDAL_VERSION=${GDAL_VERSION} \
      -f layers/${LAYER_NAME}/Dockerfile \
      -t remotepixel/amazonlinux:gdal${GDAL_VERSION}-py${PYTHON_VERSION}-${LAYER_NAME} .
    
    echo "Creating aws lambda layer for python ${PYTHON_VERSION}"
    docker run \
      --name lambda \
      --volume $(pwd)/:/local \
      --env GDAL_VERSION=${GDAL_VERSION} \
      --env PYTHON_VERSION=${PYTHON_VERSION} \
      --env LAYER_NAME=${LAYER_NAME} \
      -itd remotepixel/amazonlinux:gdal${GDAL_VERSION}-py${PYTHON_VERSION}-${LAYER_NAME} bash
    docker cp ./scripts/create-lambda-layer.sh lambda:/tmp/create-layer.sh
    docker exec -it lambda bash -c '/tmp/create-layer.sh ${GDAL_VERSION} ${PYTHON_VERSION} ${LAYER_NAME}'
    docker stop lambda
    docker rm lambda
}

# GDAL_VERSIONS="2.2 3.0 master"
GDAL_VERSIONS="3.0"
PYTHON_VERSIONS="3.6 3.7"
for GDAL_VERSION in $GDAL_VERSIONS; do
  echo "Building image for gdal ${GDAL_VERSION}"
	docker build -f base/gdal${GDAL_VERSION}/Dockerfile -t remotepixel/amazonlinux:gdal${GDAL_VERSION} .
  for PYTHON_VERSION in $PYTHON_VERSIONS; do
    build-layer "build"
    build-layer "rasterio"
    WITH_BINARIES=1 build-layer "full"
  done
done