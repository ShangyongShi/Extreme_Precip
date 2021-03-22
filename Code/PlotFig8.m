% a b c d shape: warm DJF, diff_DJF, warm MAM, diff_MAM
% e f g h scale: warm DJF, diff_DJF, warm MAM, diff_MAM

function PlotFig8(lon, lat, ...
walpha_DJF, wbeta_DJF, diff_alpha_DJF, diff_beta_DJF,...
walpha_MAM, wbeta_MAM, diff_alpha_MAM, diff_beta_MAM,...
lb_diff_alpha_DJF, ub_diff_alpha_DJF, lb_diff_beta_DJF, ub_diff_beta_DJF,...
lb_diff_alpha_MAM, ub_diff_alpha_MAM, lb_diff_beta_MAM, ub_diff_beta_MAM)

[lons, lats] = meshgrid(lon, lat);
bluered = [8,81,156
            49,130,189
            107,174,214
            189,215,231
            239,243,255
            254,240,217
            253,204,138
            252,141,89
            227,74,51
            179,0,0]./255;

reds = [254,240,217
        253,212,158
        253,187,132
        252,141,89
        239,101,72
        215,48,31
        153,0,0]./255;

color = [8	81	156
49	130	189
107	174	214
168	221	181
224	243	219
255	255	217
254	224	147
253	141	60
227	26	28
189	0	38
]./255;
color = [
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
    122 16 0]./255;
sub = {'(a)','(b)','(c)', '(d)',...
       '(e)','(f)','(g)', '(h)'};
sub_row = 2;
sub_col = 4;
name = ['DJF';'MAM';'JJA';'SON'];
% color = load('DarkBlueGreenYellowRed.txt');

figure
set(gcf,'pos',[10 10  1000 500])
hold on

% walpha_DJF
p = subplot(sub_row,sub_col,1);
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, walpha_DJF','linestyle', 'none','levelstep',0.02);
m_coast('color','k');
m_text(-84+360, 25.30, sub(1), 'fontsize',14);
caxis([0.4 0.6])
colormap(p, color)
cl = colorbar;
set(cl, 'ytick',0.4:0.04:0.6, 'fontsize', 10)
title('Warm DJF Shape','fontsize', 12)
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, 1);

% wbeta_DJF
p5 = subplot(sub_row,sub_col,2);
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, wbeta_DJF','linestyle', 'none','levelstep',1);
m_coast('color','k');
m_text(-84+360, 25.30, sub(2), 'fontsize',14);
caxis([8 18])
colormap(p5, color)
cl = colorbar;
set(cl,  'fontsize', 10)
title('Warm DJF Scale','fontsize', 12)
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, 2);



% walpha_MAM
p2 = subplot(sub_row,sub_col,3);
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, walpha_MAM','linestyle', 'none','levelstep',0.02);
m_coast('color','k');
m_text(-84+360, 25.30, sub(3), 'fontsize',14);
caxis([0.4 0.6])
colormap(p2, color)
cl = colorbar;
set(cl, 'ytick',0.4:0.04:0.6, 'fontsize', 10)
title('Warm MAM Shape','fontsize', 12)
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, 3);

% wbeta_MAM
p6 = subplot(sub_row,sub_col,4);
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, wbeta_MAM','linestyle', 'none','levelstep',1);
m_coast('color','k');
m_text(-84+360, 25.30, sub(4), 'fontsize',14);
caxis([8 18])
colormap(p6, color)
cl = colorbar;
set(cl,  'fontsize', 10)
title('Warm MAM Scale','fontsize', 12)
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, 4);


% diff alpha_DJF
p3 = subplot(sub_row, sub_col, 5);
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, diff_alpha_DJF','linestyle', 'none','levelstep',0.02);
m_plot(lons(diff_alpha_DJF' >= ub_diff_alpha_DJF'), ...
       lats(diff_alpha_DJF' >= ub_diff_alpha_DJF'), ...
       'k.','markersize',4);
m_plot(lons(diff_alpha_DJF' <= lb_diff_alpha_DJF'), ...
       lats(diff_alpha_DJF' <= lb_diff_alpha_DJF'), ...
       'k.','markersize',4);
   
m_coast('color','k');
m_text(-84+360, 25.30, sub(5), 'fontsize',14);
caxis([-0.1 0.1])
colormap(p3, bluered)
cl = colorbar;
set(cl, 'ytick',-0.1:0.04:0.1, 'fontsize', 10)
title('DJF Shape Diff','fontsize', 12)
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, 1);

% diff_beta_DJF
p7 = subplot(sub_row, sub_col, 6);
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, diff_beta_DJF','linestyle', 'none','levelstep',1);
m_plot(lons(diff_beta_DJF' >= ub_diff_beta_DJF'), ...
       lats(diff_beta_DJF' >= ub_diff_beta_DJF'), ...
       'k.','markersize',4);
m_plot(lons(diff_beta_DJF' <= lb_diff_beta_DJF'), ...
       lats(diff_beta_DJF' <= lb_diff_beta_DJF'), ...
       'k.','markersize',4);
m_coast('color','k');
m_text(-84+360, 25.30, sub(6), 'fontsize',14);
caxis([0 7])
colormap(p7,  reds)
cl = colorbar;
set(cl,'ytick',0:1:7,  'fontsize', 10)
title('DJF Scale Diff','fontsize', 12)
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, 2);

% diff alpha_MAM
p4 = subplot(sub_row, sub_col, 7);
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4)
m_text(-84+360, 25.30, sub(7), 'fontsize',14);
m_contourf(lon, lat, diff_alpha_MAM','linestyle', 'none','levelstep',0.02);
m_plot(lons(diff_alpha_MAM' >= ub_diff_alpha_MAM'), ...
       lats(diff_alpha_MAM' >= ub_diff_alpha_MAM'), ...
       'k.','markersize',4);
m_plot(lons(diff_alpha_MAM' <= lb_diff_alpha_MAM'), ...
       lats(diff_alpha_MAM' <= lb_diff_alpha_MAM'), ...
       'k.','markersize',4);
m_coast('color','k');
caxis([-0.1 0.1])
colormap(p4, bluered)
cl = colorbar;
set(cl, 'ytick',-0.1:0.04:0.1, 'fontsize', 10)
title('MAM Shape Diff','fontsize', 12)
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, 3);

% diff_beta_MAM
p8 = subplot(sub_row, sub_col, 8);
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4)
m_text(-84+360, 25.30, sub(8), 'fontsize',14);
m_contourf(lon, lat, diff_beta_MAM','linestyle', 'none','levelstep',1);
m_plot(lons(diff_beta_MAM' >= ub_diff_beta_MAM'), ...
       lats(diff_beta_MAM' >= ub_diff_beta_MAM'), ...
       'k.','markersize',4);
m_plot(lons(diff_beta_MAM' <= lb_diff_beta_MAM'), ...
       lats(diff_beta_MAM' <= lb_diff_beta_MAM'), ...
       'k.','markersize',4);
m_coast('color','k');
caxis([0 7])
colormap(p8, reds)
cl = colorbar;
set(cl, 'ytick',0:1:7, 'fontsize', 10)
title('MAM Scale Diff','fontsize', 12)
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, 4);

end
