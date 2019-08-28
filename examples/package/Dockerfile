FROM remotepixel/amazonlinux:gdal3.0-py3.7

# Create a package
# The package will always have rasterio shapely numpy
# PREFIX is set to be /opt
COPY handler.py $PREFIX/python/handler.py
RUN pip install mercantile