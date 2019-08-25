FROM remotepixel/amazonlinux:gdal3.0-py37

# PACKAGE_PREFIX is REQUIRED
ENV PACKAGE_PREFIX /var/task

# Create a package
COPY handler.py $PACKAGE_PREFIX/handler.py
RUN pip install mercantile -t $PACKAGE_PREFIX/

# Copy only handler.py and mercantile module to the zip file
# Numpy and rasterio will be delivered by the layer
RUN /local/scripts/layer.sh
