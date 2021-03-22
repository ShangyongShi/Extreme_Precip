% Try to reproduce Becker et al.
% 
path = 'D:\ÎÄµµ\Dropbox\Research\Misra_Extreme Precip\BeckerData';
file = fullfile(path, 'precip.V1.0.2006.nc');
lon  = ncread(file, 'lon');
lat  = ncread(file, 'lat');
[DJF, JJA] = BGetSeason();     % lon, lat, days, year
clear path file
% PART I  
% seasonal mean amount, intensity (average for days with precip, 
% threshold 1.0 mm/day) and frequency of days > 1.0 mm.
avg_DJF = squeeze(mean(mean(DJF, 3, 'omitnan'), 4, 'omitnan'));
avg_JJA = squeeze(mean(mean(JJA, 3, 'omitnan'), 4, 'omitnan'));

pDJF = DJF;  pDJF(find(DJF < 1)) = NaN;
int_DJF = squeeze(mean(mean(pDJF, 3, 'omitnan'), 4, 'omitnan'));
pJJA = JJA;  pJJA(find(JJA < 1)) = NaN;
int_JJA = squeeze(mean(mean(pJJA, 3, 'omitnan'), 4, 'omitnan'));

freq_DJF = zeros(300, 120);
freq_JJA = zeros(300, 120);
for i = 1:300
    for j = 1:120
        freq_DJF(i, j) = length(find(DJF(i,j,:,:) >= 1))/2437;
        freq_JJA(i, j) = length(find(JJA(i,j,:,:) >= 1))/2484;
    end
end
freq_DJF(isnan(avg_JJA)) = NaN;
freq_JJA(isnan(avg_JJA)) = NaN;

%% PART II
%  The (left) 95th percentile for daily precipitation events, 
% (middle) gamma distribution scale parameter, and (right) 
% gamma distribution shape parameter for (top) winter and (bottom) summer 
%  thd = zeros(300, 120);
alpha = zeros(300, 120);
beta  = zeros(300, 120);
chi2    = zeros(300, 120); % 0 for accept, 1 for reject
thd = zeros(300, 120);
for i = 1:300
    for j = 1:120
        if (isnan(avg_DJF(i,j)))
            alpha(i, j) = NaN;
            beta(i, j) = NaN;
            h(i, j) = NaN;
            thd(i, j) = nan;
%             thd(i,j) = NaN;
            continue
        end
        x = squeeze(DJF(i, j, :));
        thrhd = 0.01;
        xw = x(x >=thrhd)-thrhd;
        nx = length(x);   % total number of days
        nw = length(xw);  % number of wet days
        pw = length(xw) / nx;  % Frequency of wet days.
        
        % Threshold for precipitation: 1 mm/day
        
        % Fit wet days to gamma distribution
        A = log(mean(xw)) - mean(log(xw));
        alpha(i, j) = (1 + sqrt(1 + 4*A/3))/(4*A);
        beta(i, j)  = mean(xw)/alpha(i, j);
%         %
%         alpha2 = (0.5000876+0.1648852*A -0.0544274*A^2) / A
%         beta2 = mean(xw)/alpha2
%         paramEsts = makedist('Gamma','a',alpha(i,j), 'b',beta(i,j));
%         h(i,j) = chi2gof(x, 'CDF', paramEsts);
        
        % chi-square test
%         edges = [thrhd:1:29,31,33,35,36,37,38,41,44,47,50,max(xw)]';
if max(xw) > 50        
    edges = [thrhd:1:29.5,30:5:50,max(xw)]'-thrhd;
else
    edges = [thrhd:1:29.5,30:5:max(xw)]'-thrhd;
end

        binwidth = edges(2:end)-edges(1:end-1);
        centers = (edges(2:end)+edges(1:end-1))/2;

%         figure
%         ht = histogram(xw, edges);
%         obs2 = ht.Values';
        obs = histcounts(xw, edges)';
        est = (gamcdf(edges(2:end),alpha(i, j), beta(i, j))-gamcdf(edges(1:end-1),alpha(i, j), beta(i, j)))*pw*nx;
        chi2(i, j) = sum( (obs(1:end-1) - est(1:end-1)).^2 ./est(1:end-1) );
%         close

