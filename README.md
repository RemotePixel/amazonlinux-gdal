# amazonlinux-gdal
Create amazonlinux docker image with python 3.6 and GDAL 2.2.2


### Use

```Dockerfile
FROM remotepixel/amazonlinux-gdal:latest

RUN pip3 install rasterio --no-binary rasterio -t /tmp/vendored
...
```
