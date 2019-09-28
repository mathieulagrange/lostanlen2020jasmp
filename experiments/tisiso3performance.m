function [config, store, obs] = tisiso3performance(config, setting, data)
% tisiso3performance PERFORMANCE step of the expLanes experiment timbralSimilaritySol
%    [config, store, obs] = tisiso3performance(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: Mathieu Lagrange
% Date: 09-Jan-2017

% Set behavior for debug mode
if nargin==0, timbralSimilaritySol('do', 3, 'mask', {[4]    [5]    [3]    [2]    [2]    [5]    [1]    [1]    [2]    [2] [2]    [2]    [1]    [2]    [1]}); return; else store=[]; obs=[]; end

rng(0);

if strcmp(setting.reference, 'judgments') && (...
        (strcmp(setting.projection, 'lda')  && (setting.averageJudgment==0 || (setting.averageJudgment==1 && setting.separateJudgment==1))) || ...
        (strcmp(setting.projection, 'none')  && (setting.separateJudgment==1 || setting.averageJudgment==1 || (setting.averageJudgment==0 && setting.separateJudgment==1))) || ...
        (strcmp(setting.projection, 'lmnn')  && setting.averageJudgment==1 && setting.separateJudgment==1) || ...
        strcmp(setting.split, 'octave') ...
        )
    obs.p=NaN;
    return
end

data1 = expLoad(config, '', 1, 'data');
obs.p=[];
switch setting.reference
    case 'judgments'
        [data1, judgments] = handleJudgments(config, data1);
        [data1, judgments] = splitJudgments(data1, judgments, str2num(setting.split), setting.test);
        parfor k=1:size(judgments, 1)  % par
            p(k) = process3performance(config, data1, data, setting, judgments(k, :), k);
        end
        obs.p = p;
    otherwise
        obs.p = process3performance(config, data1, data, setting);
end

function p = process3performance(config, data1, data, setting, judgment, k)

if exist('judgment', 'var')
    data1.(setting.reference) = judgment;
end
data1 = getFeatures(config, data1, setting, config.step.id);

[~, ~, gt] = unique(data1.(setting.reference));

features = data1.features;
switch setting.projection
    case 'lmnn'
        switch setting.reference
            case 'judgments'
                switch setting.separateJudgment
                    case 1
                        data.projection = squeeze(data.projection(min(k, size(data.projection, 1)), :, :));
                    case 0
                        data.projection = squeeze(mean(data.projection, 1));
                    case 2
                        for  k=1:size(data.projection, 1)
                            projMatrix = squeeze(data.projection(k, :, :));
                            subspaces(:, :, k) = projMatrix*projMatrix';
                        end
                        meanSubSpace = psd_karcher_mean(subspaces);
                        disp('done karcher');
                        data.projection = sqrtm(meanSubSpace);
                        %                         for  k=1:size(data.projection, 1)
                        %                              subspaces(:, :, k) = squeeze(data.projection(k, :, :))^2;
                        %                                 projection = squeeze(data.projection(k, :, :));
                        %                             [subspaces(:, :, k), ~] = qr(projection);
                        %                         end
                        %                         subspaces = (subspaces + permute(subspaces, [2 1 3]))/2;
                        %                         meanSubSpace = psd_karcher_mean(subspaces);
                        %                         data.projection = sqrtm(meanSubSpace);
                    case 3
                        meanMatrix = zeros(size(data.projection, 2), size(data.projection, 3));
                        for k = 1:size(data.projection, 1)
                            projMatrix = squeeze(data.projection(k, :, :));
                            projMatrix   = projMatrix*projMatrix';
                            meanMatrix = meanMatrix + projMatrix^2;
                        end
                        data.projection = sqrtm(1/size(data.projection, 1)*meanMatrix);
                end
                features = (data.projection*data1.features')';
        end
        
    case 'lda'
        if ndims(data.projection)==3
            data.projection = squeeze(data.projection);
        end
        if ~isempty(data.projection)
            features = [ones(size(data1.features, 1), 1) data1.features] * data.projection';
        end
end
% features = features(:, 1);

features = real(features);


n=knnsearch(features,features,'k',setting.neighbors+1);
n(:, 1) = [];

for k=1:size(features, 1)
    ind = gt(k)==gt;
    ind = ind(n(k, :));
    prec(k) = mean(ind);
end

p = mean(prec);

% use for full set of metric (beware of memory comsumption)
% p = pdist(features);
% obs = rankingMetrics(p, gt, setting.neighbors, [], 1);
