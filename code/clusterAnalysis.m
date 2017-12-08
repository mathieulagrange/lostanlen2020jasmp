%function clusterAnalysis()
modes = 0;
load simAll
addpath('evaluation')

l = linkage(dc, 'weighted');

dendrogram(l, 78,'Orientation','right', 'Labels', names)
set(gca, 'xtick', [], 'fontSize', 15)
axis tight
saveas(gcf, '../paper/figures/allLinkage', 'png')


for k=2:15
    c(k, :) = cluster(l, 'maxclust', k);
    
    [iNames, ~, ii] = unique(instruments);
    [mNames, ~, im] = unique(modes);
    
    cmi = clusteringMetrics(c(k, :), ii);
    
    cmm = clusteringMetrics(c(k, :), im);
    
    ai(k) = cmi.nmi;
    am(k) = cmm.nmi;
    
    for m=1:100
        cr = randi(k, size(c, 2), 1);
        crmi = clusteringMetrics(cr, ii);
        crmm = clusteringMetrics(cr, im);
        arim(m) = crmi.nmi;
        armm(m) = crmm.nmi;
    end
    
    ari(k) = mean(arim);
    arm(k) = mean(armm);
end
ai(1)=NaN;
am(1)=NaN;
ari(1)=NaN;
arm(1)=NaN;

save('clusters.mat')


figure(1)
plot([ai; am; ari; arm; ai-ari; am-arm]', 'LineWidth', 2)
xlabel('Number of clusters')
ylabel('Nmi')
legend({'judgmentsInstruments', 'judgmentsModes', 'nullInstruments', 'nullModes', 'normalizedJudgmentsInstruments', 'normalizedJudgmentsModes'})
set(gca, 'FontSize', 16)
saveas(gcf, 'figures/clusterAnalysis', 'png')


figure(2)
colormap('jet')
subplot 211
imagesc([c(5, :)/5; im'/15])
subplot 212
imagesc([c(6, :)/6; ii'/15])

% trier les references
% faire un alignement par pair wise max
