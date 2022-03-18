# ICESat-2-Satellite-Derived-Bathymetry-using-Landsat-8-data
Code to process ICESat-2 ATL03 photon returns into refraction corrected bathymetry and collocate the data to reflectance values from Landsat 8 multispectral data (Processed in the SeaDAS program) to interpolate depth in optically shallow water. 
Programs needed to complete this code include but are not limited to: 
- Access to data downloads from the National Snow and Ice Data Center (ICESat-2 ATL03) and the USGS Earth Explorer (Landsat 8 OLI). 
- SEADas program published by NASA to process ocean color reflectance data. Other studies have used Accolite, however this program is not reccommended for processing multi-spectral data at highter latitudes. 
- GPS-H datum conversion tool published by the Canadian Hydrographic Service or another datum conversion tool (Ellipsoid to orthometric conversion) fixed to your study area. V-Datum provided by NOAA is a good tool for processing data collected in the continental US. Orthometric data layers for Alaska have yet to be included in that program as of 2022 however NOAA is actively working to include these datasets in the next update. 
- MATLAB to run the the refraction, collocation, and SDB algorithms. 
- The algorithms for refraction correction have been adapted for MATLAB from equations validated by Parrish, C., Magruder, L., Neuenschwander, A., Forfinski-Sarkozi, N., Alonzo, M., Jasinski, M. 2019. "Validation of ICESat-2 ATLAS Bathymetry and Analysis of ATLASs Bathymetric Mapping Performance" Remote Sensing 11, no. 14: 1634.
https://doi.org/10.3390/rs11141634
For more information regarding the methodology and study area used to derive this code, please reference the thesis document included in the GITHUB repository. 
Contact: Natalie Treadwell natalie@treadwellalaska.com
