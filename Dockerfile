FROM lambdalinux/baseimage-amzn:2017.03-004

RUN yum update -y && yum upgrade -y
RUN yum install -y python36-devel python36-pip
RUN yum clean all

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# install system libraries
RUN yum makecache fast
RUN yum install -y gcc gcc-c++ cmake automake glib2-devel
RUN yum install -y wget tar unzip zip bzip2 gzip findutils yum-utils openssl-devel
RUN yum install -y zlib-devel curl-devel libcurl-devel libjpeg-devel libpng-devel liblzma-dev libmpc-devel mpfr-devel gmp-devel
RUN yum clean all

ENV APP_DIR /tmp/app
RUN mkdir $APP_DIR

# versions of packages
ENV \
  PKGCONFIG_VERSION=0.29.2 \
  PROJ_VERSION=5.1.0 \
  GEOS_VERSION=3.6.2 \
  OPENJPEG_VERSION=2.3.0 \
  WEBP_VERSION=0.6.1 \
  ZSTD_VERSION=1.3.4 \
  GDAL_VERSION=2.3.0

# pkg-config
RUN cd $APP_DIR \
   && wget -q https://pkg-config.freedesktop.org/releases/pkg-config-$PKGCONFIG_VERSION.tar.gz \
   && tar xvf pkg-config-$PKGCONFIG_VERSION.tar.gz \
   && cd pkg-config-$PKGCONFIG_VERSION \
   && ./configure CFLAGS="-O2 -Wl,-S" --prefix=$APP_DIR/local \
   && make && make install && make clean \
   && rm -rf $APP_DIR/pkg-config-$PKGCONFIG_VERSION.tar.gz $APP_DIR/pkg-config-$PKGCONFIG_VERSION

# PROJ
RUN cd $APP_DIR \
   && wget -q http://download.osgeo.org/proj/proj-$PROJ_VERSION.tar.gz \
   && tar -zvxf proj-$PROJ_VERSION.tar.gz \
   && cd proj-$PROJ_VERSION \
   && ./configure CFLAGS="-O2 -Wl,-S" --prefix=$APP_DIR/local \
   && make && make install && make clean \
   && rm -rf $APP_DIR/proj-$PROJ_VERSION.tar.gz $APP_DIR/proj-$PROJ_VERSION

# GEOS
RUN cd $APP_DIR \
  && wget -q http://download.osgeo.org/geos/geos-$GEOS_VERSION.tar.bz2 \
  && tar jxf geos-$GEOS_VERSION.tar.bz2 \
  && cd geos-$GEOS_VERSION \
  && CFLAGS="-O2 -Wl,-S" CXXFLAGS="-O2 -Wl,-S" ./configure --prefix=$APP_DIR/local \
  && make && make install && make clean \
  && rm -rf $APP_DIR/geos-$GEOS_VERSION $APP_DIR/geos-$GEOS_VERSION.tar.bz2

# OPENJPEG
RUN cd $APP_DIR \
  && wget -q https://github.com/uclouvain/openjpeg/archive/v$OPENJPEG_VERSION.tar.gz \
  && tar -zvxf v$OPENJPEG_VERSION.tar.gz \
  && cd openjpeg-$OPENJPEG_VERSION/ \
  && mkdir build \
  && cd build \
  && cmake .. -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$APP_DIR/local \
  && make install && make clean \
  && rm -rf $APP_DIR/openjpeg-$OPENJPEG_VERSION $APP_DIR/v$OPENJPEG_VERSION.tar.gz

# WEBP
RUN cd $APP_DIR\
    && wget -q https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-${WEBP_VERSION}.tar.gz \
    && tar xzf libwebp-${WEBP_VERSION}.tar.gz \
    && cd libwebp-${WEBP_VERSION} \
    && CFLAGS="-O2 -Wl,-S" ./configure --prefix=$APP_DIR/local/ \
    && make && make install && make clean \
    && rm -rf $APP_DIR/libwebp-${WEBP_VERSION} $APP_DIR/libwebp-${WEBP_VERSION}.tar.gz

# ZSTD
RUN cd $APP_DIR \
  && wget -q https://github.com/facebook/zstd/archive/v${ZSTD_VERSION}.tar.gz \
  && tar -zvxf v${ZSTD_VERSION}.tar.gz \
  && cd zstd-${ZSTD_VERSION} \
  && make PREFIX=$APP_DIR/local/ ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1 \
  && make install PREFIX=$APP_DIR/local/ ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1 \
  && make clean \
  && rm -rf $APP_DIR/v${ZSTD_VERSION}.tar.gz $APP_DIR/zstd-${ZSTD_VERSION}

ENV LD_LIBRARY_PATH=$APP_DIR/local/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=$APP_DIR/local/lib/pkgconfig/

# GDAL
RUN cd $APP_DIR \
  && wget -q http://download.osgeo.org/gdal/$GDAL_VERSION/gdal-$GDAL_VERSION.tar.gz \
  && tar -xzvf gdal-$GDAL_VERSION.tar.gz \
  && cd gdal-$GDAL_VERSION \
  && CFLAGS="-O2 -Wl,-S" CXXFLAGS="-O2 -Wl,-S" ./configure \
      --prefix=$APP_DIR/local \
      --with-proj=$APP_DIR/local \
      --with-geos=$APP_DIR/local/bin/geos-config \
      --with-openjpeg \
      --with-webp=$APP_DIR/local \
      --with-zstd=$APP_DIR/local \
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
      --without-xerces \
      --without-xml2 \
    && make && make install && make clean \
    && rm -rf $APP_DIR/gdal-$GDAL_VERSION.tar.gz $APP_DIR/gdal-$GDAL_VERSION

ENV GDAL_DATA=$APP_DIR/local/share/gdal
ENV PROJ_LIB=$APP_DIR/local/share/proj
ENV GDAL_CONFIG=$APP_DIR/local/bin/gdal-config
ENV GEOS_CONFIG=$APP_DIR/local/bin/geos-config

RUN pip-3.6 install pip -U
RUN pip3 install cython numpy --no-binary numpy
