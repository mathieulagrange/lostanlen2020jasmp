clear all

load('extractedData/results.mat')

a = histcounts(rating(:, 1), 1:7)
b = histcounts(rating(:, 2), 1:7)

bar([a; b]')
xlabel('Rating')
set(gca, 'fontsize', 14)

saveas(gcf, 'statxp1.png');
saveas(gcf, 'statxp1.fig');

[h,p,ci,stats] = ttest2(rating(:, 1), rating(:, 2))