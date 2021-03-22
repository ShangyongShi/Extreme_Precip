% The role of extreme rain events in Peninsular Florida's climate variations
% 
% Calculate the mean, standard deviation, skewness and kurtosis
%   of the 39-year rainfall data
% Calculate the same statistics after removing rainfall days 
%   that is above or equal to 95th percentile. Apply Monte Carlo Test for
%   the differences.
% ---
% Examing the modulation by ENSO through gamma distribution parameters. The
%   two phases of ENSO
%
%
% Data: 1979.1.1-2017/2018.2.28
%
% 2019.5.4
% Shi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file = 'CPC79_18prFl.nc';
lon  = ncread(file, 'lon');
lat  = ncread(file, 'lat');
precip = ncread(file, 'precip');

% Save each month seperately
[DJF, MAM, JJA, SON] = GetSeasons(precip);

% Get original matrix oMON for mean,std,skewness and kurtosis
oMON = GetOriginalMatrix(DJF, MAM, JJA, SON);

% Get modified matrix tMON after removing top 5% rainfall days,
% the threholds of 95%, and the percent of days removed for each season.
[tDJF,tMAM,tJJA,tSON, ...
    tMON, thresholds, rm] = GetModifiedMatrix(DJF, MAM, JJA, SON);

% Calculating anomalies
anom = oMON - tMON;

color = load('DarkBlueGreenYellowRed.txt');

%% Fit gamma distribution
alpha = zeros(10, 14, 4);
beta = zeros(10, 14, 4);
chi2 = zeros(10, 14, 4);
[alpha(:,:,1), beta(:,:,1), chi2(:,:,1), thr_chi2(:,:,1)] = GammaFit(DJF);
[alpha(:,:,2), beta(:,:,2), chi2(:,:,2), thr_chi2(:,:,2)] = GammaFit(MAM);
[alpha(:,:,3), beta(:,:,3), chi2(:,:,3), thr_chi2(:,:,3)] = GammaFit(JJA);
[alpha(:,:,4), beta(:,:,4), chi2(:,:,4), thr_chi2(:,:,4)] = GammaFit(SON);

[talpha(:,:,1), tbeta(:,:,1), tchi2(:,:,1), tthr_chi2(:,:,1)] = GammaFit(tDJF);
[talpha(:,:,2), tbeta(:,:,2), tchi2(:,:,2), tthr_chi2(:,:,2)] = GammaFit(tMAM);
[talpha(:,:,3), tbeta(:,:,3), tchi2(:,:,3), tthr_chi2(:,:,3)] = GammaFit(tJJA);
[talpha(:,:,4), tbeta(:,:,4), tchi2(:,:,4), tthr_chi2(:,:,4)] = GammaFit(tSON);

alpha(chi2 > thr_chi2) = nan;
beta(chi2 > thr_chi2) = nan;

talpha(tchi2 > tthr_chi2) = nan;
tbeta(tchi2 > tthr_chi2) = nan;
%%
[walpha_DJF, wbeta_DJF, diff_alpha_DJF, diff_beta_DJF] = GamENSO(DJF);
[walpha_MAM, wbeta_MAM, diff_alpha_MAM, diff_beta_MAM] = GamENSO(MAM);
%% Monte Carlo test for anomaly (o-t) after removing top 5%
[lb, rb,lb_alpha, ub_alpha, lb_beta, ub_beta] ...
    = GetBounds(DJF, MAM, JJA, SON, oMON, rm, alpha, beta);
%% Monte Carlo test for differences between warm and cold phase of ENSO
[lb_diff_alpha_DJF, ub_diff_alpha_DJF, lb_diff_beta_DJF, ub_diff_beta_DJF]...
    = MCtestPhase(DJF);
[lb_diff_alpha_MAM, ub_diff_alpha_MAM, lb_diff_beta_MAM, ub_diff_beta_MAM]...
    = MCtestPhase(MAM);        

