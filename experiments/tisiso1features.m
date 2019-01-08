function [config, store, obs] = tisiso1features(config, setting, data)
% tisiso1features FEATURES step of the expLanes experiment timbralSimilaritySol
%    [config, store, obs] = tisiso1features(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: Mathieu Lagrange
% Date: 09-Jan-2017

% Set behavior for debug mode
if nargin==0, timbralSimilaritySol('do', 1, 'mask', {4 2 2 1 0 5 1 0 0 0 0 2 1 1 0}); return; else store=[]; obs=[]; end

% fid = fopen([config.inputPath 'fileList.txt']);
% fileList = textscan(fid, '%s/%s\n');
% fileList = fileList{1};
% fclose(fid);

fid = fopen([config.inputPath 'fileList.txt']);
fileList = fscanf(fid, '%s\n');
fclose(fid);
fileList = regexp(fileList, '.wav', 'split');
fileList(end)=[];

D = regexp(fileList, '/', 'split');
for k=1:length(D)-1,
    dk = D{k};
    instrument{k} = dk{1};
    mode{k} = [dk{1} '-' dk{2}];
    modeFamily{k} = dk{2};
    name{k} = dk{3};
end

si = regexp(instrument, '-', 'split');
for k=1:length(si),
    sik = si{k};
    family{k} = sik{1};
end
length(fileList)
obs.nbInstrument = length(unique(instrument));
obs.nbMode = length(unique(mode));
obs.nbFamily = length(unique(family));
obs.nbmodeFamily = length(unique(modeFamily));
obs.nbFiles = length(fileList);

[~, ~, gt] = unique(instrument);
obs.clInstrument = hist(gt, (1:obs.nbInstrument));
[~, ~, gt] = unique(mode);
obs.clMode = hist(gt, (1:obs.nbMode));
[~, ~, gt] = unique(family);
obs.clFamily = hist(gt, (1:obs.nbFamily));
[~, ~, gt] = unique(modeFamily);
obs.clmodeFamily = hist(gt, (1:obs.nbmodeFamily));

store.instrument = instrument;
store.mode = mode;
store.modeFamily = modeFamily;
store.family = family;
store.file = fileList;

scat_opt.M = 2;
scat_opt.oversampling = 1;
scat_opt.path_margin = 1;

%[~, ~, idx] = handleJudgments(config, store, 0, 0);

if strcmp(setting.features, 'null'), return; end

failed = zeros(1, length(fileList));
done = zeros(1, length(fileList));
parfor k=1:length(fileList)
    cc = 1;
    [a,sr] = audioread([config.inputPath fileList{k} '.wav']);
    switch setting.features
        case 'mel'
            [~, cc] = melfcc(a(:,1), sr, 'wintime', setting.sct/1000, 'hoptime', setting.sct/4000);
        case 'mfcc'
            cc = melfcc(a(:,1), sr, 'numcep', 40, 'maxfreq', ceil(sr/2));
        case 'scat'
            filt_opt = struct();
            filt_opt.Q = [12 1];
            filt_opt.J = T_to_J(sr*setting.sct/1000, filt_opt);
            Wop3 = wavelet_factory_1d(length(a), filt_opt, scat_opt);
            S = scat(a(:,1), Wop3);
            S = format_scat(S,'order_table');
            cc = [S{1+1}' S{1+2}']';
        case 'tfscat'
            tm_filt_opt = struct();
            tm_filt_opt.Q = [12 1];
            tm_filt_opt.J = T_to_J(sr*setting.sct/1000, tm_filt_opt);
            
            % NOTE: The parameter `fr_filt_opt.J` controls the largest scale
            % along the frequency axis as a power of two. For `J = 4`, this
            % means a largest frequency scale of `2^4 = 16`, which is equal to
            % 1.5 octaves since `Q = 12`.
            fr_filt_opt = struct();
            fr_filt_opt.J = 4;
            
            Wop = joint_tf_wavelet_factory_1d(size(a, 1), tm_filt_opt, ...
                fr_filt_opt, scat_opt);
            
            S = scat(a(:,1), Wop);
            S = format_scat(S, 'order_table');
            cc = real([S{1+1}' S{1+2}']');
        case 'null'
            cc = rand(1, 100);
    end
    cc = nanmean(cc');
    if ~isfinite(cc), failed(k)=1; end
    features(k, :) = cc;
end


store.features = features;

obs.failed = sum(failed);
