function PlotFig1(DJF)
m=2;
n=12;
x = reshape(squeeze(DJF(m, n, :, :)), 91*39,1);
thrhd = 1;

xw0 = x(x >=thrhd);
xw1 = xw0 - thrhd;
nx = length(x);
pw = length(xw0) / nx;  % Frequency of wet days.
        
% a1 = alpha(m, n)
% b1 = beta(m, n)
% Fit wet days to gamma distribution
A = log(mean(xw0)) - mean(log(xw0));
a0 = (1 + sqrt(1 + 4*A/3))/(4*A)
b0  = mean(xw1)/a0

A = log(mean(xw1)) - mean(log(xw1));
a1 = (1 + sqrt(1 + 4*A/3))/(4*A)
b1  = mean(xw1)/a1
%         % chi-square test
%         if max(xw0) > 50        
%             edges = [thrhd:1:34,35:5:50,60:20:(60+max(xw0))/2, max(xw0)]';%-thrhd;
%         else
%             edges = [thrhd:1:34,35:2:max(xw0)]';%-thrhd;
%         end
edges0 = [thrhd:1:34,35:5:50,60:20:(60+max(xw0))/2, max(xw0)]';%-thrhd;
edges1 = [0:1:34,35:5:50,60:20:(60+max(xw0))/2, max(xw0)]';%-thrhd;

center0 = (edges0(2:end)+edges0(1:end-1))/2;
center1 = (edges1(2:end)+edges1(1:end-1))/2;

obs0 = histcounts(xw0, edges0)';
est0 = (gamcdf(edges0(2:end),a0, b0)-gamcdf(edges0(1:end-1),a0, b0))*pw*nx;
chi0 = sum( (obs0(1:end-1) - est0(1:end-1)).^2 ./est0(1:end-1) );

obs1 = histcounts(xw1, edges1)';
est1 = (gamcdf(edges1(2:end),a1, b1)-gamcdf(edges1(1:end-1),a1, b1))*pw*nx;
chi1 = sum( (obs1(1:end-1) - est1(1:end-1)).^2 ./est1(1:end-1) );

edges = 0:1:60;        
figure;
set(gcf, 'pos',[50 50 950 400])
hold on
p1 = subplot(1,2,1);
hold on
histogram(xw0, edges);
% plot(center0, est0, 'y', 'linewidth', 1.2);
plot(0.01:0.1:max(xw0),gampdf(0.01:0.1:max(xw0), a0, b0)*pw*nx, 'r','linewidth',1.2 )
set(gca, 'fontsize',16) 
set(gca, 'xtick', 0:10:60)
set(gca, 'ytick', 0:25:150)
xlabel('Daily Precipitation (mm/day)')
ylabel('Number of Days')
text(20,100, {['\chi^2 = ', num2str(chi0, '%5.2f')]; ['\alpha = ', num2str(a0, '%4.3f')]; ...
              ['\beta = ', num2str(b0, '%4.3f')];},'fontsize',16)
text(4, 140, '(a)', 'fontsize', 16)
axis([0 60 0 150])
box on
grid on
title('Fit to Original Wet Days (x)','fontsize',20,'fontweight','bold')

p2 = subplot(1,2,2);
hold on
histogram(xw1, edges);
plot(0.01:0.1:max(xw1),gampdf(0.01:0.1:max(xw1), a1, b1)*pw*nx, 'r','linewidth',1.2 )
text(20,100, {['\chi^2 = ', num2str(chi1, '%5.2f')]; ['\alpha = ', num2str(a1, '%4.3f')]; ...
              ['\beta = ', num2str(b1, '%4.3f')];},'fontsize',16)
text(4, 140, '(b)', 'fontsize', 16)
set(gca, 'fontsize',16) 
set(gca, 'xtick', 0:10:60)
set(gca, 'ytick', 0:25:150)
xlabel('Daily Precipitation (mm/day)')
ylabel('Number of Days')
axis([0 60 0 150])
box on
grid on
title('Fit to Shifted Wet Days (x-1)','fontsize',20,'fontweight','bold')

%         figure
%         set(gcf, 'pos',[700 200 560 400])
%         hold on
%         box on
%         ht = histogram(xw, edges);
%         % plot(centers, est, 'r', 'linewidth', 1.2);
%         plot(0.01:0.1:max(xw),gampdf(0.01:0.1:max(xw), alpha(i,j), beta(i,j))*pw*nx, 'r','linewidth',1.2 )
% text(10,400, {['\chi^2 = ', num2str(chi2(i,j))]; ['\alpha = ', num2str(alpha(i,j))]; ['\beta = ', num2str(beta(i,j))];},'fontsize',16)

%         set(gca, 'ylim',[0 10])
%         title(['Threshold = ',num2str(thrhd),' mm/day, (26.75N, 82.25W)'])
