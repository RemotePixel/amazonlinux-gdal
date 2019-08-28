ARG GDAL_VERSION
ARG PYTHON_VERSION

FROM remotepixel/amazonlinux:gdal${GDAL_VERSION}-py${PYTHON_VERSION}-build

RUN pip install rasterio --no-binary :all: -t $PREFIX/python

ENV PYTHONPATH=$PYTHONPATH:$PREFIX/python