function [DJF, JJA] = BGetSeason
datadir = 'C:\Files\Research\Misra_Extreme Precip\BeckerData';
JAN = zeros(300, 120, 31, 27);
FEB = zeros(300, 120, 29, 27);
JJA = zeros(300, 120, 92, 27);
DEC = zeros(300, 120, 31, 27);
for i = 1979:2005
    file = fullfile(datadir, ['precip.V1.0.', num2str(i),'.nc']);
    precip = ncread(file, 'precip');% 300*120*365 or 366
    nd = size(precip, 3);

    if nd == 365
        len = 28;
        FEB(:,:,1:28, i-1978) = precip(:,:,32:32+len-1);
        FEB(:,:,29,i-1978) = NaN;
    else
        len = 29;
        FEB(:,:,:, i-1978) = precip(:,:,32:32+len-1);
    end
    JAN(:,:,:, i-1978) = precip(:,:,1:31);
    JJA(:,:,:, i-1978) = precip(:,:,124+len : 185+len+31-1);
    DEC(:,:,:, i-1978) = precip(:,:,307+len : 307+len+31-1);
end

file    = fullfile(datadir, 'precip.V1.0.2006.nc');
pre2006 = ncread(file, 'precip');
JAN2006 = pre2006(:,:,1:31);
FEB2006 = pre2006(:,:,32:59);
JAN(:,:,:,1:end-1) = JAN(:,:,:,2:end);
JAN(:,:,:,end)     = JAN2006;
FEB(:,:,:,1:end-1) = FEB(:,:,:,2:end);
FEB(:,:,1:28,end)  = FEB2006; FEB(:,:,29,end) = NaN;

DJF = zeros(300, 120, 91, 27);
for i = 1:27
    DJF(:,:,:,i) = cat(3, DEC(:,:,:,i), JAN(:,:,:,i), FEB(:,:,:,i));
end
DJF(DJF<0) = NaN;
JJA(JJA<0) = NaN;
end