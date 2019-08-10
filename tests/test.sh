echo
echo "gdal test examples"
geotiff=/data/tests/data/test_tmp.tif
echo "Reading raster metadata from: ${geotiff}"
gdalinfo $geotiff

echo
echo "proj examples"
# https://proj.org/usage/index.html
# https://proj.org/usage/quickstart.html
echo 55.2 12.2 | proj +proj=merc +lat_ts=56.5 +ellps=GRS80
echo 3399483.80 752085.60 | cs2cs +proj=merc +lat_ts=56.5 +ellps=GRS80 +to +proj=utm +zone=32
echo 56 12 | cs2cs +init=epsg:4326 +to +init=epsg:25832
ls -l $PROJ_LIB/proj.db
echo

echo
echo "python test examples"
python3 /data/tests/test.py
echo

