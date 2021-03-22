figure;
i = 2;
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
% m_pcolor(lon, lat, squeeze(anom(:,:,4,i))', 'linestyle','none');
m_contourf(lon, lat, squeeze(anom(:,:,4,i))', 'linestyle','none', ...
    'levelstep',0.5);
% m_text(-84+360, 25.3, sub(4, i), 'fontsize',14);
m_plot(lons(squeeze(anom(:,:,4,i))' >= squeeze(rb(:,:,4,i))'), ...
       lats(squeeze(anom(:,:,4,i))' >= squeeze(rb(:,:,4,i))'), ...
       'k.','markersize',4);
m_plot(lons(squeeze(anom(:,:,4,i))' <= squeeze(lb(:,:,4,i))'), ...
       lats(squeeze(anom(:,:,4,i))' <= squeeze(lb(:,:,4,i))'), ...
       'k.','markersize',4);
caxis([-6 6])
cl =colorbar('fontsize',12);
colormap(color);
set(cl, 'ytick',-6:1:6)
title('diff\_kurtosis', 'fontsize',14);