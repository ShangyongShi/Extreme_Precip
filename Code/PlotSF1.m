%% plot four variables after removing top 5%
function PlotSF1(lon, lat, tMON)
sub_row = 4;
sub_col = 4;
name = ['DJF';'MAM';'JJA';'SON'];
color = load('myjet.txt');
figure
set(gcf,'pos',[10 10 800 1000])
%--- average
for i = 1:4
hold on
subplot(4,4,i)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(tMON(:,:,1,i))','linestyle','none', 'levelstep',0.5);
caxis([-0.5 8])
colormap(color)
colorbar
title(name(i,:))
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, i);
end
%--- standard deviation
for i = 1:4
subplot(4,4,i+4)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(tMON(:,:,2,i))','linestyle','none', 'levelstep',0.1);
caxis([0 2])
colormap(color)
colorbar
title('Std')
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, i);
end
%--- skewness
for i = 1:4
subplot(4,4,i+8)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(tMON(:,:,3,i))','linestyle','none', 'levelstep',0.25);
caxis([-0.5 2])
colormap(color)
colorbar
title('Skewness')
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 3, i);
end
%--- kurtosis
for i = 1:4
subplot(4,4, i+12)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat,  squeeze(tMON(:,:,4,i))','linestyle','none', 'levelstep',0.5);
caxis([-0.5 8])
colormap(color)
colorbar
title('Kurtosis')
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 4, i);
end
