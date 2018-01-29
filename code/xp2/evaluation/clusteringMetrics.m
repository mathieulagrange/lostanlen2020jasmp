function metrics = clusteringMetrics(target, prediction, getAccuracy,getRandIndex,getNmi,getPairWiseMatching,getNormCondEntropies)

if ~exist('getAccuracy', 'var'), getAccuracy = 1; end
if ~exist('getNmi', 'var'), getNmi = 1; end
if ~exist('getRandIndex', 'var'), getRandIndex = 1; end
if ~exist('getPairWiseMatching', 'var'), getPairWiseMatching = 1; end
if ~exist('getNormCondEntropies', 'var'), getNormCondEntropies = 1; end

target = target(:);
prediction = prediction(:);

if min(target)<1
    target = target+1+abs(min(target));
end
if min(prediction)<1
    prediction = prediction+1+abs(min(prediction));
end

if getNmi
    metrics.nmi= real(nmi(target, prediction));
end
if getRandIndex
    [metrics.adjustedRandIndex, metrics.unadjustedRandIndex, metrics.mirkinIndex, metrics.hubertsIndex] = randIndex(target, prediction);
end
if getAccuracy
    [metrics.accuracy, metrics.classMatching] = accuracy(target, prediction);
end
if getPairWiseMatching
    [metrics.pairwiseFmeasure, metrics.pairwisePrecision, metrics.pairwiseRecall] = pairWiseMatching(target, prediction);
end
if getNormCondEntropies
    [metrics.So,metrics.Su]=normCondEntropies(target,prediction);
end

