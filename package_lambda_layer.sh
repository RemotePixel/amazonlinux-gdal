#!/bin/bash

prefix="${PREFIX:-/opt}"

py_version="${PY_VERSION:-3.6}"

layer_package="${LAYER_PACKAGE:-layer_package}"

clean_python_packages () {
    site=$1
    find $site -type d -name '__pycache__' -exec rm -rf {} +
    find $site -type d -name '*.dist-info' -exec rm -rf {} +
    find $site -type d -name '*.egg-info' -exec rm -rf {} +
    find $site -type d -name 'tests' -exec rm -rf {} +
    find $site -type d -name 'datasets' -exec rm -rf {} +
}

src=/var/lang/lib/python${py_version}/site-packages
dst=${prefix}/python/lib/python${py_version}/site-packages
mkdir -p ${dst}

clean_python_packages $src

# Note: excluding many paths in the python libs crashed the layer runtime
#       somehow, so the excludes are disabled for now.
#rsync -a $src/ ${dst}/
rsync -a \
	--exclude 'boto3' \
	--exclude 'botocore' \
	--exclude 'awscli' \
	--exclude 'samtranslator' \
	--exclude 'docker' \
	--exclude 'samcli' \
	--exclude 'share/doc/*' \
	--exclude 'share/man/man1/*' \
	--exclude 'share/man/man3/*' \
       $src/ ${dst}/


# package the binary 'libs' and the python packages into two layers,
# to reduce the size of each package and allow flexibility in using
# just the binaries or the binaries plus the python bindings.
cd ${prefix}
zip -r9 --symlinks /tmp/${layer_package}_python.zip python
zip -r9 --symlinks /tmp/${layer_package}_libs.zip bin lib/*.so* lib64/*.so* share


PIP_OPTIONS="--no-compile --no-binary :all: -t ${dst}"

# add a new python layer for pandas
rm -rf "${dst}/*"
pip3 install pandas "${PIP_OPTIONS}"
clean_python_packages "${dst}"
zip -r9 --symlinks /tmp/${layer_package}_pandas.zip python

# add a new python layer for pyarrow
rm -rf "${dst}/*"
pip3 install pyarrow s3fs "${PIP_OPTIONS}"
clean_python_packages "${dst}"
zip -r9 --symlinks /tmp/${layer_package}_pyarrow.zip python

# add a new python layer for geopandas
rm -rf "${dst}/*"
pip3 install geopandas "${PIP_OPTIONS}"
clean_python_packages "${dst}"
zip -r9 --symlinks /tmp/${layer_package}_geopandas.zip python

