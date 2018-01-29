function res = rankingMetrics(prediction, labels, rank, filter, short, small, average)

% prediction is supposed to be small for components that are close
% rank is the maximal rank for computing the metrics, e.g. for 5-precision,
% rank=5
% more information on the metrics
% http://en.wikipedia.org/wiki/Information_retrieval
% http://en.wikipedia.org/wiki/Mean_reciprocal_rank
% on hubs and orphans Aucouturier Jasa
% on reversibility Jegou Pami

if ~exist('rank', 'var') || isempty(rank), rank=5; end
if nargin<1
    labels = repmat((1:3), rank+1, 1);
    labels=labels(:);
    filter = repmat((1:6), (rank+1)/2, 1);
    filter=filter(:);
    
    prediction = (repmat(labels, 1, length(labels))==repmat(labels', length(labels), 1));
    prediction = 1-prediction;
    prediction = prediction+eps;
    %   prediction = squareform(rand(length(labels)*(length(labels)-1)/2, 1));
    prediction = prediction .* abs(1-diag(ones(1, size(prediction, 1))));
    imagesc(prediction);
end
if ~exist('filter', 'var') || isempty(filter), filter=1:length(labels); end
if ~exist('short', 'var') || isempty(short), short = 0; end
if ~exist('small', 'var') || isempty(small), small = 0; end
if ~exist('average', 'var') || isempty(short), average = 1; end

labels=labels(:);
if isvector(prediction), prediction = squareform(prediction); end
nbElts = size(prediction, 1);

% sort predictions
[null, si] = sort(prediction);

if rank > size(si, 1)-1
    rank = size(si, 1)-1;
end

% nn & map
v = zeros(nbElts, 3);
l=1;
n = zeros(1, nbElts);
for k=1:nbElts
    if labels(k) ~= 0
        ind = labels(k)==labels;
        c = sum(ind);
        if c>1
            ind = ind(si(si(:,k)~=filter(k), k));
            iRank = min(rank, sum(ind));
            n(l) = mean(ind(1:iRank));
            
            pk = cumsum(ind)./(1:size(ind, 1)).';
            v(l, 1) = sum(pk.*ind)/sum(ind);
            rr = find(ind==1);
            v(l, 2) = 1./rr(1);
            v(l, 3) = sum(ind(1:iRank))/sum(ind);
            l=l+1;
        end
    end
end
% average number of correct answers at rank
res.(['precisionAt' num2str(rank)]) = n';%mean(n, 2);
%
res.meanAveragePrecision = v(:, 1);
% inverse of the rank of the first correct answer
res.meanReciprocalRank = v(:, 2);
% ratio between the number of correct answer at rank and the number of
% correct answers
res.(['recallAt' num2str(rank)]) = v(:, 3);

if ~small
    m=zeros(1, nbElts);
    for k=1:nbElts
        % number of elements per cluster
        nbc = sum(labels==labels(k));
        % number of closest elts which are within the cluster
        nbk = find((labels(si(:, k))==labels(k)), 1, 'last');
        m(k) =  nbc / nbk;
    end
    % number of elements of the shortest ranked list that contains every
    % elements of the class of the query
    res.precisionAtCompleteRecall = m;
    
    
    VI=si(2:min(rank+1, size(si, 1)), :);
    vI = VI(:);
    v = sort(hist(vI, (1:nbElts)));
    % orphean
    res.orpheanRatio = (nbElts-length(unique(vI)))/nbElts;
    % hub
    res.hubRatio = max(v)/nbElts;
    
    % % consistency
    % for k=1:nb
    %     % number of elements per cluster
    %     nbc = sum(labels==labels(k));
    %     % number of closest elts which are within the cluster
    %     nbk = sum(labels(si(1:nbc, k))==labels(k));
    %     m(k) =  nbk / nbc;
    % end
    %
    % e(8) = mean(m);
    
    % reversibility rate: for each query, count the number of neighbors which
    % have the query as neighbor
    rev=0;
    for k=1:nbElts
        for l=2:rank+1
            if sum(si(2:rank+1, si(l, k))==k)
                rev=rev+1;
            else
                disp('');
            end
        end
    end
    res.reversibilityRate=rev/(nbElts*rank);
    res.rank = rank;
end

if short
    r.(['pAt' num2str(rank)]) = res.(['precisionAt' num2str(rank)]);
    r.map = res.meanAveragePrecision;
    r.mrr = res.meanReciprocalRank;
    r.(['rAt' num2str(rank)]) = res.(['recallAt' num2str(rank)]);
    if ~small
        r.pAtR = res.precisionAtCompleteRecall;
        
        r.o = res.orpheanRatio;
        r.hub = res.hubRatio;
        r.rev = res.reversibilityRate;
    end
    res = r ;
end

if average
    names = fieldnames(res);
    for k=1:length(names)
        res.(names{k})  = mean(res.(names{k}));
    end
end




