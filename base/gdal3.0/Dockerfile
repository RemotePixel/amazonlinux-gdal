FROM lambci/lambda-base:build

LABEL maintainer="RemotePixel <contact@remotepixel.ca>"
LABEL authors="Vincent Sarago  <vincent.sarago@gmail.com>"

RUN yum makecache fast
RUN yum install -y automake16 libpng-devel nasm

ENV PREFIX /opt
WORKDIR /opt

# versions of packages
ENV \
  LIBPNG_VERSION=1.6.36 \
  LIBJPEG_TURBO_VERSION=2.0.1 \
  OPENJPEG_VERSION=2.3.1 \
  PKGCONFIG_VERSION=0.29.2 \
  WEBP_VERSION=1.0.2 \
  ZSTD_VERSION=1.4.0

# pkg-config
RUN mkdir /tmp/pkg-config \
   && curl -sfL https://pkg-config.freedesktop.org/releases/pkg-config-$PKGCONFIG_VERSION.tar.gz | tar zxf - -C /tmp/pkg-config --strip-components=1 \
   && cd /tmp/pkg-config \
   && CFLAGS="-O2 -Wl,-S" ./configure --prefix=$PREFIX \
   && make -j $(nproc) --silent && make install && make clean \
   && rm -rf /tmp/pkg-config

# png
RUN mkdir /tmp/png \
  && curl -sfL http://prdownloads.sourceforge.net/libpng/libpng-$LIBPNG_VERSION.tar.gz | tar zxf - -C /tmp/png --strip-components=1 \
  && cd /tmp/png \
  && CFLAGS="-O2 -Wl,-S" CXXFLAGS="-O2 -Wl,-S" ./configure --prefix=$PREFIX \
  && make -j $(nproc) --silent && make install && make clean \
  && rm -rf /tmp/png

# openjpeg
RUN mkdir /tmp/openjpeg \
  && curl -sfL https://github.com/uclouvain/openjpeg/archive/v$OPENJPEG_VERSION.tar.gz | tar zxf - -C /tmp/openjpeg --strip-components=1 \
  && cd /tmp/openjpeg \
  && mkdir build && cd build \
  && cmake .. -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PREFIX \
  && make -j $(nproc) install && make clean \
  && rm -rf /tmp/openjpeg

# jpeg_turbo
RUN mkdir /tmp/jpeg \
  && curl -sfL https://github.com/libjpeg-turbo/libjpeg-turbo/archive/${LIBJPEG_TURBO_VERSION}.tar.gz | tar zxf - -C /tmp/jpeg --strip-components=1 \
  && cd /tmp/jpeg \
  && cmake -G"Unix Makefiles" -DCMAKE_INSTALL_PREFIX=$PREFIX . \
  && make -j $(nproc) install && make clean \
  && rm -rf /tmp/jpeg

# webp
RUN mkdir /tmp/webp \
    && curl -sfL https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-${WEBP_VERSION}.tar.gz | tar zxf - -C /tmp/webp --strip-components=1 \
    && cd /tmp/webp \
    && CFLAGS="-O2 -Wl,-S" ./configure --prefix=$PREFIX \
    && make -j $(nproc) --silent && make install && make clean \
    && rm -rf /tmp/webp

# zstd
RUN mkdir /tmp/zstd \
  && curl -sfL https://github.com/facebook/zstd/archive/v${ZSTD_VERSION}.tar.gz | tar zxf - -C /tmp/zstd --strip-components=1 \
  && cd /tmp/zstd \
  && make -j $(nproc) PREFIX=$PREFIX ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1 --silent && make install PREFIX=$PREFIX ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1 && make clean \
  && rm -rf /tmp/zstd

# OSGEO
ENV \
  GEOS_VERSION=3.7.2 \
  GDAL_VERSION=3.0.1 \
  PROJ_VERSION=6.1.1

# proj
RUN mkdir /tmp/proj \
   && curl -sfL http://download.osgeo.org/proj/proj-$PROJ_VERSION.tar.gz | tar zxf - -C /tmp/proj --strip-components=1 \
   && cd /tmp/proj \
   && CFLAGS="-O2 -Wl,-S" CXXFLAGS="-O2 -Wl,-S" ./configure --prefix=$PREFIX \
   && make -j $(nproc) --silent && make install && make clean \
   && rm -rf /tmp/proj

# geos
RUN mkdir /tmp/geos \
  && curl -sfL http://download.osgeo.org/geos/geos-$GEOS_VERSION.tar.bz2 | tar jxf - -C /tmp/geos --strip-components=1 \
  && cd /tmp/geos \
  && CFLAGS="-O2 -Wl,-S" CXXFLAGS="-O2 -Wl,-S" ./configure --prefix=$PREFIX \
  && make -j $(nproc) --silent && make install && make clean \
  && rm -rf /tmp/geos

ENV PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig/

# gdal
RUN mkdir /tmp/gdal \
  && curl -sfL https://github.com/OSGeo/gdal/archive/v${GDAL_VERSION}.tar.gz | tar zxf - -C /tmp/gdal --strip-components=2

RUN cd /tmp/gdal \
  && CFLAGS="-O2 -Wl,-S" CXXFLAGS="-O2 -Wl,-S" ./configure \
      --prefix=$PREFIX \
      --with-proj=$PREFIX \
      --with-geos=$PREFIX/bin/geos-config \
      --with-curl \
      --with-openjpeg \
      --with-png \
      --with-jpeg=$PREFIX \
      --with-webp=$PREFIX \
      --with-zstd=$PREFIX \
      --with-crypto \
      --with-libtiff=internal \
      --with-threads \
      --with-sqlite3 \
      --disable-debug \
      --with-hide-internal-symbols=yes \
      --without-bsb \
      --without-cfitsio \
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
      --without-python \
      --without-qhull \
      --without-sde \
      --without-xerces \
      --without-xml2

RUN cd /tmp/gdal \
  && make -j $(nproc) --silent && make install && make clean \
  && rm -rf /tmp/gdal

# from https://github.com/pypa/manylinux/blob/d8ef5d47433ba771fa4403fd48f352c586e06e43/docker/build_scripts/build.sh#L133-L138
# Install patchelf (latest with unreleased bug fixes)
ENV PATCHELF_VERSION 0.10
RUN mkdir /tmp/patchelf \
  && curl -sfL https://github.com/NixOS/patchelf/archive/$PATCHELF_VERSION.tar.gz | tar zxf - -C /tmp/patchelf --strip-components=1 \
  && cd /tmp/patchelf && ./bootstrap.sh && ./configure \
  && make -j $(nproc) --silent && make install && make clean \
  && cd / && rm -rf /tmp/patchelf

# # Move /lib64 (libjpeg) to /lib
RUN mv $PREFIX/lib64/lib* $PREFIX/lib/

# Set $ORIGIN
RUN cd $PREFIX/lib/ \
  && patchelf --remove-rpath libgdal.so \
  && patchelf --force-rpath --set-rpath '$ORIGIN' ./libgdal.so

ENV \
  GDAL_DATA=$PREFIX/share/gdal \
  PROJ_LIB=$PREFIX/share/proj \
  GDAL_CONFIG=$PREFIX/bin/gdal-config \
  GEOS_CONFIG=$PREFIX/bin/geos-config \
  PATH=$PREFIX/bin:$PATH

RUN yum clean all