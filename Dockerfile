FROM amazonlinux:latest

RUN yum update -y && yum upgrade -y

# Install apt dependencies
RUN yum install gcc gcc-c++ freetype-devel yum-utils findutils openssl-devel -y
RUN yum groupinstall development -y
RUN yum install libjpeg-devel libpng-devel libcurl-devel -y
RUN yum install zlib-devel sqlite-devel.x86_64 liblzma-dev wget zip unzip tar gzip libtool cmake -y

RUN yum install libmpc-devel mpfr-devel gmp-devel -y

ENV APP_DIR /tmp/app
RUN mkdir $APP_DIR

ENV GCC_VERSION=5.5.0
RUN cd $APP_DIR \
  && curl -o "gcc-${GCC_VERSION}.tar.gz" https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz \
  && tar xvzf "gcc-${GCC_VERSION}.tar.gz" \
  && cd gcc-${GCC_VERSION} \
  && ./configure --with-system-zlib --disable-multilib --enable-languages=c,c++ \
  && make -j 8 && make install \
  && make clean \
  && rm -rf $APP_DIR/gcc-${GCC_VERSION} $APP_DIR/gcc-${GCC_VERSION}.tar.gz

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

RUN curl https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tar.xz | tar -xJ \
    && cd Python-3.6.1 \
    && ./configure --prefix=/usr/local --enable-shared \
    && make \
    && make install \
    && cd .. \
    && rm -rf Python-3.6.1

# Some python modules needs numpy (sources) and cython
RUN pip3 install pip -U
RUN pip3 install cython numpy --no-binary numpy

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
  && rm -rf $APP_DIR/geos-$GEOS_VERSION $APP_DIR/geos-$GEOS_VERSION.tar.bz2

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

ENV WEBP_VERSION 0.6.1
RUN cd $APP_DIR\
    && curl -f -L -O https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-${WEBP_VERSION}.tar.gz \
    && tar xzf libwebp-${WEBP_VERSION}.tar.gz \
    && cd libwebp-${WEBP_VERSION} \
    && CFLAGS="-O2 -Wl,-S" ./configure --prefix=$APP_DIR/local/ \
    && make \
    && make install \
    && make clean \
    && rm -rf $APP_DIR/libwebp-${WEBP_VERSION}  $APP_DIR/libwebp-${WEBP_VERSION}.tar.gz

ENV ZSTD_VERSION 1.3.4
RUN cd $APP_DIR \
  && wget https://github.com/facebook/zstd/archive/v${ZSTD_VERSION}.tar.gz \
  && tar -zvxf v${ZSTD_VERSION}.tar.gz \
  && cd zstd-${ZSTD_VERSION} \
  && make PREFIX=$APP_DIR/local/ ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1 \
  && make install PREFIX=$APP_DIR/local/ ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1 \
  && make clean \
  && rm -rf $APP_DIR/v${ZSTD_VERSION}.tar.gz $APP_DIR/zstd-${ZSTD_VERSION}


ENV GDAL_VERSION 2.3.0
RUN cd $APP_DIR \
  && wget https://github.com/OSGeo/gdal/archive/v${GDAL_VERSION}.zip \
  && unzip v${GDAL_VERSION}.zip

ENV PATH=$APP_DIR/local/bin:$PATH
ENV LD_LIBRARY_PATH=$APP_DIR/local/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=$APP_DIR/local/lib/pkgconfig/

RUN cd $APP_DIR/gdal-$GDAL_VERSION/gdal \
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
    && make && make install \
    && rm -rf $APP_DIR/v${GDAL_VERSION}.zip

RUN cd $APP_DIR/gdal-$GDAL_VERSION/gdal \
  && g++ -std=c++11 -Wall -fPIC port/vsipreload.cpp -shared -o $APP_DIR/vsipreload.so -Iport -L. -L.libs -lgdal

ENV GDAL_DATA $APP_DIR/local/share/gdal
ENV PROJ_LIB $APP_DIR/local/share/proj
ENV GDAL_CONFIG $APP_DIR/local/bin/gdal-config
ENV GEOS_CONFIG $APP_DIR/local/bin/geos-config
