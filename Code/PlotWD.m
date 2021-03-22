function PlotWD(lon, lat, wDJF, wMAM, wJJA, wSON)
wMON(:,:,1) = wDJF;
wMON(:,:,2) = wMAM;
wMON(:,:,3) = wJJA;
wMON(:,:,4) = wSON;
% wMON(wMON == 0) = nan;
sub_row = 2;
sub_col = 2;
row = [1,1,2,2];
col = [1,2,1,2];
name = ['DJF';'MAM';'JJA';'SON'];
color = load('WhiteBlueGreenYellowRed.txt')./255;

figure
hold on
set(gcf,'pos',[10 10 700 800])
for i = 1:4
hold on
subplot(2,2,i)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4)
m_contourf(lon, lat, squeeze(wMON(:,:,i))','linestyle','none', 'levelstep',0.05);
m_coast('color','k');

caxis([0 1])
colormap(color)
colorbar
title(name(i,:), 'fontsize', 16)
RemoveSubplotWhiteArea(gca, sub_row, sub_col, row(i), col(i));
end

end
