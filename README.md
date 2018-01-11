# amazonlinux-gdal

Create amazonlinux docker image with python 3.6 and GDAL 2.2.2

### Version

- Python **3.6.1**
- Lightweight GDAL **2.2.2** with minimal support [more info](https://trac.osgeo.org/gdal/wiki/BuildingOnUnixWithMinimizedDrivers#no1)
  - Proj4 (*4.9.3*)
  - GEOS (*3.6.2*)
  - GeoTIFF
  - Jpeg2000 (OpenJPEG *2.3.0*) [see Even Rouault announcement](https://erouault.blogspot.ca/2017/10/optimizing-jpeg2000-decoding.html)

### Environment

- Python 3.6 installed in `/usr/local`
- GDAL installation inside `/tmp/app/local`

```bash
APP_DIR=/tmp/app #Custom variable to point to the custom GDAL installation

LD_LIBRARY_PATH=$APP_DIR/local:/usr/local/lib:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=$APP_DIR/local/lib:$LD_LIBRARY_PATH
GDAL_DATA=$APP_DIR/local/lib/gdal
GDAL_CONFIG=$APP_DIR/local/bin/gdal-config
```

### Use (create a lambda package)

```Dockerfile
FROM remotepixel/amazonlinux-gdal:latest

RUN pip3 install rasterio --no-binary rasterio -t /tmp/vendored

# Archive python modules
RUN cd /tmp && zip -r9q /tmp/package.zip vendored/*

# Archive GDAL shared libraries
RUN cd $APP_DIR/local && zip -r9q --symlinks /tmp/package.zip lib/*.so*
RUN cd $APP_DIR/local && zip -r9q /tmp/package.zip share
```
