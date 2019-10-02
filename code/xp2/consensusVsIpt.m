
%load ticelJudgments
%load clusters

ins = unique(instruments);
mod = unique(modes);

for k=1:length(instruments)
    in(k) =  find(ismember(ins, instruments{k}));
    mo(k) =  find(ismember(mod, modes{k}));
end

mi = zeros(length(ins));
for k=1:length(ins)
    for l=1:length(ins)
        for m=1:length(in)
            for n=1:length(in)
                if in(m) == k && l == in(n) && ensemble(m) == ensemble(n)
                    mi(k, l) = mi(k, l)+1;
                end
            end
        end
    end
end
figure(1)
[~, ~, perm] = dendrogram(linkage(mi, 'ward'))
imagesc(1-mi(perm, perm))
set(gca, 'xtick', 1:length(ins))
set(gca, 'xticklabels', ins(perm))
set(gca, 'ytick', 1:length(ins))
set(gca, 'yticklabels', ins(perm))
set(gca, 'fontsize', 16)

saveas(gcf, 'consensusVsI.png')

moo = zeros(length(mod));
for k=1:length(mod)
    for l=1:length(mod)
        for m=1:length(mo)
            for n=1:length(mo)
                if mo(m) == k && l == mo(n) && ensemble(m) == ensemble(n)
                    moo(k, l) = moo(k, l)+1;
                end
            end
        end
    end
end
figure(2)
[~, ~, perm] = dendrogram(linkage(moo, 'ward'))
imagesc(1-moo(perm, perm))
set(gca, 'xtick', 1:length(mod))
set(gca, 'xticklabels', mod(perm))
set(gca, 'ytick', 1:length(mod))
set(gca, 'yticklabels', mod(perm))
xtickangle(45)
set(gca, 'fontsize', 16)
saveas(gcf, 'consensusVsPt.png')
return

[sin, iin] = sort(in);
[smo, imo] = sort(mo);



figure(1)
colormap bone
imagesc(squareform(pdist(ensemble(iin).', 'jaccard')))
hold on
sep = find(diff(sin))
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

