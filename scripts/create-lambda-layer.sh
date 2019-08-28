#!/bin/bash
# [ "$#" -lt 3 ] && echo "Usage: create-lambda-layer <gdal-version> <python-version> " && exit 1

echo "-----------------------"
echo "Creating lambda layer"
echo "-----------------------"

GDAL_VERSION=$1
PYTHON_VERSION=$2
NAME=$3 

PACKAGE_NAME=layer-gdal${GDAL_VERSION}-py${PYTHON_VERSION}-${NAME}

if [[ $NAME == "build" ]];
then 
    echo "Strip shared libraries"
    cd $PREFIX && find lib -name \*.so\* -exec strip {} \;

    echo "Create archives"
    cd $PREFIX && zip -r9q --symlinks /tmp/${PACKAGE_NAME}.zip lib/*.so* share # bin <--- do we want the binaries ?

else
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
    cd $PREFIX && zip -r9q /tmp/${PACKAGE_NAME}.zip python
    if [[ -n "$WITH_BINARIES" ]];
    then 
        cd $PREFIX && zip -r9q --symlinks /tmp/${PACKAGE_NAME}.zip lib/*.so* share bin
    else
        cd $PREFIX && zip -r9q --symlinks /tmp/${PACKAGE_NAME}.zip lib/*.so* share
    fi
fi

cp /tmp/${PACKAGE_NAME}.zip /local/${PACKAGE_NAME}.zip
