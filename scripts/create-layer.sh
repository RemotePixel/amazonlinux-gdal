#!/bin/bash
echo "-----------------------"
echo "Creating lambda package"
echo "-----------------------"
echo

echo "Remove lambda python packages"
rm -rdf $PREFIX/python/boto3/ \
  && rm -rdf $PREFIX/python/botocore/ \
  && rm -rdf $PREFIX/python/docutils/ \
  && rm -rdf $PREFIX/python/dateutil/ \
  && rm -rdf $PREFIX/python/jmespath/ \
  && rm -rdf $PREFIX/python/s3transfer/ \
  && rm -rdf $PREFIX/python/numpy/doc/

echo "Remove uncompiled python scripts"
find $PACKAGE_PREFIX -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-36//' | sed 's/.cpython-37//'); cp $f $n; done;
find $PREFIX/python -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
find $PREFIX/python -type f -a -name '*.py' -print0 | xargs -0 rm -f

echo "Strip shared libraries"
cd $PREFIX && find lib -name \*.so\* -exec strip {} \;

echo "Create archive"
cd $PREFIX && zip -r9q /tmp/layer.zip python
cd $PREFIX && zip -r9q --symlinks /tmp/layer.zip lib/*.so*
cd $PREFIX && zip -r9q /tmp/layer.zip share
cd $PREFIX && zip -r9q /tmp/layer.zip bin

cp /tmp/layer.zip /local/layer.zip
