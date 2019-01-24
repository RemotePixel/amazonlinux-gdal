# amazonlinux-gdal

Create an **AWS lambda** like docker image with python 3.6 and GDAL.

Inspired from [developmentseed/geolambda](https://github.com/developmentseed/geolambda) and [mojodna/lambda-layer-rasterio](https://github.com/mojodna/lambda-layer-rasterio).

The aim of this repo is to construct docker image to use when creating AWS Lambda package (with python 3.6).

### GDAL Versions
- **2.5.0dev** (HEAD)
  - `Docker:` **remotepixel/amazonlinux-gdal:2.5.0dev**
  - `Github Branch:` [gdal2.5.0dev](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.5.0dev)
- **2.4.0** (14 Dec 2018)
  - `Docker:` **remotepixel/amazonlinux-gdal:2.4.0**
  - `Github Branch:` [gdal2.4.0](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.4.0)

- **2.3.2** (21 Sep 2018)
  - `Docker:` **remotepixel/amazonlinux-gdal:2.3.2**
  - `Github Branch:` [gdal2.3.2](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.3.2)


###### Image with minimal support: `-light` (no HTTP/2, no JPEGTURBO)

- **2.5.0dev** (HEAD)
  - `Docker:` **remotepixel/amazonlinux-gdal:gdal2.5.0dev-light**
  - `Github Branch:` [gdal2.5.0dev-light](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.5.0dev-light)
- **2.4.0** (14 Dec 2018)
  - `Docker:` **remotepixel/amazonlinux-gdal:2.4.0-light**
  - `Github Branch:` [gdal2.4.0-light](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.4.0-light)
- **2.3.2** (21 Sep 2018)
  - `Docker:` **remotepixel/amazonlinux-gdal:2.3.2-light**
  - `Github Branch:` [gdal2.3.2-light](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.3.2-light)


### Available Drivers
- Proj4 (*5.2.0*)
- GEOS (*3.7.1*)
- GeoTIFF (internal)
- ZSTD (*1.3.8*)
- WEBP (*1.0.1*)
- JPEG2000 (OpenJPEG *2.3.0*)
- ngHTTP2 (*1.35.1*) **# Not in -light versions**
- curl (*7.59.0*) **# Not in -light versions**
- JPEGTURBO (*2.0.1*) **# Not in -light versions**

## Use it on from DockerHub
```
FROM remotepixel/amazonlinux-gdal:{TAG}
```

## Create a Lambda package
```bash
docker run --name lambda -itd remotepixel/amazonlinux-gdal:2.4.0 /bin/bash
docker exec -it lambda bash -c 'pip3 install rasterio[s3] --no-binary numpy,rasterio -t /tmp/python -U'
docker exec -it lambda bash -c 'cd /tmp/python; zip -r9q /tmp/package.zip *'
docker exec -it lambda bash -c 'cd /var/task; zip -r9q --symlinks /tmp/package.zip lib/*.so*'
docker exec -it lambda bash -c 'cd /var/task; zip -r9q --symlinks /tmp/package.zip lib64/*.so*' # This step is not needed for `-light` image
docker exec -it lambda bash -c 'cd /var/task; zip -r9q /tmp/package.zip share'
docker cp lambda:/tmp/package.zip package.zip
docker stop lambda
docker rm lambda
```
You can find a more complex example in https://github.com/RemotePixel/remotepixel-tiler/blob/master/Dockerfile


## Create a Lambda layer
`TODO`

## Package architecture and AWS Lambda config
:warning: AWS Lambda will need `GDAL_DATA` to be set to `/var/task/share/gdal` to be able to work :warning:

```
package.zip
  |
  |___ lib/      # Shared libraries (GDAL, PROJ, GEOS...)
  |___ lib64/    # Shared libraries (64bits only)
  |___ share/    # GDAL/PROJ data directories   
  |___ rasterio/
  ....
  |___ other python module
```

##### Using HTTP/2 in AWS Lambda
By default libcurl shipped in AWS Lambda doesn't support http/2, this is why we created the docker images with custom libcurl (compiled with nghttp2). To enable HTTP/2 features in GDAL you'll need to set those differents environment variables:
- **GDAL_HTTP_MERGE_CONSECUTIVE_RANGES:** YES
- **GDAL_HTTP_MULTIPLEX:** YES
- **GDAL_HTTP_VERSION:** 2

more info in https://github.com/RemotePixel/amazonlinux-gdal/issues/7

##### Shared libraries
By default the package will be unarhived in `/var/task/` directory on AWS Lambda. The LD_LIBRARY_PATH is set to look in

`/lib64:/usr/lib64:$LAMBDA_RUNTIME_DIR:$LAMBDA_RUNTIME_DIR/lib:$LAMBDA_TASK_ROOT:$LAMBDA_TASK_ROOT/lib:/opt/lib`

which means it will be able to find any shared libs in `/var/task/lib` but not in `/var/task/lib64` To overcome this the non `-light` version of GDAL have been compiled with `/var/task/lib` and `/var/task/lib64` set as priority shared library path (`-rpath`).

more info in https://github.com/RemotePixel/amazonlinux-gdal/issues/7#issuecomment-457066719


## Optimal AWS Lambda config
- **GDAL_DATA:** /var/task/share/gdal
- **GDAL_CACHEMAX:** 512
- **VSI_CACHE:** TRUE
- **VSI_CACHE_SIZE:** 536870912
- **CPL_TMPDIR:** "/tmp"
- **GDAL_HTTP_MERGE_CONSECUTIVE_RANGES:** YES
- **GDAL_HTTP_MULTIPLEX:** YES
- **GDAL_HTTP_VERSION:** 2
- **GDAL_DISABLE_READDIR_ON_OPEN:** "EMPTY_DIR"
- **CPL_VSIL_CURL_ALLOWED_EXTENSIONS:** ".TIF,.tif,.jp2,.vrt"
