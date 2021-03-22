function [MON1, threshold, rmcount] = remove_low5(MON)
MON1 = MON;
threshold = zeros(10, 14);
rmcount = zeros(10, 14);
for i = 1:10
    for j = 1:14
        % sorted from small to large with unique values in each grid
        % iMON records the position in original series
        [uni_MON, iMON] = unique(MON(i,j,:));     
        len = length(uni_MON);
        num = ceil(len*.05);  % num ranks to be removed
        threshold(i,j) = uni_MON(num);
        MON1(i,j, find(MON(i,j,:)<=threshold(i,j))) = 0;
        rmcount(i,j) = length(find(MON(i,j,:)<=threshold(i,j)));
    end
end