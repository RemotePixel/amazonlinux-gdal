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
find $PREFIX -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-36//' | sed 's/.cpython-37//'); cp $f $n; done;
find $PREFIX/python -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
find $PREFIX/python -type f -a -name '*.py' -print0 | xargs -0 rm -f

echo "Strip shared libraries"
cd $PREFIX && find lib -name \*.so\* -exec strip {} \;

echo "Create archive"
cd $PREFIX/python && zip -r9q /tmp/package.zip *
cd $PREFIX && zip -r9q --symlinks /tmp/package.zip lib/*.so*
cd $PREFIX && zip -r9q /tmp/package.zip share
cd $PREFIX && zip -r9q /tmp/package.zip bin

cp /tmp/package.zip /local/package.zip
