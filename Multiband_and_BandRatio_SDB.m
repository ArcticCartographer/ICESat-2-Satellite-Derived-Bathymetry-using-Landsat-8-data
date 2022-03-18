clear variables; close all; clc 
LOC = readmatrix('collocatedRrsHeights.txt'); 
%[ lat lon h Rrs443 Rrs482 Rrs561 Rrs655 ] 

Info = ncinfo('2020_14_09.nc'); 
ncfile = Info.Filename; 
lats = ncread(ncfile,'lat'); 
lons = ncread(ncfile,'lon'); 
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

% Rescaling reflectances based on Seadas info (true data shift) 

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
fprintf('Loaded, rescaled reflectance values.\n'); 

% % % 3 BAND MULTIBAND – after omitting Rrs 655. 

LOC3band = LOC(:,3:6); 
h = readmatrix('collocatedRrsHeights.txt'); 
rs = size(Rrs443); 
LOC3band = [reshape(h,prod(rs),1), reshape(Rrs443,prod(rs),1),... 
reshape(Rrs482,prod(rs),1), reshape(Rrs561,prod(rs),1)]; 
fun = @(alpha, R) alpha(1) + alpha(2)*log(R(:,1)) + alpha(3)*log(R(:,2))... 
+ alpha(4)*log(R(:,3)); 
[beta, resid, J, covb, mse] = nlinfit( LOC3band(:,2:4), LOC3band(:,1),... 
fun, [1 1 1 1]); 

% % % 2 BAND FIT - using just 482 and 561. 
LOC2band = LOC(:,[3 5 6]); 
LOC2band = [reshape(h,prod(rs),1), ... 
reshape(Rrs482,prod(rs),1), reshape(Rrs561,prod(rs),1)]; 
fun = @(alpha, R) alpha(1) + alpha(2)* log(R(:,1))./log(R(:,2)); 
[beta, resid, J, covb, mse] = nlinfit(LOC2band(:,2:3), LOC2band(:,1),... 
fun, [1 1]);
