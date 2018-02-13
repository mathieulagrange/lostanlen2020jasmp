function [config, store, obs] = tisiso2project(config, setting, data)
% tisiso2project PROJECT step of the expLanes experiment timbralSimilaritySol
%    [config, store, obs] = tisiso2project(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: Mathieu Lagrange
% Date: 09-Jan-2017

% Set behavior for debug mode
if nargin==0, timbralSimilaritySol('do', 2, 'mask', {2 1 2 1 1 5 1 1 2 0 0 2 1 2}); return; else store=[]; obs=[]; end

rng(0);

% store = expLoad(config, '', 2);
% if iscell(store.projection)
%     for k=1:length(store.projection)
%         projection(:, :, k) = store.projection{k};
%     end
%     store.projection = projection;
% end
% return
if strcmp(setting.projection, 'none') || (strcmp(setting.projection, 'lda') && strcmp(setting.reference, 'judgments') && setting.averageJudgment==0)
    store.projection = [];
    return
end

switch setting.reference
    case 'judgments'
        [data, judgments] = handleJudgments(config, data, setting.averageJudgment);
        
        parfor k=1:size(judgments, 1)
            ju = judgments(k, :);
            projection(k, :, :) = process2project(store, config, data, setting, ju);
        end      
    otherwise
        projection = process2project(store, config, data, setting);
end

store.projection = projection;

function projection = process2project(store, config, data, setting, ju)

if exist('ju', 'var'), data.(setting.reference) = ju; end

data = getFeatures(config, data, setting, config.step.id);

[~, ~, gt] = unique(data.(setting.reference));

switch setting.projection
    case 'lmnn'
        projection = lmnnCG(data.features', gt', setting.neighbors, 'quiet', 1);
    case 'lda'
        projection = lda(data.features, gt);
    otherwise
        projection = [];
end