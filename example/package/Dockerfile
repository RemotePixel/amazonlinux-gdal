FROM remotepixel/amazonlinux:gdal3.0-py37

# Create a package
# The package will always have rasterio==1.0.25 shapely numpy
COPY handler.py $PREFIX/python/handler.py
RUN pip install mercantile

RUN /local/scripts/package.sh