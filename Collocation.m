%This collocation process uses ICESat-2 ATL03 data that has been preprocessed the
%ICESat2_RefractionCorrection.m process and Landsat-8 OLI reflectance
%values processed with NASA's SEADas and exported as a .nc file. This
%collocation method uses the orthometric mean of the refcorr.txt file for
%each reflectance raster cell. 
clear variables; close all; clc 

LOC = readmatrix('refcorr.txt'); 
idx = LOC(:,3) > 0; 
LOC(idx,:) = []; 
idx = LOC(:,3) < -23; 
LOC(idx,:) = []; 

Info = ncinfo('2020_14_09.nc');% .nc file from SeaDAS 
ncfile = Info.Filename; 
lats = ncread(ncfile,'lat'); 
lons = ncread(ncfile,'lon'); 
lats = lats'; 
lons = lons'; 

Rrs443 = ncread(ncfile,'Rrs_443'); 
Rrs482 = ncread(ncfile,'Rrs_482'); 
Rrs561 = ncread(ncfile,'Rrs_561'); 
Rrs655 = ncread(ncfile,'Rrs_655'); 
Rrs443 = Rrs443'; 
Rrs482 = Rrs482'; 
Rrs561 = Rrs561'; 
Rrs655 = Rrs655'; 

min443 = 0.0023233603215; 
max443 = 0.0136837861662; 
min482 = 0.002054844596; 
max482 = 0.0117353758214; 
min561 = 0.000186953921; 
max561 = 0.0051008600112; 
min655 = -0.0004717842139; 
max655 = 0.0014484306939; 

% Rescaling reflectances based on Seadas info (true data shift) This is
% only necessary if the scale of the reflectance values is changed when
% uploaded to 
a = min(Rrs443,[],'all'); 
b = max(Rrs443,[],'all'); 
Rrs443 = min443 + (Rrs443-a)/(b-a)*(max443-min443); 
a = min(Rrs482,[],'all'); 
b = max(Rrs482,[],'all'); 
Rrs482 = min482 + (Rrs482-a)/(b-a)*(max482-min482); 
a = min(Rrs561,[],'all'); 
b = max(Rrs561,[],'all'); 
Rrs561 = min561 + (Rrs561-a)/(b-a)*(max561-min561); 
a = min(Rrs655,[],'all'); 
b = max(Rrs655,[],'all'); 
Rrs655 = min655 + (Rrs655-a)/(b-a)*(max655-min655); 

%throw out the MANY MANY nans >:/  
idx = isnan(Rrs443); 
lats(idx) = []; 
lons(idx) = []; 
Rrs443(idx) = []; 
Rrs482(idx) = []; 
Rrs561(idx) = []; 
Rrs655(idx) = []; 

fprintf('Loaded and processed reflectance data.\n'); 
%save as collocatedRrsHeights.txt
