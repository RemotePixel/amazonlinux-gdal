# amazonlinux-gdal:3.0.0

Create an **AWS lambda** like docker image with python 3.7 and GDAL.

Inspired from [developmentseed/geolambda](https://github.com/developmentseed/geolambda) and [mojodna/lambda-layer-rasterio](https://github.com/mojodna/lambda-layer-rasterio).

#### Versions
- Python: **3.7.3**
- GDAL: **3.0.0** https://github.com/OSGeo/gdal/releases/tag/v3.0.0

#### Drivers
- Proj (*6.1.1*)
- GEOS (*3.7.2*)
- GeoTIFF (internal)
- ZSTD (*1.4.0*)
- WEBP (*1.0.2*)
- ngHTTP2 (*1.35.1*)
- curl (*7.59.0*)
- PNG (*1.6.36*)
- JPEGTURBO (*2.0.1*)
- JPEG2000 (OpenJPEG *2.3.1*)

### Build
```bash
$ docker login

$ docker build -f Dockerfile --tag amazonlinux-gdal:3.0.0 .

$ docker run --name amazonlinux \
	--volume $(shell pwd)/:/data \
	--rm -it amazonlinux-gdal:3.0.0 /bin/bash
```

See [`/Makefile`](/Makefile) for other pre-defined commands.

## Use it on from DockerHub
```
FROM remotepixel/amazonlinux-gdal:3.0.0
```
