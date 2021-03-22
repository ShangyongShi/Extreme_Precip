%% Fig.3 Days removed
function PlotFig4(lon, lat, rm)
% color = load('WhiteBlueGreenYellowRed.txt')./255;
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
color = customcolormap(positions, colors, m);

name = ['DJF';'MAM';'JJA';'SON'];
sub = {'(a)','(b)','(c)', '(d)'};

rm = rm.*100;
rm(rm==0) = NaN;
figure
hold on
set(gcf,'pos',[10 10 670 800])
for i = 1:2
subplot(2,2,i)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4,'fontsize',12);
m_contourf(lon, lat, squeeze(rm(:,:,i))',...
                'linestyle','none', 'levelstep',0.25);
m_coast('color','k');
m_text(-84+360, 25.15, sub( i), 'fontsize',14);
caxis([0 5])
colormap(color)
c = colorbar;
set(c, 'ytick',0:0.5:5,'fontsize',12);
title(c,'%','fontsize',12);
title(name(i,:),'fontsize',14,'fontweight','bold');
RemoveSubplotWhiteArea(gca, 2, 2, 1, i);
end
for i = 3:4
subplot(2,2,i)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(rm(:,:,i))',...
                'linestyle','none', 'levelstep',0.25);
m_coast('color','k');
m_text(-84+360, 25.15, sub( i), 'fontsize',14);
caxis([0 5])
colormap(color)
c = colorbar;
set(c, 'ytick',0:0.5:5,'fontsize',12);
title(c,'%','fontsize',12);
title(name(i,:),'fontsize',14,'fontweight','bold');
RemoveSubplotWhiteArea(gca, 2, 2, 2, i-2);
end
