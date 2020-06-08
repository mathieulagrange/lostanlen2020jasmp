addpath('libs/export_fig')
clear all
captions = {'Proposed', 'train/test validation', 'randomized features', 'lda', 'no learning', 'reduce T to 25ms', 'separable scattering', 'mfcc', 'mfcc monomials'};
ind = 1;

iaInd = 2;
d = load(['report/tables/tt' num2str(iaInd-1)]);
[~, ia] = sort(d.data.rawData{1}.p);


for k=1:length(captions)
    
    d(ind) = load(['report/tables/tt' num2str(k-1)]);
    p(ind, :) = d(ind).data.rawData{1}.p;
    p(ind, :) = p(ind, ia);   
    
    x(ind, :) = ind*ones(1, size(p, 2));
    c(ind, :) = 1:size(p, 2);
    ind = ind+1;
end

reorder = [9 8 1 7 6 5 4 3 2];
[~, reorder] = sort(reorder);
p=p(reorder, :);
captions = captions(reorder);
clf();

hold on;

s=scatter(-log1p(-p(:)/100)/log(10), x(:), ...
    'diamond', 'filled', 'MarkerFaceAlpha', 1.0);

s.CData = c(:);
s.SizeData = 75;

boxplot(-log1p(-p'/100)/log(10), 'orientation', 'horizontal', ...
    'Color', 'k', 'Symbol', '')
set(gca,'TickLabelInterpreter','latex')
set(gca, 'yticklabels', captions);
xlabel('Average precision at 5 (\%)', 'interpreter', 'latex');

custom_xticks = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10.0, 20.0, 50.0, 100.0]/100;
xticks(-log10(custom_xticks(end:-1:1)));
xticklabels(100-100*custom_xticks(end:-1:1))
set(gca(), 'XGrid', 'on');

set(gca, 'fontsize', 16)

axis([-log10(custom_xticks(end)) -log10(custom_xticks(1)) 1.5 9.5])
hold off;

set(gcf, 'Color', 'None')
savefig('../paper/figures/ablationStudyNoRand.fig')
export_fig('../paper/figures/ablationStudyNoRand.png', '-transparent')

