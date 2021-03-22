% Function to get best estimate of gamma distribution 
% using MLE (Thom 1958):
%         A = log(mean(x)) - mean(log(x));
%         alpha = (1 + sqrt(1 + 4*A/3))/(4*A);
%         beta = mean(x)/alpha;
%
% Other methods to calculate gamma parameters
%         alpha2 = (0.5000876+0.1648852*A -0.0544274*A^2) / A
%         beta2 = mean(xw)/alpha2
% Or
%         paramEsts = makedist('Gamma','a',alpha(i,j), 'b',beta(i,j));
%         h(i,j) = chi2gof(x, 'CDF', paramEsts);
% 
% Chi-square test are applied with significance level of 0.05.
% Degree of freedom for the test is estimated by number of wet days / 4
%
% Input  | DJF(lon, lat, day, year) or DJF(lon, lat, day*year)
% Output | alpha: shape parameter
%        | beta: scale parameter
%        | chi2: statistic for chi-square test
%        | thr_chi2: threshold for the test
%
% Shangyong 
% 2019.11.12
function [alpha, beta, chi2, thr_chi2] = GammaFit(DJF)
if (length(size(DJF)) == 4)
    [nlon, nlat, dy, yr] = size(DJF);
    MON   = reshape(DJF, nlon, nlat, dy*yr);
else
    [nlon, nlat, ~] = size(DJF);
    MON = DJF;
end
alpha = zeros(nlon, nlat);
beta  = zeros(nlon, nlat);
chi2  = zeros(nlon, nlat);
thr_chi2 = zeros(nlon, nlat);

