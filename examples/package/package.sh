#!/bin/bash
echo "-----------------------"
echo "Creating lambda package"
echo "-----------------------"
echo "Remove lambda python packages"
rm -rdf $PREFIX/python/boto3/ \
  && rm -rdf $PREFIX/python/botocore/ \
  && rm -rdf $PREFIX/python/docutils/ \
  && rm -rdf $PREFIX/python/dateutil/ \
  && rm -rdf $PREFIX/python/jmespath/ \
  && rm -rdf $PREFIX/python/s3transfer/ \
  && rm -rdf $PREFIX/python/numpy/doc/

echo "Strip shared libraries"
cd $PREFIX && find lib -name \*.so\* -exec strip {} \;

echo "Create archive"
cd $PREFIX/python && zip -r9q /tmp/package.zip *
cd $PREFIX && zip -r9q --symlinks /tmp/package.zip lib/*.so*
cd $PREFIX && zip -r9q /tmp/package.zip share
cd $PREFIX && zip -r9q /tmp/package.zip bin

cp /tmp/package.zip /local/package.zip
