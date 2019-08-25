
GDAL_VERSIONS="gdal2.2 gdal3.0 gdalmaster"
RUNTIMES="py36 py37"
for GDAL_VERSION in $GDAL_VERSIONS; do
  echo $GDAL_VERSION
  docker build -t remotepixel/amazonlinux:${GDAL_VERSION} -f ${GDAL_VERSION}/base/Dockerfile

  for RUNTIME in $RUNTIMES; do
    echo $RUNTIME
    docker build -t remotepixel/amazonlinux:${GDAL_VERSION}-${RUNTIME} -f ${GDAL_VERSION}/${RUNTIME}/build/Dockerfile
    # Create layer
  done
done