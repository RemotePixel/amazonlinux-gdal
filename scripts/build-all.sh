
# GDAL_VERSIONS="2.2 3.0 master"
GDAL_VERSIONS="3.0"
PYTHON_VERSIONS="3.6 3.7"

for GDAL_VERSION in $GDAL_VERSIONS; do
  echo "Building image for gdal ${GDAL_VERSION}"
	docker build \
    -f gdal${GDAL_VERSION}/Dockerfile \
    -t remotepixel/amazonlinux:gdal${GDAL_VERSION} .

  for PYTHON_VERSION in $PYTHON_VERSIONS; do
    echo "Building image with python ${PYTHON_VERSION}"
  	docker build \
      --build-arg PYTHON_VERSION=${PYTHON_VERSION}\
      --build-arg GDAL_VERSION=${GDAL_VERSION} \
      -f build/Dockerfile \
      -t remotepixel/amazonlinux:gdal${GDAL_VERSION}-py${PYTHON_VERSION} .
    
    echo "Creating aws lambda layer for python ${PYTHON_VERSION}"
    docker run \
      --name lambda \
      --volume $(pwd)/:/local \
      --env GDAL_VERSION=${GDAL_VERSION} \
      --env PYTHON_VERSION=${PYTHON_VERSION} \
      -itd remotepixel/amazonlinux:gdal${GDAL_VERSION}-py${PYTHON_VERSION} bash
    docker cp ./scripts/create-lambda-layer.sh lambda:/tmp/create-lambda-layer.sh
    docker exec -it lambda bash -c '/tmp/create-lambda-layer.sh ${GDAL_VERSION} ${PYTHON_VERSION}'
    docker stop lambda
    docker rm lambda
  done
done