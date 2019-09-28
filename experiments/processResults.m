clear all
captions = {'full', 'split', 'random', 'lda', 'nolearning', '25ms', 'separable', 'mfcc', 'monomials'}
for k=1:length(captions)
   d(k) = load(['report/tables/tt' num2str(k-1)]);
   p(k, :) = d(k).data.rawData{1}.p;
   x(k, :) = k*ones(1, size(p, 2));
   c(k, :) = 1:size(p, 2);
end

mean(p')
fig = figure(1);
boxplot(p')
xticklabels(captions);
saveas(fig, 'boxRes.png')

fig = figure(2);

s=scatter(x(:), p(:), 'filled')
s.CData = c(:);
s.SizeData = 50;
saveas(fig, 'samplesRes.png')

