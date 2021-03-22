%% Fig.3 thresholds
function PlotFig3(lon, lat, thresholds)
% color = load('D:\Research\Colormaps\GMT_drywet.txt');
color = flipud(parula);
% color = load('myjet.txt');
% color = load('WhiteBlueGreenYellowRed.txt');
% color = color./255;
sub_row = 4;
sub_col = 4;
% [lons, lats] = meshgrid(lon, lat);
name = ['DJF';'MAM';'JJA';'SON'];
sub = {'(a)','(b)','(c)', '(d)'};


figure
hold on
set(gcf,'pos',[10 10 670 800])
for i = 1:2
subplot(2,2,i)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4,'fontsize',12)
m_contourf(lon, lat, squeeze(thresholds(:,:,i))',...
                'linestyle','none', 'levelstep',2);
m_text(-84+360, 25.15, sub( i), 'fontsize',14);
m_coast('color','k');
caxis([16 36])
colormap(color)
c =colorbar;
set(c,'fontsize',12, 'ytick',16:2:36)
title(c, 'mm day^{-1}','fontsize',14)
title(name(i,:),'fontsize',14,'fontweight','bold');
RemoveSubplotWhiteArea(gca, 2, 2, 1, i);
end
for i = 3:4
subplot(2,2,i)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4,'fontsize',12)
m_contourf(lon, lat, squeeze(thresholds(:,:,i))',...
                'linestyle','none', 'levelstep',2);
m_text(-84+360, 25.15, sub( i), 'fontsize',14);
m_coast('color','k');
caxis([16 36])
colormap(color)
c =colorbar;
set(c,'fontsize',12, 'ytick',16:2:36)
title(c, 'mm day^{-1}','fontsize',14)
title(name(i,:),'fontsize',14,'fontweight','bold');
RemoveSubplotWhiteArea(gca, 2, 2, 2, i-2);
end
