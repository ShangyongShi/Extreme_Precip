% Monte Carlo test for the diffirence between warm and cold phase
% 
% DJF: 13 warm, 13 cold
% MAM: 7 warm, 6 cold
% 
% Randomly select number of  warm and cold years, fit gamma, calculate
% differences
% 2020.1.31
function [lb_diff_alpha, ub_diff_alpha, lb_diff_beta, ub_diff_beta]...
            = MCtestPhase(DJF)
tic
nMC = 200;

for k = 1:nMC
    % randomly select warm and cold years
    y = 1:39;
    wy = randperm(39, 13);
    y(wy) = nan;
    y(isnan(y)) = [];

    ctmp = randperm(26, 13); % warm and cold year won't repeat
    cy = y(ctmp);
            
    % fit new seris to gamma distribution 
    [walpha(:,:,k), wbeta(:,:,k), wchi2(:,:,k), wthr_chi2(:,:,k)] ...
                = GammaFit(DJF(:, :, :, wy));
    [calpha(:,:,k), cbeta(:,:,k), cchi2(:,:,k), cthr_chi2(:,:,k)] ...
                = GammaFit(DJF(:, :, :, cy));
end
walpha(wchi2 > wthr_chi2) = nan;
wbeta(wchi2 > wthr_chi2) = nan;
calpha(cchi2 > cthr_chi2) = nan;
cbeta(cchi2 > cthr_chi2) = nan;

rank_alpha = sort(walpha-calpha, 1, 'descend');
rank_beta  = sort(wbeta-cbeta , 1, 'descend');
lb_diff_alpha   = squeeze(rank_alpha(:,:,0.975*nMC+1));
ub_diff_alpha   = squeeze(rank_alpha(:,:,0.025*nMC+1));
lb_diff_beta    = squeeze(rank_beta (:,:,0.975*nMC+1));
ub_diff_beta    = squeeze(rank_beta(:,:,0.025*nMC+1));

toc

end