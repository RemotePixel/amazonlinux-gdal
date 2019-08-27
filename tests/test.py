import json

from pathlib import Path

import numpy
import pycrs
import pyproj
import rasterio
import shapely


def raster_metadata(geotiff: str):
    """use rasterio to get GeoTIFF metadata"""

    src = rasterio.open(geotiff)

    meta_data = {
        "src": geotiff,
        "shape": src.shape,  # (height, width)
        "width": src.width,
        "height": src.height,
        "bounds": {
            "left": src.bounds.left,
            "right": src.bounds.right,
            "bottom": src.bounds.bottom,
            "top": src.bounds.top,
        },
        "crs_proj4": src.crs.to_proj4(),
        "crs_esri_wkt": src.crs.to_wkt(morph_to_esri_dialect=True),
        "crs_ogc_wkt": src.crs.to_wkt(morph_to_esri_dialect=False),
        # https://github.com/sgillies/affine#usage-with-gis-data-packages
        # Use this in Affine.from_gdal(*src.transform.to_gdal())
        # to_gdal -> (x_offset, x_rotation, x_pixel_size, y_offset, y_rotation, y_pixel_size)
        "gdal_geo_transform": src.transform.to_gdal()
    }

    return meta_data


if __name__ == '__main__':

    geotiff = Path(__file__).parent / "data" / "test_tmp.tif"
    print("Reading raster metadata from:", geotiff)
    meta_data = raster_metadata(str(geotiff))
    print( json.dumps(meta_data) )

