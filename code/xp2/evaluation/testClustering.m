
nbRuns = 50;
nbElts = 100;
nbClasses = 10;
nbClusters = 100:-10:10;

labels = ceil(rand(1, nbElts)*nbClasses);
clear d
tic
for k=1:length(nbClusters)
    for j=1:nbRuns
        ind = labels;
        indr = rand(1, length(ind))>j/nbRuns;
        ind(indr) = ceil(rand(1, sum(indr))*nbClusters(k));
        m = clusteringMetrics(labels, ind);
        d(k, 1, j) = m.nmi;
        d(k, 2, j) = m.adjustedRandIndex;
        d(k, 3, j) = m.unadjustedRandIndex;
        d(k, 4, j) = m.mirkinIndex;
        d(k, 5, j) = m.hubertsIndex;
        d(k, 6, j) = m.accuracy;        
    end
    toc
end

% d = squeeze(mean(d*100, 1));

plot(squeeze(d(:, :, end/2)))
xlabel('nbClusters')
set(gca, 'xTickLabel', nbClusters)
legend('nmi', 'adjusted rand', 'unadjusted rand', 'mirkin index', 'huberts index', 'accuracy')