FROM lambci/lambda:build-python3.7

LABEL maintainer="RemotePixel <contact@remotepixel.ca>"
LABEL authors="Vincent Sarago  <vincent.sarago@gmail.com>"

ENV \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  CFLAGS="--std=c99"

RUN \
    pip3 install pip -U \
    && pip3 install cython numpy --no-binary numpy

ENV PREFIX /opt

COPY --from=remotepixel/amazonlinux:gdal3.0 /opt/lib/ $PREFIX/lib/ 
COPY --from=remotepixel/amazonlinux:gdal3.0 /opt/include/ $PREFIX/include/
COPY --from=remotepixel/amazonlinux:gdal3.0 /opt/share/ $PREFIX/share/
COPY --from=remotepixel/amazonlinux:gdal3.0 /opt/bin/ $PREFIX/bin/ 

ENV \
  GDAL_DATA=$PREFIX/share/gdal \
  PROJ_LIB=$PREFIX/share/proj \
  GDAL_CONFIG=$PREFIX/bin/gdal-config \
  GEOS_CONFIG=$PREFIX/bin/geos-config \
  PATH=$PREFIX/bin:$PATH

RUN pip install rasterio==1.0.25 shapely numpy --no-binary :all: -t $PREFIX/python

ENV PYTHONPATH=$PYTHONPATH:$PREFIX/python