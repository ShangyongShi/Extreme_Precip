function PlotFigChi2(lon, lat, chi2, thr_chi2, tchi2,tthr_chi2)
color = load('DarkBlueGreenYellowRed.txt');

sub_row = 4;
sub_col = 4;
name = ['DJF';'MAM';'JJA';'SON'];
figure
set(gcf,'pos',[10 10 800 1000])
%--- original shape (alpha)
for i = 1:4
hold on
subplot(4,4,i)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(chi2(:,:,i))','linestyle', 'none')%,'levelstep',0.05);
% caxis([0.5 1])
colormap(color)
cl = colorbar;
% set(cl, 'ytick',0.5:0.1:1)
title(['Original ', name(i,:),' \chi^2'])
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, i);
end

for i = 1:4
subplot(4,4,i+4)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(thr_chi2(:,:,i))','linestyle','none')%, 'levelstep',0.05);
% caxis([0.5 1])
colormap(gca, color)
cl = colorbar;
% set(cl, 'ytick',0.5:0.1:1)
title(['Original ',name(i,:),' Threshold'])
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, i);
end

%--- modified alpha
for i = 1:4
subplot(4,4,i+8)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(tchi2(:,:,i))','linestyle','none')%, 'levelstep',0.05);
% caxis([0.5 1])
colormap(gca, color)
cl = colorbar;
% set(cl, 'ytick',0.5:0.1:1)
title(['Modified ',name(i,:),' \chi ^2'])
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 3, i);
end 

for i = 1:4
subplot(4,4,i+12)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(tthr_chi2(:,:,i))','linestyle','none')%, 'levelstep',0.05);
% caxis([0.5 1])
colormap(gca, color)
cl = colorbar;
% set(cl, 'ytick',0.5:0.1:1)
title(['Modified ',name(i,:),' Threshold'])
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 4, i);
end

end
