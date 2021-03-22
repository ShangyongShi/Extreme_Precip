%% plot original climatology
function PlotFig2(lon, lat, oMON)
color1 = load('GnBu.txt');
color2 = load('blues.txt');
color3 = load('YlOrRd.txt');
color4 = load('reds.txt');

positions = 0:1/9:1;
colors = flipud([
    163 235 233 %b
    109 171 223
    100 100 221 
%g
    39 177 27
    150 218 62
 %y
    255 226 122
    255 169 56
     243 63 18 %r
    199 26 10
    122 16 0])./255;
   
m = 128;
j = customcolormap(positions, colors, m);

% color = load('WhiteBlueGreenYellowRed.txt')./255;

sub_row = 4;
sub_col = 4;
% [lons, lats] = meshgrid(lon, lat);
name = ['DJF';'MAM';'JJA';'SON'];
sub = {'(a)','(b)','(c)', '(d)';...
       '(e)','(f)','(g)', '(h)';...
       '(i)','(j)','(k)', '(l)';...
       '(m)','(n)','(o)', '(p)'};

figure
 set(gcf,'pos',[10 10 920 950])
%--- average
for i = 1:4
hold on
subplot(4,4,i)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(oMON(:,:,1,i))','linestyle','none', 'levelstep',0.5);
m_coast('color','k');
m_text(-84+360, 25.3, sub(1, i), 'fontsize',14);
caxis([0 8])
colormap(gca, j)
colorbar('fontsize',12)
title(name(i,:), 'fontsize',14);
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, i);
end
%--- standard deviation
for i = 1:4
subplot(4,4,i+4)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25]) 
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(oMON(:,:,2,i))','linestyle','none', 'levelstep',0.25);
m_coast('color','k');
m_text(-84+360, 25.3, sub(2, i), 'fontsize',14);
caxis([0 2])
colormap(gca, j)
colorbar('fontsize',12)
title('Std', 'fontsize',14);
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, i);
end
%--- skewness
for i = 1:4
subplot(4,4,i+8)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(oMON(:,:,3,i))','linestyle','none', 'levelstep',0.25);
m_coast('color','k');
m_text(-84+360, 25.3, sub(3, i), 'fontsize',14);
caxis([0 2])
colormap(gca, j)
colorbar('fontsize',12)
title('Skewness', 'fontsize',14);
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 3, i);
end
%--- kurtosis
for i = 1:4
subplot(4,4, i+12)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat,  squeeze(oMON(:,:,4,i))','linestyle','none', 'levelstep',1);
m_coast('color','k');
m_text(-84+360, 25.3, sub(4, i), 'fontsize',14);
caxis([0 8])
colormap(gca, j)
colorbar('fontsize',12)
title('Kurtosis', 'fontsize',14);
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 4, i);
end
