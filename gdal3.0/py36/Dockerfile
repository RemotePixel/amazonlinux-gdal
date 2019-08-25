FROM lambci/lambda:build-python3.6

LABEL maintainer="RemotePixel <contact@remotepixel.ca>"
LABEL authors="Vincent Sarago  <vincent.sarago@gmail.com>"

ENV \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  CFLAGS="--std=c99"

RUN \
    pip3 install pip -U \
    && pip3 install cython numpy --no-binary numpy

ENV PACKAGE_PREFIX /var/task

COPY --from=remotepixel/amazonlinux:gdal3.0 /base/lib/ $PACKAGE_PREFIX/lib/ 
COPY --from=remotepixel/amazonlinux:gdal3.0 /base/share/ $PACKAGE_PREFIX/share/
COPY --from=remotepixel/amazonlinux:gdal3.0 /base/bin/ $PACKAGE_PREFIX/bin/ 

ENV \
  GDAL_DATA=$PACKAGE_PREFIX/share/gdal \
  PROJ_LIB=$PACKAGE_PREFIX/share/proj \
  GDAL_CONFIG=$PACKAGE_PREFIX/bin/gdal-config \
  GEOS_CONFIG=$PACKAGE_PREFIX/bin/geos-config \
  PATH=$PACKAGE_PREFIX/bin:$PATH

RUN pip install rasterio==1.0.25 shapely numpy --no-binary :all: -t /opt/python

ENV PYTHONPATH=$PYTHONPATH:/opt/python