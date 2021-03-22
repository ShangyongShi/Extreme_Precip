% function specially designed for HC_HW1
% INPUT : data(10, 14, 365) or data(10,14, 366)
% OUTPUT: monthly mean, mm(10, 14, 12);
function mm = get_monthly_mean(data)
mm = zeros(10, 14, 12);

flag = mod(length(data(1,1,:)), 2);
if flag == 0   % Leap year
    len = 29;
else
    len = 28;
end

mm(:, :, 1)  = mean(data(:, :, 1:31), 3, 'omitnan');
mm(:, :, 2)  = mean(data(:, :, 32      : 32+len-1), 3, 'omitnan');
mm(:, :, 3)  = mean(data(:, :, 32+len  : 32+len+31-1), 3, 'omitnan');
mm(:, :, 4)  = mean(data(:, :, 63+len  : 63+len+30-1), 3, 'omitnan');
mm(:, :, 5)  = mean(data(:, :, 93+len  : 93+len+31-1), 3, 'omitnan');
mm(:, :, 6)  = mean(data(:, :, 124+len : 124+len+30-1), 3, 'omitnan');
mm(:, :, 7)  = mean(data(:, :, 154+len : 154+len+31-1), 3, 'omitnan');
mm(:, :, 8)  = mean(data(:, :, 185+len : 185+len+31-1), 3, 'omitnan');
mm(:, :, 9)  = mean(data(:, :, 216+len : 216+len+30-1), 3, 'omitnan');
mm(:, :, 10) = mean(data(:, :, 246+len : 246+len+31-1), 3, 'omitnan');
mm(:, :, 11) = mean(data(:, :, 277+len : 277+len+30-1), 3, 'omitnan');
mm(:, :, 12) = mean(data(:, :, 307+len : 307+len+31-1), 3, 'omitnan');