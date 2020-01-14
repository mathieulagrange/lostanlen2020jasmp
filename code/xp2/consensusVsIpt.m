
% please load this once
load ticelJudgments
load clusters

% instruments names
ins = unique(instruments);
% pt names
mod = unique(modes);

% instruments and pts as numerical indexes
for k=1:length(instruments)
    in(k) =  find(ismember(ins, instruments{k}));
    mo(k) =  find(ismember(mod, modes{k}));
end

mi = zeros(length(ins));
min = zeros(length(ins));
for k=1:length(ins)
    for l=1:length(ins)
        for m=1:length(in)
            for n=1:length(in) 
                if in(m) == k && l == in(n) && ensemble(m) == ensemble(n) % ensemble is the consensus clustering
                    min(k, l) = min(k, l)+1./(sum(in==in(m))+sum(in==in(n)));
                end
            end
        end
    end
end



figure(1)
colormap bone
[~, ~, perm] = dendrogram(linkage(min, 'ward'));
imagesc(1-min(perm, perm))
set(gca,'TickLabelInterpreter','latex')
set(gca, 'xtick', 1:length(ins))
set(gca, 'xticklabels', ins(perm))
set(gca, 'ytick', 1:length(ins))
set(gca, 'yticklabels', ins(perm))
set(gca, 'fontsize', 16)
axis square
xtickangle(45)

saveas(gcf, 'consensusVsI.png')

moo = zeros(length(mod));
moon = zeros(length(mod));
for k=1:length(mod)
    for l=1:length(mod)
        for m=1:length(mo)
            for n=1:length(mo)
                if mo(m) == k && l == mo(n) && ensemble(m) == ensemble(n)
                    moon(k, l) = moon(k, l)+1./(sum(mo==mo(m))+sum(mo==mo(n)));
                end
            end
        end
    end
end
figure(2)
colormap bone
[~, ~, perm] = dendrogram(linkage(moon, 'ward'));
imagesc(1-moon(perm, perm))
set(gca,'TickLabelInterpreter','latex')
set(gca, 'xtick', 1:length(mod))
set(gca, 'xticklabels', mod(perm))
set(gca, 'ytick', 1:length(mod))
set(gca, 'yticklabels', mod(perm))
xtickangle(45)
set(gca, 'fontsize', 16)
axis square
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

