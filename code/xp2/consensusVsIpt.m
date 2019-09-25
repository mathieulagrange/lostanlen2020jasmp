load ticelJudgments
load clusters

ins = unique(instruments);
mod = unique(modes);

for k=1:length(instruments)
   in(k) =  find(ismember(ins, instruments{k}));
   mo(k) =  find(ismember(mod, modes{k}));
end

[sin, iin] = sort(in);
[smo, imo] = sort(mo);



figure(1)
colormap bone
imagesc(squareform(pdist(ensemble(iin).', 'jaccard')))
hold on
sep = find(diff(sin));
for k=1:length(sep)
   line([0, 78], [sep(k), sep(k)]) 
    line([sep(k), sep(k)], [0, 78]) 
end
hold off
instruments(iin(sep))
saveas(gcf, 'consensusVsI.png')

figure(2)
colormap bone
imagesc(squareform(pdist(ensemble(imo).', 'jaccard')))
sep = find(diff(smo));
for k=1:length(sep)
   line([0, 78], [sep(k), sep(k)]) 
    line([sep(k), sep(k)], [0, 78]) 
end
hold off
modes(imo(sep))
saveas(gcf, 'consensusVsPt.png')

