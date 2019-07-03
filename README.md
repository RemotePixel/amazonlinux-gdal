# amazonlinux-gdal

Create an **AWS lambda** like docker image with python 3.6 and GDAL.

Inspired from [developmentseed/geolambda](https://github.com/developmentseed/geolambda) and [mojodna/lambda-layer-rasterio](https://github.com/mojodna/lambda-layer-rasterio).

The aim of this repo is to construct docker image to use when creating AWS Lambda package (with python 3.6).

### GDAL Versions

- **2.4.1** (22 March 2019)
  - `Docker:` **remotepixel/amazonlinux-gdal:2.4.1**
  - `Github Branch:` [gdal2.4.0](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.4.1)

- **2.4.0** (14 Dec 2018)
  - `Docker:` **remotepixel/amazonlinux-gdal:2.4.0**
  - `Github Branch:` [gdal2.4.0](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.4.0)

- **2.3.2** (21 Sep 2018)
  - `Docker:` **remotepixel/amazonlinux-gdal:2.3.2**
  - `Github Branch:` [gdal2.3.2](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.3.2)


###### Image with minimal support: `-light` (no HTTP/2, no JPEGTURBO)


- **2.4.0** (14 Dec 2018)
  - `Docker:` **remotepixel/amazonlinux-gdal:2.4.0-light**
  - `Github Branch:` [gdal2.4.0-light](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.4.0-light)
- **2.3.2** (21 Sep 2018)
  - `Docker:` **remotepixel/amazonlinux-gdal:2.3.2-light**
  - `Github Branch:` [gdal2.3.2-light](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.3.2-light)


##### Deprecated 

- **2.5.0dev** (HEAD)
  - `Docker:` **remotepixel/amazonlinux-gdal:2.5.0dev**
  - `Github Branch:` [gdal2.5.0dev](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.5.0dev)
  - `Docker:` **remotepixel/amazonlinux-gdal:gdal2.5.0dev-light**
  - `Github Branch:` [gdal2.5.0dev-light](https://github.com/RemotePixel/amazonlinux-gdal/tree/gdal2.5.0dev-light)

### Available Drivers (shipped with GDAL)
- Proj4 (*5.2.0*)
- GEOS (*3.7.1*)
- GeoTIFF (internal)
- ZSTD (*1.3.8*)
- WEBP (*1.0.1*)
- JPEG2000 (OpenJPEG *2.3.0*)
- ngHTTP2 (*1.35.1*) **# Not in -light versions**
- curl (*7.59.0*) **# Not in -light versions**
- PNG (*1.6.36*) **# Not in -light versions**
- JPEGTURBO (*2.0.1*) **# Not in -light versions**

**Note:** Drivers like curl and PNG are enabled by default, is using `-light` version, GDAL will use the default libs available on the amazonlinux instance.

### Available drivers

<details>

```
  $ gdalinfo --formats
  Supported Formats:
    VRT -raster- (rw+v): Virtual Raster
    DERIVED -raster- (ro): Derived datasets using VRT pixel functions
    GTiff -raster- (rw+vs): GeoTIFF
    NITF -raster- (rw+vs): National Imagery Transmission Format
    RPFTOC -raster- (rovs): Raster Product Format TOC format
    ECRGTOC -raster- (rovs): ECRG TOC format
    HFA -raster- (rw+v): Erdas Imagine Images (.img)
    SAR_CEOS -raster- (rov): CEOS SAR Image
    CEOS -raster- (rov): CEOS Image
    JAXAPALSAR -raster- (rov): JAXA PALSAR Product Reader (Level 1.1/1.5)
    GFF -raster- (rov): Ground-based SAR Applications Testbed File Format (.gff)
    ELAS -raster- (rw+v): ELAS
    AIG -raster- (rov): Arc/Info Binary Grid
    AAIGrid -raster- (rwv): Arc/Info ASCII Grid
    GRASSASCIIGrid -raster- (rov): GRASS ASCII Grid
    SDTS -raster- (rov): SDTS Raster
    DTED -raster- (rwv): DTED Elevation Raster
    PNG -raster- (rwv): Portable Network Graphics
    JPEG -raster- (rwv): JPEG JFIF
    MEM -raster- (rw+): In Memory Raster
    JDEM -raster- (rov): Japanese DEM (.mem)
    ESAT -raster- (rov): Envisat Image Format
    XPM -raster- (rwv): X11 PixMap Format
    BMP -raster- (rw+v): MS Windows Device Independent Bitmap
    DIMAP -raster- (rov): SPOT DIMAP
    AirSAR -raster- (rov): AirSAR Polarimetric Image
    RS2 -raster- (rovs): RadarSat 2 XML Product
    SAFE -raster- (rov): Sentinel-1 SAR SAFE Product
    ILWIS -raster- (rw+v): ILWIS Raster Map
    SGI -raster- (rw+v): SGI Image File Format 1.0
    SRTMHGT -raster- (rwv): SRTMHGT File Format
    Leveller -raster- (rw+v): Leveller heightfield
    Terragen -raster- (rw+v): Terragen heightfield
    ISIS3 -raster- (rw+v): USGS Astrogeology ISIS cube (Version 3)
    ISIS2 -raster- (rw+v): USGS Astrogeology ISIS cube (Version 2)
    PDS -raster- (rov): NASA Planetary Data System
    PDS4 -raster- (rw+vs): NASA Planetary Data System 4
    VICAR -raster- (rov): MIPL VICAR file
    TIL -raster- (rov): EarthWatch .TIL
    ERS -raster- (rw+v): ERMapper .ers Labelled
    JP2OpenJPEG -raster,vector- (rwv): JPEG-2000 driver based on OpenJPEG library
    L1B -raster- (rovs): NOAA Polar Orbiter Level 1b Data Set
    FIT -raster- (rwv): FIT Image
    RMF -raster- (rw+v): Raster Matrix Format
    WCS -raster- (rovs): OGC Web Coverage Service
    WMS -raster- (rwvs): OGC Web Map Service
    MSGN -raster- (rov): EUMETSAT Archive native (.nat)
    RST -raster- (rw+v): Idrisi Raster A.1
    INGR -raster- (rw+v): Intergraph Raster
    GSAG -raster- (rwv): Golden Software ASCII Grid (.grd)
    GSBG -raster- (rw+v): Golden Software Binary Grid (.grd)
    GS7BG -raster- (rw+v): Golden Software 7 Binary Grid (.grd)
    COSAR -raster- (rov): COSAR Annotated Binary Matrix (TerraSAR-X)
    TSX -raster- (rov): TerraSAR-X Product
    COASP -raster- (ro): DRDC COASP SAR Processor Raster
    R -raster- (rwv): R Object Data Store
    MAP -raster- (rov): OziExplorer .MAP
    KMLSUPEROVERLAY -raster- (rwv): Kml Super Overlay
    WEBP -raster- (rwv): WEBP
    PDF -raster,vector- (w+): Geospatial PDF
    PLMOSAIC -raster- (ro): Planet Labs Mosaics API
    CALS -raster- (rwv): CALS (Type 1)
    WMTS -raster- (rwv): OGC Web Map Tile Service
    SENTINEL2 -raster- (rovs): Sentinel 2
    PNM -raster- (rw+v): Portable Pixmap Format (netpbm)
    DOQ1 -raster- (rov): USGS DOQ (Old Style)
    DOQ2 -raster- (rov): USGS DOQ (New Style)
    PAux -raster- (rw+v): PCI .aux Labelled
    MFF -raster- (rw+v): Vexcel MFF Raster
    MFF2 -raster- (rw+): Vexcel MFF2 (HKV) Raster
    FujiBAS -raster- (rov): Fuji BAS Scanner Image
    GSC -raster- (rov): GSC Geogrid
    FAST -raster- (rov): EOSAT FAST Format
    BT -raster- (rw+v): VTP .bt (Binary Terrain) 1.3 Format
    LAN -raster- (rw+v): Erdas .LAN/.GIS
    CPG -raster- (rov): Convair PolGASP
    IDA -raster- (rw+v): Image Data and Analysis
    NDF -raster- (rov): NLAPS Data Format
    EIR -raster- (rov): Erdas Imagine Raw
    DIPEx -raster- (rov): DIPEx
    LCP -raster- (rwv): FARSITE v.4 Landscape File (.lcp)
    GTX -raster- (rw+v): NOAA Vertical Datum .GTX
    LOSLAS -raster- (rov): NADCON .los/.las Datum Grid Shift
    NTv1 -raster- (rov): NTv1 Datum Grid Shift
    NTv2 -raster- (rw+vs): NTv2 Datum Grid Shift
    CTable2 -raster- (rw+v): CTable2 Datum Grid Shift
    ACE2 -raster- (rov): ACE2
    SNODAS -raster- (rov): Snow Data Assimilation System
    KRO -raster- (rw+v): KOLOR Raw
    ROI_PAC -raster- (rw+v): ROI_PAC raster
    RRASTER -raster- (rw+v): R Raster
    BYN -raster- (rw+v): Natural Resources Canada's Geoid
    ARG -raster- (rwv): Azavea Raster Grid format
    RIK -raster- (rov): Swedish Grid RIK (.rik)
    USGSDEM -raster- (rwv): USGS Optional ASCII DEM (and CDED)
    GXF -raster- (rov): GeoSoft Grid Exchange Format
    NWT_GRD -raster- (rw+v): Northwood Numeric Grid Format .grd/.tab
    NWT_GRC -raster- (rov): Northwood Classified Grid Format .grc/.tab
    ADRG -raster- (rw+vs): ARC Digitized Raster Graphics
    SRP -raster- (rovs): Standard Raster Product (ASRP/USRP)
    BLX -raster- (rwv): Magellan topo (.blx)
    SAGA -raster- (rw+v): SAGA GIS Binary Grid (.sdat, .sg-grd-z)
    XYZ -raster- (rwv): ASCII Gridded XYZ
    HF2 -raster- (rwv): HF2/HFZ heightfield raster
    OZI -raster- (rov): OziExplorer Image File
    CTG -raster- (rov): USGS LULC Composite Theme Grid
    E00GRID -raster- (rov): Arc/Info Export E00 GRID
    ZMap -raster- (rwv): ZMap Plus Grid
    NGSGEOID -raster- (rov): NOAA NGS Geoid Height Grids
    IRIS -raster- (rov): IRIS data (.PPI, .CAPPi etc)
    PRF -raster- (rov): Racurs PHOTOMOD PRF
    RDA -raster- (ro): DigitalGlobe Raster Data Access driver
    EEDAI -raster- (ros): Earth Engine Data API Image
    SIGDEM -raster- (rwv): Scaled Integer Gridded DEM .sigdem
    IGNFHeightASCIIGrid -raster- (rov): IGN France height correction ASCII Grid
    CAD -raster,vector- (rovs): AutoCAD Driver
    PLSCENES -raster,vector- (ro): Planet Labs Scenes API
    NGW -raster,vector- (rw+s): NextGIS Web
    GenBin -raster- (rov): Generic Binary (.hdr Labelled)
    ENVI -raster- (rw+v): ENVI .hdr Labelled
    EHdr -raster- (rw+v): ESRI .hdr Labelled
    ISCE -raster- (rw+v): ISCE raster
    HTTP -raster,vector- (ro): HTTP Fetching Wrapper
```

</details>


## Use it on from DockerHub
```
FROM remotepixel/amazonlinux-gdal:{TAG}
```

### Docker environment variables
A couple environment variables are set when creating the images:

- **PREFIX**: Path where GDAL has been installed, shoud be `/var/task`
- **GDAL_DATA**: `$PREFIX/share/gdal`
- **PROJ_LIB**: `$PREFIX/share/proj`
- **GDAL_CONFIG**: `$PREFIX/bin/gdal-config`
- **GEOS_CONFIG**: `$PREFIX/bin/geos-config`
- **GDAL_VERSION**: version of GDAL
- **PATH** has been updated to add `$PREFIX/bin` in order to access gdal binaries

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