% figure
%         hold on
%         plot(0.26:0.01:ceil(max(x)), gampdf(0.26:0.01:ceil(max(x)), alpha, beta)*nw, 'r', 'linewidth', 1.2);
%         plot(centers, est, 'g', 'linewidth', 1.2);
%         
%         figure
%         bar(edges(1:end-1), obs./length(x),'histc')
%         plot(sort(xw), gamcdf(sort(xw), alpha, beta), 'r', 'linewidth', 1.2);
        
        % The 95%ile of precipitation
        aDJF = sort(unique(x), 'ascend');
        thd(i, j) = aDJF(floor(length(aDJF)*.95));
        clear aDJF  x
    end
end

% if we fit to wet dai frequency...


%%
% Percentile
figure
set(gcf,'pos',[10 50 1300 400])
hold on
subplot(1,3,1)
hold on
m_proj('mercator','lon',[230.125 294.875],'lat',[20.125 49.875])       
m_coast('color','k');
m_grid('xtick',7,'ytick',7)
m_contourf(lon, lat, thd', 'levelstep',5);
caxis([10 50])
colormap(jet)
colorbar
title('OBS Winter 95%ile','fontsize', 16)
RemoveSubplotWhiteArea(gca, 1, 3, 1, 1);

% beta - scale
subplot(1,3,2)
hold on
m_proj('mercator','lon',[230.125 294.875],'lat',[20.125 49.875])       
m_coast('color','k');
m_grid('xtick',7,'ytick',7)
m_contourf(lon, lat, beta', 'levelstep',2);
caxis([0 16])
colormap(jet)
colorbar
title('OBS Winter Scale','fontsize', 16)
RemoveSubplotWhiteArea(gca, 1, 3, 1, 2);

subplot(1,3,3)
% figure
hold on
m_proj('mercator','lon',[230.125 294.875],'lat',[20.125 49.875])       
m_coast('color','k');
m_grid('xtick',7,'ytick',7)
m_contourf(lon, lat, alpha', 'levelstep',0.15)
caxis([0 1])
colormap(jet)
colorbar
title('OBS Winter Shape','fontsize', 16)
RemoveSubplotWhiteArea(gca, 1, 3, 1, 3);

%%
% figure
% set(gcf,'pos',[10 50 600 500])
% hold on
% m_proj('mercator','lon',[230.125 304.875],'lat',[20.125 49.875])       
% m_coast('color','k');
% m_grid('xtick',8,'ytick',7)
% m_contourf(lon, lat, chi2');
% colormap
% colorbar

h = chi2;
th = 124;
h(h<th) = 1;
h(h>=th) = 0;
h(isnan(avg_DJF)) = nan;
% figure
% set(gcf,'pos',[10 50 600 500])
% hold on
% m_proj('mercator','lon',[230.125 294.875],'lat',[20.125 49.875])       
% m_coast('color','k');
% m_grid('xtick',8,'ytick',7)
% p = m_pcolor(lon, lat, h');
% set(p, 'linestyle','none')
% colormap;
% colorbar;
% caxis([0 1])

% Alpha - Shape
alpha(alpha>2.05) = 2.05;
alpha(h==0) = nan;
figure
set(gcf, 'pos',[700 200 560 335])
hold on
m_proj('mercator','lon',[230.125 294.875],'lat',[20.125 49.875])       
m_coast('color','k');
m_grid('xtick',7,'ytick',7)
m_contourf(lon, lat, alpha', 'levelstep',0.15)
caxis([0.85 2.05])
colormap(jet)
colorbar
title('OBS Winter Shape, DF=100, \chi^2=124','fontsize', 16)
% RemoveSubplotWhiteArea(gca, 1, 3, 1, 3);

%% lat(100) 44.875, lon(81) 250.125
% lat(33) 28.125 lon(190) 277.375
 i = 81;
 j = 100;
x = squeeze(DJF(i, j, :));
% x(x>quantile(x,0.95))=0;
thrhd = 1;
xw = x(x >=thrhd);
xw = xw-thrhd;
nx = length(x);   % total number of days
pw = length(xw) / nx;  % Frequency of wet days.

% Fit wet days to gamma distribution
A = log(mean(xw)) - mean(log(xw));
alph = (1 + sqrt(1 + 4*A/3))/(4*A);
bet  = mean(xw)/alph;

% chi-square test
if max(xw) > 50        
    edges = [thrhd:1:29.5,30:5:50,max(xw)]'-thrhd;
else
    edges = [thrhd:1:29.5,30:5:max(xw)]'-thrhd;
end

binwidth = edges(2:end)-edges(1:end-1);
centers = (edges(2:end)+edges(1:end-1))/2;

figure
set(gcf, 'pos',[700 200 560 400])
hold on
box on
ht = histogram(xw, edges);
obs = histcounts(xw, edges)';
est = (gamcdf(edges(2:end),alph, bet)-gamcdf(edges(1:end-1),alph, bet))*length(xw);
chi= sum( (obs(1:end-1) - est(1:end-1)).^2 ./est(1:end-1) );
% plot(centers, est, 'r', 'linewidth', 1.2);
plot(0.01:0.1:max(xw),gampdf(0.01:0.1:max(xw), alph, bet)*pw*nx, 'r','linewidth',1.2 )
text(10,300, {['\chi^2 = ', num2str(chi)]; ['\alpha = ', num2str(alph)]; ['\beta = ', num2str(bet)];},'fontsize',16)
set(gca, 'fontsize',16)
set(gca, 'ylim',[0 500])
title(['Threshold = ',num2str(thrhd),' mm/day, (44.875N, 110W)'])

%% lagged correlation lag 1 day
r1 = sum((xw(1:end-1)-mean(xw(1:end-1))).*(xw(2:end)-mean(xw(2:end))))/...
     ( sqrt(sum((xw(1:end-1)-mean(xw(1:end-1))).^2))*...
       sqrt(sum((xw(2:end)-mean(xw(2:end))).^2)) )

r2 = sum((xw(1:end-2)-mean(xw(1:end-2))).*(xw(3:end)-mean(xw(3:end))))/...
     ( sqrt(sum((xw(1:end-2)-mean(xw(1:end-2))).^2))*...
       sqrt(sum((xw(3:end)-mean(xw(3:end))).^2)) )
%% Plot Fig. 1
for i = 1
figure
set(gcf,'pos',[10 50 1600 500])
hold on
subplot(2,3,1)
hold on
m_proj('mercator','lon',[230.125 304.875],'lat',[20.125 49.875])       
m_coast('color','k');
m_grid('xtick',8,'ytick',7)
m_contourf(lon, lat, avg_DJF', 'levelstep',1);
caxis([0 8])
colormap(jet)
colorbar
title('OBS Winter Mean','fontsize', 16)
RemoveSubplotWhiteArea(gca, 2, 3, 1, 1);

subplot(2,3,2)
hold on
m_proj('mercator','lon',[230.125 304.875],'lat',[20.125 49.875])       
m_coast('color','k');
m_grid('xtick',8,'ytick',7)
m_contourf(lon, lat, int_DJF', 'levelstep',2);
caxis([0 16])
colormap(jet)
c = colorbar;
set(c, 'ytick', 0:2:14)
title('OBS Winter Intensity','fontsize', 16)
RemoveSubplotWhiteArea(gca, 2, 3, 1, 2);

subplot(2,3,3)
hold on
m_proj('mercator','lon',[230.125 304.875],'lat',[20.125 49.875])       
m_coast('color','k');
m_grid('xtick',8,'ytick',7)
m_contourf(lon, lat, freq_DJF', 'levelstep',0.1);
caxis([0 0.8])
colormap(jet)
colorbar
title('OBS Winter Freq','fontsize', 16)
RemoveSubplotWhiteArea(gca, 2, 3, 1, 3);

subplot(2,3,4)
hold on
m_proj('mercator','lon',[230.125 304.875],'lat',[20.125 49.875])       
m_coast('color','k');
m_grid('xtick',8,'ytick',7)
m_contourf(lon, lat, avg_JJA', 'levelstep',1);
caxis([0 8])
colormap(jet)
colorbar
title('OBS Summer Mean','fontsize', 16)
RemoveSubplotWhiteArea(gca, 2, 3, 2, 1);

subplot(2,3,5)
hold on
m_proj('mercator','lon',[230.125 304.875],'lat',[20.125 49.875])       
m_coast('color','k');
m_grid('xtick',8,'ytick',7)
m_contourf(lon, lat, int_JJA', 'levelstep',2);
caxis([0 16])
colormap(jet)
c = colorbar;
set(c, 'ytick', 0:2:14)
title('OBS Summer Intensity','fontsize', 16)
RemoveSubplotWhiteArea(gca, 2, 3, 2, 2);

subplot(2,3,6)
hold on
m_proj('mercator','lon',[230.125 304.875],'lat',[20.125 49.875])       
m_coast('color','k');
m_grid('xtick',8,'ytick',7)
m_contourf(lon, lat, freq_JJA', 'levelstep',0.1);
caxis([0 0.8])
colormap(jet)
colorbar
title('OBS Summer Freq','fontsize', 16)
RemoveSubplotWhiteArea(gca, 2, 3, 2, 3);
end
