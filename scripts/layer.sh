#!/bin/bash
echo "----------------------------------"
echo "Creating lambda package from layer"
echo "----------------------------------"
echo

echo "Remove uncompiled python scripts"
find $PACKAGE_PREFIX -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-36//' | sed 's/.cpython-37//'); cp $f $n; done;
find $PACKAGE_PREFIX -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
find $PACKAGE_PREFIX -type f -a -name '*.py' -print0 | xargs -0 rm -f

echo "Create archive"
cd $PACKAGE_PREFIX && zip -r9q /tmp/layer.zip *

cp /tmp/package.zip /local/package.zip
