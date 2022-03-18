clear variables; close all; clc 
%Extract strong ground track LiDAR data (Latitude, Longitude, Ellipsoidal Height) from ICESat-2 ALT03 HDF5 file as .CSV files and run 
%the conversion from ellipsoid to orthometric datum. The tool GPS-H from the Canadian 
%Hydrographic Survey was used for this code (Transformation from ITRF2014 to CGVD2013), however it is recommended to 
%convert the data to the orthometric model which best fits your study area. The following refraction correction has been adapted 
%for MATLAB from equations validated by Parrish, C., Magruder, L., Neuenschwander, A., Forfinski-Sarkozi, N., Alonzo, M., Jasinski, M. 2019. 
%"Validation of ICESat-2 ATLAS Bathymetry and Analysis of ATLASs Bathymetric Mapping Performance" Remote Sensing 11, no. 14: 1634.
% https://doi.org/10.3390/rs11141634

LOC = [csvread('GPS_H\GT1L_Ortho.csv',1,0); ... 
 csvread('GPS_H\GTL2_Ortho.csv',1,0); ... 
 csvread('GPS_H\GTL3_Ortho.csv',1,0) ]; 
azi = -2.122217210653705; %This is average of ref_azi from the ICESat-2 ATL03 HDF5 file 
elev = 1.563192527542595; %average ref_elev from hf ICESat-2 ATL03 HDF5 file 

% A little less storage-efficient, but MUCH more readable (You who dare repeat this process). 

lat = LOC(:,1); 
lon = LOC(:,2); 
h = LOC(:,3); 

theta1 = pi/2 - elev; 
kappa = azi; 
n1 = 1.00029; %n1 and n2 are the refractive indices of air and water 
n2 = 1.343; 

theta2 = asin( n1*sin(theta1) / n2 ); 
S = h / cos(theta1); 
R = S*n1/n2; 
gamma = pi/2 - theta1; 
P = sqrt( R.^2 + S.^2 - 2*R.*S*cos(theta1-theta2) ); 
alpha = asin( R*sin( theta1-theta2 ) ./ P); 
beta = gamma - alpha; 

horzoff = P.*cos(beta); % delta Y in the paper 
vertoff = P.*sin(beta); % delta Z in the paper 

latoff = horzoff*cos(kappa); % delta N in the paper 
lonoff = horzoff*sin(kappa); % delta E in the paper 

lat = lat + latoff; 
lon = lon + lonoff; 
h = h + vertoff; 
%Save output raster (Bathymetric LiDAR Data) as refcorr.txt and continue to the
%Collocation document. 
