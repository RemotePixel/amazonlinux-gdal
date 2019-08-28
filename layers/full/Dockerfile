ARG GDAL_VERSION
ARG PYTHON_VERSION

FROM remotepixel/amazonlinux:gdal${GDAL_VERSION}-py${PYTHON_VERSION}-build

# We can add pyproj too
RUN pip install \
    rasterio \
    fiona \
    shapely \
    numpy \
    GDAL~=$(gdal-config --version) \
    --no-binary :all: -t $PREFIX/python

ENV PYTHONPATH=$PYTHONPATH:$PREFIX/python