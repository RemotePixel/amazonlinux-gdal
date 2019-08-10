#!/bin/bash

prefix="${PREFIX:-/opt}"

py_version="${PY_VERSION:-3.6}"

layer_package="${LAYER_PACKAGE:-layer_package}"


# Note: excluding many paths in the python libs crashed the layer runtime
#       somehow, so the excludes are disabled for now.
src=/var/lang/lib/python${py_version}/site-packages
dst=${prefix}/python/lib/python${py_version}/site-packages
find $src -type d -name '__pycache__' -exec rm -rf {} +
mkdir -p ${dst}
rsync -a $src/ ${dst}/
#rsync -a \
#	--exclude 'boto3' \
#	--exclude 'botocore' \
#	--exclude 'aws_lambda_builders' \
#	--exclude 'awscli' \
#	--exclude 's3transfer' \
#	--exclude 'samtranslator' \
#	--exclude 'docker' \
#	--exclude 'samcli' \
#	--exclude 'wheel' \
#	--exclude 'share/doc/*' \
#	--exclude 'share/man/man1/*' \
#	--exclude 'share/man/man3/*' \
#	--exclude 'pipenv' \
#       $src/ ${dst}/

# package the binary 'libs' and the python packages into two layers,
# to reduce the size of each package and allow flexibility in using
# just the binaries or the binaries plus the python bindings.
cd ${prefix}
zip -r9 --symlinks /tmp/${layer_package}_python.zip python
zip -r9 --symlinks /tmp/${layer_package}_libs.zip bin lib/*.so* lib64/*.so* share

