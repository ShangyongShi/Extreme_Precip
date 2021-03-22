% Monte Carlo test for the diffirence between REMOVED and ORIGINAL data
% repeat random deletion for nMC=200 times | could be modified
% 
% INPUTS
% MON    | DJF 10 14 91 39/ MAM/ JJA/ SON
% oMON   | Original matrix for mean, std, skewness and kurtosis
% rm     | number of days to be removed for eash grid.
% alpha  | shape parameter fitted to original season rainfall
% beta   | scale parameter fitted to original season rainfall

% OUTPUTS
% lb     | lower 2.5% bound for MC test
% ub     | upper 2.5% bound for MC test
% lb_alpha, ub_alpha, lb_beta, ub_beta

% Modified:
% 2020.1.28
% Add MC test for gamma distribution
% 2019.5.4
% Fix the bug in skewness calculation (typo for "kurtosis")
% Fix the rank: 5 for 200 to 200*.05=10 for 200
% 

function [lb, ub, lb_alpha, ub_alpha, lb_beta, ub_beta] = ...
            MCtestSeason(MON1, oMON1, rm1, alph, bet)
tic
nMC = 200;
[nx,ny,nz] = size(MON1);
nm = nz/39;
mcmon = zeros(nMC, nx, ny, nz);
for k = 1:nMC
    for i = 1:10
        for j = 1:14
            % randomly delete rm(i,j) days from time series
            tmp = MON1(i, j, :);
            delete = randperm(nz, rm1(i, j));
            tmp(delete) = 0;
            mcmon(k, i, j, :) = tmp;
            clear tmp
        end
    end
end
% mons: 200, 10, 14, 39
% oMON(:,:,:,1): 10, 14, 4
mons = squeeze(mean(reshape(mcmon, nMC, nx, ny, nm, 39), 4, 'omitnan'));

% new matrix after deletion
nMON = zeros(nMC, 10, 14, 4);
nMON(:,:,:,1) = mean(mons, 4);
nMON(:,:,:,2) = std(mons, 1, 4);
nMON(:,:,:,3) = skewness(mons, 1, 4);
nMON(:,:,:,4) = kurtosis(mons, 1, 4);

% anomaly of new to old. 200, 10, 14, 4
for i = 1:nMC
    [malpha(:,:, i), mbeta(:,:, i)] = ...
        GammaFit(squeeze(mcmon(i, :,:,:)));
    
    anom(i,:,:,:) = squeeze(nMON(i,:,:,:)) - oMON1;
end
diff_alpha = repmat(alph,1,1,nMC) - malpha;
diff_beta  = repmat(bet ,1,1,nMC) - mbeta;
rank_alpha = sort(diff_alpha, 1, 'descend');
rank_beta  = sort(diff_beta , 1, 'descend');
lb_alpha   = squeeze(rank_alpha(:,:,0.975*nMC+1));
ub_alpha   = squeeze(rank_alpha(:,:,0.025*nMC+1));
lb_beta    = squeeze(rank_beta (:,:,0.975*nMC+1));
ub_beta    = squeeze(rank_beta(:,:,0.025*nMC+1));

% rank the anomalies
rank = zeros(nMC, 10, 14, 4);
for i = 1:4
    rank(:,:,:,i) = sort(anom(:,:,:,i),1,'descend' );
end

% ub = zeros(nx, ny, 4);
% lb = zeros(nx, ny, 4);
lb = squeeze(rank(0.975*nMC+1, :,:,:));
ub = squeeze(rank(0.025*nMC,:,:,:));

% avg_ub = squeeze(avg_rank(5,:,:));  % separately for each variable? or use top avg to calculate std etc.?
% avg_lb = squeeze(avg_rank(195,:,:)); 
% std_ub = squeeze(std_rank(5,:,:));
% std_lb = squeeze(std_rank(195,:,:)); 
% kur_ub = squeeze(kur_rank(5,:,:));
% kur_lb = squeeze(kur_rank(195,:,:)); 
% ske_ub = squeeze(ske_rank(5,:,:));
% ske_lb = squeeze(ske_rank(195,:,:)); 

toc

end