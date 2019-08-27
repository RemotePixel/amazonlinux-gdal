SHELL = /bin/bash
GDAL_VERSION = 3.0

baseimage:
	docker build  -f base/Dockerfile -t remotepixel/amazonlinux:gdal${GDAL_VERSION} .

image:
	docker build --build-arg PYTHON_VERSION=3.6 --build-arg GDAL_VERSION=${GDAL_VERSION} -f build/Dockerfile -t remotepixel/amazonlinux:gdal${GDAL_VERSION}-py36 .
	docker build --build-arg PYTHON_VERSION=3.7 --build-arg GDAL_VERSION=${GDAL_VERSION} -f build/Dockerfile -t remotepixel/amazonlinux:gdal${GDAL_VERSION}-py37 .

layers:
	#python 3.7
	docker run --name lambda --volume $(shell pwd)/:/local -itd remotepixel/amazonlinux:gdal${GDAL_VERSION}-py37 bash
	docker cp ../scripts/create-lambda-layer.sh lambda:/tmp/create-lambda-layer.sh
	docker exec -it lambda bash -c '/tmp/create-lambda-layer.sh ${GDAL_VERSION} 37'
	docker stop lambda
	docker rm lambda
	#python 3.6
	docker run --name lambda --volume $(shell pwd)/:/local -itd remotepixel/amazonlinux:gdal${GDAL_VERSION}-py36 bash
	docker cp ../scripts/create-lambda-layer.sh lambda:/tmp/create-lambda-layer.sh
	docker exec -it lambda bash -c '/tmp/create-lambda-layer.sh ${GDAL_VERSION} 36'
	docker stop lambda
	docker rm lambda

tests:
	#python 3.7
	docker run --name lambda --volume $(shell pwd)/:/local --env PYTHONPATH=/opt/python:/var/runtime --env GDAL_DATA=/opt/lib -itd lambci/lambda:build-python3.7 bash
	docker cp ./layer-gdal3.0-py37.zip lambda:/tmp/layer-gdal3.0-py37.zip
	docker exec -it lambda bash -c 'unzip -q /tmp/layer-gdal3.0-py37.zip -d /opt/'
	docker exec -it lambda python -c 'import rasterio; src = rasterio.open("https://oin-hotosm.s3.amazonaws.com/5ac626e091b5310010e0d482/0/5ac626e091b5310010e0d483.tif"); print(src.meta)'
	docker stop lambda
	docker rm lambda
	# #python 3.6
	docker run --name lambda --volume $(shell pwd)/:/local --env PYTHONPATH=/opt/python:/var/runtime -itd lambci/lambda:build-python3.6 bash
	docker cp ./layer-gdal3.0-py36.zip lambda:/tmp/layer-gdal3.0-py36.zip
	docker exec -it lambda bash -c 'unzip -q /tmp/layer-gdal3.0-py36.zip -d /opt/'
	docker exec -it lambda python -c 'import rasterio; src = rasterio.open("https://oin-hotosm.s3.amazonaws.com/5ac626e091b5310010e0d482/0/5ac626e091b5310010e0d483.tif"); print(src.meta)'
	docker stop lambda
	docker rm lambda

# TODO
#push:
#push-layer 

clean:
	docker stop lambda
	docker rm lambda