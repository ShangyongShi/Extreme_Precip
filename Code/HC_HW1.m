% ====== Homework 1 for Hydroclimatology ======
% Dataset: NCEP CPC (Xie et al. 2007 and Chen et al. 2008), 0.5*0.5, 
% 1979.1.1 - 2018.3.22 [Daily] over Peninsular Florida over land only
% 1) Calculate the seasonal mean climatology and its standard deviation of
%    rainfall for DJF, MAM, JJA and SON;
% 2) Compute skewness and kurtosis for above.
%
% Shangyong Shi
% 2019.1.16

file = 'CPC79_18prFl.nc';
lon  = ncread(file, 'lon');
lat  = ncread(file, 'lat');
precip = ncread(file, 'precip');

%%
pre_mon = zeros(10, 14, 39, 12);
ystart = 1;
for i = 1979:2017
    flag = mod(i, 4); 
    if flag == 0  % Leap year, 366 days
        ylen(i-1978) = 366;
        pre_mon(:,:,i-1978,:) = get_monthly_mean(precip(:,:,ystart:ystart+ylen(i-1978)-1));
        ystart = ystart + ylen(i-1978);     
    else % Common year, 365 days
        ylen(i-1978) = 365;
        pre_mon(:,:,i-1978,:) = get_monthly_mean(precip(:,:,ystart:ystart+ylen(i-1978)-1));
        ystart = ystart + ylen(i-1978);
    end
end
% pre_mon(:,:,29,2)   2007.Feb??
pre_mon(:,:,29,2) = 0;
pre2018 = precip(:,:,ystart:end);
jan2018 = mean(pre2018(:,:,1:31),3);
feb2018 = mean(pre2018(:,:,32:60),3);

% MAM
MAMs = mean(pre_mon(:,:,:,3:5), 4);
avg_MAM  = mean(MAMs, 3);
JJAs = mean(pre_mon(:,:,:,6:8), 4);
avg_JJA  = mean(JJAs, 3);
SONs = mean(pre_mon(:,:,:,9:11), 4);
avg_SON  = mean(SONs, 3);

% DJF
DJFs = zeros(10, 14, 39);
DJFs(:,:,1:end-1) = (pre_mon(:,:,1:end-1,12)+pre_mon(:,:,2:end, 1)...
                    +pre_mon(:,:,2:end, 2))/3;  %1979-2016
DJFs(:,:,end) = (squeeze(pre_mon(:,:,end,12))+jan2018+feb2018)/3.0;
avg_DJF = mean(DJFs, 3);

std_DJF = std(DJFs, 1, 3);
std_MAM = std(MAMs, 1, 3);
std_JJA = std(JJAs, 1, 3);
std_SON = std(SONs, 1, 3);

kur_DJF = kurtosis(DJFs, 1, 3);
kur_MAM = kurtosis(MAMs, 1, 3);
kur_JJA = kurtosis(JJAs, 1, 3);
kur_SON = kurtosis(SONs, 1, 3);

ske_DJF = skewness(DJFs, 1, 3);
ske_MAM = skewness(MAMs, 1, 3);
ske_JJA = skewness(JJAs, 1, 3);
ske_SON = skewness(SONs, 1, 3);

%%
color = load('WhiteBlueGreenYellowRed.txt');
color = color./255;

% colorwet = load('CBR_wet2.txt');
% colorwet = colorwet./255;
% color2 = load('perc2_9lev.txt');
% color2 = color2./255;
% color1 = flipud(color2);
sub_row = 4; sub_col = 4;

figure
set(gcf,'pos',[10 10 900 1000])
hold on
% subplot(4,4,1)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, avg_DJF','linestyle','none', 'levelstep',0.5);
caxis([-0.5 8])
colormap(color)
title('DJF')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, 1);

subplot(4,4,2)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, avg_MAM','linestyle','none', 'levelstep',0.5);
caxis([-0.5 8])
colormap(color)
title('MAM')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, 2);


subplot(4,4,3)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, avg_JJA','linestyle','none', 'levelstep',0.5);
caxis([-0.5 8])
colormap(color)
title('JJA')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, 3);


subplot(4,4,4)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, avg_SON','linestyle','none', 'levelstep',0.5);
caxis([-0.5 8])
colormap(color)
title('SON')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, 4);

% Standard deviation
subplot(4,4,5)
% figure
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, std_DJF','linestyle','none', 'levelstep',0.25);
caxis([-0.5 8])
colormap(color);
title('Std')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, 1);

subplot(4,4,6)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, std_MAM','linestyle','none', 'levelstep',0.25);
caxis([-0.5 8])
colormap(color);
title('Std')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, 2);


subplot(4,4,7)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, std_JJA','linestyle','none', 'levelstep',0.25);
caxis([-0.5 8])
colormap(color);
title('Std')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, 3);

subplot(4,4,8)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, std_SON','linestyle','none', 'levelstep',0.25);
caxis([-0.5 8])
colormap(color)
title('Std')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, 4);

subplot(4,4,9)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, ske_DJF','linestyle','none','levelstep',0.25);
caxis([-0.5 8])
colormap(color);
title('Skewness')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 3, 1);

subplot(4,4,10)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, ske_MAM','linestyle','none','levelstep',0.25);
caxis([-0.5 8])
colormap(color);
title('Skewness')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 3, 2);


subplot(4,4,11)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, ske_JJA','linestyle','none','levelstep',0.25);
caxis([-0.5 8])
colormap(color);
title('Skewness')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 3, 3);

subplot(4,4,12)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, ske_SON','linestyle','none','levelstep',0.25);
caxis([-0.5 8])
colormap(color);
title('Skewness')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 3,4);


subplot(4,4,13)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, kur_DJF','linestyle','none','levelstep',0.5);
caxis([-0.5 8])
colormap(color)
title('Kurtosis')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 4, 1);

subplot(4,4,14)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, kur_MAM','linestyle','none','levelstep',0.5);
caxis([-0.5 8])
colormap(color)
title('Kurtosis')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 4, 2);


subplot(4,4,15)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, kur_JJA','linestyle','none','levelstep',0.5);
caxis([-0.5 8])
colormap(color)
title('Kurtosis')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 4, 3);

subplot(4,4,16)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, kur_SON','linestyle','none','levelstep',0.5);
caxis([-0.5 8])
colormap(color)
title('Kurtosis')
% RemoveSubplotWhiteArea(gca, sub_row, sub_col, 4,4);

h = colorbar('ticks',-0.5:0.5:10);
% set(h, 'pos', [0.96,0.07 0.02 0.85])
set(h,'location','southoutside','orientation','horizontal')
set(h, 'pos', [0.16,0.05 0.72 0.02])