%% plotting part
% PlotFig1(DJF)
% PlotFig2(lon, lat, oMON)
% PlotFig3(lon, lat, thresholds)
% PlotFig4(lon, lat, rm)
% PlotFig5(lon, lat, anom, lb, rb)    
% PlotSF1(lon, lat, tMON);
% PlotFig6(lon, lat, alpha, beta);
% PlotFigChi2(lon, lat, chi2, thr_chi2, tchi2,tthr_chi2)
% PlotFig7(lon, lat, alpha, beta, talpha, tbeta,...
%                    lb_alpha, ub_alpha, lb_beta, ub_beta);
% PlotFig8(lon, lat, ...
% walpha_DJF, wbeta_DJF, diff_alpha_DJF, diff_beta_DJF,...
% walpha_MAM, wbeta_MAM, diff_alpha_MAM, diff_beta_MAM,...
% lb_diff_alpha_DJF, ub_diff_alpha_DJF, lb_diff_beta_DJF, ub_diff_beta_DJF,...
% lb_diff_alpha_MAM, ub_diff_alpha_MAM, lb_diff_beta_MAM, ub_diff_beta_MAM);

%% Wet day frequency for each season
[wDJF, nw(:,:,1)] = GetWetDayFreq(DJF, 1);
[wMAM, nw(:,:,2)] = GetWetDayFreq(MAM, 0);
[wJJA, nw(:,:,3)] = GetWetDayFreq(JJA, 0);
[wSON, nw(:,:,4)] = GetWetDayFreq(SON, 0);

tnw(:,:,1) = sum(sum(tDJF > 0.1, 3),4);
tnw(:,:,2) = sum(sum(tMAM > 0.1, 3),4);
tnw(:,:,3) = sum(sum(tJJA > 0.1, 3),4);
tnw(:,:,4) = sum(sum(tSON > 0.1, 3),4);
% PlotWD(lon, lat, wDJF, wMAM, wJJA, wSON)

%% Plot one grid gam pdf 
% a1 = alpha(2, 12, :);
% b1 = beta(2, 12, :);
% a2 = talpha(2, 12, :);
% b2 = tbeta(2, 12, :);
% 
% color = [8 81 156;189 0 38]./255;
% x = 0.1:0.1:100;
% figure;
% set(gcf,'pos',[50 50 850 500])
% subplot(2,1,1)
% hold on
% for i = 2:3
% % plot(x, gampdf(x, a1(i), b1(i))*nw(2, 12, i),'color',color(i-1,:),'linewidth',1.4);
% % plot(x, gampdf(x, a2(i), b2(i))*tnw(2, 12, i),'--','color',color(i-1,:),'linewidth',1.4);
% plot(x, gampdf(x, a1(i), b1(i)),'color',color(i-1,:),'linewidth',1.4);
% plot(x, gampdf(x, a2(i), b2(i)),'--','color',color(i-1,:),'linewidth',1.4);
% 
% end
% set(gca, 'xlim', [0 20])
% % set(gca, 'ylim', [0 1000])
% box on
% grid on
% set(gca, 'fontsize',16)
% title('83.75W, 30.25N')
% legend('Original  MAM, shape = 0.462, scale = 16.97',...
%        'Modified MAM, shape = 0.528, scale = 9.629',...
%        'Original  JJA,   shape = 0.627, scale = 11.42',...
%        'Modified JJA,   shape = 0.730, scale = 7.135')
% ylabel('Gamma PDF (Frequency)')
% text(0.5, 0.57, '(a)', 'fontsize',16)
% RemoveSubplotWhiteArea(gca, 2,1,1,1)
% subplot(2,1,2)
% hold on
% for i = 2:3
% plot(x, gampdf(x, a1(i), b1(i))*nw(2, 12, i),'color',color(i-1,:),'linewidth',1.4);
% plot(x, gampdf(x, a2(i), b2(i))*tnw(2, 12, i),'--','color',color(i-1,:),'linewidth',1.4);
% % plot(x, gampdf(x, a1(i), b1(i)),'color',color(i-1,:),'linewidth',1.4);
% % plot(x, gampdf(x, a2(i), b2(i)),'--','color',color(i-1,:),'linewidth',1.4);
% 
% end
% set(gca, 'xlim', [0 20])
% set(gca, 'ylim', [0 1000])
% box on
% grid on
% set(gca, 'fontsize',16)
% legend('Original  MAM, shape = 0.462, scale = 16.97',...
%        'Modified MAM, shape = 0.528, scale = 9.629',...
%        'Original  JJA,   shape = 0.627, scale = 11.42',...
%        'Modified JJA,   shape = 0.730, scale = 7.135')
% xlabel('Rainfall (mm/day)')
% ylabel('Number of days')
% RemoveSubplotWhiteArea(gca, 2,1,2,1)
% text(0.5, 950, '(b)', 'fontsize',16)