% Degree of freedom and chi2 value
df = [(38:249)';250;300;350;400;450;500;550;600;650;700];
chi = [ 53.384;54.572;...
        55.758;56.942;58.124;59.304;60.481;61.656;62.830;64.001;65.171;66.339;...
        67.505;68.669;69.832;70.993;72.153;73.311;74.468;75.624;76.778;...
        77.931;79.082;80.232;81.381;82.529;83.675;84.821;85.965;87.108;...
        88.250;89.391;90.531;91.670;92.808;93.945;95.081;96.217;97.351;...
        98.484;99.617;100.749;101.879;103.010;104.139;105.267;106.395;...
        107.522;108.648;109.773;110.898;112.022;113.145;114.268;115.390;...
        116.511;117.632;118.752;119.871;120.990;122.108;123.225;...%40-100
        124.342;125.458;126.574;127.689;128.804;129.918;131.031;132.144;...
        133.257;134.369;135.48;136.591;137.701;138.811;139.921;141.03;...
        142.138;143.246;144.354;145.461;146.567;147.674;148.779;149.885;...
        150.989;152.094;153.198;154.302;155.405;156.508;157.61;158.712;...
        159.814;160.915;162.016;163.116;164.216;165.316;166.415;167.514;...
        168.613;169.711;170.809;171.907;173.004;174.101;175.198;176.294;...
        177.39;178.485;179.581;180.676;181.77;182.865;183.959;185.052;...
        186.146;187.239;188.332;189.424;190.516;191.608;192.7;193.791;...
        194.883;195.973;197.064;198.154;199.244;200.334;201.423;202.513;...
        203.602;204.69;205.779;206.867;207.955;209.042;210.13;211.217;...
        212.304;213.391;214.477;215.563;216.649;217.735;218.82;219.906;...
        220.991;222.076;223.16;224.245;225.329;226.413;227.496;228.58;...
        229.663;230.746;231.829;232.912;233.994;235.077;236.159;237.24;...
        238.322;239.403;240.485;241.566;242.647;243.727;244.808;245.888;...
        246.968;248.048;249.128;250.207;251.286;252.365;253.444;254.523;...
        255.602;256.68;257.758;258.837;259.914;260.992;262.07;263.147;...
        264.224;265.301;266.378;267.455;268.531;269.608;270.684;271.76;...
        272.836;273.911;274.987;276.062;277.138;278.213;279.288;280.362;...
        281.437;282.511;283.586;284.66;285.734;286.808;287.882;341.395;...
        394.626;447.632;500.456;553.127;605.667;658.094;710.421;762.661];
%%
for i = 1:nlon
    for j = 1:nlat
        % Produce the series for fit. 
        % Threshold for precipitation: 0.1 mm/day
        % Skip ocean NaN data
        thrhd = 0.1;
        x = squeeze(MON(i, j, :));
        if (isnan(x(1)))
            alpha(i, j) = NaN;
            beta(i, j) = NaN;
            chi2(i, j) = nan;
            thr_chi2(i, j) = nan;
            continue
        end
        
        % Shift the series
        xw = x(x >=thrhd);
        xw = xw - thrhd;
        nx = length(x);
        pw = length(xw) / nx;  % Frequency of wet days.
        
        % Fit wet days to gamma distribution
        A = log(mean(xw)) - mean(log(xw));
        alpha(i, j) = (1 + sqrt(1 + 4*A/3))/(4*A);
        beta(i, j)  = mean(xw)/alpha(i, j);
        
        % chi-square test
        % set bin boundaries
        if max(xw) > 50        
            edges = [thrhd:1:34,35:5:50,60:20:(60+max(xw))/2, max(xw)]'-thrhd;
        else
            edges = [thrhd:1:34,35:2:max(xw)]'-thrhd;
        end

        obs = histcounts(xw, edges)';
        est = (gamcdf(edges(2:end),alpha(i, j), beta(i, j))-gamcdf(edges(1:end-1),alpha(i, j), beta(i, j)))*pw*nx;
        chi2(i, j) = sum( (obs(1:end-1) - est(1:end-1)).^2 ./est(1:end-1) );
        
        thr_chi2(i, j) = chi(max(find(df <= floor(length(xw)/4)))); 


    end
end
alpha(alpha == 0) = NaN;
beta(beta == 0) = NaN;
% %  Plot PDF and histogram for one grid       
% figure
% set(gcf, 'pos',[700 200 560 400])
% hold on
% box on
% ht = histogram(xw, edges);
% % plot(centers, est, 'r', 'linewidth', 1.2);
% plot(0.01:0.1:max(xw),...
%   gampdf(0.01:0.1:max(xw), alpha(i,j), beta(i,j))*pw*nx, ...
%   'r','linewidth',1.2 )
% text(10,400, {['\chi^2 = ', num2str(chi2(i,j))]; ...
%   ['\alpha = ', num2str(alpha(i,j))]; ...
%   ['\beta = ', num2str(beta(i,j))];},'fontsize',16)
% set(gca, 'fontsize',16)
% set(gca, 'ylim',[0 10])
% title(['Threshold = ',num2str(thrhd),' mm/day, (26.75N, 82.25W)'])

% Lagged correlation
% r1 = sum((xw(1:end-1)-mean(xw(1:end-1))).*(xw(2:end)-mean(xw(2:end))))/...
%      ( sqrt(sum((xw(1:end-1)-mean(xw(1:end-1))).^2))*...
%        sqrt(sum((xw(2:end)-mean(xw(2:end))).^2)) )
% r2 = sum((xw(1:end-2)-mean(xw(1:end-2))).*(xw(3:end)-mean(xw(3:end))))/...
%      ( sqrt(sum((xw(1:end-2)-mean(xw(1:end-2))).^2))*...
%        sqrt(sum((xw(3:end)-mean(xw(3:end))).^2)) )
%    
% r5 = sum((xw(1:end-5)-mean(xw(1:end-2))).*(xw(6:end)-mean(xw(6:end))))/...
%      ( sqrt(sum((xw(1:end-5)-mean(xw(1:end-5))).^2))*...
%        sqrt(sum((xw(6:end)-mean(xw(6:end))).^2)) )


% for i = 1:10
%     for j = 1:14
%         test1(i, j, :) = reshape(DJF(i,j,:), 1, 91*39);
%         percent(i, j, 1) = length(find(test1(i, j, :) >=0.1))/91/39*100;
%         test2(i, j, :) = reshape(MAM(i,j,:), 1, 92*39);
%         percent(i, j, 2) = length(find(test2(i, j, :) >=0.1))/92/39*100;
%         test3(i, j, :) = reshape(JJA(i,j,:), 1, 92*39);
%         percent(i, j, 3) = length(find(test3(i, j, :) >=0.1))/92/39*100;
%         test4(i, j, :) = reshape(SON(i,j,:), 1, 91*39);
%         percent(i, j, 4) = length(find(test4(i, j, :) >=0.1))/91/39*100;
%     end
% end
