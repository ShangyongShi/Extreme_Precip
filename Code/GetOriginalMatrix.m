% Get the mean, std, skewness and kurtosis of the original rainfall data.
% INPUT  | DJF, MAM, JJA, SON (produced by GetSeasons.m)
% OUTPUT | oMON 
%        | lon, lat, variable, season
% size   | 10,  14,     4,       4
function oMON = GetOriginalMatrix(DJF, MAM, JJA, SON)
[lon, lat, ~, yr] = size(DJF);
MON = zeros(lon, lat, yr, 4);
MON(:,:,:,1) = mean(DJF, 3, 'omitnan');
MON(:,:,:,2) = mean(MAM, 3, 'omitnan');
MON(:,:,:,3) = mean(JJA, 3, 'omitnan');
MON(:,:,:,4) = mean(SON, 3, 'omitnan');

oMON = zeros(lon, lat, 4, 4);
% average
oMON(:,:,1,1) = squeeze(mean(mean(DJF, 3, 'omitnan'),4));
oMON(:,:,1,2) = squeeze(mean(mean(MAM, 3, 'omitnan'),4));
oMON(:,:,1,3) = squeeze(mean(mean(JJA, 3, 'omitnan'),4));
oMON(:,:,1,4) = squeeze(mean(mean(SON, 3, 'omitnan'),4));
% std, skewness and kurtosis
for i = 1:4
    oMON(:,:,2,i) = std(MON(:,:,:,i), 1, 3);
    oMON(:,:,3,i) = skewness(MON(:,:,:,i), 1, 3);
    oMON(:,:,4,i) = kurtosis(MON(:,:,:,i), 1, 3);
end
end