% x = squeeze(DJF(5,5,:));
h = zeros(10, 14);
for i = 1:10;
    for j = 1:14
x = squeeze(DJF(i,j,:));
if (isnan(x(1)))
    h(i,j) = NaN;
    continue
end
x(isnan(x)) = []; % Just null days: Feb.30, Feb 31 and Feb.29
thrhd = 1;

xd = x(x < thrhd);
xw = x(x >=thrhd);

paramEsts = fitdist(xw,'Gamma');  
h(i,j) = chi2gof(xw,'CDF',paramEsts);
    end 
end
% figure
subplot(2,2,1)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_pcolor(lon, lat, h');
title('DJF')
alpha(find(h==0))=nan;
alpha(alpha==inf)=nan;

figure
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_coast('color','k');
m_grid('xtick',3,'ytick',4)
m_pcolor(lon, lat, alpha');
title('JJA')

%%
beta = zeros(10, 14);
chi2 = zeros(10, 14);
for i = 4
    for j = 8
x=squeeze(JJA(i,j,:));
if(isnan(x(1)))
    alpha(i,j) = nan;
    continue
end
x(isnan(x)) = []; % Just null days: Feb.30, Feb 31 and Feb.29
thrhd = 0.99;

xd = x(x < thrhd);
xw = x(x >=thrhd);

nx = length(x); % total number of days
nw = length(xw);
p0 = length(xd) / nx;    % Frequency of dry days.
pw = 1 - p0;                        % Frequency of wet days.

in = 1;
% edges = (0:1:130)';
edges = [thrhd:in:30,50,70]';
binwidth = edges(2:end)-edges(1:end-1);
centers = (edges(2:end)+edges(1:end-1))/2;
% Fit wet days to gamma distribution
A = log(mean(xw)) - mean(log(xw));
alpha(i,j) = (1 + sqrt(1 + 4*A/3))/(4*A);
beta(i,j)  = mean(xw)/alpha(i,j);
    
%
% figure
ht = histogram(xw, edges);
ps = ht.Values'./nx ./binwidth;                % Frequency of wet days in each bin.
close
obs = ps.*binwidth*nx;
est = (gamcdf(edges(2:end),alpha(i,j), beta(i,j))-gamcdf(edges(1:end-1),alpha(i,j), beta(i,j)))*pw*nx;
% est = gampdf(centers, alpha, beta)'*pw*0.1*nx;
% chi = sum( (obs - est).^2 ./est );
chi2(i, j) = sum( (obs - est).^2 ./est );

hold on
plot(1:0.01:max(x), gampdf(1:0.01:max(x), alpha(i,j), beta(i,j))*pw*nx, 'r', 'linewidth', 1.2);
axis([0 130 0 800])
    end
end
chi2(chi2==0) = NaN;

% 
% paramEsts = fitdist(xw,'Gamma');  
% [h,p] = chi2gof(xw,'CDF',paramEsts);
% 
% figure
% b = bar(edges(1:end-1),ps,'histc');
% b.FaceColor = [0.35 .63 .8]; 
% delete(findobj('marker', '*'));
% set(gca, 'xlim', [0 60])
% hold on
% plot(0:0.01:max(x), gampdf(0:0.01:max(x), alpha, beta)*pw, 'r', 'linewidth', 1.2);
% text(7, 0.3, ['chi = ', num2str(chi2)])
% title(['Binwidth = ', num2str(in)])
