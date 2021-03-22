% Calculate 39-year mean wet day frequency for each season
% pw = number of wet days/number of days in this season
% INPUT  | MON:
%        | isDJF: if input is DJF, enter 1; else enter 0
% OUTPUT | wMON spatial distribution of pw in each grid
%        | nwdays: number of wet days in 39 years.
% Shangyong 2019.12.13
function [wMON, nwdays] = GetWetDayFreq(MON, isDJF)
if isDJF == 1
    ndays = zeros(1, 1, 39);
    ndays(1, 1, :) = 90;
    ndays(1, 1, 2:4:38) = 91;
    wMON = squeeze(mean(squeeze(sum(MON > 0.1, 3))./repmat(ndays,10,14), 3));
elseif isDJF == 0
    ndays = size(MON, 3);
    wMON = squeeze(mean(sum(MON > 0.1, 3)/ndays, 4));
else
    error('Enter 1 for DJF, 0 for others')
end
nwdays = sum(sum(MON > 0.1, 3),4);
wMON(isnan(MON(:,:,1,1))) = nan;
