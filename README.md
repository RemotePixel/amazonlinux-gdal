# amazonlinux-gdal

Create amazonlinux docker image with python 3.6 and GDAL 2.3.1

Note:
- another version with gdal2.2.2 is also available: https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.2.2
- update to gdal 2.3.1 is inspired from [developmentseed/geolambda](https://github.com/developmentseed/geolambda)

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
- Lightweight GDAL **2.3.1** with minimal support [more info](https://trac.osgeo.org/gdal/wiki/BuildingOnUnixWithMinimizedDrivers#no1)
  - Proj4 (*5.1.0*)
  - GEOS (*3.6.2*)
  - GeoTIFF
  - ZSTD (*1.3.4*)
  - WEBP (*0.6.1*)
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
RUN cd $APP_DIR/local && zip -r9q /tmp/package.zip share
```

To makes everything works fine you need to set those env variable in AWS Lambda
- `GDAL_DATA=/var/task/share/gdal/`
- `PROJ_LIB=/var/task/share/proj/`
