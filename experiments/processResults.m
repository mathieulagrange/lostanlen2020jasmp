clear all
captions = {'full', 'split', 'random', 'lda', 'nolearning', '25ms', 'separable', 'mfcc', 'monomials'}
ind = 1;

iaInd = 2;
d = load(['report/tables/tt' num2str(iaInd-1)]);
[~, ia] = sort(d.data.rawData{1}.p);


for k=1:length(captions)
    if k==3, continue;end
    
    d(ind) = load(['report/tables/tt' num2str(k-1)]);
    p(ind, :) = d(ind).data.rawData{1}.p;
    p(ind, :) = p(ind, ia);   
    
    x(ind, :) = ind*ones(1, size(p, 2));
    c(ind, :) = 1:size(p, 2);
    ind = ind+1;
end

captions(3)=[];


mean(p')
fig = figure(1);
boxplot(p', 'orientation', 'horizontal')
set(gca, 'yticklabels', captions);
xlabel('aP@5')
saveas(fig, 'boxRes.png')

fig = figure(2);

s=scatter(p(:), x(:), 'filled');
s.CData = c(:);
s.SizeData = 70;
set(gca, 'yticklabels', captions);
axis([55 103 0.5 8.5])
xlabel('aP@5')
saveas(fig, 'samplesRes.png')

