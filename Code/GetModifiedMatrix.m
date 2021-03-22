% tMONx : Modified daily data for each season
% tMON  : Matrix of mean, std, skewness and kurtosis of modified data
% thresholds : 95% rank thresholds for rainfall
% rm : number of days removed in each season.
function [tMON1,tMON2,tMON3,tMON4, tMON, thresholds, rm] = ...
          GetModifiedMatrix(DJF, MAM, JJA, SON)
% remove top 5%
[tMON1, threshold1, rm1] = remove_top5(reshape(DJF,10,14,91*39));
[tMON2, threshold2, rm2] = remove_top5(reshape(MAM,10,14,92*39));
[tMON3, threshold3, rm3] = remove_top5(reshape(JJA,10,14,92*39));
[tMON4, threshold4, rm4] = remove_top5(reshape(SON,10,14,91*39));

thresholds(:,:,1) = threshold1; thresholds(:,:,2) = threshold2;
thresholds(:,:,3) = threshold3; thresholds(:,:,4) = threshold4;
rm(:,:,1) = rm1./3520; rm(:,:,2) = rm2./3588; 
rm(:,:,3) = rm3./3588; rm(:,:,4) = rm4./3549;

% tMONs: lon, lat, year, season. 10 14 39 4
tMONs(:,:,:,1) = squeeze(mean(reshape(tMON1, 10, 14, 91, 39), 3, 'omitnan'));
tMONs(:,:,:,2) = squeeze(mean(reshape(tMON2, 10, 14, 92, 39), 3, 'omitnan'));
tMONs(:,:,:,3) = squeeze(mean(reshape(tMON3, 10, 14, 92, 39), 3, 'omitnan'));
tMONs(:,:,:,4) = squeeze(mean(reshape(tMON4, 10, 14, 91, 39), 3, 'omitnan'));

n = isnan(JJA(:,:,1,1));
tMONs(repmat(n, 1, 1, 4, 4)) = nan;

% Calculating mean, std, kurtosis, skewness
tMON = zeros(10, 14, 4, 4); % lon, lat, variable, season
for i = 1:4
    tMON(:,:,1,i) = mean(tMONs(:,:,:,i), 3); % average
    tMON(:,:,2,i) = std(tMONs(:,:,:,i), 1, 3);
    tMON(:,:,3,i) = skewness(tMONs(:,:,:,i), 1, 3);
    tMON(:,:,4,i) = kurtosis(tMONs(:,:,:,i), 1, 3);
end

