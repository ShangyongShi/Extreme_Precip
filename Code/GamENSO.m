% To examine the ENSO influence on winter and spring precipitation
% Get the scale and shape estimates for DJF and MAM for warm and cold
% phase of ENSO years. And compute the difference of warm - cold.
% warm_DJF = [1980;1983;1987;1988;1992;1995;1998;2003;2005;2007;2010;2015;2016];
% cold_DJF = [1984;1985;1989;1996;1999;2000;2001;2006;2008;2009;2011;2012;2018];
% warm_MAM = [1982;1983;1987;1992;1998;2015;2016];
% cold_MAM = [1985;1989;1999;2000;2008;2011;];

% Input  | MON: DJF or MAM
% Output | walpha, wbeta
%        | diff_alpha, diff_beta
% 
% Shangyong
% 2019.12.18

function [walpha, wbeta, diff_alpha, diff_beta] = GamENSO(MON)
[lon, lat, day, ~] = size(MON);
if (day == 91) % DJF
    wy = [1;4;8;9;13;16;19;24;26;28;31;36;37];
    cy = [5;6;10;17;20;21;27;29;30;32;33];
elseif (day == 92) % MAM
    wy = [4;5;9;14;20;37;38];
    cy = [7;11;21;22;30;33];
else
    error('Wrong input!')
end
wMON = reshape(MON(:, :, :, wy), lon, lat, day*length(wy)); 
cMON = reshape(MON(:, :, :, cy), lon, lat, day*length(cy));
 
[walpha, wbeta, wchi2, wthr_chi2] = GammaFit(wMON);
[calpha, cbeta, cchi2, cthr_chi2] = GammaFit(cMON);

walpha(wchi2 > wthr_chi2) = nan;
wbeta(wchi2 > wthr_chi2) = nan;
calpha(cchi2 > cthr_chi2) = nan;
cbeta(cchi2 > cthr_chi2) = nan;
diff_alpha = walpha - calpha;
diff_beta = wbeta - cbeta;


end

