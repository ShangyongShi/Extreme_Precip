function PlotFig5(lon, lat, anom, lb, rb)
color = load('NCV_BlueRed.txt');
[lons, lats] = meshgrid(lon, lat);
sub_row = 4;
sub_col = 4;
name = ['DJF';'MAM';'JJA';'SON'];
sub = {'(a)','(b)','(c)', '(d)';...
       '(e)','(f)','(g)', '(h)';...
       '(i)','(j)','(k)', '(l)';...
       '(m)','(n)','(o)', '(p)'};

% top 5%
figure
set(gcf,'pos',[10 10 900 950])
hold on
for i = 1:4
subplot(4,4,i)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(anom(:,:,1,i))','linestyle','none', 'levelstep',0.25);
m_text(-84+360, 25.3, sub(1, i), 'fontsize',14);     
m_plot(lons(squeeze(anom(:,:,1,i))' >= squeeze(rb(:,:,1,i))'), ...
       lats(squeeze(anom(:,:,1,i))' >= squeeze(rb(:,:,1,i))'), ...
       'k.','markersize',4);
m_plot(lons(squeeze(anom(:,:,1,i))' <= squeeze(lb(:,:,1,i))'), ...
       lats(squeeze(anom(:,:,1,i))' <= squeeze(lb(:,:,1,i))'), ...
       'k.','markersize',4);       
m_coast('color','k');
caxis([-2 2])
colormap(color)
colorbar('fontsize',12)
title(name(i,:), 'fontsize',14);
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1,i);

end
%--- std
for i = 1:4
subplot(4,4,i+4)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])   
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(anom(:,:,2,i))', 'linestyle','none', 'levelstep',0.25);
m_text(-84+360, 25.3, sub(2, i), 'fontsize',14);
m_plot(lons(squeeze(anom(:,:,2,i))' >= squeeze(rb(:,:,2,i))'), ...
       lats(squeeze(anom(:,:,2,i))' >= squeeze(rb(:,:,2,i))'), ...
       'k.','markersize',4);
m_plot(lons(squeeze(anom(:,:,2,i))' <= squeeze(lb(:,:,2,i))'), ...
       lats(squeeze(anom(:,:,2,i))' <= squeeze(lb(:,:,2,i))'), ...
       'k.','markersize',4);
m_coast('color','k');
caxis([-2 2])
colormap(color)
colorbar('fontsize',12)
title('diff\_std', 'fontsize',14);
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2,i);
end

%----skewness
for i = 1:4
subplot(4,4,i+8)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(anom(:,:,3,i))', 'linestyle','none', ...
    'levelstep',0.25);
m_text(-84+360, 25.3, sub(3, i), 'fontsize',14);
m_plot(lons(squeeze(anom(:,:,3,i))' >= squeeze(rb(:,:,3,i))'), ...
       lats(squeeze(anom(:,:,3,i))' >= squeeze(rb(:,:,3,i))'), ...
       'k.','markersize',4);
m_plot(lons(squeeze(anom(:,:,3,i))' <= squeeze(lb(:,:,3,i))'), ...
       lats(squeeze(anom(:,:,3,i))' <= squeeze(lb(:,:,3,i))'), ...
       'k.','markersize',4);       
m_coast('color','k');
caxis([-2 2])
cl =colorbar('fontsize',12);
colormap(color);
set(cl, 'ytick',-6:1:6)
title('diff\_skewness', 'fontsize',14);
RemoveSubplotWhiteArea(gca, sub_row, sub_col,3,i);
end

%----
for i = 1:4
subplot(4,4,i+12)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(anom(:,:,4,i))', 'linestyle','none', ...
    'levelstep',0.5);
m_text(-84+360, 25.3, sub(4, i), 'fontsize',14);
m_plot(lons(squeeze(anom(:,:,4,i))' >= squeeze(rb(:,:,4,i))'), ...
       lats(squeeze(anom(:,:,4,i))' >= squeeze(rb(:,:,4,i))'), ...
       'k.','markersize',4);
m_plot(lons(squeeze(anom(:,:,4,i))' <= squeeze(lb(:,:,4,i))'), ...
       lats(squeeze(anom(:,:,4,i))' <= squeeze(lb(:,:,4,i))'), ...
       'k.','markersize',4);       
m_coast('color','k');
caxis([-6 6])
cl =colorbar('fontsize',12);
colormap(color);
set(cl, 'ytick',-6:1:6)
title('diff\_kurtosis', 'fontsize',14);
RemoveSubplotWhiteArea(gca, sub_row, sub_col,4,i);
end

% h = colorbar('ticks',-4:0.5:4);
% % set(h, 'pos', [0.96,0.05 0.02 0.85])
% set(h,'location','southoutside','orientation','horizontal')
% set(h, 'pos', [0.16,0.05 0.72 0.02])
