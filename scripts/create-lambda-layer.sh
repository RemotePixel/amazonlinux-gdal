#!/bin/bash
[ "$#" -lt 2 ] && echo "Usage: create-lambda-layer <gdal-version> <python-version> " && exit 1

GDAL_VERSION=$1
PYTHON_VERSION=$2

echo "-----------------------"
echo "Creating lambda layer"
echo "-----------------------"
echo "Remove lambda python packages"
rm -rdf $PREFIX/python/boto3/ \
  && rm -rdf $PREFIX/python/botocore/ \
  && rm -rdf $PREFIX/python/docutils/ \
  && rm -rdf $PREFIX/python/dateutil/ \
  && rm -rdf $PREFIX/python/jmespath/ \
  && rm -rdf $PREFIX/python/s3transfer/ \
  && rm -rdf $PREFIX/python/numpy/doc/

echo "Remove uncompiled python scripts"
find $PREFIX/python -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-[2-3][0-9]//'); cp $f $n; done;
find $PREFIX/python -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
find $PREFIX/python -type f -a -name '*.py' -print0 | xargs -0 rm -f

echo "Strip shared libraries"
cd $PREFIX && find lib -name \*.so\* -exec strip {} \;

echo "Create archives"
PACKAGE_NAME=layer-gdal${GDAL_VERSION}-py${PYTHON_VERSION}
cd $PREFIX && zip -r9q /tmp/${PACKAGE_NAME}.zip python
cd $PREFIX && zip -r9q --symlinks /tmp/${PACKAGE_NAME}.zip lib/*.so* share # bin <--- do we want the binaries ?

# We also make a light layer with only the libs
cd $PREFIX && zip -r9q --symlinks /tmp/${PACKAGE_NAME}-light.zip lib/*.so* share # bin <--- do we want the binaries ?

cp /tmp/${PACKAGE_NAME}.zip /local/${PACKAGE_NAME}.zip
cp /tmp/${PACKAGE_NAME}-light.zip /local/${PACKAGE_NAME}-light.zip
