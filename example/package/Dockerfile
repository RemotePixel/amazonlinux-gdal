FROM remotepixel/amazonlinux:gdal3.0-py37

# Create a package
COPY handler.py $PREFIX/python/handler.py
RUN pip install mercantile

RUN /local/scripts/package.sh