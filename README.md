# amazonlinux-gdal:2.5.0dev-light

Create an **AWS lambda** like docker image with python 3.6 and GDAL.

Inspired from [developmentseed/geolambda](https://github.com/developmentseed/geolambda) and [mojodna/lambda-layer-rasterio](https://github.com/mojodna/lambda-layer-rasterio).

#### Versions
- Python: **3.6.5**
- GDAL: **2.5.0 dev** (GDAL commit [319c1ea20b1](https://github.com/OSGeo/gdal/commit/319c1ea20b10d7501e95ad2dcbb4b6a25fa15fa7) - 24 Jan 2019)

#### Drivers
- Proj4 (*5.2.0*)
- GEOS (*3.7.1*)
- GeoTIFF (internal)
- ZSTD (*1.3.8*)
- WEBP (*1.0.1*)
- JPEG2000 (OpenJPEG *2.3.0*)

### Build
```bash
$ docker login

$ docker build -f Dockerfile --tag amazonlinux-gdal:2.5.0dev-light .

$ docker run --name amazonlinux \
	--volume $(shell pwd)/:/data \
	--rm -it amazonlinux-gdal:2.5.0dev-light /bin/bash
```

See [`/Makefile`](/Makefile) for other pre-defined commands.

## Use it on from DockerHub
```
FROM remotepixel/amazonlinux-gdal:2.5.0dev-light
```
