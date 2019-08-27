
#!/bin/bash
[ "$#" -lt 2 ] && echo "Usage: test-layer <gdal-version> <python-version> " && exit 1

GDAL_VERSION=$1
PYTHON_VERSION=$2

docker run \
    --name lambda \
    --volume $(pwd)/:/local \
    --env GDAL_DATA=/opt/share/gdal \
    --env PROJ_LIB=/opt/share/proj \
    --env GDAL_VERSION=${GDAL_VERSION} \
    --env PYTHON_VERSION=${PYTHON_VERSION} \
    --env PYTHONPATH=/opt/python:/var/runtime \
    -itd lambci/lambda:build-python${PYTHON_VERSION} bash
docker cp ./layer-gdal${GDAL_VERSION}-py${PYTHON_VERSION}.zip lambda:/tmp/layer-gdal${GDAL_VERSION}-py${PYTHON_VERSION}.zip
docker exec -it lambda bash -c 'unzip -q /tmp/layer-gdal${GDAL_VERSION}-py${PYTHON_VERSION}.zip -d /opt/'
docker exec -it lambda python -c 'import rasterio; src = rasterio.open("https://oin-hotosm.s3.amazonaws.com/5ac626e091b5310010e0d482/0/5ac626e091b5310010e0d483.tif"); print(src.meta)'
docker stop lambda
docker rm lambda