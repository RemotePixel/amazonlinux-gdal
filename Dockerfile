FROM amazonlinux:latest

################################################################################
#                             INSTALL PYTHON 3.6                               #
################################################################################

# Install apt dependencies for python3.6
RUN yum install -y gcc gcc-c++ freetype-devel yum-utils findutils openssl-devel
RUN yum -y groupinstall development

RUN curl https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tar.xz | tar -xJ \
    && cd Python-3.6.1 \
    && ./configure --prefix=/usr/local --enable-shared \
    && make \
    && make install \
    && cd .. \
    && rm -rf Python-3.6.1

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Install python module needed for gdal and rasterio
RUN pip3 install cython numpy --no-binary numpy

################################################################################
#                                INSTALL GDAL                                  #
################################################################################

# Install apt dependencies fro GDAL and drivers
RUN yum install -y libjpeg-devel zlib-devel libpng-devel libcurl-devel \
                   sqlite-devel.x86_64 wget zip  unzip tar gzip libtool cmake

ENV APP_DIR /tmp/app
RUN mkdir $APP_DIR

ENV PROJ_VERSION 4.9.3
RUN cd $APP_DIR \
   && wget -q https://github.com/OSGeo/proj.4/archive/$PROJ_VERSION.zip \
   && unzip $PROJ_VERSION.zip \
   && cd proj.4-$PROJ_VERSION \
   && sh autogen.sh \
   && ./configure CFLAGS="-O2 -Wl,-S" --prefix=$APP_DIR/local \
   && make && make install && make clean \
   && rm -rf $APP_DIR/$PROJ_VERSION.zip $APP_DIR/proj.4-$PROJ_VERSION

ENV GEOS_VERSION 3.6.2
RUN cd $APP_DIR \
  && wget http://download.osgeo.org/geos/geos-$GEOS_VERSION.tar.bz2 \
  && tar jxf geos-$GEOS_VERSION.tar.bz2 \
  && cd geos-$GEOS_VERSION \
  && CFLAGS="-O2 -Wl,-S" CXXFLAGS="-O2 -Wl,-S" ./configure --prefix=$APP_DIR/local \
  && make && make install && make clean \
  && rm -rf $APP_DIR/geos-$GEOS_VERSION $APP_DIR/$GEOS_VERSION.tar.gz

ENV OPENJPEG_VERSION 2.3.0
RUN cd $APP_DIR \
  && wget https://github.com/uclouvain/openjpeg/archive/v$OPENJPEG_VERSION.tar.gz \
  && tar -zvxf v$OPENJPEG_VERSION.tar.gz \
  && cd openjpeg-$OPENJPEG_VERSION/ \
  && mkdir build \
  && cd build \
  && cmake .. -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$APP_DIR/local \
  && make install && make clean \
  && rm -rf $APP_DIR/openjpeg-$OPENJPEG_VERSION $APP_DIR/v$OPENJPEG_VERSION.tar.gz

ENV LD_LIBRARY_PATH=$APP_DIR/local/lib:$LD_LIBRARY_PATH

# Build and install GDAL (minimal support geotiff and jp2 support, https://trac.osgeo.org/gdal/wiki/BuildingOnUnixWithMinimizedDrivers#no1)
# applying patch from Sean Gillies https://github.com/sgillies/frs-wheel-builds/blob/fafaeadfb638f44d8384e3742c829d2d68297915/patches/changeset_40330.diff
#   to enable openjpeg 2.3.0 support
ENV GDAL_VERSION 2.2.2
RUN cd $APP_DIR \
  && wget http://download.osgeo.org/gdal/$GDAL_VERSION/gdal${GDAL_VERSION//.}.zip \
  && unzip gdal${GDAL_VERSION//.}.zip \
  && cd $APP_DIR/gdal-$GDAL_VERSION \
  && wget https://github.com/sgillies/frs-wheel-builds/raw/fafaeadfb638f44d8384e3742c829d2d68297915/patches/changeset_40330.diff \
  && patch -u --verbose -p4 < ./changeset_40330.diff \
  && CFLAGS="-O2 -Wl,-S" CXXFLAGS="-O2 -Wl,-S" ./configure \
      --prefix=$APP_DIR/local \
      --with-static-proj4=$APP_DIR/local \
      --with-geos=$APP_DIR/local/bin/geos-config \
      --with-openjpeg=$APP_DIR/local \
      --with-threads \
      --disable-debug \
      --with-jpeg \
      --with-hide-internal-symbols \
      --with-curl \
      --without-bsb \
      --without-cfitsio \
      --without-cryptopp \
      --without-ecw \
      --without-expat \
      --without-fme \
      --without-freexl \
      --without-gif \
      --without-gif \
      --without-gnm \
      --without-grass \
      --without-grib \
      --without-hdf4 \
      --without-hdf5 \
      --without-idb \
      --without-ingres \
      --without-jasper \
      --without-jp2mrsid \
      --without-kakadu \
      --without-libgrass \
      --without-libkml \
      --without-libtool \
      --without-mrf \
      --without-mrsid \
      --without-mysql \
      --without-netcdf \
      --without-odbc \
      --without-ogdi \
      --without-pcidsk \
      --without-pcraster \
      --without-pcre \
      --without-perl \
      --without-pg \
      --without-php \
      --without-png \
      --without-python \
      --without-qhull \
      --without-sde \
      --without-sqlite3 \
      --without-webp \
      --without-xerces \
      --without-xml2 \
    && make && make install \
    && rm -rf $APP_DIR/gdal${GDAL_VERSION//.}.zip $APP_DIR/gdal-$GDAL_VERSION

ENV GDAL_DATA $APP_DIR/local/lib/gdal
ENV GDAL_CONFIG $APP_DIR/local/bin/gdal-config
