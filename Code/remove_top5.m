function [MON1, threshold, rmcount] = remove_top5(MON)
MON1 = MON;
threshold = zeros(10, 14);
rmcount = zeros(10, 14);
for i = 1:10
    for j = 1:14
        % sorted from small to large with unique values in each grid
        % iMON records the position in original series
        [uni_MON, ~] = unique(MON(i,j,:));     
        len = length(uni_MON);
        num = ceil(len*.05);  % num ranks to be removed
        threshold(i,j) = uni_MON(end-num+1);
        MON1(i,j, MON(i,j,:)>=threshold(i,j)) = 0;
        rmcount(i,j) = length(find(MON(i,j,:)>=threshold(i,j)));
    end
end