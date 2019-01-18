# amazonlinux-gdal

Create amazonlinux docker image with python 3.6 and GDAL (see :point_down: from version)

Inspired from [developmentseed/geolambda](https://github.com/developmentseed/geolambda)

### GDAL Versions
- **master** (HEAD - Nov 2018) https://github.com/RemotePixel/amazonlinux-gdal/tree/gdalmaster
- **2.4.0** : https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.4.0
- **2.3.1** : https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.3.1
- **2.3.0** : https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.3.0
- **2.2.2** : https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.2.2

### Version

- OS: **Amazon Linux AMI**
```
$ cat /etc/*-release
NAME="Amazon Linux AMI"
VERSION="2018.03"
ID="amzn"
ID_LIKE="rhel fedora"
VERSION_ID="2018.03"
PRETTY_NAME="Amazon Linux AMI 2018.03"
ANSI_COLOR="0;33"
CPE_NAME="cpe:/o:amazon:linux:2018.03:ga"
HOME_URL="http://aws.amazon.com/amazon-linux-ami/"
Amazon Linux AMI release 2018.03
```

- Python **3.6.5** | pip **18.0**
- Lightweight GDAL **2.4.0** with minimal support [more info](https://trac.osgeo.org/gdal/wiki/BuildingOnUnixWithMinimizedDrivers#no1)
  - Proj4 (*5.2.0*)
  - GEOS (*3.6.2*)
  - GeoTIFF
  - ZSTD (*1.3.8*)
  - WEBP (*1.0.1*)
  - :warning: HTTP2 (*1.35.1*)
  - curl (*7.59.0*)
  - JPEGTURBO (*2.0.1*)
  - JPEG2000 (OpenJPEG *2.3.0*) [see Even Rouault announcement](https://erouault.blogspot.ca/2017/10/optimizing-jpeg2000-decoding.html)

### Environment

- GDAL installation inside `/tmp/app/local`

```bash
APP_DIR=/tmp/app #Custom variable to point to the custom GDAL installation

PATH=$APP_DIR/local/bin:$PATH
LD_LIBRARY_PATH=$APP_DIR/local:/usr/local/lib:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=$APP_DIR/local/lib:$LD_LIBRARY_PATH
PKG_CONFIG_PATH=$APP_DIR/local/lib/pkgconfig/

GDAL_DATA=$APP_DIR/local/share/gdal
PROJ_LIB=$APP_DIR/local/share/proj
GDAL_CONFIG=$APP_DIR/local/bin/gdal-config
GEOS_CONFIG=$APP_DIR/local/bin/geos-config
```

### Use (create a lambda package)

```Dockerfile
FROM remotepixel/amazonlinux-gdal:2.3.0

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
