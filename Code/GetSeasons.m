%% save each month seperately
% DJF: 1979(D)1980(JF)-2017(D)2018(JF), MAM/JJA/SON:1979-2017
% 
function [DJF, MAM, JJA, SON] = GetSeasons(precip)
% precip(precip<=1)=NaN;
[lon, lat,~] = size(precip);
JAN = zeros(lon,lat,31,39);
ystart = 1;
for i = 1979:2017
    flag = mod(i, 4); 
    if flag == 0  % Leap year, 366 days
         ylen(i-1978) = 366; len = 29;
    else % Common year, 365 days
         ylen(i-1978) = 365; len = 28;
    end
    pretmp = precip(:,:,ystart:ystart+ylen(i-1978)-1);
    JAN(:,:,:, i-1978) = pretmp(:,:,1:31);
    MAM(:,:,:, i-1978) = pretmp(:,:,32+len  : 93+len+31-1) ;
    JJA(:,:,:, i-1978) = pretmp(:,:,124+len : 185+len+31-1);
    SON(:,:,:, i-1978) = pretmp(:,:,216+len : 277+len+30-1);
    DEC(:,:,:, i-1978) = pretmp(:,:,307+len : 307+len+31-1);

    FEBtmp = pretmp(:,:,32      : 32+len-1);
    if i == 1979
        FEB = FEBtmp;
        FEBcycle = FEB;
        clear FEB
    else
        FEB = cat(3, FEBcycle, FEBtmp);
        FEBcycle = FEB;
        clear FEB
    end
    clear pretmp
    ystart = ystart + ylen(i-1978);
end
clear flag

FEB = FEBcycle; %clear FEBcycle
pre2018 = precip(:,:,ystart:end); clear precip 
jan2018 = pre2018(:,:,1:31);
feb2018 = pre2018(:,:,32:59);
JAN(:,:,:,1:end-1) = JAN(:,:,:,2:end); 
JAN(:,:,:,end) = jan2018; 

FEB(:,:,1:28)=[];
FEB2 = cat(3,FEB, feb2018);
FEB = FEB2; 

clear FEB2 
clear jan2018 feb2018
clear pre2018

DJF = zeros(10, 14, 91, 39);
fstart = 1;
for i = 1:39
    if(mod(i+1979, 4)==0)
        DJF(:,:,:,i)=cat(3, cat(3, DEC(:,:,:,i), JAN(:,:,:,i)), ....
                              FEB(:,:,fstart:fstart+28));
        fstart = fstart+29;
    else
        DJF(:,:,1:end-1,i)=cat(3, cat(3, DEC(:,:,:,i), JAN(:,:,:,i)), ....
                              FEB(:,:,fstart:fstart+27));
        DJF(:,:,end,i) = nan;
        fstart = fstart+28;
    end
end

clear fstart
clear FEB FEBtmp FEBcycle DEC
end