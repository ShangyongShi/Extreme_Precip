function PlotFig7(lon, lat, alpha, beta, talpha, tbeta,...
                   lb_alpha, ub_alpha, lb_beta, ub_beta)
a = alpha - talpha;
b = beta - tbeta;
% color = load('NCV_BlueRed.txt');
blue = flipud(load('C:\Files\Research\Colormaps\WhiteBlue.txt')./255);
blues = blue(14:28:254,:);
reds =[0.9971    0.8990    0.8529
        0.9882    0.6781    0.5680
        0.9846    0.4258    0.3003
        0.8667    0.1627    0.1431
        0.6243    0.0533    0.0794];
    
sub_row = 2;
sub_col = 4;
name = ['DJF';'MAM';'JJA';'SON'];
sub = {'(a)','(b)','(c)', '(d)';...
       '(e)','(f)','(g)', '(h)'};
[lons, lats] = meshgrid(lon, lat);

%%
figure;
hold on
set(gcf,'pos',[10 10 1150 600])
%--- modified alpha
for i = 1:4
subplot(2,4,i)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4, 'fontsize',12)
m_contourf(lon, lat, squeeze(a(:,:,i))','linestyle','none', 'levelstep',0.01);
m_coast('color','k');
m_plot(lons(squeeze(a(:,:,i))' >= squeeze(ub_alpha(:,:,i))'), ...
       lats(squeeze(a(:,:,i))' >= squeeze(ub_alpha(:,:,i))'), ...
       'k.','markersize',4);
m_plot(lons(squeeze(a(:,:,i))' <= squeeze(lb_alpha(:,:,i))'), ...
       lats(squeeze(a(:,:,i))' <= squeeze(lb_alpha(:,:,i))'), ...
       'k.','markersize',4);

m_text(-84+360, 25.25, sub(1, i), 'fontsize',14);
caxis([-0.13 -0.04])
colormap(gca, blues)
cl = colorbar('fontsize',12);
% set(cl, 'ytick',0.4:0.1:1)
title([name(i,:),' Shape Diff'],'fontsize',14)
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, i);
end

%--- modified scale beta
for i = 1:4
subplot(2,4, i+4)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4, 'fontsize',12)
m_contourf(lon, lat,  squeeze(b(:,:,i))','linestyle','none', 'levelstep',1);
m_coast('color','k');
m_plot(lons(squeeze(b(:,:,i))' >= squeeze(ub_beta(:,:,i))'), ...
       lats(squeeze(b(:,:,i))' >= squeeze(ub_beta(:,:,i))'), ...
       'k.','markersize',4);
m_plot(lons(squeeze(b(:,:,i))' <= squeeze(lb_beta(:,:,i))'), ...
       lats(squeeze(b(:,:,i))' <= squeeze(lb_beta(:,:,i))'), ...
       'k.','markersize',4);

m_text(-84+360, 25.25, sub(2, i), 'fontsize',14);
caxis([2 7])
colormap(gca, reds)
cl = colorbar('fontsize',12);
% set(cl, 'ytick',4:2:16)
title([name(i,:),' Scale Diff'],'fontsize',14)
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, i);
end
