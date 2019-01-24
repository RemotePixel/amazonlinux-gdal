# amazonlinux-gdal:2.4.0

Create an **AWS lambda** like docker image with python 3.6 and GDAL.

Inspired from [developmentseed/geolambda](https://github.com/developmentseed/geolambda) and [mojodna/lambda-layer-rasterio](https://github.com/mojodna/lambda-layer-rasterio).

#### Versions
- Python: **3.6.5**
- GDAL: **2.4.0** https://github.com/OSGeo/gdal/releases/tag/v2.4.0

#### Drivers
- Proj4 (*5.2.0*)
- GEOS (*3.7.1*)
- GeoTIFF (internal)
- ZSTD (*1.3.8*)
- WEBP (*1.0.1*)
- ngHTTP2 (*1.35.1*)
- curl (*7.59.0*)
- JPEGTURBO (*2.0.1*)
- JPEG2000 (OpenJPEG *2.3.0*)

### Build
```bash
$ docker login

$ docker build -f Dockerfile --tag amazonlinux-gdal:2.4.0 .

$ docker run --name amazonlinux \
	--volume $(shell pwd)/:/data \
	--rm -it amazonlinux-gdal:2.4.0 /bin/bash
```

See [`/Makefile`](/Makefile) for other pre-defined commands.

## Use it on from DockerHub
```
FROM remotepixel/amazonlinux-gdal:2.4.0
```
