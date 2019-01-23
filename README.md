# amazonlinux-gdal

Create amazonlinux docker image with python 3.6 and GDAL (see :point_down: from version)

Inspired from [developmentseed/geolambda](https://github.com/developmentseed/geolambda) amnd [mojodna/lambda-layer-rasterio](https://github.com/mojodna/lambda-layer-rasterio)

### GDAL Versions
- **2.4.0** : https://github.com/OSGeo/gdal/releases/tag/v2.4.0

- Python **3.6.5** | pip **18.0**
- Lightweight GDAL with minimal support [more info](https://trac.osgeo.org/gdal/wiki/BuildingOnUnixWithMinimizedDrivers#no1)
  - Proj4 (*5.2.0*)
  - GEOS (*3.7.1*)
  - GeoTIFF
  - ZSTD (*1.3.8*)
  - WEBP (*1.0.1*)
  - ngHTTP2 (*1.35.1*)
  - curl (*7.59.0*)
  - JPEGTURBO (*2.0.1*)
  - JPEG2000 (OpenJPEG *2.3.0*) [see Even Rouault announcement](https://erouault.blogspot.ca/2017/10/optimizing-jpeg2000-decoding.html)

### Environment

- GDAL installation inside `/opt`

```bash
PREFIX=/opt #Custom variable to point to the custom GDAL installation

PATH=$PREFIX/bin:$PATH
PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig/

GDAL_DATA=$PREFIX/share/gdal
PROJ_LIB=$PREFIX/share/proj
GDAL_CONFIG=$PREFIX/bin/gdal-config
GEOS_CONFIG=$PREFIX/bin/geos-config
```

### Use (create a lambda package)

```Dockerfile
FROM remotepixel/amazonlinux-gdal:2.4.0

RUN pip3 install rasterio --no-binary rasterio -t /tmp/vendored

# Archive python modules
RUN cd /tmp && zip -r9q /tmp/package.zip vendored/*

# Archive GDAL shared libraries
RUN cd $APP_DIR/local && zip -r9q --symlinks /tmp/package.zip lib/*.so*
RUN cd $APP_DIR/local && zip -r9q --symlinks /tmp/package.zip lib64/*.so*
RUN cd $APP_DIR/local && zip -r9q /tmp/package.zip share
```

Complete example can be found in https://github.com/RemotePixel/remotepixel-tiler/blob/8b53422d05bc67d034330491b00e887533446a84/Dockerfile#L32-L42

To makes everything works fine you need to set those env variable in AWS Lambda
- `GDAL_DATA=/var/task/share/gdal/`
- `PROJ_LIB=/var/task/share/proj/`
