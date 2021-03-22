% seasons
% a b c d original shape
% e f g h modified shape
% i j k l original scale
% m n o p modified scale
function PlotFig6(lon, lat, alpha, beta)
% color = load('DarkBlueGreenYellowRed.txt');
positions = 0:1/9:1;
colors = flipud([
    163 235 233 %b
    109 171 223
    100 100 221 
%g
    39 177 27
    150 218 62
 %y
    255 226 122
    255 169 56
     243 63 18 %r
    199 26 10
    122 16 0])./255;
   
m = 128;
color = customcolormap(positions, colors, m);

sub_row = 2;
sub_col = 4;
name = ['DJF';'MAM';'JJA';'SON'];
sub = {'(a)','(b)','(c)', '(d)';...
       '(e)','(f)','(g)', '(h)'};

figure
set(gcf,'pos',[10 10 1150 600])
%--- original shape (alpha)
for i = 1:4
hold on
subplot(2,4,i)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4, 'fontsize',12)
m_contourf(lon, lat, squeeze(alpha(:,:,i))','linestyle', 'none','levelstep',0.05);
m_coast('color','k');
m_text(-84+360, 25.25, sub(1, i), 'fontsize',14);
caxis([0.4 1])
colormap(color)
cl = colorbar('fontsize',12);
set(cl, 'ytick',0.4:0.1:1)
title(['Original ', name(i,:),' Shape'],'fontsize',14)
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 1, i);
end

%--- original scale beta
for i = 1:4
subplot(2,4,i+4)
hold on
m_proj('mercator','lon',[275.75 280.25],'lat',[24.75 31.25])       
m_grid('xtick',3,'ytick',4, 'fontsize',12)
m_contourf(lon, lat, squeeze(beta(:,:,i))','linestyle','none', 'levelstep',1);
m_coast('color','k');
m_text(-84+360, 25.25, sub(2, i), 'fontsize',14);
caxis([4 16])
colormap(gca, color)
cl = colorbar('fontsize',12);
set(cl, 'ytick',4:2:16)
title(['Original ', name(i,:),' Scale'],'fontsize',14);
RemoveSubplotWhiteArea(gca, sub_row, sub_col, 2, i);
end

end